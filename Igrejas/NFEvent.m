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
        request.predicate = [self _predicateWithStartTime:startTime limitTime:limitTime];

        NSArray *events = [managedObjectContext executeFetchRequest:request error:NULL];
        events = [self _sortedEvents:events withStartTime:startTime];

        __block NFEvent *matchingEvent;
        [self _enumerateMatchingEvents:events withStartTime:startTime startDate:date limitDate:limitDate calendar:calendar block:^(NFEvent *event, BOOL *stop) {
            matchingEvent = event;
            *stop = YES;
        }];

        if (matchingEvent) {
            return matchingEvent;
        }

        date = limitDate;
    }

    return nil;
}

+ (NSArray *)nextMissasAfterEvent:(NFEvent *)event
                         withSpan:(NSInteger)spanInMinutes
                         date:(NSDate *)date
                         calendar:(NSCalendar *)calendar
             managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[NFEvent entityName]];

    NSInteger startTime = event.startTimeValue;
    NSInteger limitTime = (startTime + (spanInMinutes / 60) * 100 + (spanInMinutes % 60)) % 2400;
    request.predicate = [self _predicateWithStartTime:startTime limitTime:limitTime];

    NSArray *events = [managedObjectContext executeFetchRequest:request error:NULL];

    /*
     * Consider the case where the first event found after the current time is
     * actually on the following day. In that case, we need to use the following
     * day's match context in order to verify if the next events match.
     *
     * How can we tell exactly which date was used in the match context to check
     * if the event matches? Well, if the start time is lesser than the specified
     * date, that means it's a match from tomorrow.
     */

    NSDate *startDate;

    NSDateComponents *components = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    if (startTime > components.hour * 100 + components.minute) {
        startDate = date;
    } else {
        NSDateComponents *components = [NSDateComponents new];
        components.day = 1;
        startDate = [calendar dateByAddingComponents:components toDate:date options:0];
    }

    components = [NSDateComponents new];
    components.minute = spanInMinutes;
    NSDate *limitDate = [calendar dateByAddingComponents:components toDate:startDate options:0];

    events = [self _filteredEvents:events withStartTime:startTime startDate:startDate limitDate:limitDate calendar:calendar];
    events = [self _sortedEvents:events withStartTime:startTime];

    return events;
}

+ (NSArray *)_sortedEvents:(NSArray *)events withStartTime:(NSInteger)startTime
{
    return [events sortedArrayUsingComparator:^NSComparisonResult(NFEvent *e1, NFEvent *e2) {
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
}

+ (NSArray *)_filteredEvents:(NSArray *)events
               withStartTime:(NSInteger)startTime
                   startDate:(NSDate *)startDate
                   limitDate:(NSDate *)limitDate
                    calendar:(NSCalendar *)calendar
{
    NSMutableArray *filtered = [NSMutableArray arrayWithCapacity:events.count];

    [self _enumerateMatchingEvents:events withStartTime:startTime startDate:startDate limitDate:limitDate calendar:calendar block:^(NFEvent *event, BOOL *stop) {
        [filtered addObject:event];
    }];

    return filtered;
}

+ (void)_enumerateMatchingEvents:(NSArray *)events
                   withStartTime:(NSInteger)startTime
                       startDate:(NSDate *)startDate
                       limitDate:(NSDate *)limitDate
                        calendar:(NSCalendar *)calendar
                           block:(void (^)(NFEvent *, BOOL *))block
{
    NFEventMatchContext *currentDayContext, *followingDayContext;

    for (NFEvent *event in events) {
        NFEventMatchContext *context;

        // Check if this event is in today's or the following day's date
        // and fetch the appropriate context
        if (event.startTimeValue >= startTime) {
            if (!currentDayContext) {
                currentDayContext = [[NFEventMatchContext alloc] initWithReferenceDate:startDate calendar:calendar];
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
            BOOL stop = NO;
            block(event, &stop);
            if (stop) {
                break;
            }
        }
    }
}

+ (NSPredicate *)_predicateWithStartTime:(NSInteger)startTime limitTime:(NSInteger)limitTime
{
    if (limitTime > startTime) {
        return [NSPredicate predicateWithFormat:@"startTime >= %@ AND startTime <= %@ AND type == %@", @(startTime), @(limitTime), @(NFEventTypeMissa)];
    } else {
        // Take into account the case where the limit time is on another day
        return [NSPredicate predicateWithFormat:@"((startTime >= %@ AND startTime <= 2359) OR (startTime >= 0 AND startTime <= %@)) AND type == %@", @(startTime), @(limitTime), @(NFEventTypeMissa)];
    }
}

+ (NSInteger)_timeWithDate:(NSDate *)date calendar:(NSCalendar *)calendar
{
    NSDateComponents *components = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    return components.hour * 100 + components.minute;
}

@end
