//
//  NFJMJ2013ViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 03/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFFacebookIntegration.h"
#import "NFLaredoViewController.h"

static NSString *kURL = @"https://www.facebook.com/CatholicDioceseofLaredo";
static NSString *kProfileID = @"117682098250535";

@implementation NFLaredoViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section * 100 + indexPath.row) {
        case 0: {
            NSURL *url = [NSURL URLWithString:@"http://dioceseoflaredo.org"];
            [[UIApplication sharedApplication] openURL:url];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
        case 1: {
            NSURL *url = [NSURL URLWithString:@"http://www.vatican.va"];
            [[UIApplication sharedApplication] openURL:url];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
        case 101: {
            [self _openFacebookPage];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
    }
}

- (void)_openFacebookPage
{
    if ([NFFacebookIntegration canOpenFacebookApp]) {
        [NFFacebookIntegration openProfileWithID:kProfileID];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kURL]];
    }
}

@end
