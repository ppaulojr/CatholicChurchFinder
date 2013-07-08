//
//  NFMonthlyEvent.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 21/06/13.
//  Copyright (c) 2013 Fernando Lemos. All rights reserved.
//

#import "NFMonthlyEvent.h"

@implementation NFMonthlyEvent

- (BOOL)matchesWithContext:(NFEventMatchContext *)context
{
    if (self.weekValue == 0) {
        // This is an event that happens every month on
        // a specific day of the month
        return self.dayValue == context.referenceDateComponents.day;
    }

    if (self.dayValue != context.referenceDateComponents.weekday) {
        // No match
        return NO;
    }

    // This is an event that happens every month on
    // a specific weekday on a specific week and we
    // already checked that the weekday matches

    if (self.weekValue > 0) {
        // The specific week is the ordinal number of the week
        // (e.g. first monday of every month)
        return self.weekValue == context.referenceDateComponents.weekdayOrdinal;
    } else {
        // The specific week is an offset from the first weekday
        // in the next month (e.g. last monday of every month)
        return self.weekValue == context.reverseWeekdayOrdinal;
    }
}

@end
