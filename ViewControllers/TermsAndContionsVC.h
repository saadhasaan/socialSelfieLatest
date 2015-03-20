//
//  TermsAndContionsVC.h
//  SocialSelfie
//
//  Created by Globit on 18/02/2015.
//  Copyright (c) 2015 SocialSelfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsAndContionsVC : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)backBtnAction:(id)sender;
-(id)initWithUrl:(NSString*)link;
@end
