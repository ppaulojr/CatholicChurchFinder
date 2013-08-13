//
//  NFTweetFormatter.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 04/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFTweetFormatter.h"

@interface NFTweetFormatter ()

@property (strong, nonatomic) NSRegularExpression *hashtagRegex;

@property (strong, nonatomic) NSRegularExpression *userRegex;

@property (strong, nonatomic) NSDataDetector *linkDetector;

@property (strong, nonatomic) NSDictionary *hashtagStyle;

@property (strong, nonatomic) NSDictionary *userStyle;

@property (strong, nonatomic) NSDictionary *linkStyle;

@end

@implementation NFTweetFormatter

- (id)init
{
    self = [super init];
    if (self) {
        self.hashtagRegex = [NSRegularExpression regularExpressionWithPattern:@"#\\w+" options:0 error:NULL];
        self.userRegex = [NSRegularExpression regularExpressionWithPattern:@"@\\w+" options:0 error:NULL];
        self.linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:NULL];

        self.hashtagStyle = @{NSForegroundColorAttributeName : [UIColor orangeColor]};
        self.userStyle = @{NSForegroundColorAttributeName : [UIColor purpleColor]};
        self.linkStyle = @{NSForegroundColorAttributeName : [UIColor blueColor]};
    }
    return self;
}

- (NSAttributedString *)attributedTextForTweet:(NSDictionary *)tweet
{
    NSString *originalText = tweet[@"text"];
    NSRange textRange = NSMakeRange(0, originalText.length);

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:originalText];

    id block = ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [text addAttributes:self.hashtagStyle range:result.range];
    };
    [self.hashtagRegex enumerateMatchesInString:originalText options:0 range:textRange usingBlock:block];

    block = ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [text addAttributes:self.userStyle range:result.range];
    };
    [self.userRegex enumerateMatchesInString:originalText options:0 range:textRange usingBlock:block];

    block = ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [text addAttributes:self.linkStyle range:result.range];
    };
    [self.linkDetector enumerateMatchesInString:originalText options:0 range:textRange usingBlock:block];

    return text;
}

@end
