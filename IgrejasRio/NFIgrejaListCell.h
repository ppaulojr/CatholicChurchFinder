//
//  NFIgrejaListCell.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 24/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFIgrejaListCell : UITableViewCell

+ (void)invalidateCachedLocale;

- (void)configureWithIgreja:(NFIgreja *)igreja distance:(CLLocationDistance)distance;

@end
