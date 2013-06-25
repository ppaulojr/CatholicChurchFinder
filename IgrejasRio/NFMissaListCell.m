//
//  NFMissaListCell.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 25/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFIgreja.h"
#import "NFMissaListCell.h"

static NSNumberFormatter *numberFormatter;

@interface NFMissaListCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation NFMissaListCell

+ (void)invalidateCachedLocale
{
    numberFormatter = nil;
}

- (NSNumberFormatter *)numberFormatter
{
    if (!numberFormatter) {
        numberFormatter = [NSNumberFormatter new];
        numberFormatter.minimumFractionDigits = 1;
        numberFormatter.maximumFractionDigits = 1;
        numberFormatter.minimumIntegerDigits = 1;
    }
    return numberFormatter;
}

- (void)configureWithEvent:(NFEvent *)event distance:(CLLocationDistance)distance
{
    self.titleLabel.text = event.igreja.nome;
    self.distanceLabel.text = [[[self numberFormatter] stringFromNumber:@(distance / 1000)] stringByAppendingString:@" km"];

    // Print the time and date (note that we don't take the
    // user locale into account here)
    self.detailLabel.text = [NSString stringWithFormat:@"%02d:%02d - %02d:%02d",
                             event.startTimeValue / 100, event.startTimeValue % 100,
                             event.endTimeValue / 100, event.endTimeValue % 100];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.distanceLabel sizeToFit];
    CGRect frame = self.distanceLabel.frame;
    frame.origin.x = CGRectGetMaxX(self.contentView.bounds) - CGRectGetWidth(frame) - 10;
    frame.origin.y = (CGRectGetHeight(self.contentView.bounds) - CGRectGetHeight(frame)) / 2;
    self.distanceLabel.frame = frame;

    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size.width = CGRectGetMinX(frame) - 10 - 8;
    self.titleLabel.frame = titleFrame;

    CGRect detailFrame = self.detailLabel.frame;
    detailFrame.size.width = titleFrame.size.width;
    self.detailLabel.frame = detailFrame;
}

@end
