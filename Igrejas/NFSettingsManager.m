//
//  NFSettingsManager.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 01/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFSettingsManager.h"

static NSString * const kNFConfigurationManagerMapTypeKey = @"NFConfigurationManagerMapTypeKey";

@implementation NFSettingsManager

+ (instancetype)sharedManager
{
    static NFSettingsManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NFSettingsManager new];
    });
    return instance;
}

- (MKMapType)mapType
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:kNFConfigurationManagerMapTypeKey];
    if (number) {
        return [number intValue];
    } else {
        return MKMapTypeStandard;
    }
}

- (void)setMapType:(MKMapType)mapType
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:mapType forKey:kNFConfigurationManagerMapTypeKey];
    [defaults synchronize];
}

@end
