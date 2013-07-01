//
//  NFIgrejaDetailPanel.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 26/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NFIgreja.h"

@protocol NFIgrejaDetailPanelDelegate;


@interface NFIgrejaDetailPanel : UIView

@property (weak, nonatomic) id <NFIgrejaDetailPanelDelegate> delegate;

+ (instancetype)panel;

- (void)configureWithIgreja:(NFIgreja *)igreja;

@end


@protocol NFIgrejaDetailPanelDelegate <NSObject>

- (void)igrejaDetailPanelSiteLinkTapped:(NFIgrejaDetailPanel *)panel;

- (void)igrejaDetailPanel:(NFIgrejaDetailPanel *)panel phoneLinkTappedWithTextCheckingResults:(NSArray *)results;

@end
