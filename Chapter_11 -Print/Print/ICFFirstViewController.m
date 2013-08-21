//
//  ICFFirstViewController.m
//  Print
//
//  Created by Kyle Richter on 4/2/12.
//  Copyright (c) 2012 Dragon Forged Software. All rights reserved.
//

#import "ICFFirstViewController.h"

@implementation ICFFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.title = @"Text Editor";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc 
{
    [theTextView release];
    [super dealloc];
}


- (void)viewDidUnload 
{
    [theTextView release];
    theTextView = nil;
    [super viewDidUnload];
}

#pragma mark - Actions

- (IBAction)print:(id)sender 
{
    UIPrintInteractionController *print = [UIPrintInteractionController sharedPrintController];
    print.delegate = self;
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Print for iOS";
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    print.printInfo = printInfo;
    

    UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc] initWithText:[theTextView text]];
    textFormatter.startPage = 0;
    textFormatter.contentInsets = UIEdgeInsetsMake(36.0, 36.0, 36.0, 36.0); //half inch margins
    textFormatter.maximumContentWidth = 540;   // printed content should be 8-inches wide within those margins
   
    print.printFormatter = textFormatter;
    [textFormatter release];
    
    print.showsPageRange = YES;

    
    void (^completionHandler)(UIPrintInteractionController *,BOOL, NSError *) = ^(UIPrintInteractionController *print,BOOL completed, NSError *error)
    {
        if (!completed && error) 
        {
            NSLog(@"Error!");
        }
    };
    
    [print presentAnimated:YES completionHandler:completionHandler]; 
}

- (IBAction)hideKeyboard:(id)sender 
{
    [theTextView resignFirstResponder];
}

#pragma mark - Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations: @"resizeText" context:nil];
    [UIView setAnimationDuration: 0.3];
    CGRect frame = [theTextView frame]; 
    frame.size.height = 199;
    [theTextView setFrame: frame];
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations: @"resizeText" context:nil];
    [UIView setAnimationDuration: 0.3];
    CGRect frame = [theTextView frame]; 
    frame.size.height = 367;
    [theTextView setFrame: frame];
    [UIView commitAnimations];
    
}

#pragma mark - UIPrintInteractionControllerDelegate

- (void)printInteractionControllerWillPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController
{
    NSLog(@"Print Interaction Controller Will Present");
}

- (void)printInteractionControllerDidPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController
{
    NSLog(@"Print Interaction Controller Did Present");
}

- (void)printInteractionControllerWillDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController
{
    NSLog(@"Print Interaction Controller Will Dismiss");
}

- (void)printInteractionControllerDidDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController
{
    NSLog(@"Print Interaction Controller Did Dismiss");
}

- (void)printInteractionControllerWillStartJob:(UIPrintInteractionController *)printInteractionController
{
    NSLog(@"Print Interaction Controller Will Start Job");
}

- (void)printInteractionControllerDidFinishJob:(UIPrintInteractionController *)printInteractionController
{
    NSLog(@"Print Interaction Controller Did Finish Job");
}

@end
