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

@end

@implementation NFMainViewController

- (void)viewDidLoad
{
    CLLocationCoordinate2D location;
    location.latitude = -22.903534;
    location.longitude= -43.209572;

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 5 * 1000, 5 * 1000);

    // Point to the city center and then start tracking the user
    self.mapView.region = region;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;

    NSManagedObjectContext *moc = [NFCoreDataStackManager sharedManager].managedObjectContext;
    for (NFIgreja *igreja in [NFIgreja allIgrejasInContext:moc]) {
        [self.mapView addAnnotation:igreja];
    }
}

@end
