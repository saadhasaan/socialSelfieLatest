//
//  CenterMainViewController.m
//  SocialSelfie
//
//  Created by Saad Khan on 23/08/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "CenterMainViewController.h"

@interface CenterMainViewController ()

@end

@implementation CenterMainViewController

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
    self.navigationItem.titleView=self.navTitleView;
    
    UIButton *btnTopBarRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnTopBarRight setFrame:CGRectMake(0, 0, 31, 25)];
    [btnTopBarRight.imageView setContentMode:UIViewContentModeLeft ];
    [btnTopBarRight setImage:[UIImage imageNamed:@"right-menu-icon.png"] forState:UIControlStateNormal];
    [btnTopBarRight setImage:[UIImage imageNamed:@"right-menu-icon-pressed.png"] forState:UIControlStateHighlighted];
//    [btnTopBarRight addTarget:self action:@selector(backButtonChat:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItemRight = [[UIBarButtonItem alloc] initWithCustomView:btnTopBarRight];
    self.navigationItem.rightBarButtonItem = barButtonItemRight;

    self.titleImage.layer.cornerRadius=5;//For making round corner
    self.titleImage.clipsToBounds=YES;//For making round corner

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSharePressed:(id)sender {
}

- (IBAction)btnLikePressed:(id)sender {
}

- (IBAction)btnCommentPressed:(id)sender {
}
@end
