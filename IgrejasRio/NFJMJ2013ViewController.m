//
//  NFJMJ2013ViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 03/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFJMJ2013ViewController.h"

@implementation NFJMJ2013ViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section * 100 + indexPath.row) {
        case 0: {
            NSURL *url = [NSURL URLWithString:@"http://www.rio2013.com/"];
            [[UIApplication sharedApplication] openURL:url];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
        case 1: {
            NSURL *url = [NSURL URLWithString:@"http://www.horariodemissa.com.br/"];
            [[UIApplication sharedApplication] openURL:url];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
    }
}

@end
