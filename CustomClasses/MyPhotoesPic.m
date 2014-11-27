//
//  MyPhotoesPic.m
//  SocialSelfie
//
//  Created by Saad Khan on 09/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "MyPhotoesPic.h"

@implementation MyPhotoesPic
-(MyPhotoesPic*) initWithDictionary:(NSDictionary*)dict
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
        if([dict valueForKey:@"createdDate"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"createdDate"]])
            {
                self.createdDate=[dict valueForKey:@"createdDate"];
            }
        }
        if([dict valueForKey:@"totalComment"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"totalComment"]])
            {
                self.commentCount=[[dict valueForKey:@"totalComment"]integerValue];
            }
        }
        if([dict valueForKey:@"totalLike"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"totalLike"]])
            {
                self.likeCount=[[dict valueForKey:@"totalLike"]integerValue];
            }
        }
    }
    return  self;
}

@end
