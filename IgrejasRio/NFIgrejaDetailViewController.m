//
//  NFIgrejaDetailViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 26/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <PSAlertView/PSPDFActionSheet.h>

#import "NFIgrejaDetailPanel.h"
#import "NFIgrejaDetailViewController.h"

@interface NFIgrejaDetailViewController () <NFIgrejaDetailPanelDelegate>

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


#pragma mark - Igreja detail panel delegate

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
