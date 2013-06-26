//
//  NFMissaListViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 25/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "CLLocation+NFDefaultLocation.h"
#import "NFCoreDataStackManager.h"
#import "NFIgreja.h"
#import "NFMissaListCell.h"
#import "NFMissaListViewController.h"
#import "NFMonthlyEvent.h"
#import "NFWeeklyEvent.h"
#import "NFYearlyEvent.h"


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

    CMP(self.event.startTimeValue, entry.event.startTimeValue) {
        CMP(self.igrejaDistance, entry.igrejaDistance) {
            return [self.event.igreja.nome caseInsensitiveCompare:entry.event.igreja.nome];
        }
    }

#undef CMP
}

@end


@interface NFMissaListViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *userLocation;

@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, strong) NSMutableArray *entries;

@property (nonatomic, strong) NSTimer *refreshTimer;

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

- (void)viewDidAppear:(BOOL)animated
{
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
    // Calculate all distances again
    for (NFMissaListEntry *entry in self.entries) {
        entry.igrejaDistance = [entry.igrejaLocation distanceFromLocation:self.userLocation];
    }

    // Sort by distance
    [self.entries sortUsingSelector:@selector(compareToEntry:)];

    // Reload what's shown on screen
    [self.tableView reloadData];
}


#pragma mark - Fetching from the database

- (NSDate *)_searchLimitDateWithStartDate:(NSDate *)startDate
{
    NSDateComponents *components = [NSDateComponents new];
    components.hour = 1;

    return [self.calendar dateByAddingComponents:components toDate:startDate options:0];
}

- (uint16_t)_timeFromNSDate:(NSDate *)date
{
    NSDateComponents *components = [self.calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    return components.hour * 100 + components.minute;
}

- (void)_updateEvents
{
    NSManagedObjectContext *moc = [NFCoreDataStackManager sharedManager].managedObjectContext;

    NSDate *startDate = [NSDate date];
    NSDate *limitDate = [self _searchLimitDateWithStartDate:startDate];

    uint16_t startTime = [self _timeFromNSDate:startDate];
    uint16_t limitTime = [self _timeFromNSDate:limitDate];

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[NFEvent entityName]];

    request.predicate = [NSPredicate predicateWithFormat:@"startTime >= %@ AND startTime <= %@ AND type == %@",
                         @(startTime), @(limitTime), @(NFEventTypeMissa)];

    NSMutableArray *matches = [[moc executeFetchRequest:request error:NULL] mutableCopy];

    // TODO: Move all this logic to the model, add unit tests

    // Get some components we'll need to filter further
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit;
    NSDateComponents *components = [self.calendar components:flags fromDate:startDate];

    // Find out what is the last weekday this month
    NSDateComponents *lastWeekdayComp = [NSDateComponents new];
    lastWeekdayComp.year = components.year;
    lastWeekdayComp.month = components.month;
    lastWeekdayComp.weekday = components.weekday;
    lastWeekdayComp.weekdayOrdinal = -1;
    NSDate *lastWeekday = [self.calendar dateFromComponents:lastWeekdayComp];

    // Get the start date without time
    NSDateComponents *startDateWithoutTimeComp = [NSDateComponents new];
    startDateWithoutTimeComp.year = components.year;
    startDateWithoutTimeComp.month = components.month;
    startDateWithoutTimeComp.day = components.day;
    NSDate *startDateWithoutTime = [self.calendar dateFromComponents:startDateWithoutTimeComp];

    // Figure out how many weeks from the last week
    NSDateComponents *weeksFromLastWeekdayComp = [self.calendar components:NSWeekCalendarUnit fromDate:lastWeekday toDate:startDateWithoutTime options:0];
    NSInteger reverseWeeksOrdinal = weeksFromLastWeekdayComp.week - 1;

    [matches filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NFEvent *entry, NSDictionary *bindings) {
        if ([entry isKindOfClass:[NFWeeklyEvent class]]) {
            // This is an event that happens every week on
            // a specific weekday
            NFWeeklyEvent *event = (NFWeeklyEvent *)entry;
            return event.weekdayValue == components.weekday;
        } else if ([entry isKindOfClass:[NFMonthlyEvent class]]) {
            NFMonthlyEvent *event = (NFMonthlyEvent *)entry;
            if (event.weekValue == 0) {
                // This is an event that happens every month on
                // a specific day of the month
                return event.dayValue == components.day;
            } else if (event.dayValue == components.weekday) {
                // This is an event that happens every month on
                // a specific weekday on a specific week and we
                // already checked that the weekday matches
                if (event.weekValue > 0) {
                    // The specific week is the ordinal number of the week
                    // (e.g. first monday of every month)
                    return event.weekValue == components.weekdayOrdinal;
                } else {
                    // The specific week is an offset from the first weekday
                    // in the next month (e.g. last monday of every month)
                    return event.weekValue == reverseWeeksOrdinal;
                }
            } else {
                // The weekday doesn't match
                return NO;
            }
        } else {
            NFYearlyEvent *event = (NFYearlyEvent *)entry;
            return event.dayValue == components.day && event.monthValue == components.month;
        }
    }]];

    self.entries = [NSMutableArray arrayWithCapacity:matches.count];

    // Create the entries
    for (NFEvent *event in matches) {
        NFMissaListEntry *entry = [NFMissaListEntry new];
        entry.event = event;
        entry.igrejaLocation = [[CLLocation alloc] initWithLatitude:event.igreja.latitudeValue longitude:event.igreja.longitudeValue];
        [self.entries addObject:entry];
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NFMissaListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    NFMissaListEntry *entry = self.entries[indexPath.row];
    [cell configureWithEvent:entry.event distance:entry.igrejaDistance];

    return cell;
}


#pragma mark - Location manager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.userLocation = [locations lastObject];
    [self _calculateDistances];
}

@end
