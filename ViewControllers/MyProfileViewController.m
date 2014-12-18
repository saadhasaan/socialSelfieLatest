//
//  MyProfileViewController.m
//  SocialSelfie
//
//  Created by Saad Khan on 13/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "MyProfileViewController.h"
#import "FriendCell.h"
#import "UtilsFunctions.h"
#import "Constants.h"
#import "UIImageView+AFNetworking.h"
#import "MyPhotoesViewController.h"
#import "FriendsReqViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface MyProfileViewController ()
{
    NSMutableArray * mainFriendArray;
}
@end

@implementation MyProfileViewController

- (id)init
{
    self = [super initWithNibName:@"MyProfileViewController" bundle:nil];
    if (self) {
        mainFriendArray=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //For Collection view
    [self.collectionView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellWithReuseIdentifier:@"friendCollectionCell"];
    
    if (GetStringWithKey(kProfileImage)) {
        [self.myImage setImageWithURL:[NSURL URLWithString:GetStringWithKey(kProfileImage)] placeholderImage:[UIImage imageNamed:@"parallax_avatar"]];
    }
    if (GetStringWithKey(kName)) {
        self.myNameLbl.text=GetStringWithKey(kName);
    }
    [UtilsFunctions makeUIImageViewRound:self.myImage ANDRadius:48];
    
    [self getAllFriendsReqWebservice];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark: UICollectionView Delegates and Datasource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [mainFriendArray count];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70,70);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);//(top, left, bottom, right);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FriendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"friendCollectionCell" forIndexPath:indexPath];
    FriendReq * user=[mainFriendArray objectAtIndex:indexPath.row];
    [cell.userPic setImageWithURL:[NSURL URLWithString:user.reqUserPicURL] placeholderImage:[UIImage imageNamed:@"no_pic_background.png"]];
    return cell;
}
#pragma mark;IBActions
- (IBAction)backbtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)goToMyPhotoesAction:(id)sender {
    MyPhotoesViewController * myPhotoesVC=[[MyPhotoesViewController alloc]init];
    [self.navigationController pushViewController:myPhotoesVC animated:YES];
}

- (IBAction)goToMyAlertsAction:(id)sender {
}

- (IBAction)goToFriendReqAction:(id)sender {
    FriendsReqViewController * friendReqVC=[[FriendsReqViewController alloc]init];
    [self.navigationController pushViewController:friendReqVC animated:YES];
}
#pragma mark:Webservice
-(void)getAllFriendsReqWebservice{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (GetStringWithKey(kUserID)) {
        [params setObject:GetStringWithKey(kUserID) forKey:kUserID];
    }
    
    [params setObject:kTaskGetFriends forKey:kTask];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURLUser parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject valueForKey:kStatusCode]integerValue]==7000) {
            NSArray * dataArray=(NSArray*)[responseObject valueForKey:kValue];
            for (NSDictionary *dict in dataArray) {
                [mainFriendArray removeAllObjects];
                FriendReq * user=[[FriendReq alloc]initWithDictionary:dict ANDIsReqRecieving:NO];
                [mainFriendArray addObject:user];
                [self.collectionView reloadData];
            }
        }
        else if ([[responseObject valueForKey:kStatusCode]integerValue]==7001) {                     ShowMessage(kAppName, @"No record found against your request.");
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}
@end
