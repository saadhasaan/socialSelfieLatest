//
//  FriendReq.h
//  SocialSelfie
//
//  Created by Saad Khan on 15/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendReq : NSObject

@property (nonatomic, strong) NSString * reqID;
@property (nonatomic, strong) NSString * reqUserName;
@property (nonatomic, strong) NSString * reqUserPicURL;
@property (nonatomic, strong) NSString * reqStatus;
@property (nonatomic, strong) NSString * reqUserID;
@property (nonatomic) BOOL isRecieved;

-(FriendReq*) initWithDictionary:(NSDictionary*)dict ANDIsReqRecieving:(BOOL)isRecvng;
@end
