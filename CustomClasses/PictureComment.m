//
//  PictureComment.m
//  SocialSelfie
//
//  Created by Saad Khan on 10/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "PictureComment.h"

@implementation PictureComment
-(PictureComment*) initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (![dict isKindOfClass:[NSDictionary class]])
    {
        return self;
    }
    if(self)
    {
        if([dict valueForKey:@"commentId"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"commentId"]])
            {
                self.commentID=[dict valueForKey:@"commentId"];
            }
        }
        if([dict valueForKey:@"comment"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"comment"]])
            {
                self.commenText = [dict valueForKey:@"comment"];
            }
        }
        if([dict valueForKey:@"createdDate"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"createdDate"]])
            {
                self.commentDate=[dict valueForKey:@"createdDate"];
            }
        }
        if([dict valueForKey:@"imageId"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"imageId"]])
            {
                self.imageID=[dict valueForKey:@"imageId"];
            }
        }
        if([dict valueForKey:@"name"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"name"]])
            {
                self.commentBy=[dict valueForKey:@"name"];
            }
        }
        if([dict valueForKey:@"profileImage"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"profileImage"]])
            {
                self.commentByImgURL=[dict valueForKey:@"profileImage"];
            }
        }
        if([dict valueForKey:@"userId"])
        {
            if(![[NSNull null]isEqual:[dict valueForKey:@"userId"]])
            {
                self.commentByUserID=[dict valueForKey:@"userId"];
            }
        }
    }
    return  self;
}
-(PictureComment*) initWithDictionaryWithCommentID:(NSString *)cmtID ANDCommentText:(NSString *)cmtText ANDCreatedDate:(NSString *)date ANDProfileImageID:(NSString *)imgID ANDUserName:(NSString *)usrname ANDProfileImageURL:(NSString *)url ANDUserID:(NSString *)userid
{
    self = [super init];
    if(self)
    {
        self.commentID=cmtID;
        self.commenText = cmtText;
        self.commentDate=date;
        self.imageID=imgID;
        self.commentBy=usrname;
        self.commentByImgURL=url;
        self.commentByUserID=userid;
    }
    return  self;
    
}


@end
