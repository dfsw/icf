//
//  ICFAppDelegate.m
//  ShoutOut
//
//  Created by Joe Keeley on 3/11/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import "ICFAppDelegate.h"

#import "ICFMainViewController.h"
#import "AFHTTPClient.h"

@implementation ICFAppDelegate

@synthesize window = _window;
@synthesize mainViewController = _mainViewController;
@synthesize pushToken;

- (void)dealloc
{
    [_window release];
    [_mainViewController release];
    [super dealloc];
}

//Notification received methods
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif 
{
    application.applicationIconBadgeNumber = 0;
    if ([application applicationState] == UIApplicationStateActive) {
        NSLog(@"Received local notification - app active");
    } else {
        NSLog(@"Received local notification - from background");
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo 
{
    application.applicationIconBadgeNumber = 0;
    if ([application applicationState] == UIApplicationStateActive) {
        NSLog(@"Received remote notification - app active");
    } else {
        NSLog(@"Received remote notification - from background");
    }
}

//Push Notification registration delegate methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken 
{
    //store token, which will be sent to our server after collecting user's name
    [self setPushToken:devToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err 
{
    NSLog(@"Error in registration. Error: %@", err);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.mainViewController = [[[ICFMainViewController alloc] initWithNibName:@"ICFMainViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //reset badge number when re-entering the app
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


@end
