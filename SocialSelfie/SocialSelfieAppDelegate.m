//
//  SocialSelfieAppDelegate.m
//  SocialSelfie
//
//  Created by Saad Khan on 23/08/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "SocialSelfieAppDelegate.h"
#import "HomeViewController.h"
#import "MainLoginViewController.h"
#import "UtilsFunctions.h"
#import "Constants.h"
#import "AFNetworking.h"

@implementation SocialSelfieAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    if ([GetStringWithKey(kIsLoggedIn) isEqualToString:@"YES"]) {
        HomeViewController * homeVC=[[HomeViewController alloc]init];
        mainNavigationController=[[UINavigationController alloc]initWithRootViewController:homeVC];
    }
    else{
        MainLoginViewController * homeVC=[[MainLoginViewController alloc]init];
        mainNavigationController=[[UINavigationController alloc]initWithRootViewController:homeVC];
    }
    [mainNavigationController.navigationBar setHidden:YES];
    
	self.window.rootViewController = mainNavigationController;
    [self.window makeKeyAndVisible];
    
    // Let the device know we want to receive push notifications
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    return YES;
}

#pragma mark:UIApplication 
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    NSString* newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    SaveStringWithKey(newToken, kDeviceID);
    if (GetStringWithKey(kUserID) && [GetStringWithKey(kIsPushRegistered)isEqualToString:@"YES"]) {
       //Do nothing
    }
    else if(GetStringWithKey(kUserID)){
        [self updateDeviceTokenForPush];
    }
    NSLog(@"Push token is: %@", newToken);
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
 
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSString* alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    NSLog(@"Push Message:%@",alertValue);
    badgeCount++;
}
#pragma mark-Custom Methods
-(void)resetBadgeCount{
    badgeCount=0;
}
-(NSInteger)getBadgeCount{
    return badgeCount;
}
#pragma mark-Webservice
-(void)updateDeviceTokenForPush{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:kTaskRegisterDevice forKey:kTask];
    if (GetStringWithKey(kUserID)) {
        [params setObject:GetStringWithKey(kUserID) forKey:kUserID];
    }
    if (GetStringWithKey(kDeviceID)) {
        [params setObject:GetStringWithKey(kDeviceID) forKey:kDeviceID];
    }
    [params setObject:@"1" forKey:kDeviceType];
    
    [manager POST:kBaseURLUser parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject valueForKey:@"success"]boolValue]){
            SaveStringWithKey(kIsPushRegistered, @"YES");
        }
        else{
            SaveStringWithKey(kIsPushRegistered, @"NO");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end
