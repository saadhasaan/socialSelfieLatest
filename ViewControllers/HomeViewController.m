//
//  HomeViewController.m
//  SocialSelfie
//
//  Created by Saad Khan on 18/10/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionCell.h"
#import "MensGalleryViewController.h"
#import "WoMensGalleryViewController.h"
#import "Constants.h"
#import "UtilsFunctions.h"
#import "UploadPhotoViewController.h"
#import "MyPhotoesViewController.h"
#import "MyProfileViewController.h"

@interface HomeViewController ()
{
    NSMutableArray * mainArray;
    NSMutableArray * imgIconArray;
}
@end

@implementation HomeViewController

- (id)init
{
    self = [super initWithNibName:@"HomeViewController" bundle:nil];
    if (self) {
        mainArray=[[NSMutableArray alloc]init];
        imgIconArray=[[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects:@"mens_gallery_icon",@"womens_gallery_icon",@"upload_photo",@"take_photo",@"my_photos",@"my_profile",@"my_alerts_icon",@"chat_icon",@"settings_icon", nil]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //For Collection view
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HomeColCell"];
    
    [self loadMainArray];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark:Custom Methods
-(void)loadMainArray{
    [mainArray removeAllObjects];
    [mainArray addObject:kMenGallery];
    [mainArray addObject:kWomenGallery];
    [mainArray addObject:kUploadPhoto];
    [mainArray addObject:kTakePhoto];
    [mainArray addObject:kMyPhoto];
    [mainArray addObject:kMyProfile];
    [mainArray addObject:kMyAlerts];
    [mainArray addObject:kChat];
    [mainArray addObject:kSettings];
}
-(void)moveToUploadVCWithImage:(UIImage *)img{
    UploadPhotoViewController * uploadVC=[[UploadPhotoViewController alloc]initWithImage:[UtilsFunctions imageWithImage:img scaledToSize:CGSizeMake(300, 300)]];
    [self.navigationController pushViewController:uploadVC animated:YES];
}
#pragma mark: UICollectionView Delegates and Datasource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [mainArray count];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(94,90);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);//(top, left, bottom, right);
}
- (HomeCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeColCell" forIndexPath:indexPath];
    
    cell.titleLbl.text=[mainArray objectAtIndex:indexPath.row];
    cell.imgView.image=[UIImage imageNamed:[imgIconArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%li",(long)indexPath.row);
    if([[mainArray objectAtIndex:indexPath.row]isEqualToString:kMenGallery]){
        MensGalleryViewController * mensGalleryVC=[[MensGalleryViewController alloc]init];
        [self.navigationController pushViewController:mensGalleryVC animated:YES];
    }
    else if([[mainArray objectAtIndex:indexPath.row]isEqualToString:kWomenGallery]){
        WoMensGalleryViewController * womensGalleryVC=[[WoMensGalleryViewController alloc]init];
        [self.navigationController pushViewController:womensGalleryVC animated:YES];
    }
    else if([[mainArray objectAtIndex:indexPath.row]isEqualToString:kMyProfile]){
        MyProfileViewController * myProfileVC=[[MyProfileViewController alloc]init];
        [self.navigationController pushViewController:myProfileVC animated:YES];
    }
    else if([[mainArray objectAtIndex:indexPath.row]isEqualToString:kUploadPhoto]){
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [imagePickerController.navigationBar setTintColor:[UIColor colorWithRed:73.0/255.0 green:189.0/255.0 blue:143.0/255.0 alpha:1]];
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else
        {
            ShowMessage(@"Error", @"Sorry! Gallery is not available");
        }
    }
    else if([[mainArray objectAtIndex:indexPath.row]isEqualToString:kTakePhoto]){
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [imagePickerController.navigationBar setTintColor:[UIColor colorWithRed:73.0/255.0 green:189.0/255.0 blue:143.0/255.0 alpha:1]];
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else
        {
            ShowMessage(@"Error", @"Sorry! Camera is not available");
        }
    }
    else if([[mainArray objectAtIndex:indexPath.row]isEqualToString:kMyPhoto]){
        MyPhotoesViewController * myPhotoVC=[[MyPhotoesViewController alloc]init];
        [self.navigationController pushViewController:myPhotoVC animated:YES];
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if([info valueForKey:UIImagePickerControllerOriginalImage]){
        UIImage *chosenImage =info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:NO completion:nil];
        [self performSelector:@selector(moveToUploadVCWithImage:) withObject:chosenImage afterDelay:0.05];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
