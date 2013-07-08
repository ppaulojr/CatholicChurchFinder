//
//  NFWeeklyEvent.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 21/06/13.
//  Copyright (c) 2013 Fernando Lemos. All rights reserved.
//

#import "NFWeeklyEvent.h"

@implementation NFWeeklyEvent

- (BOOL)matchesWithContext:(NFEventMatchContext *)context
{
    return self.weekdayValue == context.referenceDateComponents.weekday;
}

@end
