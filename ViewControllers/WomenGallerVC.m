//
//  WomenGallerVC.m
//  SocialSelfie
//
//  Created by Saad Khan on 18/10/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "WomenGallerVC.h"
#import "CommentsViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Constants.h"
#import "UtilsFunctions.h"
#import "MyPhotoesViewController.h"
#import "GellaryPicture.h"
#import "UIImageView+AFNetworking.h"

@interface WomenGallerVC ()
{
    SharePopUpView * sharePopUpView;
    BOOL isSharePopUpViewPresent;
    NSMutableArray * mainImgURLArray;
    NSInteger currentIndex;
}
@end

@implementation WomenGallerVC

- (id)init
{
    self = [super initWithNibName:@"WomenGallerVC" bundle:nil];
    if (self) {
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
    
    _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    _imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    _imagePager.indicatorDisabled=YES;
    
    mainImgURLArray=[[NSMutableArray alloc]init];
    [self getAllPicturesOfMensGalleryWebsrvice];
    
    self.userPicImgView.layer.cornerRadius=8;//For making round corner
    self.userPicImgView.clipsToBounds=YES;//For making round corner
    
    currentIndex=0;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.likeBtn setSelected:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark:Custom Methods
- (void)reverse {
    if ([mainImgURLArray count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [mainImgURLArray count] - 1;
    while (i < j) {
        [mainImgURLArray exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}
-(void)loadViewWithData{
    GellaryPicture * gelPic=[mainImgURLArray objectAtIndex:0];
    self.userNameLbl.text=gelPic.userName;
    self.likeCountLbl.text=[NSString stringWithFormat:@"%li",(long)gelPic.likeCount];
    currentIndex=0;
    [self.userPicImgView setImageWithURL:[NSURL URLWithString:gelPic.userProfileImageURL]placeholderImage:[UIImage imageNamed:@"parallax_avatar"]];
    if(gelPic.isLikedByMe){
        [self.likeBtn setSelected:YES];
    }
    else{
        [self.likeBtn setSelected:NO];
    }
}
-(void)updateLikeCountOfTheLikeObject{
    GellaryPicture * gelPic=[mainImgURLArray objectAtIndex:currentIndex];
    gelPic.likeCount+=1;
    gelPic.isLikedByMe=YES;
    self.likeCountLbl.text=[NSString stringWithFormat:@"%li",(long)gelPic.likeCount];
}
#pragma mark - AFImagePager DataSource
- (NSArray *) arrayWithImageUrlStrings
{
//    return [NSArray arrayWithObjects:
//            @"https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen1.png",
//            @"https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen2.png",
//            @"https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen3.png",
//            nil];
    if (mainImgURLArray.count>0) {
        [self loadViewWithData];
    }
    NSMutableArray * urlsArray=[[NSMutableArray alloc]init];
    for (GellaryPicture * gelPic in mainImgURLArray) {
        [urlsArray addObject:gelPic.imageURL];
    }
    return urlsArray;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image
{
    return UIViewContentModeScaleAspectFit;
}
- (UIImage *) placeHolderImageForImagePager{
    return [UIImage imageNamed:@"no_pic_background"];
}
#pragma mark - AFImagePagerDelegate
- (void) imagePager:(AFImagePager *)imagePager didScrollToIndex:(NSUInteger)index{
    if (mainImgURLArray.count>=index) {
        GellaryPicture * gelPic=[mainImgURLArray objectAtIndex:index];
        self.userNameLbl.text=gelPic.userName;
        self.likeCountLbl.text=[NSString stringWithFormat:@"%li",(long)gelPic.likeCount];
        [self.userPicImgView setImageWithURL:[NSURL URLWithString:gelPic.userProfileImageURL]placeholderImage:[UIImage imageNamed:@"parallax_avatar"]];
        if(gelPic.isLikedByMe){
            [self.likeBtn setSelected:YES];
        }
        else{
            [self.likeBtn setSelected:NO];
        }
        currentIndex=index;
    }
}
#pragma mark:IBActions
- (IBAction)goToPhotosAction:(id)sender {
    MyPhotoesViewController * myPhotoVC=[[MyPhotoesViewController alloc]init];
    [self.navigationController pushViewController:myPhotoVC animated:YES];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goToCommentsAction:(id)sender {
    CommentsViewController * commentVC=[[CommentsViewController alloc]initWithPicObjec:[mainImgURLArray objectAtIndex:currentIndex]];
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (IBAction)goToShareAction:(id)sender {
    if (!isSharePopUpViewPresent) {
        isSharePopUpViewPresent=YES;
        [self.view addSubview:sharePopUpView];
    }
    else{
        isSharePopUpViewPresent=NO;
        [sharePopUpView removeFromSuperview];
    }
}

- (IBAction)goToLikeAction:(id)sender {
    [self.likeBtn setSelected:YES];
    [self likePhotoWebservice];
}

- (IBAction)topRightBtnAction:(id)sender {
    UIActionSheet * actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add as friend",@"Report person", nil];
    [actionSheet showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex==0) {
        [self sendFriendReqWebservice];
    }
    else if (buttonIndex==1) {
       
    }
}

#pragma mark:SharePopUpViewDelegate
-(void)shareFBButtonHasBeenPressed{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        GellaryPicture * gelP=[mainImgURLArray objectAtIndex:currentIndex];
        [fbPostSheet setInitialText:[NSString stringWithFormat:@"I like that picture very much on Central Selfie and this picture get %li likes, please check that",(long)gelP.likeCount]];

        NSURL * url=[NSURL URLWithString:gelP.imageURL];
        [fbPostSheet addURL:url];
        
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
        GellaryPicture * gelP=[mainImgURLArray objectAtIndex:currentIndex];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"I like that picture very much on Central Selfie and this picture get %li likes, please check that",(long)gelP.likeCount]];
        NSURL * url=[NSURL URLWithString:gelP.imageURL];
        [tweetSheet addURL:url];

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
#pragma mark:Webservices
-(void)likePhotoWebservice{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (mainImgURLArray.count>=currentIndex) {
        GellaryPicture * gelPic=[mainImgURLArray objectAtIndex:currentIndex];
        [params setObject:gelPic.imageID forKey:kImageID];
    }
    if (GetStringWithKey(kUserID)) {
        [params setObject:GetStringWithKey(kUserID) forKey:kUserID];
    }

    [params setObject:kTaskLikeImage forKey:kTask];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURLImages parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject valueForKey:kStatusCode]integerValue]==12000) {
//            ShowMessage(kAppName, @"HOT");
            [self updateLikeCountOfTheLikeObject];
        }
        if ([[responseObject valueForKey:kStatusCode]integerValue]==12001) {
            ShowMessage(kAppName, @"Image has been already liked");
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}
-(void)sendFriendReqWebservice{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (mainImgURLArray.count>=currentIndex) {
        GellaryPicture * gelPic=[mainImgURLArray objectAtIndex:currentIndex];
        [params setObject:gelPic.userID forKey:kRecieverID];
    }
    if (GetStringWithKey(kUserID)) {
        [params setObject:GetStringWithKey(kUserID) forKey:kUserID];
    }
    
    [params setObject:kTaskSendFriendReq forKey:kTask];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURLUser parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject valueForKey:kStatusCode]integerValue]==14000) {
            ShowMessage(kAppName, @"Friend request has been sent successfully.");
        }
        else if ([[responseObject valueForKey:kStatusCode]integerValue]==14001) {
            ShowMessage(kAppName, @"You have already accepted the request.");
        }
        else if ([[responseObject valueForKey:kStatusCode]integerValue]==14002) {
            ShowMessage(kAppName, @"Your request has been blocked by other person.");
        }
        else if ([[responseObject valueForKey:kStatusCode]integerValue]==14005) {
            ShowMessage(kAppName, @"Request failure.");
        }
        
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}
-(void)getAllPicturesOfMensGalleryWebsrvice{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (GetStringWithKey(kUserID)) {
        [params setObject:GetStringWithKey(kUserID) forKey:kUserID];
    }
    
    [params setObject:kTaskGetAllFemaleImages forKey:kTask];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURLImages parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject valueForKey:kStatusCode]integerValue]==15000) {
            if ([responseObject valueForKey:kValue] && ![[responseObject valueForKey:kValue]isEqual:[NSNull null]]) {
                NSArray * arrayUrl=[responseObject valueForKey:kValue];
                [mainImgURLArray removeAllObjects];
                for (NSDictionary *dict in arrayUrl) {
                    GellaryPicture * gelPic=[[GellaryPicture alloc]initWithDictionary:dict];
                    [mainImgURLArray addObject:gelPic];
                }
                [self reverse];
                [_imagePager reloadData];
            }
        }
        else if ([[responseObject valueForKey:@"statusCode"]integerValue]==15001) {
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}
@end
