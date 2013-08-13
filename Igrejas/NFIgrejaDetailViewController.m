//
//  NFIgrejaDetailViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 26/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <PSAlertView/PSPDFActionSheet.h>

#import "NFGoogleMapsIntegration.h"
#import "NFIgrejaDetailPanel.h"
#import "NFIgrejaDetailViewController.h"
#import "NFSettingsManager.h"
#import "NFWazeIntegration.h"

@interface NFIgrejaDetailViewController () <MKMapViewDelegate, NFIgrejaDetailPanelDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NFIgrejaDetailPanel *detailPanel;

@end

@implementation NFIgrejaDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.detailPanel = [NFIgrejaDetailPanel panel];
    self.detailPanel.delegate = self;
    [self.scrollView addSubview:self.detailPanel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.mapView.mapType = [NFSettingsManager sharedManager].mapType;

    self.mapView.region = MKCoordinateRegionMakeWithDistance(self.igreja.coordinate, 1000, 1000);
    [self.mapView addAnnotation:self.igreja];

    [self.detailPanel configureWithIgreja:self.igreja];
    [self.view setNeedsLayout];
}

- (void)viewDidLayoutSubviews
{
    [self.detailPanel sizeToFit];
    CGRect frame = self.detailPanel.frame;
    frame.origin.y = CGRectGetHeight(self.mapView.bounds);
    self.detailPanel.frame = frame;

    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetMaxY(frame));
}


#pragma mark - Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[NFIgreja class]]) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        annotationView.image = [UIImage imageNamed:@"pin-map"];
        return annotationView;
    } else {
        return nil;
    }
}


#pragma mark - Igreja detail panel delegate

- (MKMapItem *)_mapItemForIgreja
{
    NSString *endereco = self.igreja.endereco;
    if (self.igreja.bairro) {
        endereco = [endereco stringByAppendingFormat:@", %@", self.igreja.bairro];
    }

    NSMutableDictionary *addressDict = [@{
        (__bridge NSString *)kABPersonAddressStreetKey : endereco,
        (__bridge NSString *)kABPersonAddressCityKey : @"Rio de Janeiro",
        (__bridge NSString *)kABPersonAddressStateKey : @"Rio de Janeiro"
    } mutableCopy];

    if (self.igreja.cep) {
        addressDict[(__bridge NSString *)kABPersonAddressZIPKey] = self.igreja.cep;
    }

    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.igreja.coordinate addressDictionary:addressDict];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];

    item.name = self.igreja.nome;

    return item;
}

- (void)igrejaDetailPanelAddressLinkTapped:(NFIgrejaDetailPanel *)panel
{
    PSPDFActionSheet *actionSheet = [[PSPDFActionSheet alloc] initWithTitle:nil];

    [actionSheet addButtonWithTitle:@"Ver no mapa" block:^{
        [[self _mapItemForIgreja] openInMapsWithLaunchOptions:nil];
    }];

    [actionSheet addButtonWithTitle:@"Rota de carro" block:^{
        MKMapItem *igrejaMapItem = [self _mapItemForIgreja];
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, igrejaMapItem] launchOptions:launchOptions];
    }];

    [actionSheet addButtonWithTitle:@"Rota à pé" block:^{
        MKMapItem *igrejaMapItem = [self _mapItemForIgreja];
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, igrejaMapItem] launchOptions:launchOptions];
    }];

    if ([NFGoogleMapsIntegration canOpenDirectionsInGoogleMaps]) {
        [actionSheet addButtonWithTitle:@"Rota no Google Maps" block:^{
            [NFGoogleMapsIntegration openDirectionsInGoogleMapsWithIgreja:self.igreja];
        }];
    }

    if ([NFWazeIntegration canOpenDirectionsInWaze]) {
        [actionSheet addButtonWithTitle:@"Rota no Waze" block:^{
            [NFWazeIntegration openDirectionsInWazeWithIgreja:self.igreja];
        }];
    }

    [actionSheet setCancelButtonWithTitle:@"Cancelar" block:nil];

    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)igrejaDetailPanel:(NFIgrejaDetailPanel *)panel phoneLinkTappedWithTextCheckingResults:(NSArray *)results
{
    PSPDFActionSheet *actionSheet = [[PSPDFActionSheet alloc] initWithTitle:nil];

    for (NSTextCheckingResult *result in results) {
        NSString *title = [NSString stringWithFormat:@"Ligar para %@", result.phoneNumber];
        [actionSheet addButtonWithTitle:title block:^{
            [[UIApplication sharedApplication] openURL:result.URL];
        }];
    }

    [actionSheet setCancelButtonWithTitle:@"Cancelar" block:nil];

    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)igrejaDetailPanelSiteLinkTapped:(NFIgrejaDetailPanel *)panel
{
    PSPDFActionSheet *actionSheet = [[PSPDFActionSheet alloc] initWithTitle:nil];

    [actionSheet addButtonWithTitle:@"Abrir link no navegador" block:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.igreja.site]];
    }];

    [actionSheet setCancelButtonWithTitle:@"Cancelar" block:nil];

    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

@end
