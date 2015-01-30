//
//  FacebookManager.m
//  FacebookIntegration
//
//  Created by Sohaib Muhammad on 03/05/2013.
//  Copyright (c) 2013 coeus. All rights reserved.

//  Add the Facebook SDK for iOS Framework by dragging the FacebookSDK.framework folder from the SDK installation folder into the Frameworks section of your Project Navigator.
//  Add the Facebook SDK for iOS resource bundle by dragging the FacebookSDKResources.bundle file from the FacebookSDK.framework/Resources folder into the Frameworks section of your Project Navigator.
//  The SDK relies on five other frameworks and libraries (AdSupport, Accounts, libsqlite3, Security and Social) to use the Facebook features built into iOS6.
//  And if u want to support ios5 than make the above frameworks optional


#import "FacebookManager.h"
#import "FBUser.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FBPermssionConstants.h"
@interface FacebookManager()

@property (strong, nonatomic) FBUser* user;
@property (strong, nonatomic) NSArray *premissions;


@end
@implementation FacebookManager


+(FacebookManager *)sharedManager
{
    static FacebookManager* sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[FacebookManager alloc] init];
    });
    return sharedInstance;
}
-(void)permissions:(NSArray *)permissions{
    
    if (!self.premissions) {
        self.premissions = [[NSArray alloc] initWithArray:permissions];
    }
}
-(void)openSessionCompletionHandler:(OpenSessionCompletionHandler)handler{
    
    NSAssert(self.premissions, @"please set permsssion first before this function");
    
    
    

    
    [FBSession openActiveSessionWithReadPermissions:self.premissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
       
        [self sessionStateChanged:session state:status error:error];
        NSLog(@"App ID is %@",FBSession.activeSession.appID);
        
        if (!error) {
            handler(nil);
        }
        else
            handler( error);
        
    }];
    

    
}

-(void)postOnFacebookStatus:(NSMutableDictionary *)params WithCompletionHandler:(PostOnFacebookCompletionHandler)handler{
    
    
    
//    NSMutableDictionary* params1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                    @"Test Falcon Invite", @"title",
//                                    @"Come check out my app.",  @"message",
//                                    @"1671139061", @"to",
//                                    nil];
//    [FBWebDialogs presentRequestsDialogModallyWithSession:[FBSession activeSession]
//                                                  message:@"Check out this Falcon App"
//                                                    title:@"THIS IS A TITLE"
//                                               parameters:params1
//                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
//                                                      if (error) {
//                                                          // Case A: Error launching the dialog or sending request.
//                                                          NSLog(@"Error sending request.");
//                                                      } else {
//                                                          if (result == FBWebDialogResultDialogNotCompleted) {
//                                                              // Case B: User clicked the "x" icon
//                                                              NSLog(@"User canceled request.");
//                                                          } else {
//                                                              NSLog(@"Request Sent. %@", params);
//                                                          }
//                                                      }}];

    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // No permissions found in session, ask for it
        [FBSession.activeSession
         requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceEveryone
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 
                 [FBRequestConnection startWithGraphPath:@"me/feed"
                                              parameters:params
                                              HTTPMethod:@"POST"
                                       completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                           if (error)
                                           {
                                               handler(error);
                                           }
                                           else
                                           {
                                               handler(nil);
                                           }
                                           NSLog(@"the error while posting is %@",error);
                                           //verify result
                                       }];
             
                 
                 // If permissions granted, publish the story
             }
         }];}
    else
    {
    
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (error)
                              {
                                  handler(error);
                              }
                              else
                              {
                                  handler(nil);
                              }
                              NSLog(@"the error while posting is %@",error);
                              //verify result
                          }];
    }
    
   
}


-(void)postOnFacebookImage:(UIImage *)image WithCompletionHandler:(PostOnFacebookCompletionHandler) handler{
    
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForUploadPhoto:image] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             
             if (!error) {
                handler(nil); 
             }
             else
                 handler( error);
         }];
    }
    
}


-(void)postOnFacebookWithParameters:(NSDictionary *)parameters WithCompletionHandler:(PostOnFacebookCompletionHandler)handler{
    
    [[FBRequest requestWithGraphPath:@"me/photos"
                        parameters:parameters
                          HTTPMethod:@"POST"] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                                           NSDictionary<FBGraphUser> *user,
                                                                           NSError *error) {
        
        if (!error) {
            handler(nil);
        }
        else
            handler( error);
    }];
    
    
    
    
}
-(void)checkAvailablePermissions
{
    FBRequest *eventPostOK = [FBRequest requestWithGraphPath:@"me/permissions" parameters:Nil HTTPMethod:@"GET"];
    [eventPostOK startWithCompletionHandler: ^(FBRequestConnection *connection,
                                               NSDictionary* result,
                                               NSError *error) {
        BOOL canDoIt = FALSE;
        if (!error)
        {
            FBGraphObject *data = [result objectForKey:@"data"];
            for(NSDictionary<FBGraphObject> *aKey in data) {
                canDoIt = [[aKey objectForKey:@"create_event"] boolValue];
            }
        }
        else
            NSLog(@"%@", error);
        
        NSLog(@"%@", canDoIt ? @"I can create Events" : @"I can't create Events");
    }];
}
-(void)requestWithGraphPath:(NSString *)key andParams:(NSMutableDictionary *)params WithCompletionHandler:(PlacesHandler)handler
{
    [[FBRequest requestWithGraphPath:key parameters:params HTTPMethod:@"GET"] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                                                                           NSMutableDictionary *result,
                                                                                                           NSError *error) {
        NSLog(@"%s    %@",__FUNCTION__,error);
        NSLog(@"The Results are %@",result);
        if (error == nil)
        {
            handler(result,nil);
        }
        else
        {
            handler(nil,error);
        }
    }];
    
//http://graph.facebook.com/252380098232346/picture
    
}

-(void)postChekIn:(NSMutableDictionary *)params withCompletionHandler:(CheckinHandler)handler
{
//    [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error)
//     {
//     if (error)
//     {
//         NSLog(@"Error during permisions");
//     }
//     
//     
//     }];
    
    
    
    
        
    
//    [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
//     
//                                          defaultAudience:FBSessionDefaultAudienceEveryone
//                                        completionHandler:^(FBSession *session, NSError *error){}];
    
//    [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//        
//        [self sessionStateChanged:session state:status error:error];
//        NSLog(@"App ID is %@",FBSession.activeSession.appID);
//        
//        if (!error) {
//                   }
//       
//           
//        
//    }];
    
    
//    [[FBRequest requestWithGraphPath:@"/me/checkins" parameters:params HTTPMethod:@"POST"] startWithCompletionHandler:^(FBRequestConnection *connection,
//                                                                                                           id result,
//                                                                                                           NSError *error) {
//        NSLog(@"%s    %@",__FUNCTION__,error);
//        NSLog(@"The Results are %@",result);
    
//    }];
    
    
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error )
                              {
                                  handler(nil,nil);
                              }
                              else
                              {
                                  handler(nil,error);
                              }
                              NSLog(@"the error while posting is %@",error);
                              //verify result
                          }];

}

-(void)getPostPermissionWithCompletionHandler:(PublishHandler)handler
{
    
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // No permissions found in session, ask for it
        [FBSession.activeSession
         requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceEveryone
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 handler(nil,nil);
             }
             else
             {
                 handler(nil,error);
                 
                 // If permissions granted, publish the story
             }
         }];}
    else
    {
        handler(nil,nil);
    }

    
}

- (void)action:(NSDictionary *)data params:(NSMutableDictionary *)params {
    // Facebook SDK * error handling *
    // if the operation is not user cancelled
    NSString *status = [data objectForKey:@"status"];
    NSString *title = [data objectForKey:@"title"];
    //  UIImage *image = [data objectForKey:@"photo"];
    
    [params setObject:status forKey:@"description"];
    [params setObject:@"http://5hands.com.au/" forKey:@"link"];
    [params setObject:title forKey:@"name"];
    
    
    
    //  [params setObject:@"100001256527379" forKey:@"tags"];
    
    // [params setObject:[NSString stringWithFormat:NSLocalizedString(@"justFinished", nil),title] forKey:@"name"];
    //NSLog(@"selectedplace is %@",mSelectedPlace.id);
    
    NSString *apiPath = nil;
    
    NSMutableArray *imgTags=[NSMutableArray array];
    NSMutableArray *statusTags = [NSMutableArray array];
    
//    for (NSDictionary *user in mSelectedFriends) {
//        
//        NSLog(@"^^^^^^^^^%@^^^^^^^",[user objectForKey:@"id"]);
//        
//        [statusTags addObject:user[@"id"]];
//        [imgTags addObject:@{@"tag_uid":user[@"id"]}];
//    }
    
    
    id<FBGraphObject> action = [FBGraphObject graphObject];
    //    [NSArray arrayWithObjects:@"1712242652",@"100001256527379", nil];
    NSString *friendIds=[statusTags componentsJoinedByString:@","];
    [action setObject:@"100001256527379" forKey:@"tags"];
    //    NSString *access_token = [_fbSession accessToken];
    //    [params setObject:access_token forKey:@"access_token"];
    [params setObject:@"644662765550744" forKey:@"place"];
   
    
      
        apiPath = @"me/testified_example:tagging";
  
    //NSString *access_token = [FBSession accessToken];
 //   [action setObject:access_token forKey:@"access_token"];
    [action setObject:@"644662765550744" forKey:@"place"];
    FBRequest *actionRequest = [FBRequest requestForPostWithGraphPath:apiPath
                                                          graphObject:action];
    
    FBRequestConnection *requestConnection = [[FBRequestConnection alloc] init];
    [requestConnection addRequest:actionRequest
                completionHandler:^(FBRequestConnection *connection,
                                    id result,
                                    NSError *error) {
                    NSLog(@"%s    %@",__FUNCTION__,error);
                    
//                    [self showAlert:NSLocalizedString(@"showAlert", nil) result:result error:error];
//                    if (_delegate != nil) {
//                        
//                        [_delegate faceboookConnectSuccess:self requestType:FBRequestTypePostOnFriendWall];
//                    }
//                    
                    
                    
                }];
    [requestConnection start];
    
    //    if (mSelectedPlace != nil) {
    //
    //        [params setObject:mSelectedPlace.id forKey:@"place"];
    //
    //    }
    
    //  [NSString stringWithFormat:@"%@/feed",@"100001256527379"];
    
    //  FBRequest *request = [[[FBRequest alloc] initWithSession:_fbSession graphPath:apiPath parameters:params HTTPMethod:@"POST"] autorelease];
    
    
    //   FBRequest *actionRequest = [FBRequest requestForPostWithGraphPath:@"me/feed"
    //                                                       graphObject:action];
    
    //    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    //
    //        NSLog(@"%s    %@",__FUNCTION__,error);
    //
    //        // [self showAlert:NSLocalizedString(@"showAlert", nil) result:result error:error];
    //        if (_delegate != nil) {
    //
    //            [_delegate faceboookConnectSuccess:self requestType:FBRequestTypePostOnFriendWall];
    //        }
    //        
    //        
    //    }];
}





-(void)closeSession{
    
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];

}

- (void)populateUserDetailsWithCompletionHandler:(GetUserDetailsCompletionHandler)handler
{
    if (!self.user) {
        self.user = [[FBUser alloc] init];
    }
    
    
    if (FBSession.activeSession.isOpen) {
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             
             if (!error) {
                 
                 
                 
                 
                 self.user.name = user.name;
                 self.user.fId = user.id;
                 self.user.firstName = user.first_name;
                 self.user.lastName = user.last_name;
                 self.user.birthday = user.birthday;
                 self.user.imgUrl = [self profilePicture];
                 self.user.email = [user objectForKey:@"email"];
                 self.user.userName = user.username;
                 handler(self.user, nil);
                 
                 
                 
             }
            else
                handler(nil, error);
         }];
    }
}


-(NSString *)getName
{
    return self.user.name;
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
            
        case FBSessionStateOpen:
            
            break;
        case FBSessionStateClosed:
            
        case FBSessionStateClosedLoginFailed:
                        
            [FBSession.activeSession closeAndClearTokenInformation];
            
           
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }    
}

-(NSString *)profilePicture{

    NSString *imgUrl = nil;
    
    imgUrl  = [NSString stringWithFormat:@ "http://graph.facebook.com/%@/picture?type=large",self.user.fId];
    
    return imgUrl;
    
}

-(void)getListOfFriendsUsingAppWithCompletionHandler:(FriendsUsingAppHandler)handler
{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:@"name, picture, installed" forKey:@"fields"];
//    FBRequest* friendsRequest = [FBRequest requestWithGraphPath:@"me/friends?fields=installed" parameters:dict HTTPMethod:@"GET"];
//    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
//                                                  NSDictionary* result,
//                                                  NSError *error) {
//        NSArray* friends = [result objectForKey:@"data"];
//        NSLog(@"Found: %i friends", friends.count);
//        for (NSDictionary<FBGraphUser>* friend in friends) {
//            NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
//            
//        }}];
    
    
//    NSString *query = @"SELECT uid FROM userWHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = ?)AND is_app_user = 1";
    
    FBRequest* friendsRequest = [FBRequest requestWithGraphPath:@"me/friends" parameters:@{@"fields":@"name,picture,installed,first_name"} HTTPMethod:@"GET"];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        
        if (error) {
                        handler(nil,error);
                    } else {
        
        NSArray* friends = [result objectForKey:@"data"];
        
        NSMutableArray *installedFriends = [[NSMutableArray alloc] init];
        
        for (NSDictionary<FBGraphUser>* friend in friends)
        {
            if ([[friend objectForKey:@"installed"] boolValue])
            {
                [installedFriends addObject:friend];
            }
        }
        
                                 handler(installedFriends,nil);
                    }}];
        
    
    
    
//    NSString *query = [NSString stringWithFormat:@"Select name, uid, pic_square from user where is_app_user = 1 and uid in (select uid2 from friend where uid1 = %@) order by concat(first_name,last_name) asc", self.user.fId];
//    
//    // Set up the query parameter
//    NSDictionary *queryParam =
//    [NSDictionary dictionaryWithObjectsAndKeys:query, @"q", nil];
//    // Make the API request that uses FQL
//    [FBRequestConnection startWithGraphPath:@"/fql"
//                                 parameters:queryParam
//                                 HTTPMethod:@"GET"
//                          completionHandler:^(FBRequestConnection *connection,
//                                              id result,
//                                              NSError *error) {
//                              if (error) {
//                                  handler(nil,error);
//                              } else {
//                                  handler(result,nil);
//                              }
//                          }];

    
}
-(BOOL)checkIfTheUserLoggedIn
{
    if (FBSession.activeSession.isOpen)
    {
        return YES;
    }
//     if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
//     {
//         return YES;
//     }
    return NO;
}
@end
