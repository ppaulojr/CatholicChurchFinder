//
//  NFIgrejaListViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 24/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "CLLocation+NFDefaultLocation.h"
#import "NFCoreDataStackManager.h"
#import "NFIgreja.h"
#import "NFIgrejaListCell.h"
#import "NFIgrejaListViewController.h"
#import "NSString+NFNormalizing.h"


typedef NS_ENUM(NSInteger, NFIgrejaListScope) {
    NFIgrejaListScopeAll = 0,
    NFIgrejaListScopeNome,
    NFIgrejaListScopeBairro
};


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


@interface NFIgrejaListViewController () <CLLocationManagerDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *userLocation;

@property (nonatomic, strong) NSMutableArray *entries;

@property (nonatomic, strong) NSPredicate *filterPredicate;

@property (nonatomic, strong) NSArray *filteredEntries;

@end

@implementation NFIgrejaListViewController

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

    NSManagedObjectContext *moc = [NFCoreDataStackManager sharedManager].managedObjectContext;
    NSArray *igrejas = [NFIgreja allIgrejasInContext:moc];

    self.entries = [NSMutableArray new];

    for (NFIgreja *igreja in igrejas) {
        NFIgrejaListEntry *entry = [NFIgrejaListEntry new];
        entry.igreja = igreja;
        entry.location = [[CLLocation alloc] initWithLatitude:igreja.latitudeValue longitude:igreja.longitudeValue];
        [self.entries addObject:entry];
    }

    [self _calculateDistances];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}

- (void)_localeDidChange
{
    [NFIgrejaListCell invalidateCachedLocale];
}

- (void)_calculateDistances
{
    for (NFIgrejaListEntry *entry in self.entries) {
        entry.distance = [entry.location distanceFromLocation:self.userLocation];
    }

    [self.entries sortUsingSelector:@selector(compareToEntry:)];

    [self.tableView reloadData];
}

- (NSArray *)_arrayForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.filteredEntries;
    } else {
        return self.entries;
    }
}

- (NFIgrejaListEntry *)_entryForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    return [self _arrayForTableView:tableView][indexPath.row];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self _arrayForTableView:tableView].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NFIgrejaListEntry *entry = [self _entryForRowAtIndexPath:indexPath tableView:tableView];

    // It's important to use self.tableView here instead of tableView,
    // as the prototype cell is set up for self.tableView, not for the
    // table view provided by the search display controller
    NFIgrejaListCell *cell = (NFIgrejaListCell *)[self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureWithIgreja:entry.igreja distance:entry.distance];

    return cell;
}


#pragma mark - Location manager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.userLocation = [locations lastObject];
    [self _calculateDistances];
}


#pragma mark - Search display controller delegate

- (void)filterSearchResultsWithScope:(NFIgrejaListScope)scope text:(NSString *)text
{
    NSString *normalizedText = [text nf_searchNormalizedString];
    NSPredicate *predicate;

    switch (scope) {
        case NFIgrejaListScopeAll:
            predicate = [NSPredicate predicateWithFormat:@"self.igreja.normalizedNome CONTAINS %@ OR self.igreja.normalizedBairro CONTAINS %@", normalizedText, normalizedText];
            break;
        case NFIgrejaListScopeNome:
            predicate = [NSPredicate predicateWithFormat:@"self.igreja.normalizedNome CONTAINS %@", normalizedText];
            break;
        case NFIgrejaListScopeBairro:
            predicate = [NSPredicate predicateWithFormat:@"self.igreja.normalizedBairro CONTAINS %@", normalizedText];
            break;
    }

    self.filteredEntries = [self.entries filteredArrayUsingPredicate:predicate];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterSearchResultsWithScope:searchOption text:self.searchDisplayController.searchBar.text];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterSearchResultsWithScope:self.searchDisplayController.searchBar.selectedScopeButtonIndex text:searchString];
    return YES;
}

@end
