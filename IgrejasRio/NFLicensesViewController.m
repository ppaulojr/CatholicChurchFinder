//
//  NFLicensesViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 02/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFLicensesViewController.h"

@interface NFLicensesViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation NFLicensesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"licenses" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:htmlURL]];
}

@end
