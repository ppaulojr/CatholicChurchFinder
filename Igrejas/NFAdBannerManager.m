//
//  NFAdBannerManager.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 04/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <AdMob/GADBannerView.h>

#import "NFAdBannerManager.h"

@interface NFAdBannerManager () <GADBannerViewDelegate>

@property (getter = isBannerVisible, assign, nonatomic) BOOL bannerVisible;

@property (strong, nonatomic) GADBannerView *bannerView;

@property (strong, nonatomic) void (^currentAddBlock)(UIView *);

@property (strong, nonatomic) void (^currentRemoveBlock)(UIView *);

@end

@implementation NFAdBannerManager

+ (instancetype)sharedManagerWithRootViewController:(UIViewController *)rootViewController
{
    static NFAdBannerManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NFAdBannerManager alloc] initWithRootViewController:rootViewController];
    });
    return instance;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if (self) {
        /*
        self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        self.bannerView.delegate = self;
        self.bannerView.alpha = 0;
        self.bannerView.adUnitID = @"a151d5833b1b003";
        self.bannerView.rootViewController = rootViewController;
        [self.bannerView loadRequest:[GADRequest request]];
         */
    }
    return self;
}

- (void)takeOverAdBannerWithAddBlock:(void (^)(UIView *))addBlock removeBlock:(void (^)(UIView *))removeBlock
{
    if (self.currentRemoveBlock) {
        self.currentRemoveBlock(self.bannerView);
    }

    if (self.isBannerVisible) {
        self.currentAddBlock = nil;
        addBlock(self.bannerView);
    } else {
        self.currentAddBlock = addBlock;
    }

    self.currentRemoveBlock = removeBlock;
}


#pragma mark - Ad banner view delegate

#ifdef DEBUG
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"Failed to receive AdMob ads: %@", error.localizedDescription);
}
#endif

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    self.bannerVisible = YES;

    [UIView animateWithDuration:0.5 animations:^{
        self.bannerView.alpha = 1;
    }];

    if (self.currentAddBlock) {
        self.currentAddBlock(self.bannerView);
        self.currentAddBlock = nil;
    }
}

@end
