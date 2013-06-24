//
//  NFIgrejaListCell.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 24/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFIgreja.h"
#import "NFIgrejaListCell.h"

static NSNumberFormatter *numberFormatter;

@interface NFIgrejaListCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation NFIgrejaListCell

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
    }
    return numberFormatter;
}

- (void)configureWithIgreja:(NFIgreja *)igreja distance:(CLLocationDistance)distance
{
    self.titleLabel.text = igreja.nome;
    self.detailLabel.text = igreja.bairro;
    self.distanceLabel.text = [[[self numberFormatter] stringFromNumber:@(distance / 1000)] stringByAppendingString:@" km"];
}

@end
