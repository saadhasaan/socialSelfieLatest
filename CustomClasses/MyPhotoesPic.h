//
//  MyPhotoesPic.h
//  SocialSelfie
//
//  Created by Saad Khan on 09/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPhotoesPic : NSObject

@property (nonatomic, strong) NSString * imageID;
@property (nonatomic, strong) NSString * createdDate;
@property (nonatomic, strong) NSString * imageURL;
@property (nonatomic) NSInteger hoursFromPosted;
@property (nonatomic) NSInteger likeCount;
@property (nonatomic) NSInteger commentCount;

-(MyPhotoesPic *) initWithDictionary:(NSDictionary*)dict;

@end
