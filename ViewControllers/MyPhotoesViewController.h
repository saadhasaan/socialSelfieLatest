//
//  MyPhotoesViewController.h
//  SocialSelfie
//
//  Created by Saad Khan on 27/10/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPhotoCell.h"
#import "SharePopUpView.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface MyPhotoesViewController : UIViewController<MyPhotoCellDelegate,SharePopUpViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtnAction:(id)sender;

@end
