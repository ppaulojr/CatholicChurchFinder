//
//  NFTwitterTimelineViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 04/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <PSAlertView/PSPDFActionSheet.h>
#import <QuartzCore/QuartzCore.h>

#import "NFTwitterIntegration.h"
#import "NFTwitterTimelineLoader.h"
#import "NFTwitterTimelineViewController.h"

static NSString * const kScreenName = @"jmj_pt";
static NSString * const kScreenNameURLFormat = @"https://twitter.com/%@";
static NSString * const kStatusURLFormat = @"https://twitter.com/%@/status/%@";

@interface NFTwitterTimelineViewController () <NFTwitterTimelineLoaderDelegate>

@property (strong, nonatomic) NFTwitterTimelineLoader *timelineLoader;

@property (strong, nonatomic) UIView *statusView;

@end

@implementation NFTwitterTimelineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self _showStatusWithText:@"Carregando tweets..."];

    self.timelineLoader = [[NFTwitterTimelineLoader alloc] initWithTableView:self.tableView screenName:kScreenName];
    self.timelineLoader.delegate = self;
    self.tableView.dataSource = self.timelineLoader;
}

- (void)_showStatusWithText:(NSString *)text
{
    [self.statusView removeFromSuperview];

    self.statusView = [UIView new];
    self.statusView.backgroundColor = [UIColor whiteColor];

    CGRect frame = CGRectInset(self.view.bounds, 40, 0);
    frame.origin.y = 10;
    frame.origin.x = 10;
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.text = text;
    [label sizeToFit];

    frame = CGRectInset(label.frame, -10, -10);
    frame.origin.x = (self.view.bounds.size.width - frame.size.width) / 2;
    frame.origin.y = 60;
    self.statusView.frame = frame;

    self.statusView.layer.cornerRadius = 10;
    self.statusView.layer.borderWidth = 1;
    self.statusView.layer.borderColor = [UIColor lightGrayColor].CGColor;

    [self.statusView addSubview:label];
    [self.view addSubview:self.statusView];
}

- (void)_hideStatus
{
    [self.statusView removeFromSuperview];
    self.statusView = nil;
}

- (IBAction)_actionButtonTapped:(id)sender
{
    PSPDFActionSheet *actionSheet = [[PSPDFActionSheet alloc] initWithTitle:nil];

    if ([NFTwitterIntegration canOpenTwitterApp]) {
        [actionSheet addButtonWithTitle:@"Ver no app do Twitter" block:^{
            [NFTwitterIntegration openTwitterAppWithScreenName:kScreenName];
        }];
    }

    [actionSheet addButtonWithTitle:@"Ver no Safari" block:^{
        NSString *url = [NSString stringWithFormat:kScreenNameURLFormat, kScreenName];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }];

    [actionSheet setCancelButtonWithTitle:@"Cancelar" block:nil];

    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}


#pragma mark - Twitter timeline loader delegate

- (void)twitterTimelineLoader:(NFTwitterTimelineLoader *)loader didFinishLoadingTweetsWithSuccess:(BOOL)success
{
    if (success) {
        [self _hideStatus];
    } else if (loader.tweets.count == 0) {
        [self _showStatusWithText:@"Houve um erro ao carregar os tweets. Verifique se você autorizou este app a acessar sua conta do Twitter no app Ajustes de seu aparelho e se você está conectado à Internet."];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *statusID = [self.timelineLoader statusIDForTweetAtIndexPath:indexPath];

    if ([NFTwitterIntegration canOpenTwitterApp]) {
        [NFTwitterIntegration openTwitterAppWithStatusID:statusID];
    } else {
        NSString *url = [NSString stringWithFormat:kStatusURLFormat, kScreenName, statusID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

@end
