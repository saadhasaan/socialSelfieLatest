//
//  FriendReq.m
//  SocialSelfie
//
//  Created by Saad Khan on 15/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "FriendReq.h"

@implementation FriendReq
-(FriendReq*) initWithDictionary:(NSDictionary*)dict ANDIsReqRecieving:(BOOL)isRecvng
{
    self = [super init];
    if (![dict isKindOfClass:[NSDictionary class]])
    {
        return self;
    }
    if(self)
    {
        if([dict valueForKey:@"name"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"name"]])
            {
                self.reqUserName=[dict valueForKey:@"name"];
            }
        }
        if([dict valueForKey:@"profileImage"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"profileImage"]])
            {
                self.reqUserPicURL=[dict valueForKey:@"profileImage"];
            }
        }
        if([dict valueForKey:@"requestId"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"requestId"]])
            {
                self.reqID=[dict valueForKey:@"requestId"];
            }
        }
        if([dict valueForKey:@"status"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"status"]])
            {
                self.reqStatus=[[dict valueForKey:@"status"]integerValue];
            }
        }
        if([dict valueForKey:@"userId"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"userId"]])
            {
                self.reqUserID=[dict valueForKey:@"userId"];
            }
        }
        _isRecieved=isRecvng;
    }
    return self;
}
@end
