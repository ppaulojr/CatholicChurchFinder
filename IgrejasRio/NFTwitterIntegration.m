//
//  NFTwitterIntegration.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 04/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFTwitterIntegration.h"

static NSString * const kURLScheme = @"twitter://";
static NSString * const kScreenNameURLFormat = @"twitter://user?screen_name=%@";
static NSString * const kStatusURLFormat = @"twitter://status?id=%@";

@implementation NFTwitterIntegration

+ (BOOL)canOpenTwitterApp
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kURLScheme]];
}

+ (void)openTwitterAppWithScreenName:(NSString *)screenName
{
    NSString *url = [NSString stringWithFormat:kScreenNameURLFormat, screenName];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openTwitterAppWithStatusID:(NSString *)statusID
{
    NSString *url = [NSString stringWithFormat:kStatusURLFormat, statusID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
