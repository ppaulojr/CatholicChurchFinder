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

@end

@implementation NFSettingsViewController

- (void)awakeFromNib
{
    [self _selectMapType:[NFSettingsManager sharedManager].mapType];
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
}

@end
