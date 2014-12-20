//
//  SettingsViewController.m
//  SocialSelfie
//
//  Created by Globit on 18/12/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "SettingsViewController.h"

#define kTopCell    @"topAlertCell"
#define kFriendReqAlertCell     @"friendReqAlertCell"

@interface SettingsViewController ()
{
    NSMutableArray * mainArray;
}
@end

@implementation SettingsViewController
- (id)init
{
    self = [super initWithNibName:@"SettingsViewController" bundle:nil];
    if (self) {
        mainArray=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadMainArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark: Custom Methods
-(void)loadMainArray{
    [mainArray removeAllObjects];
    [mainArray addObject:kTopCell];
    [mainArray addObject:kFriendReqAlertCell];
}
#pragma mark: UITableView Delegates and Datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mainArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[mainArray objectAtIndex:indexPath.row]isEqualToString:kTopCell]) {
        return 90;
    }
    else{
        return 180;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[mainArray objectAtIndex:indexPath.row]isEqualToString:kTopCell]) {
        return self.cellTopAlert;
    }
    else{
        return self.cellFriendsAlert;
    }
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pushAlertsBtnPressed:(id)sender {
    [self.btnPushAlerts setSelected:!self.btnPushAlerts];
}

- (IBAction)AcceptAllFriendReqPressed:(id)sender {
    [self.btnAcceptAllFreindReq setSelected:!self.btnAcceptAllFreindReq.selected];
}

- (IBAction)denyAllFriendReqPressed:(id)sender {
    [self.btnDenyAllFriendReq setSelected:!self.btnDenyAllFriendReq.selected];
}

- (IBAction)denyAllNotificationFriendNotifications:(id)sender {
    [self.btndontNotifyFriendReq setSelected:!self.btndontNotifyFriendReq];
}
@end
