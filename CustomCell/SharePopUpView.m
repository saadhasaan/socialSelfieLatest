//
//  SharePopUpView.m
//  SocialSelfie
//
//  Created by Saad Khan on 04/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "SharePopUpView.h"

@implementation SharePopUpView
@synthesize delegate;
- (id)init
{
    self = [self loadFromNib];
    if (self) {
        
    }
    return self;
}

- (id)loadFromNib
{
    NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"SharePopUpView" owner:nil options:nil];
    return [array objectAtIndex:0];
}


- (IBAction)shareTWBtnAction:(id)sender {
    [delegate shareTWButtonHasBeenPressed];
}

- (IBAction)shareFBBtnAction:(id)sender {
    [delegate shareFBButtonHasBeenPressed];
}

- (IBAction)closeBtnAction:(id)sender {
    [delegate closeSharePopUpViewButtonHasBeenPressed];
}
@end
