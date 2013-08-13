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


@interface NFMissaListViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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

    // We have to do this here because we're not an
    // UITableViewController subclass
    NSIndexPath *selection = [self.tableView indexPathForSelectedRow];
    if (selection) {
        [self.tableView deselectRowAtIndexPath:selection animated:animated];
    }

    NFAdBannerManager *adManager = [NFAdBannerManager sharedManagerWithRootViewController:self.tabBarController];

    [adManager takeOverAdBannerWithAddBlock:^(UIView *adView) {
        self.adView = adView;
        [self.view addSubview:adView];

        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, adView.frame.size.height, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    } removeBlock:^(UIView *adView) {
        self.adView = nil;
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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    if (!self.adView) {
        return;
    }

    CGRect frame = self.adView.frame;
    frame.origin.y = self.tableView.frame.size.height - frame.size.height;
    self.adView.frame = frame;
}


#pragma mark - Fetching from the database

- (void)_updateEvents
{
    NSDate *now = [NSDate date];

    NSManagedObjectContext *moc = [NFCoreDataStackManager sharedManager].managedObjectContext;
    NFEvent *firstMissa = [NFEvent firstMissaAfterDate:now calendar:self.calendar managedObjectContext:moc];

    if (!firstMissa) {
        self.sections = [NSArray array];
        return;
    }

    NSArray *nextMissas = [NFEvent nextMissasAfterEvent:firstMissa withSpan:3 * 60 date:now calendar:self.calendar managedObjectContext:moc];
    NSAssert(nextMissas.count > 0, @"Expected at least one next missa");
    NSAssert([nextMissas[0] isEqual:firstMissa], @"Expected the first missa to be the first event in the list");

    // Note that @distinctUnionOfObjects messes up the ordering,
    // so we have to do it manually
    NSMutableOrderedSet *times = [NSMutableOrderedSet orderedSetWithCapacity:3 * 60 / 15];
    for (NFEvent *event in nextMissas) {
        [times addObject:event.startTime];
    }

    self.sections = [NSMutableArray arrayWithCapacity:times.count];

    for (NSNumber *startTime in times) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startTime == %@", startTime];
        NSArray *filtered = [nextMissas filteredArrayUsingPredicate:predicate];

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
    if (startTime > 1159) {
        return [NSString stringWithFormat:@"%d:%02dPM", startTime / 100 - 12, startTime % 100];
    }
    else
    {
        return [NSString stringWithFormat:@"%d:%02dAM", startTime / 100, startTime % 100];    
    }

    
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
