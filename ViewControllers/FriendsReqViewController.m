//
//  FriendsReqViewController.m
//  SocialSelfie
//
//  Created by Saad Khan on 15/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "FriendsReqViewController.h"
#import "HMSegmentedControl.h"

#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "FriendReq.h"
#import "UtilsFunctions.h"
#import "Constants.h"

@interface FriendsReqViewController ()
{
    NSMutableArray * mainArrayRec;
    NSMutableArray * mainArraySent;
    BOOL showRec;
}
@end

@implementation FriendsReqViewController

- (id)init
{
    self = [super initWithNibName:@"FriendsReqViewController" bundle:nil];
    if (self) {
        mainArrayRec=[[NSMutableArray alloc]init];
        mainArraySent=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self getAllFriendReqsWebservice];
    showRec=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark:Custom Methods
//-(void)addSegmentBarToViewNew{
//    HMSegmentedControl *tempSegmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(5, 64 ,310, 36)];
//    
//    [tempSegmentControl setSectionImages:@[[UIImage imageNamed:@"recieve_requests"],[UIImage imageNamed:@"send_requests"]]];
//    
//    [tempSegmentControl setSectionSelectedImages:@[[UIImage imageNamed:@"recieve_requests_pressed"], [UIImage imageNamed:@"send_requests_pressed"]]];
//    
//    [tempSegmentControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
//    
//    tempSegmentControl.type = HMSegmentedControlTypeImages;
//    
//    [tempSegmentControl setSelectedSegmentIndex:0];
//    
//    
//    [tempSegmentControl setBackgroundColor:[UIColor clearColor]];
//    
//    [tempSegmentControl setSelectionIndicatorColor:[UIColor clearColor]];
//    
//    [tempSegmentControl setSelectionStyle:HMSegmentedControlSelectionStyleBox];
//    
//    [tempSegmentControl setSelectionLocation:HMSegmentedControlSelectionLocationUp];
//    
//    [self.view addSubview:tempSegmentControl];
//}
#pragma mark: UITableView Delegates and Datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (showRec) {
        return mainArrayRec.count;
    }
    else{
        return mainArraySent.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"friendReqCell";
    
    
    FriendReqCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"FriendReqCell" owner:nil options:nil];
        cell = (FriendReqCell*)[nibArray objectAtIndex:0];
    }
    if (showRec) {
        [cell loadDataWithWithData:[mainArrayRec objectAtIndex:indexPath.row]];
    }
    else{
        [cell loadDataWithWithData:[mainArraySent objectAtIndex:indexPath.row]];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.delegate=self;
    return cell;
}
#pragma mark:FriendReqCellDelegate
-(void)actionOnFriendReqWithValue:(BOOL)isAccepted ANDReqID:(NSString *)rID{
    if (isAccepted) {
        [self acceptFriendReqWebserviceWithID:rID];
    }
    else{
        [self rejectFriendReqWebserviceWithID:rID];
    }
}
#pragma mark-Selectors
- (IBAction)segmentedControlChangedValue:(UISegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    NSInteger index=segmentedControl.selectedSegmentIndex;
    if (index==0) {
        showRec=YES;
    }
    else{
        showRec=NO;
    }
    [self.tableView reloadData];
}
#pragma mark:IBActions
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark:Webservices
-(void)getAllFriendReqsWebservice{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:kTaskGetAllFriendReq forKey:kTask];
    if (GetStringWithKey(kUserID)) {
        [params setObject:GetStringWithKey(kUserID) forKey:kUserID];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURLUser parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject valueForKey:@"statusCode"]integerValue]==8001){
            ShowMessage(kAppName,@"No record found against your request.");
        }
        else if([[responseObject valueForKey:@"statusCode"]integerValue]==8000){
            NSDictionary * mainDict=[responseObject valueForKey:kValue];
            NSArray * recReqArray=[mainDict valueForKey:@"receiving_request"];
            NSArray * sentReqArray=[mainDict valueForKey:@"sending_request"];
            [mainArraySent removeAllObjects];
            [mainArrayRec removeAllObjects];
            for (NSDictionary * dict in recReqArray) {
                FriendReq * req=[[FriendReq alloc]initWithDictionary:dict ANDIsReqRecieving:YES];
                if (req.reqStatus==0) {
                    [mainArrayRec addObject:req];
                }
            }
            for (NSDictionary * dict in sentReqArray) {
                FriendReq * req=[[FriendReq alloc]initWithDictionary:dict ANDIsReqRecieving:NO];
                if (req.reqStatus==0) {
                    [mainArraySent addObject:req];
                }
            }
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}
-(void)acceptFriendReqWebserviceWithID:(NSString *)otherUserID{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:kTaskAcceptFriendReq forKey:kTask];
    if (GetStringWithKey(kUserID)) {
        [params setObject:GetStringWithKey(kUserID) forKey:kUserID];
    }
    [params setObject:otherUserID forKey:kRequestID];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURLUser parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject valueForKey:@"statusCode"]integerValue]==5001){
            ShowMessage(kAppName,@"Unable to update the record.");
        }
        else if([[responseObject valueForKey:@"statusCode"]integerValue]==5000){
            ShowMessage(kAppName, @"Friend request has been accepted successfully.");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}
-(void)rejectFriendReqWebserviceWithID:(NSString *)otherUserID{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:kTaskRejectFriendReq forKey:kTask];
    if (GetStringWithKey(kUserID)) {
        [params setObject:GetStringWithKey(kUserID) forKey:kUserID];
    }
    [params setObject:otherUserID forKey:kRequestID];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURLUser parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject valueForKey:@"statusCode"]integerValue]==6001){
            ShowMessage(kAppName,@"Unable to update the record.");
        }
        else if([[responseObject valueForKey:@"statusCode"]integerValue]==6000){
            ShowMessage(kAppName, @"Friend request has been rejected successfully.");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}

@end
