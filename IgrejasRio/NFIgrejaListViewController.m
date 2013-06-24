//
//  NFIgrejaListViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 24/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFCoreDataStackManager.h"
#import "NFIgreja.h"
#import "NFIgrejaListCell.h"
#import "NFIgrejaListViewController.h"


@interface NFIgrejaListEntry : NSObject

@property (nonatomic, strong) NFIgreja *igreja;

@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, assign) CLLocationDistance distance;

@end

@implementation NFIgrejaListEntry

- (NSComparisonResult)compareToEntry:(NFIgrejaListEntry *)entry
{
    if (self.distance > entry.distance) {
        return NSOrderedDescending;
    } else if (self.distance < entry.distance) {
        return NSOrderedAscending;
    } else {
        return [self.igreja.nome caseInsensitiveCompare:entry.igreja.nome];
    }
}

@end


@interface NFIgrejaListViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *userLocation;

@property (nonatomic, strong) NSMutableArray *entries;

@end

@implementation NFIgrejaListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    self.userLocation = [[CLLocation alloc] initWithLatitude:-22.903534 longitude:-43.209572];

    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];

    NSManagedObjectContext *moc = [NFCoreDataStackManager sharedManager].managedObjectContext;
    NSArray *igrejas = [NFIgreja allIgrejasInContext:moc];

    self.entries = [NSMutableArray new];

    for (NFIgreja *igreja in igrejas) {
        NFIgrejaListEntry *entry = [NFIgrejaListEntry new];
        entry.igreja = igreja;
        entry.location = [[CLLocation alloc] initWithLatitude:igreja.latitudeValue longitude:igreja.longitudeValue];
        [self.entries addObject:entry];
    }

    [self calculateDistances];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}

- (void)localeDidChange
{
    [NFIgrejaListCell invalidateCachedLocale];
}

- (void)calculateDistances
{
    for (NFIgrejaListEntry *entry in self.entries) {
        entry.distance = [entry.location distanceFromLocation:self.userLocation];
    }

    [self.entries sortUsingSelector:@selector(compareToEntry:)];

    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NFIgrejaListEntry *entry = self.entries[indexPath.row];

    NFIgrejaListCell *cell = (NFIgrejaListCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureWithIgreja:entry.igreja distance:entry.distance];

    return cell;
}


#pragma mark - Location manager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.userLocation = [locations lastObject];
    [self calculateDistances];
}

@end
