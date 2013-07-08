//
//  NFMissaListViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 25/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "CLLocation+NFDefaultLocation.h"
#import "NFAdBannerManager.h"
#import "NFCoreDataStackManager.h"
#import "NFEventMatchContext.h"
#import "NFIgreja.h"
#import "NFIgrejaDetailViewController.h"
#import "NFMissaListCell.h"
#import "NFMissaListViewController.h"


@interface NFMissaListEntry : NSObject

@property (nonatomic, strong) NFEvent *event;

@property (nonatomic, strong) CLLocation *igrejaLocation;

@property (nonatomic, assign) CLLocationDistance igrejaDistance;

@end

@implementation NFMissaListEntry

- (NSComparisonResult)compareToEntry:(NFMissaListEntry *)entry
{
#define CMP(x, y) \
    if ((x) > (y)) { \
        return NSOrderedDescending; \
    } else if ((y) > (x)) { \
        return NSOrderedAscending; \
    } else

    CMP(self.igrejaDistance, entry.igrejaDistance) {
        return [self.event.igreja.nome caseInsensitiveCompare:entry.event.igreja.nome];
    }

#undef CMP
}

@end


@interface NFMissaListViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *userLocation;

@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, strong) NSMutableArray *sections;

@property (nonatomic, strong) NSTimer *refreshTimer;

@property (nonatomic, weak) UIView *adView;

@end

@implementation NFMissaListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.userLocation = [CLLocation nf_defaultLocation];

    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];

    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NFAdBannerManager *adManager = [NFAdBannerManager sharedManagerWithRootViewController:self.tabBarController];

    [adManager takeOverAdBannerWithAddBlock:^(UIView *adView) {
        self.adView = adView;

        [self.tableView addSubview:adView];
        [self _adjustAdViewPosition];

        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, adView.frame.size.height, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    } removeBlock:^(UIView *adView) {
        [adView removeFromSuperview];

        self.tableView.contentInset = UIEdgeInsetsZero;
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Update the interface
    [self _updateEvents];
    [self _calculateDistances];

    // Start the refresh timer
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(_refreshTimerFired) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Stop the refresh timer
    [self.refreshTimer invalidate];
    self.refreshTimer = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[NFIgrejaDetailViewController class]]) {
        NSIndexPath *selection = [self.tableView indexPathForSelectedRow];
        NSAssert(selection != nil, @"Expected table view row to be selected");

        NFMissaListEntry *entry = ((NSArray *)self.sections[selection.section])[selection.row];

        NFIgrejaDetailViewController *controller = (NFIgrejaDetailViewController *)segue.destinationViewController;
        controller.title = entry.event.igreja.nome;
        controller.igreja = entry.event.igreja;
    }
}

- (void)_refreshTimerFired
{
    // Reload the model
    [self _updateEvents];
    [self _calculateDistances];

    // Reload the table view
    [self.tableView reloadData];
}

- (void)_localeDidChange
{
    // Get a new calendar and reload
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [self _updateEvents];
    [self _calculateDistances];

    // The cells need to take this into account too
    [NFMissaListCell invalidateCachedLocale];

    // Now we can reload the table view
    [self.tableView reloadData];
}

- (void)_calculateDistances
{
    // Calculate all distances again and sort the sections
    for (NSMutableArray *section in self.sections) {
        for (NFMissaListEntry *entry in section) {
            entry.igrejaDistance = [entry.igrejaLocation distanceFromLocation:self.userLocation];
        }
        [section sortUsingSelector:@selector(compareToEntry:)];
    }

    // Reload what's shown on screen
    [self.tableView reloadData];
}

- (void)_adjustAdViewPosition
{
    if (!self.adView) {
        return;
    }

    CGRect frame = self.adView.frame;
    frame.origin.y = self.tableView.contentOffset.y + self.tableView.frame.size.height - frame.size.height;
    self.adView.frame = frame;
}


#pragma mark - Fetching from the database

- (NSDate *)_searchLimitDateWithStartDate:(NSDate *)startDate
{
    NSDateComponents *components = [NSDateComponents new];
    components.hour = 3;

    return [self.calendar dateByAddingComponents:components toDate:startDate options:0];
}

- (uint16_t)_timeFromNSDate:(NSDate *)date
{
    NSDateComponents *components = [self.calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    return components.hour * 100 + components.minute;
}

- (void)_updateEvents
{
    // TODO: Move more stuff into the the model, add unit tests

    NSManagedObjectContext *moc = [NFCoreDataStackManager sharedManager].managedObjectContext;

    NSDate *startDate = [NSDate date];
    NSDate *limitDate = [self _searchLimitDateWithStartDate:startDate];

    uint16_t startTime = [self _timeFromNSDate:startDate];
    uint16_t limitTime = [self _timeFromNSDate:limitDate];

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[NFEvent entityName]];

    request.predicate = [NSPredicate predicateWithFormat:@"startTime >= %@ AND startTime <= %@ AND type == %@",
                         @(startTime), @(limitTime), @(NFEventTypeMissa)];

    NSMutableArray *matches = [[moc executeFetchRequest:request error:NULL] mutableCopy];

    NFEventMatchContext *context = [[NFEventMatchContext alloc] initWithReferenceDate:startDate calendar:self.calendar];
    [matches filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NFEvent *entry, NSDictionary *bindings) {
        return [entry matchesWithContext:context];
    }]];

    // Find out the unique start times
    NSArray *times = [matches valueForKeyPath:@"@distinctUnionOfObjects.startTime"];
    times = [times sortedArrayUsingSelector:@selector(compare:)];

    self.sections = [NSMutableArray arrayWithCapacity:times.count];

    // Create the sections
    for (NSNumber *startTime in times) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startTime == %@", startTime];
        NSArray *filtered = [matches filteredArrayUsingPredicate:predicate];

        NSMutableArray *section = [NSMutableArray arrayWithCapacity:filtered.count];
        for (NFEvent *event in filtered) {
            NFMissaListEntry *entry = [NFMissaListEntry new];
            entry.event = event;
            entry.igrejaLocation = [[CLLocation alloc] initWithLatitude:event.igreja.latitudeValue longitude:event.igreja.longitudeValue];
            [section addObject:entry];
        }

        [self.sections addObject:section];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NFMissaListEntry *entry = ((NSArray *)self.sections[section])[0];
    int startTime = entry.event.startTimeValue;

    return [NSString stringWithFormat:@"%02d:%02d", startTime / 100, startTime % 100];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.sections[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NFMissaListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    NFMissaListEntry *entry = ((NSArray *)self.sections[indexPath.section])[indexPath.row];
    [cell configureWithEvent:entry.event distance:entry.igrejaDistance];

    return cell;
}


#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self _adjustAdViewPosition];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detail" sender:self];
}


#pragma mark - Location manager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.userLocation = [locations lastObject];
    [self _calculateDistances];
}

@end
