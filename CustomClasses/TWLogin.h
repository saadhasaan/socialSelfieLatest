//
//  TWLogin.h
//  SocialSelfie
//
//  Created by Saad Khan on 04/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBUserSelf.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@protocol TWLoginDelegate
-(void)failedToFetchAnyTWAccount;
-(void)twProfileHasBeenFetchedSuccessfullyWithInfo:(FBUserSelf *)fbUser;
-(void)twProfileDidNotFetched;
@end

@interface TWLogin : NSObject

@property (weak, nonatomic) id<TWLoginDelegate> delegate;

@property (strong, nonatomic) ACAccountStore *accountStore;

-(void)fetchTWData;
@end
