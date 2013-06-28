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

@interface NFMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NFIgreja *selectedIgreja;

@end

@implementation NFMapViewController

- (void)viewDidLoad
{
    NSManagedObjectContext *moc = [NFCoreDataStackManager sharedManager].managedObjectContext;

    for (NFIgreja *igreja in [NFIgreja allIgrejasInContext:moc]) {
        [self.mapView addAnnotation:igreja];
    }

    // Fall back to a default location
    self.mapView.region = MKCoordinateRegionMakeWithDistance([CLLocation nf_defaultLocation].coordinate, 5000, 5000);

    // Track the user
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[NFIgrejaDetailViewController class]]) {
        NFIgrejaDetailViewController *controller = (NFIgrejaDetailViewController *)segue.destinationViewController;
        controller.title = self.selectedIgreja.nome;
        controller.igreja = self.selectedIgreja;
    }
}


#pragma mark - Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[NFIgreja class]]) {
        return nil;
    }

    static NSString * const reuseIdentifier = @"igreja";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
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
