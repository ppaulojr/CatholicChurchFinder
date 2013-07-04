//
//  NFFacebookIntegration.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 04/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFFacebookIntegration : NSObject

+ (BOOL)canOpenFacebookApp;

+ (void)openProfileWithID:(NSString *)profileID;

@end
