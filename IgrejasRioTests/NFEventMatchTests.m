//
//  NFEventMatchTests.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 12/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFCoreDataStackManager.h"
#import "NFEventMatchTests.h"
#import "NFMonthlyEvent.h"
#import "NFWeeklyEvent.h"
#import "NFYearlyEvent.h"

@interface NFEventMatchTests ()

@property (strong, nonatomic) NSCalendar *calendar;

@property (strong, nonatomic) NSManagedObjectContext *moc;

@end

@implementation NFEventMatchTests

- (void)setUp
{
    // Set up a gregorian calendar on UTC time
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    self.calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];

    // Create an in-memory persistent store
    NSManagedObjectModel *mom = [NFCoreDataStackManager sharedManager].managedObjectModel;
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    [psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL];

    // Use that coordinator with the managed object context
    self.moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.moc.persistentStoreCoordinator = psc;
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

- (void)testWeeklyEventMatch
{
    NFWeeklyEvent *event = [NFWeeklyEvent insertInManagedObjectContext:self.moc];
    event.weekdayValue = 7;

    NSDate *date = [self _dateWithYear:2013 month:5 day:18];
    NFEventMatchContext *context = [[NFEventMatchContext alloc] initWithReferenceDate:date calendar:self.calendar];

    STAssertTrue([event matchesWithContext:context], @"Weekly event failed to match context");

    date = [self _dateWithYear:2013 month:1 day:1];
    context = [[NFEventMatchContext alloc] initWithReferenceDate:date calendar:self.calendar];

    STAssertFalse([event matchesWithContext:context], @"Weekly event incorrectly matched context");

    [self.moc reset];
}

- (void)testMonthlyEventMatch
{
    NFMonthlyEvent *event = [NFMonthlyEvent insertInManagedObjectContext:self.moc];
    event.dayValue = 15;

    NSDate *date = [self _dateWithYear:2013 month:5 day:15];
    NFEventMatchContext *context = [[NFEventMatchContext alloc] initWithReferenceDate:date calendar:self.calendar];

    STAssertTrue([event matchesWithContext:context], @"Monthly event failed to match context");

    date = [self _dateWithYear:2013 month:5 day:18];
    context = [[NFEventMatchContext alloc] initWithReferenceDate:date calendar:self.calendar];

    STAssertFalse([event matchesWithContext:context], @"Monthly event incorrectly matched context");

    [self.moc reset];
}

- (void)testMonthlyEventMatchWithReverseWeekdayOrdinal
{
    NFMonthlyEvent *event = [NFMonthlyEvent insertInManagedObjectContext:self.moc];
    event.dayValue = 7;
    event.weekValue = -2;

    NSDate *date = [self _dateWithYear:2013 month:5 day:18];
    NFEventMatchContext *context = [[NFEventMatchContext alloc] initWithReferenceDate:date calendar:self.calendar];

    STAssertTrue([event matchesWithContext:context], @"Monthly event failed to match context");

    date = [self _dateWithYear:2013 month:5 day:25];
    context = [[NFEventMatchContext alloc] initWithReferenceDate:date calendar:self.calendar];

    STAssertFalse([event matchesWithContext:context], @"Monthly event incorrectly matched context");

    [self.moc reset];
}

- (void)testYearlyEventMatch
{
    NFYearlyEvent *event = [NFYearlyEvent insertInManagedObjectContext:self.moc];
    event.dayValue = 18;
    event.monthValue = 5;

    NSDate *date = [self _dateWithYear:2013 month:5 day:18];
    NFEventMatchContext *context = [[NFEventMatchContext alloc] initWithReferenceDate:date calendar:self.calendar];

    STAssertTrue([event matchesWithContext:context], @"Yearly event failed to match context");

    date = [self _dateWithYear:2013 month:5 day:20];
    context = [[NFEventMatchContext alloc] initWithReferenceDate:date calendar:self.calendar];

    STAssertFalse([event matchesWithContext:context], @"Yearly event incorrectly matched context");

    [self.moc reset];
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
