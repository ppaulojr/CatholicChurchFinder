//
//  NFEvent.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 21/06/13.
//  Copyright (c) 2013 Fernando Lemos. All rights reserved.
//

#import "_NFEvent.h"
#import "NFEventMatchContext.h"

typedef NS_ENUM(NSInteger, NFEventType) {
    NFEventTypeMissa = 0,
    NFEventTypeConfissao
};

@interface NFEvent : _NFEvent

- (NSString *)formattedTime;

- (BOOL)matchesWithContext:(NFEventMatchContext *)context;

+ (NFEvent *)firstMissaAfterDate:(NSDate *)date
                        calendar:(NSCalendar *)calendar
            managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
