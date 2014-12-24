//
//  SettingsViewController.m
//  SocialSelfie
//
//  Created by Globit on 18/12/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "SettingsViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UtilsFunctions.h"
#import "Constants.h"

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
    if (GetStringWithKey(kIsPushEnabled)) {
        if ([GetStringWithKey(kIsPushEnabled)isEqualToString:@"NO"]) {
            [self.btnPushAlerts setSelected:YES];
        }
    }
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
        self.cellTopAlert.selectionStyle=UITableViewCellSelectionStyleNone;
        return self.cellTopAlert;
    }
    else{
        self.cellFriendsAlert.selectionStyle=UITableViewCellSelectionStyleNone;
        return self.cellFriendsAlert;
    }
}
#pragma mark-Webservices
-(void)disableNotificationsWebservice{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:kTaskDisableNotify forKey:kTask];
    if (GetStringWithKey(kUserID)) {
        [params setObject:GetStringWithKey(kUserID) forKey:kUserID];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURLUser parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject valueForKey:@"statusCode"]integerValue]==11000){
            ShowMessage(kAppName,@"Notification setting has been disabled.");
        }
        else if([[responseObject valueForKey:@"statusCode"]integerValue]==11001){
            ShowMessage(kAppName, @"Unable to update the record.");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}

-(void)acceptAllFriendReqWebservice{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:kTaskAcceptAllFriendRequest forKey:kTask];
    if (GetStringWithKey(kUserID)) {
        [params setObject:GetStringWithKey(kUserID) forKey:kUserID];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURLUser parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject valueForKey:@"statusCode"]integerValue]==9000){
            ShowMessage(kAppName,@"ALL Friend request has been accepted successfully.");
        }
        else if([[responseObject valueForKey:@"statusCode"]integerValue]==9001){
            ShowMessage(kAppName, @"Unable to update the record.");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}

-(void)denyAllFriendReqWebservice{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:kTaskDenyAllFriendRequest forKey:kTask];
    if (GetStringWithKey(kUserID)) {
        [params setObject:GetStringWithKey(kUserID) forKey:kUserID];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURLUser parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject valueForKey:@"statusCode"]integerValue]==10000){
            ShowMessage(kAppName,@"ALL Friend request has been denied successfully.");
        }
        else if([[responseObject valueForKey:@"statusCode"]integerValue]==10001){
            ShowMessage(kAppName, @"Unable to update the record.");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark-IBActions and Selectors
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pushAlertsBtnPressed:(id)sender {
    [self.btnPushAlerts setSelected:!self.btnPushAlerts.selected];
    if (self.btnPushAlerts.selected) {
        [self disableNotificationsWebservice];
        SaveStringWithKey(@"NO", kIsPushEnabled);
    }
    else{
        SaveStringWithKey(@"YES", kIsPushEnabled);
    }
}

- (IBAction)AcceptAllFriendReqPressed:(id)sender {
    [self acceptAllFriendReqWebservice];
}

- (IBAction)denyAllFriendReqPressed:(id)sender {
    [self denyAllFriendReqWebservice];
}

- (IBAction)denyAllNotificationFriendNotifications:(id)sender {
    [self.btndontNotifyFriendReq setSelected:!self.btndontNotifyFriendReq];
}
@end
