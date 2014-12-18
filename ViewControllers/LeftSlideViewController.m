//
//  LeftSlideViewController.m
//  SocialSelfie
//
//  Created by Saad Khan on 23/08/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "LeftSlideViewController.h"
#import "SocialSelfieAppDelegate.h"
#import "LoginViewController.h"

@interface LeftSlideViewController ()
{
    NSArray * itemsArray;
    SocialSelfieAppDelegate * appDelegate;
}
@end

@implementation LeftSlideViewController

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
    
    appDelegate=(SocialSelfieAppDelegate *)[UIApplication sharedApplication].delegate;
    
    itemsArray=[[NSArray alloc]initWithObjects:@"Log In or Sign Up",@"Contacts",@"Dial Pad", @"Messages", @"Recent", @"Settings", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
	static NSString *cellIdentifier = @"OptionCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell==nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        //        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        
	}
    
    cell.textLabel.text = [itemsArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%d",indexPath.row+1]];
    cell.imageView.highlightedImage=[UIImage imageNamed:[NSString stringWithFormat:@"icon%d_pressed",indexPath.row+1]];

    cell.textLabel.textColor=[UIColor colorWithRed:206.0/255.0 green:206.0/255.0 blue:206.0/255.0 alpha:1];
    cell.textLabel.highlightedTextColor=[UIColor blackColor];
    UIView * selectedView = [[UIView alloc] initWithFrame:cell.frame];
    selectedView.backgroundColor = [UIColor colorWithRed:209.0/255.0 green:157.0/255.0 blue:62.0/255.0 alpha:1];//[UIColor colorWithRed:225.0/255 green:207.0/255 blue:173.0/255.0 alpha:1.0];
    cell.selectedBackgroundView = selectedView;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==MENU_ITEM_LOGIN){
//        if(![appDelegate isCurrentCenterViewController:[LoginViewController class]]){
//            LoginViewController * loginVC=[[LoginViewController alloc]init];
//            [appDelegate changeCenterViewController:loginVC];
//        }
    }
    
}

@end
