//
//  SharePopUpView.h
//  SocialSelfie
//
//  Created by Saad Khan on 04/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SharePopUpViewDelegate
-(void)shareFBButtonHasBeenPressed;
-(void)shareTWButtonHasBeenPressed;
-(void)closeSharePopUpViewButtonHasBeenPressed;
@end

@interface SharePopUpView : UIView

@property (weak, nonatomic) id<SharePopUpViewDelegate> delegate;
- (IBAction)shareTWBtnAction:(id)sender;
- (IBAction)shareFBBtnAction:(id)sender;
- (IBAction)closeBtnAction:(id)sender;

@end
