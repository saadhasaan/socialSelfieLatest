//
//  GellaryPicture.m
//  SocialSelfie
//
//  Created by Saad Khan on 09/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "GellaryPicture.h"

@implementation GellaryPicture
-(GellaryPicture*) initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (![dict isKindOfClass:[NSDictionary class]])
    {
        return self;
    }
    if(self)
    {
        if([dict valueForKey:@"imageId"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"imageId"]])
            {
                self.imageID=[dict valueForKey:@"imageId"];
            }
        }
        if([dict valueForKey:@"imageName"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"imageName"]])
            {
                self.imageURL = [dict valueForKey:@"imageName"];
            }
        }
        if([dict valueForKey:@"name"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"name"]])
            {
                self.userName=[dict valueForKey:@"name"];
            }
        }
        if([dict valueForKey:@"profileImage"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"profileImage"]])
            {
                self.userProfileImageURL=[dict valueForKey:@"profileImage"];
            }
        }
        if([dict valueForKey:@"totalLike"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"totalLike"]])
            {
                self.likeCount=[[dict valueForKey:@"totalLike"]integerValue];
            }
        }
        if([dict valueForKey:@"userId"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"userId"]])
            {
                self.userID=[dict valueForKey:@"userId"];
            }
        }
    }
    return  self;
}
-(GellaryPicture *) initWithImageID:(NSString *)imgID{
    self = [super init];
    if (self) {
        self.imageID=imgID;
    }
    return self;
}
@end
