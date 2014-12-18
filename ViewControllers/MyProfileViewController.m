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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark: UICollectionView Delegates and Datasource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;//[mainFriendArray count];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70,70);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);//(top, left, bottom, right);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FriendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"friendCollectionCell" forIndexPath:indexPath];

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
@end
