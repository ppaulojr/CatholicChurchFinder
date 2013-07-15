//
//  NFEvent.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 21/06/13.
//  Copyright (c) 2013 Fernando Lemos. All rights reserved.
//

#import "NFEvent.h"

@implementation NFEvent

- (NSString *)formattedTime
{
    // Note that this doesn't take into account the user's locale
    if (self.endTime) {
        return [NSString stringWithFormat:@"%02d:%02d - %02d:%02d",
                self.startTimeValue / 100, self.startTimeValue % 100,
                self.endTimeValue / 100, self.endTimeValue % 100];
    } else {
        return [NSString stringWithFormat:@"%02d:%02d",
                self.startTimeValue / 100, self.startTimeValue % 100];
    }
}

- (BOOL)matchesWithContext:(NFEventMatchContext *)context
{
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

+ (NFEvent *)firstMissaAfterDate:(NSDate *)date
                        calendar:(NSCalendar *)calendar
            managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[NFEvent entityName]];

    static const NSInteger interval = 50;
    for (NSInteger i = 0; i < 24 * 60; i += interval) {
        NSDateComponents *components = [NSDateComponents new];
        components.minute = interval;
        NSDate *limitDate = [calendar dateByAddingComponents:components toDate:date options:0];

        NSInteger startTime = [self _timeWithDate:date calendar:calendar];
        NSInteger limitTime = [self _timeWithDate:limitDate calendar:calendar];

        // Take into account the case where the limit time is on another day
        if (limitTime > startTime) {
            request.predicate = [NSPredicate predicateWithFormat:@"startTime >= %@ AND startTime <= %@ AND type == %@", @(startTime), @(limitTime), @(NFEventTypeMissa)];
        } else {
            request.predicate = [NSPredicate predicateWithFormat:@"((startTime >= %@ AND startTime <= 2359) OR (startTime >= 0 AND startTime <= %@)) AND type == %@", @(startTime), @(limitTime), @(NFEventTypeMissa)];
        }

        NSArray *events = [managedObjectContext executeFetchRequest:request error:NULL];

        events = [events sortedArrayUsingComparator:^NSComparisonResult(NFEvent *e1, NFEvent *e2) {
            NSInteger t1 = e1.startTimeValue;
            NSInteger t2 = e2.startTimeValue;

            // Offset for the fact that the start times might be on the
            // following day (this is why we can't use a sort descriptor)
            if (t1 < startTime) {
                t1 += 2400;
            }
            if (t2 < startTime) {
                t2 += 2400;
            }

            if (t1 > t2) {
                return NSOrderedDescending;
            } else if (t1 < t2) {
                return NSOrderedAscending;
            } else {
                return NSOrderedSame;
            }
        }];

        NFEventMatchContext *currentDayContext, *followingDayContext;

        for (NFEvent *event in events) {
            NFEventMatchContext *context;

            // Check if this event is in today's or the following day's date
            // and fetch the appropriate context
            if (event.startTimeValue >= startTime) {
                if (!currentDayContext) {
                    currentDayContext = [[NFEventMatchContext alloc] initWithReferenceDate:date calendar:calendar];
                }
                context = currentDayContext;
            } else {
                if (!followingDayContext) {
                    // We use the limit date instead because that must
                    // be on the following day
                    followingDayContext = [[NFEventMatchContext alloc] initWithReferenceDate:limitDate calendar:calendar];
                }
                context = followingDayContext;
            }

            if ([event matchesWithContext:context]) {
                return event;
            }
        }

        date = limitDate;
    }

    return nil;
}

+ (NSInteger)_timeWithDate:(NSDate *)date calendar:(NSCalendar *)calendar
{
    NSDateComponents *components = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    return components.hour * 100 + components.minute;
}

@end
