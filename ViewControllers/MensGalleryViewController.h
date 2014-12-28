//
//  MensGalleryViewController.h
//  SocialSelfie
//
//  Created by Saad Khan on 18/10/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFImagePager.h"
#import "SharePopUpView.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>


@interface MensGalleryViewController : UIViewController<SharePopUpViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userPicImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;

@property (weak, nonatomic) IBOutlet AFImagePager *imagePager;

@property (weak, nonatomic) IBOutlet UILabel *likeCountLbl;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (strong, nonatomic) IBOutlet UIImageView *tempImgView;

- (IBAction)goToPhotosAction:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)goToCommentsAction:(id)sender;
- (IBAction)goToShareAction:(id)sender;
- (IBAction)goToLikeAction:(id)sender;
- (IBAction)topRightBtnAction:(id)sender;

@end
