//
//  NFTwitterTimelineLoader.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 04/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NFTwitterTimelineLoaderDelegate;


@interface NFTwitterTimelineLoader : NSObject <UITableViewDataSource>

@property (weak, nonatomic) id <NFTwitterTimelineLoaderDelegate> delegate;

@property (readonly, strong, nonatomic) NSMutableArray *tweets;

- (id)initWithTableView:(UITableView *)tableView screenName:(NSString *)screenName;

- (NSString *)statusIDForTweetAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol NFTwitterTimelineLoaderDelegate <NSObject>

- (void)twitterTimelineLoader:(NFTwitterTimelineLoader *)loader didFinishLoadingTweetsWithSuccess:(BOOL)success;

@end
