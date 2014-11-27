//
//  PictureComment.h
//  SocialSelfie
//
//  Created by Saad Khan on 10/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureComment : NSObject
@property (nonatomic, strong) NSString * commentID;
@property (nonatomic, strong) NSString * commenText;
@property (nonatomic, strong) NSString * commentDate;
@property (nonatomic, strong) NSString * imageID;
@property (nonatomic, strong) NSString * commentBy;
@property (nonatomic, strong) NSString * commentByImgURL;
@property (nonatomic, strong) NSString * commentByUserID;

-(PictureComment *) initWithDictionary:(NSDictionary*)dict;
-(PictureComment*) initWithDictionaryWithCommentID:(NSString *)cmtID ANDCommentText:(NSString *)cmtText ANDCreatedDate:(NSString *)date ANDProfileImageID:(NSString *)imgID ANDUserName:(NSString *)usrname ANDProfileImageURL:(NSString *)url ANDUserID:(NSString *)userid;
@end
