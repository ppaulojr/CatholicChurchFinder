//
//  NFSettingsManager.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 01/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFSettingsManager : NSObject

@property (assign, nonatomic) MKMapType mapType;

+ (instancetype)sharedManager;

@end
