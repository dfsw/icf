//
//  ICFFlipsideViewController.h
//  ShoutOut
//
//  Created by Joe Keeley on 3/11/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICFFlipsideViewController;

@protocol ICFFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(ICFFlipsideViewController *)controller;
@end

@interface ICFFlipsideViewController : UIViewController <UITextFieldDelegate>
{
    
    
}

@property (assign, nonatomic) IBOutlet id <ICFFlipsideViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITextField *shoutTextField;
@property (retain, nonatomic) IBOutlet UIWebView *shoutsWebView;
@property (retain, nonatomic) NSString *shoutName;
@property (retain, nonatomic) IBOutlet UIView *activityView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UILabel *activityLabel;

- (IBAction)done:(id)sender;

@end
