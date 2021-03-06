//
//  NFSettingsViewController.m
//  IgrejasRio
//
//  Created by Fernando Lemos on 01/07/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import "NFSettingsManager.h"
#import "NFSettingsViewController.h"

@interface NFSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *mapTypeStandardCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *mapTypeHybridCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *versionCell;

@end

@implementation NFSettingsViewController

- (void)viewDidLoad
{
    [self _selectMapType:[NFSettingsManager sharedManager].mapType];

    NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSAssert(versionString, @"Unable to find the CFBundleShortVersionString");
    self.versionCell.detailTextLabel.text = versionString;
    
    [super viewDidLoad];
}

- (void)_selectMapType:(MKMapType)mapType
{
    if (mapType == MKMapTypeStandard) {
        self.mapTypeStandardCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.mapTypeHybridCell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        self.mapTypeStandardCell.accessoryType = UITableViewCellAccessoryNone;
        self.mapTypeHybridCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        MKMapType mapType = indexPath.row == 0 ? MKMapTypeStandard : MKMapTypeHybrid;
        [self _selectMapType:mapType];
        [NFSettingsManager sharedManager].mapType = mapType;
    }
    else
    {
        switch (indexPath.row) {
            case 2:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.netfilter.com.br"]];
                break;
            case 3:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.horariodemissa.com.br"]];
                break;
            default:
                break;
        }
    }
}

@end
