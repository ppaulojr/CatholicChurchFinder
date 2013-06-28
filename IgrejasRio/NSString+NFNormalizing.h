//
//  NSString+NFNormalizing.h
//  NetFilter
//
//  Created by Fernando Lemos on 04/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NFNormalizing)

- (NSString *)nf_stringByTrimmingWhitespaceAndNewline;

- (NSString *)nf_searchNormalizedString;

@end
