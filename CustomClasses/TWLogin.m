//
//  TWLogin.m
//  SocialSelfie
//
//  Created by Saad Khan on 04/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "TWLogin.h"

@implementation TWLogin
@synthesize delegate;
-(id)init{
    self=[super init];
    if (self) {
        [self fetchTWData];
    }
    return self;
}

-(void)fetchTWData
{
    // Request access to the Twitter accounts
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            // Check if the users has setup at least one Twitter account
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                // Creating a request to get the info about a user on Twitter
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:twitterAccount.username forKey:@"screen_name"]];
                [twitterInfoRequest setAccount:twitterAccount];
                // Making the request
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Check if we reached the reate limit
                        if ([urlResponse statusCode] == 429) {
//                            ShowMessage(@"WiClan",@"Connecting Error");
                            [delegate twProfileDidNotFetched];
                            return;
                        }
                        // Check if there was an error
                        if (error) {
//                            ShowMessage(@"WiClan", error.localizedDescription);
                            [delegate twProfileDidNotFetched];
                            return;
                        }
                        // Check if there is some response data
                        if (responseData) {
                            NSError *error = nil;
                            NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            
                            NSString *name = [(NSDictionary *)TWData objectForKey:@"name"];

                            NSString *loc = [(NSDictionary *)TWData objectForKey:@"location"];

                            
                            NSString *profileImageStringURL = [(NSDictionary *)TWData objectForKey:@"profile_image_url_https"];
                            //                            self.myPic.imageURL=[NSURL URLWithString:profileImageStringURL];

                            
                        }

                    });
                }];
            }
            else{
                [delegate twProfileDidNotFetched];
            }
        } else {
            [delegate failedToFetchAnyTWAccount];
        }
    }];
    
}

@end
