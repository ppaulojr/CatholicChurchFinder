//
//  NFAdBannerManager.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 04/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//


#import "NFAdBannerManager.h"

@interface NFAdBannerManager ()


@end

@implementation NFAdBannerManager

+ (instancetype)sharedManagerWithRootViewController:(UIViewController *)rootViewController
{
    static NFAdBannerManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NFAdBannerManager alloc] initWithRootViewController:rootViewController];
    });
    return instance;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if (self) {
 
    }
    return self;
}

@end
