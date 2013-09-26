//
//  NFIgrejaDetailViewController.h
//  IgrejasRio
//
//  Created by Fernando Lemos on 26/06/13.
//  Copyright (c) 2013 NetFilter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "NFIgreja.h"

@interface NFIgrejaDetailViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NFIgreja *igreja;

@end
