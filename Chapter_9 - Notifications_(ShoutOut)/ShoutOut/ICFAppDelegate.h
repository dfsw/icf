//
//  ICFAppDelegate.h
//  ShoutOut
//
//  Created by Joe Keeley on 3/11/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICFMainViewController;

@interface ICFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ICFMainViewController *mainViewController;
@property (retain, nonatomic) NSData *pushToken;

@end
