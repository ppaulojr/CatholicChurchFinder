//
//  NFIgrejaDetailPanel.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 26/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NFIgreja.h"

@interface NFIgrejaDetailPanel : UIView

+ (instancetype)panel;

- (void)configureWithIgreja:(NFIgreja *)igreja;

@end
