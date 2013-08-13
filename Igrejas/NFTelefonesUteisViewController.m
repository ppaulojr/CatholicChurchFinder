//
//  NFTelefonesUteisViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 03/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <PSAlertView/PSPDFActionSheet.h>

#import "NFTelefonesUteisViewController.h"

@interface NFTelefonesUteisViewController ()

@property (assign, nonatomic) BOOL canMakePhoneCalls;

@end

@implementation NFTelefonesUteisViewController

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.canMakePhoneCalls = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];

    if (!self.canMakePhoneCalls) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.canMakePhoneCalls) {
        return;
    }

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *phoneNumber = cell.detailTextLabel.text;

    PSPDFActionSheet *actionSheet = [[PSPDFActionSheet alloc] initWithTitle:cell.textLabel.text];

    NSString *title = [NSString stringWithFormat:@"Ligar para %@", phoneNumber];
    [actionSheet addButtonWithTitle:title block:^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        NSString *phoneEncoded = [phoneNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneEncoded]];
        [[UIApplication sharedApplication] openURL:url];
    }];

    [actionSheet setCancelButtonWithTitle:@"Cancelar" block:^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];

    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

@end
