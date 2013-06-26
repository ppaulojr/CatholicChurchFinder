//
//  NFIgrejaDetailViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 26/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFIgrejaDetailPanel.h"
#import "NFIgrejaDetailViewController.h"

@interface NFIgrejaDetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NFIgrejaDetailPanel *detailPanel;

@end

@implementation NFIgrejaDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.detailPanel = [NFIgrejaDetailPanel panel];
    [self.scrollView addSubview:self.detailPanel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.mapView.region = MKCoordinateRegionMakeWithDistance(self.igreja.coordinate, 1000, 1000);
    [self.mapView addAnnotation:self.igreja];

    [self.detailPanel configureWithIgreja:self.igreja];
}

- (void)viewWillLayoutSubviews
{
    [self.detailPanel sizeToFit];
    CGRect frame = self.detailPanel.frame;
    frame.origin.y = CGRectGetHeight(self.mapView.bounds);
    self.detailPanel.frame = frame;

    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetMaxY(frame));
}

@end