//
//  CLLocation+NFDefaultLocation.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 25/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "CLLocation+NFDefaultLocation.h"

@implementation CLLocation (NFDefaultLocation)

+ (CLLocation *)nf_defaultLocation
{
    return [[CLLocation alloc] initWithLatitude:-22.903534 longitude:-43.209572];
}

@end
