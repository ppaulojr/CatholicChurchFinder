//
//  NFTweetFormatter.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 04/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFTweetFormatter : NSObject

- (NSAttributedString *)attributedTextForTweet:(NSDictionary *)tweet;

@end
