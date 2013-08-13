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
    return [[CLLocation alloc] initWithLatitude:27.509642 longitude:-99.504461];
}

@end
