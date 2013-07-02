//
//  NFMapViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 28/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "CLLocation+NFDefaultLocation.h"
#import "NFCoreDataStackManager.h"
#import "NFIgreja.h"
#import "NFIgrejaDetailViewController.h"
#import "NFMapViewController.h"
#import "NFSettingsManager.h"

@interface NFMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NFIgreja *selectedIgreja;

@property (assign, nonatomic) MKMapRect annotationsRect;

@property (strong, nonatomic) NSManagedObjectContext *backgroundMOC;

@end

@implementation NFMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create a managed object context for background access
    self.backgroundMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.backgroundMOC.persistentStoreCoordinator = [NFCoreDataStackManager sharedManager].persistentStoreCoordinator;

    // Fall back to a default location
    self.mapView.region = MKCoordinateRegionMakeWithDistance([CLLocation nf_defaultLocation].coordinate, 5000, 5000);

    // Track the user
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.mapView.mapType = [NFSettingsManager sharedManager].mapType;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[NFIgrejaDetailViewController class]]) {
        NFIgrejaDetailViewController *controller = (NFIgrejaDetailViewController *)segue.destinationViewController;
        controller.title = self.selectedIgreja.nome;
        controller.igreja = self.selectedIgreja;
    }
}

- (void)_updateMapRegion
{
    MKCoordinateRegion region = self.mapView.region;
    NSPredicate *excludingUserPredicate = [NSPredicate predicateWithFormat:@"class != %@", [MKUserLocation class]];

    // Check if we're too zoomed out for annotations
    if (region.span.latitudeDelta > 0.1) {
        self.annotationsRect = MKMapRectMake(0, 0, 0, 0);
        [self.mapView removeAnnotations:[self.mapView.annotations filteredArrayUsingPredicate:excludingUserPredicate]];
        return;
    }

    MKMapRect visibleRect = self.mapView.visibleMapRect;

    // If the visible rect is a subset of the annotation rect,
    // we don't have to look for more annotations
    if (MKMapRectContainsRect(self.annotationsRect, visibleRect)) {
        return;
    }

    // Set the new annotations rect to be slightly bigger
    self.annotationsRect = MKMapRectInset(visibleRect, -visibleRect.size.width / 4, -visibleRect.size.height / 4);

    MKCoordinateRegion annotationsRegion = MKCoordinateRegionForMapRect(self.annotationsRect);

    [self.backgroundMOC performBlock:^{
        // Get the annotations within the annotations region
        NSArray *allAnnotations = [NFIgreja igrejasInMapRegion:annotationsRegion context:self.backgroundMOC];

        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *currentAnnotations = [self.mapView.annotations filteredArrayUsingPredicate:excludingUserPredicate];

            NSPredicate *toRemovePredicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@", allAnnotations];
            NSArray *toRemove = [currentAnnotations filteredArrayUsingPredicate:toRemovePredicate];

            NSPredicate *toAddPredicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@", currentAnnotations];
            NSArray *toAdd = [allAnnotations filteredArrayUsingPredicate:toAddPredicate];

            [self.mapView removeAnnotations:toRemove];
            [self.mapView addAnnotations:toAdd];
        });
    }];
}


#pragma mark - Map view delegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self _updateMapRegion];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[NFIgreja class]]) {
        return nil;
    }

    static NSString * const reuseIdentifier = @"igreja";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if (!view) {
        view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        view.image = [UIImage imageNamed:@"pin-map"];
        view.canShowCallout = YES;
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    self.selectedIgreja = view.annotation;
    [self performSegueWithIdentifier:@"detail" sender:self];
}

@end
