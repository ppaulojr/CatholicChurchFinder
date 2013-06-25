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

@end
