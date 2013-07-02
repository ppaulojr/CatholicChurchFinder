//
//  NFAppDelegate.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 20/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFAppDelegate.h"

@implementation NFAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UINavigationBar *allNavBars = [UINavigationBar appearance];
    allNavBars.tintColor = [UIColor colorWithRed:53/255.0 green:139/255.0 blue:171/255.0 alpha:1];

    return YES;
}

@end
