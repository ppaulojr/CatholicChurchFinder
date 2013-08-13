//
//  NSString+NFNormalizing.m
//  NetFilter
//
//  Created by Fernando Lemos on 04/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NSString+NFNormalizing.h"

@implementation NSString (NFNormalizing)

- (NSString *)nf_stringByTrimmingWhitespaceAndNewline
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)nf_searchNormalizedString
{
    NSMutableString *buffer = [self mutableCopy];
    CFMutableStringRef bufferRef = (__bridge CFMutableStringRef)buffer;
    CFStringTransform(bufferRef, NULL, kCFStringTransformToLatin, false);
    CFStringTransform(bufferRef, NULL, kCFStringTransformStripCombiningMarks, false);
    return buffer.lowercaseString;
}

@end
