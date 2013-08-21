//
//  ICFDynamicDetectionViewController.m
//  TextKit
//
//  Created by Kyle Richter on 7/13/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import "ICFDynamicDetectionViewController.h"

@interface ICFDynamicDetectionViewController ()

@end

@implementation ICFDynamicDetectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [textView setDataDetectorTypes: UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink | UIDataDetectorTypeAddress | UIDataDetectorTypeCalendarEvent];
    [textView setText:@"Website: http://www.pearsoned.com\nPhone: (310) 597-3781\nAddress: 1 infinite loop cupertino ca 95014\nWhen: July 15th at 7pm PST"];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    toBeLaunchedURL = URL;
    
    if([[URL absoluteString] hasPrefix:@"http://"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URL Launching" message:[NSString stringWithFormat:@"About to launch %@", [URL absoluteString]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Launch", nil];
        [alert show];
        [alert release];
        
        return NO;
    }
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
        return;
    else
        [[UIApplication sharedApplication] openURL:toBeLaunchedURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [textView release];
    [super dealloc];
}

@end
