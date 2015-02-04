//
//  MainLoginViewController.m
//  SocialSelfie
//
//  Created by Saad Khan on 04/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "MainLoginViewController.h"
#import <AdSupport/AdSupport.h>
#import "UtilsFunctions.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "HomeViewController.h"
#import "SocialSelfieAppDelegate.h"
#import "HFViewController.h"
#import "FBUser.h"

#define facebookKey @"1492084591036761"
@interface MainLoginViewController (){
    FBLogin * fbLogin;
    TWLogin * twLogin;
    SocialSelfieAppDelegate * appDelegate;
    FacebookManager *fbManager;
    NSArray * permissionsArray;
}

@end

@implementation MainLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        appDelegate=(SocialSelfieAppDelegate*)[UIApplication sharedApplication].delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    SaveStringWithKey([[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],kDeviceID);
    SaveStringWithKey(@"1", kDeviceType);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark:FBLoginDelegate
-(void)failedToFetchAnyAccount{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    ShowMessage(kAppName, @"Please add Facebook account in Seetings.");
}
-(void)fbProfileHasBeenFetchedSuccessfullyWithInfo:(FBUserSelf *)fbUser{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [self facebookLoginWebserviceWithFBUser:fbUser];
    //Save data in user default
    if (fbUser.email) {
        SaveStringWithKey(fbUser.email, kUserName);
    }
    if (fbUser.profileImageURL) {
        SaveStringWithKey(fbUser.profileImageURL, kProfileImage);
    }
    if(fbUser.firstName){
        SaveStringWithKey(fbUser.firstName, kName);
    }
    if (fbUser.gender) {
        SaveStringWithKey(fbUser.gender, kGender);
    }
    if (fbUser.email) {
        SaveStringWithKey(fbUser.email, kEmail);
    }
}
-(void)fbProfileDidNotFetched{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    ShowMessage(kAppName, @"Failed to fetch any Facebook profile, please try again and make sure you have added facebook account in settings of phone.");
}
#pragma mark: TWLoginDelegate
-(void)failedToFetchAnyTWAccount{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    ShowMessage(kAppName, @"Failed to fetch any Twitter account");
}
-(void)twProfileHasBeenFetchedSuccessfullyWithInfo:(FBUserSelf *)fbUser{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [self facebookLoginWebserviceWithFBUser:fbUser];
    //Save data in user default
    if (fbUser.email) {
        SaveStringWithKey(fbUser.email, kUserName);
    }
    if (fbUser.profileImageURL) {
        SaveStringWithKey(fbUser.profileImageURL, kProfileImage);
    }
    if(fbUser.userName){
        SaveStringWithKey(fbUser.firstName, kName);
    }
    if (fbUser.gender) {
        SaveStringWithKey(fbUser.gender, kGender);
    }
    if (fbUser.email) {
        SaveStringWithKey(fbUser.email, kEmail);
    }
}
-(void)twProfileDidNotFetched{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    ShowMessage(kAppName, @"Failed to fetch any Twitter profile");
}
#pragma mark:IBActions and Selectors
-(void)goToHomeScreenAfterSuccessfulLogin{
    [appDelegate updateDeviceTokenForPush];
    HomeViewController * homeVC=[[HomeViewController alloc]init];
    [self.navigationController pushViewController:homeVC animated:YES];
}
- (IBAction)facebookBtnAction:(id)sender {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    if (!fbLogin) {
//        fbLogin=[[FBLogin alloc]initWithKey:facebookKey];
//        fbLogin.delegate=self;
//    }
//    else{
//        [fbLogin facebookAccountInit];
//    }
    
//    HFViewController * hfVC = [[HFViewController alloc] init];
//    [self.navigationController pushViewController:hfVC animated:YES];
    
    [self shareOnSocialMedia:nil];
}

- (IBAction)twitterBtnPressed:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (!twLogin) {
        twLogin=[[TWLogin alloc]init];
    }
    else{
        [twLogin fetchTWData];
    }
    twLogin.delegate=self;
}
- (void)shareOnSocialMedia:(NSDictionary *)params
{
    
    fbManager = [FacebookManager sharedManager];
    if (!permissionsArray) {
        permissionsArray = [[NSArray alloc] initWithObjects:@"public_profile", nil];
        
    }
    [fbManager permissions:permissionsArray];
    
    [fbManager openSessionCompletionHandler:^(NSError *error) {
        
        if (error == nil)
        {
            //   [DejalBezelActivityView removeViewAnimated:YES];
            
            [fbManager populateUserDetailsWithCompletionHandler:^(FBUser *user,NSError* error){
                
                if (error == nil)
                {
                    FBUserSelf * fbUserSelf=[[FBUserSelf alloc]init];
                    if (user.email) {
                        fbUserSelf.userName=user.email;
                        SaveStringWithKey(user.email, kUserName);
                    }
                    else{
                        fbUserSelf.email=@"No Username";
                        SaveStringWithKey(@"No Username", kUserName);
                    }
                    if (user.imgUrl) {
                        fbUserSelf.profileImageURL=user.imgUrl;
                        SaveStringWithKey(user.imgUrl, kProfileImage);
                    }
                    else{
                        fbUserSelf.profileImageURL=@"";
                        SaveStringWithKey(@"", kProfileImage);
                    }
                    if(user.name){
                        fbUserSelf.userName=user.name;
                        SaveStringWithKey(user.name, kName);
                    }
                    else{
                        fbUserSelf.userName=@"No Name";
                        SaveStringWithKey(@"No Name", kName);
                    }
                    if (user.email) {
                        fbUserSelf.email=user.email;
                        SaveStringWithKey(user.email, kEmail);
                    }
                    else{
                        fbUserSelf.email=@"No Email";
                        SaveStringWithKey(@"No Email", kEmail);
                    }
//                    customerInfo.facebookID = user.fId;
//                    customerInfo.facebookName = [self.fbManager getName];
                    [self facebookLoginWebserviceWithFBUser:fbUserSelf];
                }
                
            }];
            
//            [fbLoginView removeFromSuperview];
            
//            sorryLabel.hidden = YES;
//            animatedImage.hidden = NO;
//            [self runAnimation];
            
//            [self.view addSubview:loadingView];
//            loadingView.center = self.view.center;
            
        }
        else
        {
            BOOL isError = [FBErrorUtility shouldNotifyUserForError:error];
            
            if (isError)
            {
                NSString * userErrorMsg = [FBErrorUtility userMessageForError:error];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:userErrorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            }
            else
            {
                FBErrorCategory userErrorCategory = [FBErrorUtility errorCategoryForError:error];
                
                if (userErrorCategory == FBErrorCategoryUserCancelled)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You have cancelled the login operation." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
                else if (userErrorCategory == FBErrorCategoryAuthenticationReopenSession)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Login Again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There is a problem connecting to facebook." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
                
            }
            
            //  [DejalBezelActivityView removeViewAnimated:YES];
        }
    }];
    
}
- (IBAction)socialSelfieLoginBtnPressed:(id)sender {
    LoginViewController * loginVC=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (IBAction)signUpBtnPressed:(id)sender {
    SignupViewController * signUp=[[SignupViewController alloc]init];
    [self.navigationController pushViewController:signUp animated:YES];
}

- (IBAction)aboutUsBtnPressed:(id)sender {
}
#pragma mark:Webservices
-(void)facebookLoginWebserviceWithFBUser:(FBUserSelf * )fbUser{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:fbUser.firstName forKey:kName];
    [params setObject:fbUser.fbiD forKey:kFBID];
    if (fbUser.gender) {
        [params setObject:fbUser.gender forKey:kGender];
    }
    else{
        [params setObject:@"Female" forKey:kGender];
    }
    if (fbUser.email) {
        [params setObject:fbUser.email forKey:kEmail];
    }
    else{
        [params setObject:@"NP" forKey:kEmail];
    }
    [params setObject:fbUser.profileImageURL forKey:kFacebookImage];
    if (GetStringWithKey(kIsPushEnabled)) {
        if ([GetStringWithKey(kIsPushEnabled)isEqualToString:@"NO"]) {
            [params setObject:@"0" forKey:kNotificationStatus];
        }
        else{
            [params setObject:@"1" forKey:kNotificationStatus];
        }
    }
    else{
        [params setObject:@"1" forKey:kNotificationStatus];
    }
//    if (GetStringWithKey(kDeviceType)) {
//        [params setObject:GetStringWithKey(kDeviceType) forKey:kDeviceType];
//    }
//    if (GetStringWithKey(kDeviceID)) {
//        [params setObject:GetStringWithKey(kDeviceID) forKey:kDeviceID];
//    }
    [params setObject:kTaskFBLogin forKey:kTask];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([[responseObject valueForKey:@"statusCode"]integerValue]==3000){
            NSDictionary * valueDict=[responseObject valueForKey:kValue];
            if ([valueDict valueForKey:kFacebookImage] && ![[valueDict valueForKey:kFacebookImage]isEqual:[NSNull null]]) {
                SaveStringWithKey([valueDict valueForKey:kFacebookImage], kProfileImage);
            }
            if ([valueDict valueForKey:kUserID] && ![[valueDict valueForKey:kUserID]isEqual:[NSNull null]]) {
                SaveStringWithKey([valueDict valueForKey:kUserID], kUserID);
            }
            SaveStringWithKey(@"YES", kIsLoggedIn);
            [self performSelectorOnMainThread:@selector(goToHomeScreenAfterSuccessfulLogin) withObject:nil waitUntilDone:NO];
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}
-(void)twitterLoginWebserviceWithFBUser:(FBUserSelf * )fbUser{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:fbUser.userName forKey:kName];
    [params setObject:fbUser.fbiD forKey:kTwitterID];
    if (fbUser.gender) {
        [params setObject:fbUser.gender forKey:kGender];
    }
    else{
        [params setObject:@"Female" forKey:kGender];
    }
    if (fbUser.email) {
        [params setObject:fbUser.email forKey:kEmail];
    }
    else{
        [params setObject:@"NP" forKey:kEmail];
    }
    [params setObject:fbUser.profileImageURL forKey:kTwitterImage];
    SaveStringWithKey(fbUser.profileImageURL, kProfileImage);
//    if (GetStringWithKey(kDeviceType)) {
//        [params setObject:GetStringWithKey(kDeviceType) forKey:kDeviceType];
//    }
//    if (GetStringWithKey(kDeviceID)) {
//        [params setObject:GetStringWithKey(kDeviceID) forKey:kDeviceID];
//    }
    if (GetStringWithKey(kIsPushEnabled)) {
        if ([GetStringWithKey(kIsPushEnabled)isEqualToString:@"NO"]) {
            [params setObject:@"0" forKey:kNotificationStatus];
        }
        else{
            [params setObject:@"1" forKey:kNotificationStatus];
        }
    }
    else{
        [params setObject:@"1" forKey:kNotificationStatus];
    }
    [params setObject:kTaskTWLogin forKey:kTask];
    [params setObject:@"NP" forKey:kCountry];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([[responseObject valueForKey:@"statusCode"]integerValue]==4000){
            NSDictionary * valueDict=[responseObject valueForKey:kValue];
            if ([valueDict valueForKey:kTwitterImage] && ![[valueDict valueForKey:kTwitterImage]isEqual:[NSNull null]]) {
                SaveStringWithKey([valueDict valueForKey:kTwitterImage], kProfileImage);
            }
            if ([valueDict valueForKey:kUserID] && ![[valueDict valueForKey:kUserID]isEqual:[NSNull null]]) {
                SaveStringWithKey([valueDict valueForKey:kUserID], kUserID);
            }
            SaveStringWithKey(@"YES", kIsLoggedIn);
            [self performSelectorOnMainThread:@selector(goToHomeScreenAfterSuccessfulLogin) withObject:nil waitUntilDone:NO];
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}

@end
