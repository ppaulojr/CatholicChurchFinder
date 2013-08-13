//
//  NFTwitterIntegration.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 04/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFTwitterIntegration : NSObject

+ (BOOL)canOpenTwitterApp;

+ (void)openTwitterAppWithScreenName:(NSString *)screenName;

+ (void)openTwitterAppWithStatusID:(NSString *)statusID;

@end
