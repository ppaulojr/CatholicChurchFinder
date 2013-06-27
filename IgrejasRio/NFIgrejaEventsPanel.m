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

#define CMP(x, y) \
    if ((x) > (y)) { \
        return NSOrderedDescending; \
    } else if ((y) > (x)) { \
        return NSOrderedAscending; \
    } else


static NSString * const weekdayNames[] = {
    @"Domingo", @"Segunda", @"Terça", @"Quarta", @"Quinta", @"Sexta", @"Sábado"
};

static NSString * const ordinalNamesM[] = {
    @"Antepenúltimo", @"Penúltimo", @"Último", nil,
    @"Primeiro", @"Segundo", @"Terceiro", @"Quarto", @"Quinto"
};

static NSString * const ordinalNamesF[] = {
    @"Antepenúltima", @"Penúltima", @"Última", nil,
    @"Primeira", @"Segunda", @"Terceira", @"Quarta", @"Quinta"
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

@property (assign, nonatomic) CGFloat largestHeaderWidth;

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
        label.text = @"(Nenhum evento informado)";
        [label sizeToFit];
        self.largestHeaderWidth = label.frame.size.width;
        [self addSubview:label];
        return;
    }

    // TODO: Move part of this to the model, add unit tests

    self.eventPairs = [NSMutableArray arrayWithCapacity:events.count];

    // Add the weekly events first
    NSPredicate *weeklyPredicate = [NSPredicate predicateWithFormat:@"self.class == %@", [NFWeeklyEvent class]];
    NSArray *weeklyEvents = [[events allObjects] filteredArrayUsingPredicate:weeklyPredicate];
    [self _addWeeklyEvents:weeklyEvents];

    // Then add the monthly events
    NSPredicate *monthlyPredicate = [NSPredicate predicateWithFormat:@"self.class == %@", [NFMonthlyEvent class]];
    NSArray *monthlyEvents = [[events allObjects] filteredArrayUsingPredicate:monthlyPredicate];
    [self _addMonthlyEvents:monthlyEvents];

    // TODO: And then the yearly events

    // Finally place the labels
    [self _placeLabels];

    // Done with this
    self.eventPairs = nil;
}

- (void)_placeLabels
{
    self.largestHeaderWidth = 0;

    for (NFIgrejaEventPair *pair in self.eventPairs) {
        // Create the header label
        UILabel *headerLabel = [UILabel new];
        headerLabel.font = [UIFont boldSystemFontOfSize:14];
        headerLabel.text = pair.headerText;
        [self addSubview:headerLabel];

        // Find out if it's larger than the previous largest header
        [headerLabel sizeToFit];
        CGSize size = headerLabel.frame.size;
        if (size.width > self.largestHeaderWidth) {
            self.largestHeaderWidth = size.width;
        }

        // Create the content label
        UILabel *contentLabel = [UILabel new];
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.text = pair.contentText;
        [self addSubview:contentLabel];
    }
}

- (void)layoutSubviews
{
    CGFloat lineHeight = 0;
    BOOL handlingHeader = YES;

    CGRect maxContentFrame;
    maxContentFrame.size.width = self.bounds.size.width - self.largestHeaderWidth - 8;
    maxContentFrame.size.height = 9999;

    for (UILabel *label in self.subviews) {
        CGRect frame;

        if (handlingHeader) {
            // Just position the header
            frame = label.frame;
            frame.origin.x = self.largestHeaderWidth - label.frame.size.width;
            frame.origin.y = lineHeight;
        } else {
            // Size the label
            label.frame = maxContentFrame;
            [label sizeToFit];

            // Position it to the right of the header
            frame = label.frame;
            frame.origin.x = self.largestHeaderWidth + 8;
            frame.origin.y = lineHeight;

            // Set the new line height
            lineHeight = CGRectGetMaxY(frame);
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
#ifdef DEBUG
                abort();
#endif
                return NSOrderedSame;
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
        [bucket addObject:[event formattedTime]];
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
            pair.headerText = [NSString stringWithFormat:@"Todo dia %d:", firstEvent.dayValue];
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

@end
