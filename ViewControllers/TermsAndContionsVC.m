//
//  TermsAndContionsVC.m
//  SocialSelfie
//
//  Created by Globit on 18/02/2015.
//  Copyright (c) 2015 SocialSelfie. All rights reserved.
//

#import "TermsAndContionsVC.h"
#import "MBProgressHUD.h"
#import "UtilsFunctions.h"

@interface TermsAndContionsVC ()
{
        NSString * urlString;
}
@end

@implementation TermsAndContionsVC
-(id)initWithUrl:(NSString*)link{
    self = [super initWithNibName:@"TermsAndContionsVC" bundle:nil];
    if (self) {
        urlString=[[NSString alloc]initWithString:link];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (urlString) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
        self.webView.delegate=self;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark:UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    ShowMessage(@"Failure", error.description);
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
