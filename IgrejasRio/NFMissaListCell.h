//
//  NFMissaListCell.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 25/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NFEvent.h"

@interface NFMissaListCell : UITableViewCell

+ (void)invalidateCachedLocale;

- (void)configureWithEvent:(NFEvent *)event distance:(CLLocationDistance)distance;

@end
