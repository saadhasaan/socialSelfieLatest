//
//  FacebookManager.h
//  FacebookIntegration
//
//  Created by Sohaib Muhammad on 03/05/2013.
//  Copyright (c) 2013 coeus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  FBUser;

typedef void(^GetUserDetailsCompletionHandler) (FBUser* user, NSError* error);
typedef void(^PostOnFacebookCompletionHandler) (NSError* error);
typedef void(^PlacesHandler) (NSMutableDictionary *results, NSError* error);
typedef void(^CheckinHandler) (id results, NSError* error);
typedef void(^FriendsUsingAppHandler) (id results, NSError* error);
typedef void(^PublishHandler) (id results, NSError* error);
typedef void(^OpenSessionCompletionHandler) (NSError* error);
@interface FacebookManager : NSObject
+(FacebookManager *)sharedManager;
-(void)permissions:(NSArray *)permissions;  // setPermissions
-(void)openSessionCompletionHandler:(OpenSessionCompletionHandler)handler;   //openSession
-(void)closeSession;    //closeSession

-(void)postChekIn:(NSMutableDictionary *)params withCompletionHandler:(CheckinHandler)handler;
// get user details
-(void)populateUserDetailsWithCompletionHandler:(GetUserDetailsCompletionHandler)handler;
-(NSString *)getName;
// post status on facebook only
-(void)getPostPermissionWithCompletionHandler:(PublishHandler)handler;
-(void)postOnFacebookStatus:(NSMutableDictionary *)params WithCompletionHandler:(PostOnFacebookCompletionHandler)handler;
-(void)getListOfFriendsUsingAppWithCompletionHandler:(FriendsUsingAppHandler)handler;
// upload image on facebook only
-(void)checkAvailablePermissions;
-(void)requestWithGraphPath:(NSString *)key andParams:(NSMutableDictionary *)params WithCompletionHandler:(PlacesHandler)handler;
-(void)postOnFacebookWithParameters:(NSDictionary *)parameters WithCompletionHandler:(PostOnFacebookCompletionHandler)handler;
-(NSString *)profilePicture;
-(void)tagFriendsWithParams:(NSDictionary *)dict;
-(BOOL)checkIfTheUserLoggedIn;
@end
