//
//  NFTwitterTimelineViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 04/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFTwitterTimelineLoader.h"
#import "NFTwitterTimelineViewController.h"

@interface NFTwitterTimelineViewController ()

@property (strong, nonatomic) NFTwitterTimelineLoader *timelineLoader;

@end

@implementation NFTwitterTimelineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.timelineLoader = [[NFTwitterTimelineLoader alloc] initWithTableView:self.tableView screenName:@"jmj_pt"];
    self.tableView.dataSource = self.timelineLoader;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

@end
