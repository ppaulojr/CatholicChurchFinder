//
//  NFFacebookIntegration.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 04/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFFacebookIntegration.h"

static NSString * const kURLScheme = @"fb://";
static NSString * const kProfileURLFormat = @"fb://profile/%@";

@implementation NFFacebookIntegration

+ (BOOL)canOpenFacebookApp
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kURLScheme]];
}

+ (void)openProfileWithID:(NSString *)profileID
{
    NSString *url = [NSString stringWithFormat:kProfileURLFormat, profileID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
