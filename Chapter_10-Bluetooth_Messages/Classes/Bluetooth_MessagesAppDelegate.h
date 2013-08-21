//
//  Bluetooth_MessagesAppDelegate.h
//  Bluetooth Messages
//
//  Created by Kyle Richter on 3/1/12.
//  Copyright 2012 Dragon Forged Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Bluetooth_MessagesAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

