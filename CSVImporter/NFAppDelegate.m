//
//  NFAppDelegate.m
//  CSVImporter
//
//  Created by Fernando Lemos on 21/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFAppDelegate.h"
#import "NFCoreDataStackManager+Import.h"

@implementation NFAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if !TARGET_IPHONE_SIMULATOR
# error "You must compile and run this in the simulator!"
#endif

    NSLog(@"Starting import...");
    [[NFCoreDataStackManager sharedManager] performImport];
    NSLog(@"Importing done!");
    NSLog(@"Get the Core Data database at: %@", [NFCoreDataStackManager sharedManager].importOutputDatabasePath);

    exit(0);
}

@end
