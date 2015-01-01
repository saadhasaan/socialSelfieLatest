//
//  WoMensGalleryViewController.h
//  SocialSelfie
//
//  Created by Saad Khan on 18/10/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "WoMensGalleryViewController.h"
#import "CommentsViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Constants.h"
#import "UtilsFunctions.h"
#import "MyPhotoesViewController.h"
#import "GellaryPicture.h"
#import "UIImageView+AFNetworking.h"

@interface WoMensGalleryViewController ()
{
    SharePopUpView * sharePopUpView;
    BOOL isSharePopUpViewPresent;
    NSMutableArray * mainImgURLArray;
}
@end

@implementation WoMensGalleryViewController

- (id)init
{
    self = [super initWithNibName:@"WoMensGalleryViewController" bundle:nil];
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
 
    mainImgURLArray=[[NSMutableArray alloc]init];
    [self getAllPicturesOfMensGalleryWebsrvice];
    
    self.userPicImgView.layer.cornerRadius=8;//For making round corner
    self.userPicImgView.clipsToBounds=YES;//For making round corner

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        GellaryPicture * gelPic=[mainImgURLArray objectAtIndex:0];
        self.userNameLbl.text=gelPic.userName;
        [self.userPicImgView setImageWithURL:[NSURL URLWithString:gelPic.userProfileImageURL]placeholderImage:[UIImage imageNamed:@"parallax_avatar"]];
    }
    NSMutableArray * urlsArray=[[NSMutableArray alloc]init];
    for (GellaryPicture * gelPic in mainImgURLArray) {
        [urlsArray addObject:gelPic.imageURL];
    }
    return urlsArray;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image
{
    return UIViewContentModeScaleToFill;
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
        [self.userPicImgView setImageWithURL:[NSURL URLWithString:gelPic.userProfileImageURL]];
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
    CommentsViewController * commentVC=[[CommentsViewController alloc]init];
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
}
-(void)shareFBButtonHasBeenPressed{
}
-(void)shareTWButtonHasBeenPressed{    
}
-(void)closeSharePopUpViewButtonHasBeenPressed{
    isSharePopUpViewPresent=NO;
    [sharePopUpView removeFromSuperview];
}
#pragma mark:Webservices
-(void)likePhotoWebservice{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    

    [params setObject:@"asd" forKey:kImageID];
    if (GetStringWithKey(kUserID)) {
        [params setObject:GetStringWithKey(kUserID) forKey:kUserID];
    }

    [params setObject:kTaskLikeImage forKey:kTask];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
