//
//  NFEventMatchTests.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 12/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFEventMatchTests.h"
#import "NFEventMatchContext.h"

@interface NFEventMatchTests ()

@property (strong, nonatomic) NSCalendar *calendar;

@end

@implementation NFEventMatchTests

- (void)setUp
{
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    self.calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
}

- (void)testEventMatchContext
{
    NSDate *date = [self _dateWithYear:2013 month:5 day:18];
    NFEventMatchContext *context = [[NFEventMatchContext alloc] initWithReferenceDate:date calendar:self.calendar];

    STAssertEquals(context.referenceDateComponents.day, 18, nil);
    STAssertEquals(context.referenceDateComponents.month, 5, nil);
    STAssertEquals(context.referenceDateComponents.weekday, 7, nil);
    STAssertEquals(context.reverseWeekdayOrdinal, -2, nil);

    date = [self _dateWithYear:2013 month:5 day:25];
    context = [[NFEventMatchContext alloc] initWithReferenceDate:date calendar:self.calendar];

    STAssertEquals(context.referenceDateComponents.day, 25, nil);
    STAssertEquals(context.referenceDateComponents.month, 5, nil);
    STAssertEquals(context.referenceDateComponents.weekday, 7, nil);
    STAssertEquals(context.reverseWeekdayOrdinal, -1, nil);

    date = [self _dateWithYear:2013 month:5 day:24];
    context = [[NFEventMatchContext alloc] initWithReferenceDate:date calendar:self.calendar];

    STAssertEquals(context.referenceDateComponents.day, 24, nil);
    STAssertEquals(context.referenceDateComponents.month, 5, nil);
    STAssertEquals(context.referenceDateComponents.weekday, 6, nil);
    STAssertEquals(context.reverseWeekdayOrdinal, -2, nil);

    date = [self _dateWithYear:2013 month:5 day:31];
    context = [[NFEventMatchContext alloc] initWithReferenceDate:date calendar:self.calendar];

    STAssertEquals(context.referenceDateComponents.day, 31, nil);
    STAssertEquals(context.referenceDateComponents.month, 5, nil);
    STAssertEquals(context.referenceDateComponents.weekday, 6, nil);
    STAssertEquals(context.reverseWeekdayOrdinal, -1, nil);

    date = [self _dateWithYear:2013 month:1 day:1];
    context = [[NFEventMatchContext alloc] initWithReferenceDate:date calendar:self.calendar];

    STAssertEquals(context.referenceDateComponents.day, 1, nil);
    STAssertEquals(context.referenceDateComponents.month, 1, nil);
    STAssertEquals(context.referenceDateComponents.weekday, 3, nil);
    STAssertEquals(context.reverseWeekdayOrdinal, -5, nil);

    date = [self _dateWithYear:2013 month:12 day:31];
    context = [[NFEventMatchContext alloc] initWithReferenceDate:date calendar:self.calendar];

    STAssertEquals(context.referenceDateComponents.day, 31, nil);
    STAssertEquals(context.referenceDateComponents.month, 12, nil);
    STAssertEquals(context.referenceDateComponents.weekday, 3, nil);
    STAssertEquals(context.reverseWeekdayOrdinal, -1, nil);
}

- (NSDate *)_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDateComponents *components = [NSDateComponents new];
    components.year = year;
    components.month = month;
    components.day = day;

    return [self.calendar dateFromComponents:components];
}

@end
