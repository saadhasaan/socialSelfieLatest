//
//  SignupViewController.h
//  SocialSelfie
//
//  Created by Saad Khan on 30/08/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TNRadioButtonGroup.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface SignupViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *termsBtn;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *fullNameTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *countryTF;
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;

- (IBAction)femaleBtnAction:(id)sender;
- (IBAction)termsBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)addPhotobtnAction:(id)sender;

- (IBAction)maleBtnAction:(id)sender;
- (IBAction)signupBtnAction:(id)sender;
@end
