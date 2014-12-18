//
//  BaseViewController.m
//  SocialSelfie
//
//  Created by Saad Khan on 31/08/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "BaseViewController.h"
#import "SocialSelfieAppDelegate.h"

@interface BaseViewController ()
{
    SocialSelfieAppDelegate * appDelegate;
}
@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    UIButton *btnTopBarLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnTopBarLeft setFrame:CGRectMake(0, 0, 31, 25)];
    [btnTopBarLeft.imageView setContentMode:UIViewContentModeLeft ];
    [btnTopBarLeft setImage:[UIImage imageNamed:@"right-menu-icon.png"] forState:UIControlStateNormal];
    [btnTopBarLeft setImage:[UIImage imageNamed:@"right-menu-icon-pressed.png"] forState:UIControlStateHighlighted];
    [btnTopBarLeft addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnTopBarLeft];
    self.navigationItem.leftBarButtonItem = barButtonItemRight;
    
    appDelegate=(SocialSelfieAppDelegate *)[UIApplication sharedApplication].delegate;
}
-(void)showMenu:(id)sender{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
