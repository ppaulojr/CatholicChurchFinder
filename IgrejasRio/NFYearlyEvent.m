//
//  NFYearlyEvent.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 21/06/13.
//  Copyright (c) 2013 Fernando Lemos. All rights reserved.
//

#import "NFYearlyEvent.h"

@implementation NFYearlyEvent

- (BOOL)matchesWithContext:(NFEventMatchContext *)context
{
    return self.dayValue == context.referenceDateComponents.day &&
    self.monthValue == context.referenceDateComponents.month;
}

@end
