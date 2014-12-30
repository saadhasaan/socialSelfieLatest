//
//  GellaryPicture.h
//  SocialSelfie
//
//  Created by Saad Khan on 09/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GellaryPicture : NSObject
@property (nonatomic, strong) NSString * imageID;
@property (nonatomic, strong) NSString * imageURL;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * userProfileImageURL;
@property (nonatomic) NSInteger likeCount;
@property (nonatomic, strong) NSString * userID;
@property (nonatomic) BOOL isLikedByMe;

-(GellaryPicture *) initWithDictionary:(NSDictionary*)dict;
-(GellaryPicture *) initWithImageID:(NSString *)imgID;

@end
