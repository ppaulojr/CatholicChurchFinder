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

- (id)initWithTableView:(UITableView *)tableView screenName:(NSString *)screenName;

@end


@protocol NFTwitterTimelineLoaderDelegate <NSObject>

// TODO

@end
