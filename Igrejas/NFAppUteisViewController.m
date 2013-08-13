//
//  NFTelefonesUteisViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 03/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <PSAlertView/PSPDFActionSheet.h>

#import "NFAppUteisViewController.h"

@interface NFAppUteisViewController ()
@property (nonatomic,strong) NSArray * appId;
@end

@implementation NFAppUteisViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    _appId = @[@"489906277",@"580203100",@"367869456"];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *appIdDownload = _appId[indexPath.row];
    NSDictionary * dic = @{SKStoreProductParameterITunesItemIdentifier: appIdDownload};
    SKStoreProductViewController * stPvc = [[SKStoreProductViewController alloc] init];
    [stPvc loadProductWithParameters:dic completionBlock:^(BOOL result, NSError *error) {
        
    }];
    stPvc.delegate = self;
    [self presentViewController:stPvc animated:YES completion:^{
        
    }];
}

- (void) productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
