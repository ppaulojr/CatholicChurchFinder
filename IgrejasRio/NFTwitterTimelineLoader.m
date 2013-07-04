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

#import "NFTweetFormatter.h"
#import "NFTwitterTimelineLoader.h"

#define MAX_TWEETS 50

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

        self.tweets = [NSMutableArray arrayWithCapacity:MAX_TWEETS];
        self.accountStore = [ACAccountStore new];

        self.tweetFormatter = [NFTweetFormatter new];

        [self _loadTimeline];
    }
    return self;
}

- (id)init
{
    return nil;
}

- (void)_loadTimeline
{
    [self _cancelRefreshTimer];

    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        // TODO: Call the delegate
        return;
    }

    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (!granted) {
            // TODO: Invoke the delegate
            return;
        }

        // TODO: Use since_id to add objects to the array
        NSDictionary *params = @{
            @"screen_name" : self.screenName,
            @"count" : @"50"
        };

        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodGET
                                                          URL:[NSURL URLWithString:kTimelineURL]
                                                   parameters:params];

        request.account = [[self.accountStore accountsWithAccountType:accountType] lastObject];

        id success = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSArray *JSON) {
            NSUInteger previousCount = self.tweets.count;
            [self.tweets addObjectsFromArray:JSON];

            if (previousCount == 0) {
                [self.tableView reloadData];
            } else {
                // TODO
            }

            // TODO
            //[self _setupRefreshTimer];
        };

        id failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            // TODO: Invoke the delegate
        };

        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:[request preparedURLRequest]
                                                                                            success:success failure:failure];

        [operation start];
    }];
}

- (void)_cancelRefreshTimer
{
    [self.refreshTimer invalidate];
    self.refreshTimer = nil;
}

- (void)_setupRefreshTimer
{
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(_refreshTimerFired) userInfo:nil repeats:YES];
}

- (void)_refreshTimerFired
{
    [self _loadTimeline];
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
    [cell.imageView setImageWithURL:profileImageURL placeholderImage:[UIImage imageNamed:@"twitter-placeholder"]];

    return cell;
}

@end
