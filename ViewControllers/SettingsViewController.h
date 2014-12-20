//
//  SettingsViewController.h
//  SocialSelfie
//
//  Created by Globit on 18/12/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellTopAlert;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellFriendsAlert;
@property (weak, nonatomic) IBOutlet UIButton *btnPushAlerts;
@property (weak, nonatomic) IBOutlet UIButton *btnAcceptAllFreindReq;
@property (weak, nonatomic) IBOutlet UIButton *btnDenyAllFriendReq;
@property (weak, nonatomic) IBOutlet UIButton *btndontNotifyFriendReq;


- (IBAction)backBtnAction:(id)sender;
- (IBAction)pushAlertsBtnPressed:(id)sender;
- (IBAction)AcceptAllFriendReqPressed:(id)sender;
- (IBAction)denyAllFriendReqPressed:(id)sender;
- (IBAction)denyAllNotificationFriendNotifications:(id)sender;
@end
