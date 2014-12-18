//
//  WoMensGalleryViewController.h
//  SocialSelfie
//
//  Created by Saad Khan on 18/10/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFImagePager.h"
#import "SharePopUpView.h"

@interface WoMensGalleryViewController : UIViewController<SharePopUpViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userPicImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;

@property (weak, nonatomic) IBOutlet AFImagePager *imagePager;

@property (weak, nonatomic) IBOutlet UILabel *likeCountLbl;

- (IBAction)goToPhotosAction:(id)sender;

- (IBAction)backAction:(id)sender;
- (IBAction)goToCommentsAction:(id)sender;
- (IBAction)goToShareAction:(id)sender;
- (IBAction)goToLikeAction:(id)sender;

@end
