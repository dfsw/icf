//
//  AddressBookAppDelegate.m
//  AddressBook
//
//  Created by Kyle Richter on 2/27/12.
//  Copyright 2012 Dragon Forged Software. All rights reserved.
//

#import "AddressBookAppDelegate.h"
#import "RootViewController.h"


@implementation AddressBookAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    // Set the navigation controller as the window's root view controller and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

