//
//  MyProfileViewController.h
//  SocialSelfie
//
//  Created by Saad Khan on 13/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13BadgeView.h"
#import "SocialSelfieAppDelegate.h"

@interface MyProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UILabel *myNameLbl;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

- (IBAction)backbtnAction:(id)sender;
- (IBAction)goToMyPhotoesAction:(id)sender;
- (IBAction)goToMyAlertsAction:(id)sender;
- (IBAction)goToFriendReqAction:(id)sender;
@end
