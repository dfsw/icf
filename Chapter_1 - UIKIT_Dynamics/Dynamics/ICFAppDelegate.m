//
//  ICFAppDelegate.m
//  Dynamics
//
//  Created by Kyle Richter on 7/14/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import "ICFAppDelegate.h"

#import "ICFViewController.h"

@implementation ICFAppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.viewController = [[[ICFViewController alloc] initWithNibName:@"ICFViewController" bundle:nil] autorelease];
    navController = [[[UINavigationController alloc] initWithRootViewController:self.viewController] autorelease];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
