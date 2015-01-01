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
#import "SocialSelfieAppDelegate.h"

@interface SignupViewController ()
{
    BOOL isFemalePressed;
    BOOL isMalePressed;
    BOOL isTermsPressed;
    BOOL isPictureAdded;
    SocialSelfieAppDelegate * appDelegate;
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
        isPictureAdded=NO;
        appDelegate=(SocialSelfieAppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView.scrollEnabled=YES;
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width,self.signUpBtn.frame.origin.y + self.signUpBtn.frame.size.height + 50);
    
    [UtilsFunctions makeUIImageViewRound:self.profileImg ANDRadius:2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark:Selector Methods
-(void)goToHomeAfterSuccessfulLogin{
    [appDelegate updateDeviceTokenForPush];
    ShowMessage(kAppName, @"You have signed up successfuly");
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

- (IBAction)addPhotobtnAction:(id)sender {
    UIActionSheet * actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery", nil];
    [actionSheet showInView:self.view];
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
                            if (isPictureAdded) {
                                [self signUpWebservice];
                            }
                            else{
                                ShowMessage(kAppName, @"Please add profile picture.");
                            }
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
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex==0) {
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//            [imagePickerController.navigationBar setTintColor:[UIColor colorWithRed:86.0/255.0 green:198.0/255.0 blue:160.0/255.0 alpha:1.0]];
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else
        {
            ShowMessage(@"Error", @"Sorry! Camera is not available");
        }
    }
    else if (buttonIndex==1) {
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            [imagePickerController.navigationBar setTintColor:[UIColor colorWithRed:86.0/255.0 green:198.0/255.0 blue:160.0/255.0 alpha:1.0]];
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else
        {
            ShowMessage(@"Error", @"Sorry! Photo Library is not available");
        }
    }
}
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage =info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if(chosenImage.size.width>320)
    {
        self.profileImg.image=[UtilsFunctions imageByCroppingImage:chosenImage toSize:CGSizeMake(320, 320)];
    }
    else{
        self.profileImg.image=chosenImage;
    }
    isPictureAdded=YES;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    [params setObject:kTaskSignUp forKey:kTask];
    
    NSData * imageData=UIImageJPEGRepresentation(self.profileImg.image, 0.1);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [manager POST:kBaseURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:kUploadedFile fileName:[NSString stringWithFormat: @"sharingImage%f.jpg", [[NSDate date] timeIntervalSince1970]] mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
//    [manager POST:kBaseURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

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
