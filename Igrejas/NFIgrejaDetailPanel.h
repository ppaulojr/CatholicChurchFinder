//
//  NFIgrejaDetailPanel.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 26/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NFIgreja.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@protocol NFIgrejaDetailPanelDelegate;


@interface NFIgrejaDetailPanel : UIView

@property (weak, nonatomic) id <NFIgrejaDetailPanelDelegate> delegate;

+ (instancetype)panel;

- (void)configureWithIgreja:(NFIgreja *)igreja;

@end


@protocol NFIgrejaDetailPanelDelegate <NSObject>

- (void)igrejaDetailPanelAddressLinkTapped:(NFIgrejaDetailPanel *)panel;

- (void)igrejaDetailPanel:(NFIgrejaDetailPanel *)panel phoneLinkTappedWithTextCheckingResults:(NSArray *)results;

- (void)igrejaDetailPanelSiteLinkTapped:(NFIgrejaDetailPanel *)panel;

@end
