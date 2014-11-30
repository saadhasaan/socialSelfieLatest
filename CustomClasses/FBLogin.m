//
//  FBLogin.m
//  SocialSelfie
//
//  Created by Saad Khan on 04/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "FBLogin.h"


@implementation FBLogin
@synthesize delegate;
-(id)initWithKey:(NSString *)accountKey{
    self=[super init];
    if (self) {
        fbAccountkey=accountKey;
        [self facebookAccountInit];
    }
    return self;
}
-(void)facebookAccountInit
{
    if (!self.accountStore) {
        self.accountStore = [[ACAccountStore alloc]init];
    }
    ACAccountType *FBaccountType= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:fbAccountkey,ACFacebookAppIdKey,@[@"email"],ACFacebookPermissionsKey, nil];
    
    [self.accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
     ^(BOOL granted, NSError *e) {
         if (granted)
         {
             NSArray *accounts = [self.accountStore accountsWithAccountType:FBaccountType];
             //it will always be the last object with single sign on
             self.facebookAccount = [accounts lastObject];
             ACAccountCredential *facebookCredential = [self.facebookAccount credential];
             NSString *accessToken = [facebookCredential oauthToken];
             NSLog(@"Facebook Access Token: %@", accessToken);
             NSLog(@"facebook account =%@",self.facebookAccount);
             [self performSelectorOnMainThread:@selector(getMyFBInfo) withObject:nil waitUntilDone:NO];
             //             [self getMyFBInfo];
         }
         else
         {
             NSLog(@"Please enable facebook from setting.");
             [self performSelectorOnMainThread:@selector(callDelegateFailedToFetchAnyAccount) withObject:nil waitUntilDone:NO];
         }
     }];
}
-(void)callDelegateFailedToFetchAnyAccount{
    [delegate failedToFetchAnyAccount];
}
-(void)callDelegateProfileHasBeenFetchedSuccessfullyWithInfo:(FBUserSelf *)fbUser{
    [delegate fbProfileHasBeenFetchedSuccessfullyWithInfo:fbUser];
}
-(void)callDelegatefbProfileDidNotFetched{
    [delegate fbProfileDidNotFetched];
}
-(void)getMyFBInfo
{
    
    NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:requestURL parameters:nil];
    NSLog(@"%@",request);
    request.account = self.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
        
        if(!error)
        {
            NSDictionary *list =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            FBUserSelf * fbUser=[[FBUserSelf alloc]initWithDictionary:list];
            [self performSelectorOnMainThread:@selector(callDelegateProfileHasBeenFetchedSuccessfullyWithInfo:) withObject:fbUser waitUntilDone:NO];
        }
        else
        {
            NSLog(@"error from get%@",error);
            [self performSelectorOnMainThread:@selector(callDelegatefbProfileDidNotFetched) withObject:nil waitUntilDone:NO];
        }
        
    }];
}

@end
