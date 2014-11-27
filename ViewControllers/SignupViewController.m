//
//  SignupViewController.m
//  SocialSelfie
//
//  Created by Saad Khan on 30/08/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "SignupViewController.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "UtilsFunctions.h"
#import "MBProgressHUD.h"
#import "HomeViewController.h"

@interface SignupViewController ()
{
    BOOL isFemalePressed;
    BOOL isMalePressed;
    BOOL isTermsPressed;
}
@end

@implementation SignupViewController
@synthesize femaleBtn;
@synthesize maleBtn;
@synthesize termsBtn;
@synthesize scrollView;
- (id)init
{
    self = [super initWithNibName:@"SignupViewController" bundle:Nil];
    if (self) {
        isFemalePressed=NO;
        isMalePressed=YES;
        isTermsPressed=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView.scrollEnabled=YES;
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width,self.signUpBtn.frame.origin.y + self.signUpBtn.frame.size.height + 50);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark:Selector Methods
-(void)goToHomeAfterSuccessfulLogin{
    HomeViewController * homeVC=[[HomeViewController alloc]init];
    [self.navigationController pushViewController:homeVC animated:YES];
}
#pragma mark:IBActions
- (IBAction)femaleBtnAction:(id)sender {
    if(isFemalePressed){
        [femaleBtn setImage:[UIImage imageNamed:@"check_btn_blank"] forState:UIControlStateNormal];
        [maleBtn setImage:[UIImage imageNamed:@"check_btn"] forState:UIControlStateNormal];
        isFemalePressed=NO;
        isMalePressed=YES;
    }
    else{
        [femaleBtn setImage:[UIImage imageNamed:@"check_btn"] forState:UIControlStateNormal];
        [maleBtn setImage:[UIImage imageNamed:@"check_btn_blank"] forState:UIControlStateNormal];
        isFemalePressed=YES;
        isMalePressed=NO;
    }
}

- (IBAction)termsBtnAction:(id)sender {
    if(isTermsPressed){
        [termsBtn setImage:[UIImage imageNamed:@"check_btn"] forState:UIControlStateNormal];
        isTermsPressed=NO;
    }
    else{
        [termsBtn setImage:[UIImage imageNamed:@"check_btn_blank"] forState:UIControlStateNormal];
        isTermsPressed=YES;
    }
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)maleBtnAction:(id)sender {
    if(isMalePressed){
        [maleBtn setImage:[UIImage imageNamed:@"check_btn_blank"] forState:UIControlStateNormal];
        [femaleBtn setImage:[UIImage imageNamed:@"check_btn"] forState:UIControlStateNormal];
        isMalePressed=NO;
        isFemalePressed=YES;
    }
    else{
        [maleBtn setImage:[UIImage imageNamed:@"check_btn"] forState:UIControlStateNormal];
        [femaleBtn setImage:[UIImage imageNamed:@"check_btn_blank"] forState:UIControlStateNormal];
        isMalePressed=YES;
        isFemalePressed=NO;

    }
}

- (IBAction)signupBtnAction:(id)sender {
    if ([self.userNameTF.text length]>0) {
        if ([self.passwordTF.text length]>0) {
            if ([self.fullNameTF.text length]>0) {
                if ([self.emailTF.text length]>0) {
                    if ([self.countryTF.text length]>0) {
                        if (isTermsPressed) {
                            [self signUpWebservice];
                        }
                        else{
                            ShowMessage(kAppName, @"Please accept terms and conditions.");
                        }
                    }
                    else{
                        ShowMessage(kAppName, @"Please enter country name.");
                    }
                }
                else{
                    ShowMessage(kAppName, @"Please enter email.");
                }
            }
            else{
                ShowMessage(kAppName, @"Please enter name.");
            }
        }
        else{
            ShowMessage(kAppName, @"Please enter a password.");
        }
    }
    else{
        ShowMessage(kAppName, @"Please enter username.");
    }
}

#pragma mark:Webservices
-(void)signUpWebservice{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.userNameTF.text forKey:kUserName];
    [params setObject:self.passwordTF.text forKey:kPassword];
    [params setObject:self.fullNameTF.text forKey:kName];
    [params setObject:self.emailTF.text forKey:kEmail];
    [params setObject:self.countryTF.text forKey:kCountry];
    [params setObject:@"1234556" forKey:kPhone];
    if (isMalePressed) {
        [params setObject:@"male" forKey:kGender];
    }
    else{
        [params setObject:@"female" forKey:kGender];
    }
    if (GetStringWithKey(kDeviceType)) {
        [params setObject:GetStringWithKey(kDeviceType) forKey:kDeviceType];
    }
    if (GetStringWithKey(kDeviceID)) {
        [params setObject:GetStringWithKey(kDeviceID) forKey:kDeviceID];
    }
    [params setObject:kTaskSignUp forKey:kTask];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        NSString * string=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@"JSON: %@", jsonDict);
        if ([[jsonDict valueForKey:@"status"]integerValue]==1) {
            if ([[jsonDict valueForKey:@"statusCode"]integerValue]==1001) {
                ShowMessage(kAppName,@"User name is already exists.");
            }
            else if ([[jsonDict valueForKey:@"statusCode"]integerValue]==1002){
                ShowMessage(kAppName,@"The email address is already associated with other account.");
            }
            else if ([[jsonDict valueForKey:@"statusCode"]integerValue]==1003){
                ShowMessage(kAppName,@"Unable to insert the record.");
            }
            else if([[jsonDict valueForKey:@"statusCode"]integerValue]==1000){
                NSDictionary * valueDict=[jsonDict valueForKey:kValue];
                if ([valueDict valueForKey:kUserName] && ![[valueDict valueForKey:kUserName]isEqual:[NSNull null]]) {
                    SaveStringWithKey([valueDict valueForKey:kUserName], kUserName);
                }
                if ([valueDict valueForKey:kUserID] && ![[valueDict valueForKey:kUserID]isEqual:[NSNull null]]) {
                    SaveStringWithKey([valueDict valueForKey:kUserID], kUserID);
                }
                if ([valueDict valueForKey:kProfileImage] && ![[valueDict valueForKey:kProfileImage]isEqual:[NSNull null]]) {
                    SaveStringWithKey([valueDict valueForKey:kProfileImage], kProfileImage);
                }
                if ([valueDict valueForKey:kPhone] && ![[valueDict valueForKey:kPhone]isEqual:[NSNull null]]) {
                    SaveStringWithKey([valueDict valueForKey:kPhone], kPhone);
                }
                if ([valueDict valueForKey:kName] && ![[valueDict valueForKey:kName]isEqual:[NSNull null]]) {
                    SaveStringWithKey([valueDict valueForKey:kName], kName);
                }
                if ([valueDict valueForKey:kGender] && ![[valueDict valueForKey:kGender]isEqual:[NSNull null]]) {
                    SaveStringWithKey([valueDict valueForKey:kGender], kGender);
                }
                if ([valueDict valueForKey:kFacebookImage] && ![[valueDict valueForKey:kFacebookImage]isEqual:[NSNull null]]) {
                    SaveStringWithKey([valueDict valueForKey:kFacebookImage], kFacebookImage);
                }
                if ([valueDict valueForKey:kEmail] && ![[valueDict valueForKey:kEmail]isEqual:[NSNull null]]) {
                    SaveStringWithKey([valueDict valueForKey:kEmail], kEmail);
                }
                if ([valueDict valueForKey:kCountry] && ![[valueDict valueForKey:kCountry]isEqual:[NSNull null]]) {
                    SaveStringWithKey([valueDict valueForKey:kCountry], kCountry);
                }
                if ([valueDict valueForKey:kTwitterImage] && ![[valueDict valueForKey:kTwitterImage]isEqual:[NSNull null]]) {
                    SaveStringWithKey([valueDict valueForKey:kTwitterImage], kTwitterImage);
                }
                SaveStringWithKey(@"YES", kIsLoggedIn);
                [self performSelectorOnMainThread:@selector(goToHomeAfterSuccessfulLogin) withObject:nil waitUntilDone:NO];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}

@end
