//
//  CenterMainViewController.h
//  SocialSelfie
//
//  Created by Saad Khan on 23/08/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CenterMainViewController : BaseViewController
{
    
}
@property (strong, nonatomic) IBOutlet UIView *navTitleView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UIImageView *centerImage;
@property (weak, nonatomic) IBOutlet UILabel *lblLikesCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentsCount;

- (IBAction)btnSharePressed:(id)sender;
- (IBAction)btnLikePressed:(id)sender;
- (IBAction)btnCommentPressed:(id)sender;

@end
