//
//  NFMainViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 21/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFCoreDataStackManager.h"
#import "NFIgreja.h"
#import "NFMainViewController.h"

@interface NFMainViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation NFMainViewController

- (void)viewDidLoad
{
    CLLocationCoordinate2D location;
    location.latitude = -22.903534;
    location.longitude= -43.209572;

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 5 * 1000, 5 * 1000);

    self.mapView.region = region;

    [self focusUserLocation];

    NSManagedObjectContext *moc = [NFCoreDataStackManager sharedManager].managedObjectContext;
    for (NFIgreja *igreja in [NFIgreja allIgrejasInContext:moc]) {
        [self.mapView addAnnotation:igreja];
    }
}

- (void)focusUserLocation
{
    if (self.locationManager) {
        return;
    }

    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;

    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    MKCoordinateRegion newRegion = MKCoordinateRegionMake(location.coordinate, self.mapView.region.span);

    [self.mapView setRegion:newRegion animated:YES];

    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager error: %@", error);
}

@end
