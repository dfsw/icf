//
//  ICFAppDelegate.m
//  Print
//
//  Created by Kyle Richter on 4/2/12.
//  Copyright (c) 2012 Dragon Forged Software. All rights reserved.
//

#import "ICFAppDelegate.h"

#import "ICFFirstViewController.h"

#import "ICFSecondViewController.h"

@implementation ICFAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    UIViewController *viewController1 = [[[ICFFirstViewController alloc] initWithNibName:@"ICFFirstViewController" bundle:nil] autorelease];
    UIViewController *viewController2 = [[[ICFSecondViewController alloc] initWithNibName:@"ICFSecondViewController" bundle:nil] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
    
    
    
    if (![UIPrintInteractionController isPrintingAvailable]) 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"This device does not support printing!"
                                                            delegate:nil 
                                                   cancelButtonTitle:@"Dismiss"
                                                   otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}



@end
