//
//  MainLoginViewController.h
//  SocialSelfie
//
//  Created by Saad Khan on 04/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignupViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "FBLogin.h"
#import "FBUserSelf.h"
#import "TWLogin.h"
#import "FacebookManager.h"

@interface MainLoginViewController : UIViewController<FBLoginDelegate,TWLoginDelegate>

- (IBAction)facebookBtnAction:(id)sender;
- (IBAction)twitterBtnPressed:(id)sender;
- (IBAction)socialSelfieLoginBtnPressed:(id)sender;
- (IBAction)signUpBtnPressed:(id)sender;
- (IBAction)aboutUsBtnPressed:(id)sender;
@end
