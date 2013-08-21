//
//  ICFMainViewController.m
//  ShoutOut
//
//  Created by Joe Keeley on 3/11/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import "ICFMainViewController.h"
#import "ICFAppDelegate.h"
#import "AFHTTPClient.h"

@implementation ICFMainViewController
@synthesize userNameTextField;
@synthesize activityView;
@synthesize activityIndicator;


#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [self setUserNameTextField:nil];
    [self setActivityView:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (void)dealloc 
{
    [userNameTextField release];
    [activityView release];
    [activityIndicator release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(ICFFlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{    
    if ([[userNameTextField text] length] > 0) 
    {
        //display activityView and animate indicator
        [activityView setHidden:NO];
        [activityIndicator startAnimating];
        
        //first call server with name & token
        ICFAppDelegate *appDelegate = (ICFAppDelegate *)[[UIApplication sharedApplication] delegate];
        
NSDictionary *postDictionary =
@{@"device[token]":[appDelegate pushToken],
  @"device[name]":[userNameTextField text]};
        
        AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kShoutOutServerURLString]];
       
        [httpClient postPath:@"/devices" 
                  parameters:postDictionary 
                     success:^(AFHTTPRequestOperation *operation, id responseObject) 
                    {
                        //now go to shout screen
                        ICFFlipsideViewController *controller = [[[ICFFlipsideViewController alloc] initWithNibName:@"ICFFlipsideViewController" bundle:nil] autorelease];
                        [controller setDelegate:self];
                        [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                        [controller setShoutName:[self.userNameTextField text]];
                        
                        [self presentViewController:controller
                                           animated:YES
                                         completion:nil];
                        
                        NSLog(@"Device has been successfully logged on server");                     
                         
                        [activityView setHidden:YES];
                        [activityIndicator stopAnimating];
                     } 
         
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
                    {
                         NSLog(@"Device setup on server failed: %@",error);
                        
                         [activityView setHidden:YES];
                         [activityIndicator stopAnimating];
                     }];

        
    } 
    
    else 
    {
        UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Shout Out" 
                                                               message:@"Please enter your name" 
                                                              delegate:nil 
                                                     cancelButtonTitle:@"OK Will Do!" 
                                                     otherButtonTitles:nil];
        [successAlert show];
        [successAlert release];
    }
}

- (IBAction)setReminder:(id)sender 
{
    NSDate *now = [NSDate date];
    UILocalNotification *reminderNotification = [[UILocalNotification alloc] init];
    
    //when notification should fire
    [reminderNotification setFireDate:[now dateByAddingTimeInterval:60]];
    [reminderNotification setTimeZone:[NSTimeZone defaultTimeZone]];
    
    //what notification should look like
    [reminderNotification setAlertBody:@"Don't forget to Shout Out!"];
    [reminderNotification setAlertAction:@"Shout Now"];
    [reminderNotification setSoundName:UILocalNotificationDefaultSoundName];
    [reminderNotification setApplicationIconBadgeNumber:1];
    
    //schedule notification
    [[UIApplication sharedApplication] scheduleLocalNotification:reminderNotification];
    [reminderNotification release];    
    
    UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Reminder" 
                                                           message:@"Your Reminder has been Scheduled" 
                                                          delegate:nil 
                                                 cancelButtonTitle:@"OK Thanks!" 
                                                 otherButtonTitles:nil];
    [successAlert show];
    [successAlert release];
}

#pragma mark - Text Field delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return YES;
}


@end
