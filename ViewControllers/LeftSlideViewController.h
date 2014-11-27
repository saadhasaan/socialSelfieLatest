//
//  LeftSlideViewController.h
//  SocialSelfie
//
//  Created by Saad Khan on 23/08/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MENU_ITEM_LOGIN = 0,
    MENU_ITEM_OTHER
} MENU_ITEM;
@interface LeftSlideViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
