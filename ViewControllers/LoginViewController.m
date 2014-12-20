//
//  LoginViewController.m
//  SocialSelfie
//
//  Created by Saad Khan on 04/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "UtilsFunctions.h"
#import "HomeViewController.h"
#import "SocialSelfieAppDelegate.h"

@interface LoginViewController ()
{
    SocialSelfieAppDelegate * appDelegate;
}
@end

@implementation LoginViewController

- (id)init
{
    self = [super initWithNibName:@"LoginViewController" bundle:nil];
    if (self) {
        appDelegate=(SocialSelfieAppDelegate*)[UIApplication sharedApplication].delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark:IBActions and Selectors
-(void)goToHomeAfterSuccessfulLogin{
    [appDelegate updateDeviceTokenForPush];
    HomeViewController * homeVC=[[HomeViewController alloc]init];
    [self.navigationController pushViewController:homeVC animated:YES];
}
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)siginBtnPressed:(id)sender {
    [self signInWebservice];
}
#pragma mark:Webservices
-(void)signInWebservice{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.userNameTF.text forKey:kUserName];
    [params setObject:self.passwordTF.text forKey:kPassword];
    if (GetStringWithKey(kDeviceType)) {
        [params setObject:GetStringWithKey(kDeviceType) forKey:kDeviceType];
    }
    if (GetStringWithKey(kDeviceID)) {
        [params setObject:GetStringWithKey(kDeviceID) forKey:kDeviceID];
    }
    [params setObject:kTaskLogin forKey:kTask];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject valueForKey:@"statusCode"]integerValue]==2001){
            ShowMessage(kAppName,@"Invalid username for login.");
        }
        else if ([[responseObject valueForKey:@"statusCode"]integerValue]==2003){
            ShowMessage(kAppName,@"Invalid credentials for login.");
        }
        else if([[responseObject valueForKey:@"statusCode"]integerValue]==2000){
            NSDictionary * valueDict=[responseObject valueForKey:@"value"];
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
            if ([valueDict valueForKey:kFacebookImage] && ![[valueDict valueForKey:kFacebookImage]isEqual:[NSNull null]])
            {
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
            [self performSelector:@selector(goToHomeAfterSuccessfulLogin) withObject:nil afterDelay:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}

@end
