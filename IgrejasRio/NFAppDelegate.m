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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
