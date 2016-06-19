//
//  NFTwitterTimelineLoader.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 04/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <AFNetworking/AFNetworking.h>
#import <Social/Social.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "NFTweetFormatter.h"
#import "NFTwitterTimelineLoader.h"

#define NUM_TWEETS 30

static NSString * const kTimelineURL = @"https://api.twitter.com/1.1/statuses/user_timeline.json";

@interface NFTwitterTimelineLoader ()

@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSString *screenName;

@property (strong, nonatomic) ACAccountStore *accountStore;

@property (strong, nonatomic) NSMutableArray *tweets;

@property (strong, nonatomic) NSTimer *refreshTimer;

@property (strong, nonatomic) NFTweetFormatter *tweetFormatter;

@end

@implementation NFTwitterTimelineLoader

- (id)initWithTableView:(UITableView *)tableView screenName:(NSString *)screenName
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.screenName = screenName;

        self.tweets = [NSMutableArray arrayWithCapacity:NUM_TWEETS * 2];
        self.accountStore = [ACAccountStore new];

        self.tweetFormatter = [NFTweetFormatter new];

        [self loadTimeline];
    }
    return self;
}

- (id)init
{
    return nil;
}

- (void)loadTimeline
{
    [self cancelRefreshTimer];

    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        [self.delegate twitterTimelineLoader:self didFinishLoadingTweetsWithSuccess:NO];
        return;
    }

    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (!granted) {
            [self.delegate twitterTimelineLoader:self didFinishLoadingTweetsWithSuccess:NO];
            return;
        }

        NSMutableDictionary *params = [@{
            @"screen_name" : self.screenName,
            @"count" : [NSString stringWithFormat:@"%d", NUM_TWEETS]
        } mutableCopy];

        BOOL appendingTweets = NO;
        if (self.tweets.count) {
            appendingTweets = YES;
            NSDictionary *latestTweet = self.tweets[0];
            params[@"since_id"] = [NSString stringWithFormat:@"%@", latestTweet[@"id"]];
        }

        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodGET
                                                          URL:[NSURL URLWithString:kTimelineURL]
                                                   parameters:params];

        request.account = [[self.accountStore accountsWithAccountType:accountType] lastObject];

        NSURL *URL = [NSURL URLWithString:@"http://example.com/resources/123.json"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSArray * JSON = responseObject;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, JSON.count)];
            [self.tweets insertObjects:JSON atIndexes:indexSet];
            
            if (JSON.count) {
                if (appendingTweets) {
                    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:JSON.count];
                    for (int i = 0; i < JSON.count; ++i) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        [indexPaths addObject:indexPath];
                    }
                    
                    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                } else {
                    [self.tableView reloadData];
                }
            }
            [self setupRefreshTimer];
            [self.delegate twitterTimelineLoader:self didFinishLoadingTweetsWithSuccess:YES];

        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [self.delegate twitterTimelineLoader:self didFinishLoadingTweetsWithSuccess:NO];
        }];
    }];
}

- (void) cancelRefreshTimer
{
    [self.refreshTimer invalidate];
    self.refreshTimer = nil;
}

- (void) setupRefreshTimer
{
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(_refreshTimerFired) userInfo:nil repeats:YES];
}

- (void) refreshTimerFired
{
    [self loadTimeline];
}

- (NSString *)statusIDForTweetAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tweet = self.tweets[indexPath.row];
    return [NSString stringWithFormat:@"%@", tweet[@"id"]];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweet" forIndexPath:indexPath];

    NSDictionary *tweet = self.tweets[indexPath.row];
    cell.textLabel.attributedText = [self.tweetFormatter attributedTextForTweet:tweet];

    NSURL *profileImageURL = [NSURL URLWithString:[tweet valueForKeyPath:@"user.profile_image_url"]];
    
    [cell.imageView sd_setImageWithURL:profileImageURL placeholderImage:[UIImage imageNamed:@"twitter-placeholder"]];

    return cell;
}

@end
