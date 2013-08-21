//
//  ICFMainViewController.h
//  ShoutOut
//
//  Created by Joe Keeley on 3/11/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import "ICFFlipsideViewController.h"

@interface ICFMainViewController : UIViewController <ICFFlipsideViewControllerDelegate, UITextFieldDelegate>
{
    
    
}

@property (retain, nonatomic) IBOutlet UITextField *userNameTextField;
@property (retain, nonatomic) IBOutlet UIView *activityView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)showInfo:(id)sender;
- (IBAction)setReminder:(id)sender;

@end
