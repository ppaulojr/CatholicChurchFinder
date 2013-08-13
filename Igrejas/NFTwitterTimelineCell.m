//
//  NFTwitterTimelineCell.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 04/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFTwitterTimelineCell.h"

@implementation NFTwitterTimelineCell

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize totalSize = self.contentView.bounds.size;

    CGRect imageFrame = CGRectMake(10, 0, 48, 48);
    imageFrame.origin.y = (totalSize.height - imageFrame.size.height) / 2;
    self.imageView.frame = imageFrame;

    CGRect frame = self.textLabel.frame;
    frame.origin.x = CGRectGetMaxX(imageFrame) + 8;
    frame.size.width = totalSize.width - frame.origin.x - 10;
    self.textLabel.frame = frame;
}

@end
