//
//  MyPhotoesViewController.m
//  SocialSelfie
//
//  Created by Saad Khan on 27/10/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "MyPhotoesViewController.h"
#import "HMSegmentedControl.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Constants.h"
#import "UtilsFunctions.h"
#import "MyPhotoesPic.h"
#import "CommentsViewController.h"

@interface MyPhotoesViewController ()
{
    NSMutableArray * mainArray;
    NSMutableArray * mainArrayRecent;
    NSMutableArray * mainArrayYesterday;
    SharePopUpView * sharePopUpView;
    BOOL isSharePopUpViewPresent;
    PhotoAddedType dateType;
    NSInteger selectedPhotoTag;
}
@end

@implementation MyPhotoesViewController

- (id)init
{
    self = [super initWithNibName:@"MyPhotoesViewController" bundle:Nil];
    if (self) {
        mainArray=[[NSMutableArray alloc]init];
        mainArrayRecent=[[NSMutableArray alloc]init];
        mainArrayYesterday=[[NSMutableArray alloc]init];
        sharePopUpView=[[SharePopUpView alloc]init];
        sharePopUpView.frame=CGRectMake(0, self.view.frame.size.height-130-100,sharePopUpView.frame.size.width, sharePopUpView.frame.size.height);
        sharePopUpView.delegate=self;
        isSharePopUpViewPresent=NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self addSegmentBarToViewNew];
    [self getMyPhotosWebservice];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark: Custom Methods
-(void)filterMainArray{
    [mainArrayRecent removeAllObjects];
    [mainArrayYesterday removeAllObjects];
    for (MyPhotoesPic * photoObj in mainArray) {
        if (photoObj.hoursFromPosted<=24) {
            [mainArrayRecent addObject:photoObj];
        }
        else if(photoObj.hoursFromPosted<=48)
        {
            [mainArrayYesterday addObject:photoObj];
        }
    }
    
}
#pragma mark: UITableView Delegates and Datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dateType==Recent) {
        return [mainArrayRecent count];
    }
    else if(dateType==Yesterday){
        return [mainArrayYesterday count];
    }
    else{
        return [mainArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"photoCell";
    MyPhotoesPic * photoObj;
    if (dateType==Recent) {
        photoObj=[mainArrayRecent objectAtIndex:indexPath.row];
    }
    else if(dateType==Yesterday){
        photoObj=[mainArrayYesterday objectAtIndex:indexPath.row];
    }
    else{
        photoObj=[mainArray objectAtIndex:indexPath.row];
    }
    
    MyPhotoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"MyPhotoCell" owner:nil options:nil];
        cell = (MyPhotoCell*)[nibArray objectAtIndex:0];
    }
    [cell loadDataWithImageURL:photoObj];
    cell.tag=indexPath.row;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.delegate=self;
    return cell;
}
#pragma mark:MyPhotoCellDelegate
-(void)gotoCommentsDetailForPhotoID:(NSString* )photoID{
    CommentsViewController * commentVC=[[CommentsViewController alloc]initWithImageID:photoID];
    [self.navigationController pushViewController:commentVC animated:YES];
}
-(void)gotoShareForPhotoID:(NSInteger )cellTag{
    selectedPhotoTag=cellTag;
    if (!isSharePopUpViewPresent) {
        isSharePopUpViewPresent=YES;
        [self.view addSubview:sharePopUpView];
    }
    else{
        isSharePopUpViewPresent=NO;
        [sharePopUpView removeFromSuperview];
    }
}
-(void)gotoLikesDetailForPhotoID:(NSInteger )cellTag{
    
}
#pragma mark:SharePopUpViewDelegate
-(MyPhotoesPic *)getThePhotoObjectWithPhotoID{
    MyPhotoesPic * photoObj;
    if (dateType==Recent) {
        if (mainArrayRecent.count<selectedPhotoTag) {
            photoObj=[mainArrayRecent objectAtIndex:selectedPhotoTag];
        }
    }
    else if(dateType==Yesterday){
        if(mainArrayYesterday.count<selectedPhotoTag){
            photoObj=[mainArrayYesterday objectAtIndex:selectedPhotoTag];
        }
    }
    else{
        if (mainArray.count<selectedPhotoTag) {
            photoObj=[mainArray objectAtIndex:selectedPhotoTag];
        }
    }
    return photoObj;
}
-(void)shareFBButtonHasBeenPressed{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        MyPhotoesPic * photoObj=[self getThePhotoObjectWithPhotoID];
        if (photoObj) {
            [fbPostSheet setInitialText:[NSString stringWithFormat:@"I like that picture very much on Central Selfie and this picture get %li likes & %li comments, please check that",(long)photoObj.likeCount,(long)photoObj.commentCount]];
        }
        
        [self presentViewController:fbPostSheet animated:YES completion:nil];
    } else
    {
        ShowMessage(kAppName, @"You can't post right now, make sure your device has an internet connection and you have at least one facebook account setup");
    }
}
-(void)shareTWButtonHasBeenPressed{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        MyPhotoesPic * photoObj=[self getThePhotoObjectWithPhotoID];
        if (photoObj) {
            [tweetSheet setInitialText:[NSString stringWithFormat:@"I like that picture very much on Central Selfie and this picture get %li likes & %li comments, please check that",(long)photoObj.likeCount,(long)photoObj.commentCount]];
        }
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
    }
    else
    {
        ShowMessage(kAppName, @"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup");
    }
    
}

-(void)closeSharePopUpViewButtonHasBeenPressed{
    isSharePopUpViewPresent=NO;
    [sharePopUpView removeFromSuperview];
}

#pragma mark:Custom Methods
-(void)addSegmentBarToViewNew{
    HMSegmentedControl *tempSegmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(7, 64 ,306, 36)];
    
    [tempSegmentControl setSectionImages:@[[UIImage imageNamed:@"recent_btn"],[UIImage imageNamed:@"yesterday_btn"],[UIImage imageNamed:@"all_btn"]]];
    
    [tempSegmentControl setSectionSelectedImages:@[[UIImage imageNamed:@"recent_btn_pressed"], [UIImage imageNamed:@"yesterday_btn_pressed"],[UIImage imageNamed:@"all_btn_pressed"]]];
    
    [tempSegmentControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    tempSegmentControl.type = HMSegmentedControlTypeImages;
    
    [tempSegmentControl setSelectedSegmentIndex:0];
    
    
    [tempSegmentControl setBackgroundColor:[UIColor clearColor]];
    
    [tempSegmentControl setSelectionIndicatorColor:[UIColor clearColor]];
    
    [tempSegmentControl setSelectionStyle:HMSegmentedControlSelectionStyleBox];
    
    [tempSegmentControl setSelectionLocation:HMSegmentedControlSelectionLocationUp];
    
    [self.view addSubview:tempSegmentControl];
    
    dateType=Recent;
}
#pragma mark-Selectors
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    dateType=segmentedControl.selectedSegmentIndex;
    [self.tableView reloadData];
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark:Webservices
-(void)getMyPhotosWebservice{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];.
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:kTaskGetUserImage forKey:kTask];
    if (GetStringWithKey(kUserID)) {
        [params setObject:GetStringWithKey(kUserID) forKey:kUserID];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURLImages parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject valueForKey:@"statusCode"]integerValue]==11001){
            ShowMessage(kAppName,@"No record found against your request.");
        }
        else if([[responseObject valueForKey:@"statusCode"]integerValue]==11000){
            NSArray * array=[responseObject valueForKey:kValue];
            [mainArray removeAllObjects];
            for (NSDictionary * dict in array) {
                MyPhotoesPic * imgData=[[MyPhotoesPic alloc]initWithDictionary:dict];
                [mainArray addObject:imgData];
            }
            [self filterMainArray];
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}

@end
