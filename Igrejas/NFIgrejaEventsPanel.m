//
//  NFIgrejaEventsPanel.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 26/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFIgreja.h"
#import "NFIgrejaEventsPanel.h"
#import "NFMonthlyEvent.h"
#import "NFWeeklyEvent.h"
#import "NFYearlyEvent.h"
#import "OrdinalNumberFormatter.h"

#define CMP(x, y) \
    if ((x) > (y)) { \
        return NSOrderedDescending; \
    } else if ((y) > (x)) { \
        return NSOrderedAscending; \
    } else

#define CMP_STR(x, y) \
    do { \
        if ((x) && (y)) { \
            return [(x) compare:(y)]; \
        } else if ((x)) { \
            return NSOrderedDescending; \
        } else if ((y)) { \
            return NSOrderedAscending; \
        } else { \
            return NSOrderedSame; \
        } \
    } while (NO)


static NSString * const weekdayNames[] = {
    @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"
};

static NSString * const ordinalNamesM[] = {
    @"third last", @"second last", @"Último", nil,
    @"1st", @"2nd", @"3rd", @"4th", @"5th"
};

static NSString * const ordinalNamesF[] = {
    @"third last", @"second last", @"Last", nil,
    @"1st", @"2nd", @"3rd", @"4th", @"5th"
};

static BOOL weekdayIsM[] = {
    YES, NO, NO, NO, NO, NO, YES
};

static const int ordinalZero = 3;


@interface NFIgrejaEventPair : NSObject

@property (nonatomic, strong) NSString *headerText;

@property (nonatomic, strong) NSString *contentText;

@end

@implementation NFIgrejaEventPair

- (NSString *)description
{
    return [NSString stringWithFormat:@"<header = %@, content = %@>", self.headerText, self.contentText];
}

@end


@interface NFIgrejaEventsPanel ()

@property (strong, nonatomic) NSMutableArray *eventPairs;

@end

@implementation NFIgrejaEventsPanel

- (void)configureWithEvents:(NSSet *)events
{
    // Get rid of any previous subviews
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    // Handle this specific case
    if (events.count == 0) {
        UILabel *label = [UILabel new];
        label.font = [UIFont italicSystemFontOfSize:14];
        label.textColor = [UIColor grayColor];
        label.text = @"(No event reported)";
        [label sizeToFit];
        [self addSubview:label];
        return;
    }

    // TODO: Move part of this to the model, add unit tests

    self.eventPairs = [NSMutableArray arrayWithCapacity:events.count];
    NSArray *allEvents = [events allObjects];

    // Add the weekly events first
    NSPredicate *weeklyPredicate = [NSPredicate predicateWithFormat:@"self.class == %@", [NFWeeklyEvent class]];
    NSArray *weeklyEvents = [allEvents filteredArrayUsingPredicate:weeklyPredicate];
    [self _addWeeklyEvents:weeklyEvents];

    // Then add the monthly events
    NSPredicate *monthlyPredicate = [NSPredicate predicateWithFormat:@"self.class == %@", [NFMonthlyEvent class]];
    NSArray *monthlyEvents = [allEvents filteredArrayUsingPredicate:monthlyPredicate];
    [self _addMonthlyEvents:monthlyEvents];

    // And then the yearly events
    NSPredicate *yearlyPredicate = [NSPredicate predicateWithFormat:@"self.class == %@", [NFYearlyEvent class]];
    NSArray *yearlyEvents = [allEvents filteredArrayUsingPredicate:yearlyPredicate];
    [self _addYearlyEvents:yearlyEvents];

    // Finally place the labels
    [self _placeLabels];

    // Done with this
    self.eventPairs = nil;
}

- (void)_placeLabels
{
    for (NFIgrejaEventPair *pair in self.eventPairs) {
        // Create the header label
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 9999, 9999)];
        headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
        headerLabel.textColor = [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1];
        headerLabel.text = pair.headerText;
        [self addSubview:headerLabel];

        // We can size the header here
        [headerLabel sizeToFit];

        // Create the content label
        UILabel *contentLabel = [UILabel new];
        contentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        contentLabel.text = pair.contentText;
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
    }
}

- (void)layoutSubviews
{
    BOOL handlingHeader = YES;
    CGFloat lastY = 0;
    CGRect maxFrame = CGRectMake(0, 0, self.bounds.size.width, 9999);

    for (UILabel *label in self.subviews) {
        CGRect frame;

        if (handlingHeader) {
            // Just position the header
            frame = label.frame;
            frame.origin.y = lastY;

            // Increment by the small distance
            lastY += frame.size.height + 4;
        } else {
            // Size the label
            label.frame = maxFrame;
            [label sizeToFit];

            // Position it
            frame = label.frame;
            frame.origin.y = lastY;

            // Increment by the big distnace
            lastY += frame.size.height + 20;
        }

        label.frame = frame;
        handlingHeader = !handlingHeader;
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    [self layoutIfNeeded];

    UIView *lastSubview = self.subviews.lastObject;
    size.height = CGRectGetMaxY(lastSubview.frame);
    return size;
}

- (void)_addWeeklyEvents:(NSArray *)events
{
    if (!events.count) {
        return;
    }

    // Order the events by weekday and then start time
    events = [events sortedArrayUsingComparator:^NSComparisonResult(NFWeeklyEvent *e1, NFWeeklyEvent *e2) {
        CMP(e1.weekdayValue, e2.weekdayValue) {
            CMP(e1.startTimeValue, e2.startTimeValue) {
                CMP_STR(e1.observation, e2.observation);
            }
        }
    }];

    NSMutableArray *buckets[7] = { nil };

    for (NFWeeklyEvent *event in events) {
        // If we haven't created this bucket, create it now
        int index = event.weekdayValue - 1;
        NSMutableArray *bucket = buckets[index];
        if (!bucket) {
            bucket = [NSMutableArray array];
            buckets[index] = bucket;
        }

        // Add the text to the bucket
        NSString *text = [event formattedTime];
        if (event.observation) {
            text = [text stringByAppendingFormat:@" %@", event.observation];
        }
        [bucket addObject:text];
    }

    for (int i = 0; i < 7; i++) {
        // Nothing to do if we don't have events on this weekday
        NSArray *bucket = buckets[i];
        if (!bucket) {
            continue;
        }

        // Find the weekday name
        NSString *weekdayName = weekdayNames[i];
        assert(weekdayName);

        // Find the content
        NSString *content = [bucket componentsJoinedByString:@", "];

        // Add the pair
        NFIgrejaEventPair *pair = [NFIgrejaEventPair new];
        pair.headerText = [weekdayName stringByAppendingString:@":"];
        pair.contentText = content;
        [self.eventPairs addObject:pair];
    }
}

- (void)_addMonthlyEvents:(NSArray *)events
{
    if (!events.count) {
        return;
    }

    NSMutableDictionary *buckets = [NSMutableDictionary dictionaryWithCapacity:events.count];

    // Sort the events by start time so they're already
    // sorted when we join them in a string
    events = [events sortedArrayUsingComparator:^NSComparisonResult(NFMonthlyEvent *e1, NFMonthlyEvent *e2) {
        CMP(e1.startTimeValue, e2.startTimeValue) {
            return NSOrderedSame;
        }
    }];

    // Group together events in the same day, using a key
    // that allows us to sort the events
    for (NFMonthlyEvent *event in events) {
        int keyInt = event.dayValue;
        if (event.weekValue == 0) {
            // Absolute day of month will come later
            keyInt += 1000000;
        } else {
            int weekValueForKey = event.weekValue;
            if (weekValueForKey < 0) {
                // We want "last or before last" type specifiers
                // to be shown after "first or second" specifiers,
                // and we also want them in the reverse order (i.e.,
                // before last should come before the last one)
                weekValueForKey += 100;
            }
            keyInt += 10000 * event.weekValue;
        }

        NSNumber *key = @(keyInt);
        NSMutableArray *bucket = buckets[key];
        if (!bucket) {
            bucket = [NSMutableArray array];
            buckets[key] = bucket;
        }
        [bucket addObject:event];
    }

    // Sort the buckets so we can iterate in order
    NSArray *sortedKeys = [[buckets allKeys] sortedArrayUsingSelector:@selector(compare:)];

    // Finally output the text for each bucket
    for (NSNumber *key in sortedKeys) {
        NSArray *bucket = buckets[key];
        NFIgrejaEventPair *pair = [NFIgrejaEventPair new];

        NFMonthlyEvent *firstEvent = bucket[0];
        if (firstEvent.weekValue == 0) {
            OrdinalNumberFormatter * onf = [[OrdinalNumberFormatter alloc] init];
            pair.headerText = [NSString stringWithFormat:@"Every %@:", [onf stringForObjectValue:@((int)firstEvent.dayValue)]];
        } else {
            int weekdayIndex = firstEvent.dayValue - 1;
            NSString *weekday = weekdayNames[weekdayIndex];
            NSString * const *ordinalNames = weekdayIsM[weekdayIndex] ? ordinalNamesM : ordinalNamesF;

            int ordinalindex = ordinalZero + firstEvent.weekValue;
            NSString *ordinalName = ordinalNames[ordinalindex];

            pair.headerText = [NSString stringWithFormat:@"%@ %@:", ordinalName, weekday];
        }

        // Get the formatted time and observation from each event
        NSMutableArray *textComponents = [NSMutableArray arrayWithCapacity:bucket.count];
        for (NFMonthlyEvent *event in bucket) {
            NSString *text = [event formattedTime];
            if (event.observation) {
                text = [text stringByAppendingFormat:@" %@", event.observation];
            }
            [textComponents addObject:text];
        }

        // Define the content text
        pair.contentText = [textComponents componentsJoinedByString:@", "];

        // Add the pair to the list
        [self.eventPairs addObject:pair];
    }
}

- (void)_addYearlyEvents:(NSArray *)events
{
    // Sort by month, day and start time
    events = [events sortedArrayUsingComparator:^NSComparisonResult(NFYearlyEvent *ev1, NFYearlyEvent *ev2) {
        CMP(ev1.monthValue, ev2.monthValue) {
            CMP(ev1.dayValue, ev2.dayValue) {
                CMP(ev1.startTimeValue, ev2.startTimeValue) {
                    CMP_STR(ev1.observation, ev2.observation);
                }
            }
        }
    }];

    // Simply output them
    for (NFYearlyEvent *event in events) {
        NFIgrejaEventPair *pair = [NFIgrejaEventPair new];
        pair.headerText = [NSString stringWithFormat:@"Every %02d/%02d", event.monthValue, event.dayValue];

        NSString *text = [event formattedTime];
        if (event.observation) {
            text = [text stringByAppendingFormat:@" %@", event.observation];
        }
        pair.contentText = text;

        [self.eventPairs addObject:pair];
    }
}

@end
