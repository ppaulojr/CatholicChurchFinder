//
//  NFEventMatchContext.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 08/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFEventMatchContext.h"

@interface NFEventMatchContext ()

@property (strong, nonatomic) NSDateComponents *referenceDateComponents;

@property (assign, nonatomic) NSInteger reverseWeekdayOrdinal;

@end

@implementation NFEventMatchContext

- (id)initWithReferenceDate:(NSDate *)referenceDate calendar:(NSCalendar *)calendar
{
    self = [super init];
    if (self) {
        // TODO: Add unit tests for matching in general

        // Get the components we'll need
        NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit;
        self.referenceDateComponents = [calendar components:flags fromDate:referenceDate];

        // Find out the reverse weekday ordinal
        self.reverseWeekdayOrdinal = [self _reverseWeekdayOrdinalWithCalendar:calendar];
    }
    return self;
}

- (NSInteger)_reverseWeekdayOrdinalWithCalendar:(NSCalendar *)calendar
{
    // Find out what is the last weekday in the month of the reference date
    NSDateComponents *lastWeekdayComp = [NSDateComponents new];
    lastWeekdayComp.year = self.referenceDateComponents.year;
    lastWeekdayComp.month = self.referenceDateComponents.month;
    lastWeekdayComp.weekday = self.referenceDateComponents.weekday;
    lastWeekdayComp.weekdayOrdinal = -1;
    NSDate *lastWeekday = [calendar dateFromComponents:lastWeekdayComp];

    // Get the start date without time
    NSDateComponents *refDateWithoutTimeComp = [NSDateComponents new];
    refDateWithoutTimeComp.era = self.referenceDateComponents.era;
    refDateWithoutTimeComp.year = self.referenceDateComponents.year;
    refDateWithoutTimeComp.month = self.referenceDateComponents.month;
    refDateWithoutTimeComp.day = self.referenceDateComponents.day;
    NSDate *startDateWithoutTime = [calendar dateFromComponents:refDateWithoutTimeComp];

    // Figure out how many weeks from the last week
    NSDateComponents *weeksFromLastWeekdayComp = [calendar components:NSWeekCalendarUnit fromDate:lastWeekday toDate:startDateWithoutTime options:0];
    return weeksFromLastWeekdayComp.week - 1;
}

@end
