//
//  NFAdBannerManager.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 04/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFAdBannerManager : NSObject

+ (instancetype)sharedManagerWithRootViewController:(UIViewController *)rootViewController;

- (void)takeOverAdBannerWithAddBlock:(void (^)(UIView *))addBlock removeBlock:(void (^)(UIView *))removeBlock;

@end

