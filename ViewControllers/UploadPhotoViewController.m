//
//  UploadPhotoViewController.m
//  SocialSelfie
//
//  Created by Saad Khan on 29/10/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "UploadPhotoViewController.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "UtilsFunctions.h"
#import "MBProgressHUD.h"

@interface UploadPhotoViewController ()

@end

@implementation UploadPhotoViewController
@synthesize mainImage;
- (id)initWithImage:(UIImage *)img
{
    self = [super initWithNibName:@"UploadPhotoViewController" bundle:Nil];
    if (self) {
        mainImage=img;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imgView.image=mainImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark:Selector Methods
-(void)actionAfterUploadSuccess{
    ShowMessage(kAppName, @"Photo uploaded successfully");
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if([info valueForKey:UIImagePickerControllerOriginalImage]){
        UIImage *chosenImage =info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:NO completion:nil];
        self.imgView.image=[UtilsFunctions imageWithImage:chosenImage scaledToSize:CGSizeMake(300, 300)];
        mainImage=chosenImage;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark:IBAction & Selectors
- (IBAction)selectPhotoAction:(id)sender {
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [imagePickerController.navigationBar setTintColor:[UIColor colorWithRed:73.0/255.0 green:189.0/255.0 blue:143.0/255.0 alpha:1]];
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else
    {
        ShowMessage(@"Error", @"Sorry! Camera is not available");
    }
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)uploadBtnAction:(id)sender {
    [self uploadPhotoWebservice];
}

#pragma mark:Webservices
-(void)uploadPhotoWebservice{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:kTaskUploadImage forKey:kTask];
    if (GetStringWithKey(kUserID)) {
        [params setObject:GetStringWithKey(kUserID) forKey:kUserID];
    }
//    [params setObject:UIImagePNGRepresentation(mainImage) forKey:kUploadedFile];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSData * imageData=UIImageJPEGRepresentation(mainImage, 0.1);
    
    [manager POST:kBaseURLImages parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:kUploadedFile fileName:[NSString stringWithFormat: @"sharingImage%f.jpg", [[NSDate date] timeIntervalSince1970]] mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self performSelectorOnMainThread:@selector(actionAfterUploadSuccess) withObject:nil waitUntilDone:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];

}
@end

