//
//  NFEventMatchContext.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 08/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFEventMatchContext : NSObject

@property (readonly, strong, nonatomic) NSDateComponents *referenceDateComponents;

@property (readonly, assign, nonatomic) NSInteger reverseWeekdayOrdinal;

- (id)initWithReferenceDate:(NSDate *)referenceDate calendar:(NSCalendar *)calendar;

@end
