//
//  NFIgrejaEventsPanel.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 26/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFIgreja.h"
#import "NFIgrejaEventsPanel.h"
#import "NFWeeklyEvent.h"

#define CMP(x, y) \
    if ((x) > (y)) { \
        return NSOrderedDescending; \
    } else if ((y) > (x)) { \
        return NSOrderedAscending; \
    } else


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

    // TODO: Then add the monthly events

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
    // Order the events by weekday and then start time
    events = [events sortedArrayUsingComparator:^NSComparisonResult(NFWeeklyEvent *e1, NFWeeklyEvent *e2) {
        CMP(e1.weekdayValue, e2.weekdayValue) {
            CMP(e1.startTimeValue, e2.startTimeValue) {
                return [e1.igreja.nome caseInsensitiveCompare:e2.igreja.nome];
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
        NSMutableArray *bucket = buckets[i];
        if (!bucket) {
            continue;
        }

        // Find the weekday name
        static NSString *weekdayNames[] = {
            @"Domingo", @"Segunda", @"Terça", @"Quarta", @"Quinta", @"Sexta", @"Sábado"
        };
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

@end
