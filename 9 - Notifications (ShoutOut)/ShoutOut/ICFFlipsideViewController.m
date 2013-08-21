//
//  ICFFlipsideViewController.m
//  ShoutOut
//
//  Created by Joe Keeley on 3/11/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import "ICFFlipsideViewController.h"
#import "AFHTTPClient.h"

@implementation ICFFlipsideViewController

@synthesize delegate = _delegate;
@synthesize shoutTextField;
@synthesize shoutsWebView;
@synthesize shoutName;
@synthesize activityView;
@synthesize activityIndicator;
@synthesize activityLabel;

#pragma mark - View lifecycle


- (void)viewDidUnload
{
    [self setShoutTextField:nil];
    [self setShoutsWebView:nil];
    [self setActivityView:nil];
    [self setActivityIndicator:nil];
    [self setActivityLabel:nil];
    [super viewDidUnload];
}


- (void)dealloc 
{
    [shoutTextField release];
    [shoutsWebView release];
    [activityView release];
    [activityIndicator release];
    [activityLabel release];
    [shoutName release], shoutName = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSURLRequest *shoutListURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kShoutOutServerURLString]];
    [self.shoutsWebView loadRequest:shoutListURLRequest];
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

#pragma mark - Text Field delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    
    if ([[textField text] length] > 0 ) 
    {
        //start activity indicator
        [self.activityView setHidden:NO];
        [self.activityIndicator startAnimating];
        
        //we have a message, set up post dictionary
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSMutableDictionary *postDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
        [postDictionary setObject:[textField text] forKey:@"shout[shout_message]"];
        [postDictionary setObject:[self shoutName] forKey:@"shout[name]"];
        [dateFormatter setDateFormat:@"yyyy"];
        [postDictionary setObject:[dateFormatter stringFromDate:today] forKey:@"shout[shout_date(1i)]"];
        [dateFormatter setDateFormat:@"MM"];
        [postDictionary setObject:[dateFormatter stringFromDate:today] forKey:@"shout[shout_date(2i)]"];
        [dateFormatter setDateFormat:@"d"];
        [postDictionary setObject:[dateFormatter stringFromDate:today] forKey:@"shout[shout_date(3i)]"];
        [dateFormatter release];
        
        //set up post request
        AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kShoutOutServerURLString]];
        
        [httpClient postPath:@"/shouts" 
                  parameters:postDictionary 
                     success:^(AFHTTPRequestOperation *operation, id responseObject) 
                    {

                        [self.activityView setHidden:YES];
                        [self.activityIndicator stopAnimating];

                        UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Shout Out" 
                                                                            message:@"Your Shout Out has been posted!" 
                                                                           delegate:nil 
                                                                  cancelButtonTitle:@"OK Thanks!" 
                                                                  otherButtonTitles:nil];
                        [successAlert show];
                        [successAlert release];

                        //reload the webview with existing shouts
                        NSURLRequest *shoutListURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kShoutOutServerURLString]];
                        [self.shoutsWebView loadRequest:shoutListURLRequest];

                     } 
         
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
                    {

                        [self.activityView setHidden:YES];
                        [self.activityIndicator stopAnimating];
                        UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle:@"Shout Out" 
                                                                            message:@"Your Shout Out has NOT been posted - ran into an error!" 
                                                                           delegate:nil 
                                                                  cancelButtonTitle:@"Ah Bummer!" 
                                                                  otherButtonTitles:nil];
                        [failureAlert show];
                        [failureAlert release];

        }];
    }
    
    
    return YES;
}

@end
