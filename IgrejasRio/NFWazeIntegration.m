//
//  NFWazeIntegration.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 02/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFWazeIntegration.h"

static NSString * const kURLScheme = @"waze://";
static NSString * const kURLFormat = @"%@?ll=%f,%f&navigate=yes";

@implementation NFWazeIntegration

+ (BOOL)canOpenDirectionsInWaze
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kURLScheme]];
}

+ (void)openDirectionsInWazeWithIgreja:(NFIgreja *)igreja
{
    NSString *url = [NSString stringWithFormat:kURLFormat, kURLScheme, igreja.latitudeValue, igreja.longitudeValue];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
