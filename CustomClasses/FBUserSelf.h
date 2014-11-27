//
//  FBUserSelf.h
//  SocialSelfie
//
//  Created by Saad Khan on 04/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface FBUserSelf : NSObject
@property (nonatomic, strong) NSString * fbiD;
@property (nonatomic, strong) NSString * dob;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * link;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * displayName;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * profileImageURL;

-(FBUserSelf*) initWithDictionary:(NSDictionary*)dict;
@end
