//
//  SocialSelfieAppDelegate.h
//  SocialSelfie
//
//  Created by Saad Khan on 23/08/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"
#import "CenterMainViewController.h"

@class JASidePanelController;

@interface SocialSelfieAppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController * mainNavigationController;
}
@property (strong, nonatomic) UIWindow *window;

@end
