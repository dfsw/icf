//
//  ICFAppDelegate.h
//  TextKit
//
//  Created by Kyle Richter on 7/13/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICFViewController;

@interface ICFAppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navController;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ICFViewController *viewController;

@end
