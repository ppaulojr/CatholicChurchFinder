//
//  NFGoogleMapsIntegration.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 02/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NFIgreja.h"

@interface NFGoogleMapsIntegration : NSObject

+ (BOOL)canOpenDirectionsInGoogleMaps;

+ (void)openDirectionsInGoogleMapsWithIgreja:(NFIgreja *)igreja;

@end
