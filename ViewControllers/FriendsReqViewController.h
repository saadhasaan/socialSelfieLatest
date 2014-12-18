//
//  FriendsReqViewController.h
//  SocialSelfie
//
//  Created by Saad Khan on 15/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendReqCell.h"

@interface FriendsReqViewController : UIViewController<FriendReqCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backBtnAction:(id)sender;
@end
