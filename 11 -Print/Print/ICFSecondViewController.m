//
//  ICFSecondViewController.m
//  Print
//
//  Created by Kyle Richter on 4/2/12.
//  Copyright (c) 2012 Dragon Forged Software. All rights reserved.
//

#import "ICFSecondViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ICFSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Web Browser";
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [backButton setEnabled: [theWebView canGoBack]];
    [forwardButton setEnabled: [theWebView canGoForward]];
    
    [urlBarTextField becomeFirstResponder];
}



- (void)dealloc 
{
    [urlBarTextField release];
    [backButton release];
    [forwardButton release];
    [super dealloc];
}


- (void)viewDidUnload 
{
    [urlBarTextField release];
    urlBarTextField = nil;
    [backButton release];
    backButton = nil;
    [forwardButton release];
    forwardButton = nil;
    [super viewDidUnload];
}

- (IBAction)go:(id)sender
{
    NSString *urlString = [urlBarTextField text];
    
    //add http:// to string if user didnt type it
    if(![[urlString lowercaseString] hasPrefix:@"http://"])
    {
        urlString = [@"http://" stringByAppendingString: urlString];
    }
        
    NSURL *urlToLoad = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: urlToLoad];
    
    [theWebView loadRequest: request];
    
    [urlToLoad release];
    [request release];
    
    [urlBarTextField resignFirstResponder];

}

- (IBAction)print:(id)sender 
{
    /*
     IMPORTANT: There is a bug in the pre-released version of iOS 6 that prevents this from working, tracked up radar 11809539
     */
    
    UIPrintInteractionController *print = [UIPrintInteractionController sharedPrintController];
    print.delegate = self;
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Print for iOS";
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    print.printInfo = printInfo;
    print.showsPageRange = YES;
    
    
    NSURL *requestURL = [[theWebView request] URL];
    NSError *error = nil;
    
    NSString *contentHTML = [NSString stringWithContentsOfURL:requestURL 
                                              encoding:NSASCIIStringEncoding
                                                 error:&error];
    
    UIMarkupTextPrintFormatter *textFormatter = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText:contentHTML];
    textFormatter.startPage = 0;
    textFormatter.contentInsets = UIEdgeInsetsMake(36.0, 36.0, 36.0, 36.0); //half inch margins
    textFormatter.maximumContentWidth = 540;   // printed content should be 6-inches wide within those margins
    
    print.printFormatter = textFormatter;
    [textFormatter release];
    
    void (^completionHandler)(UIPrintInteractionController *,BOOL, NSError *) = ^(UIPrintInteractionController *print,BOOL completed, NSError *error)
    {
        if (!completed && error) 
        {
            NSLog(@"Error!");
        }
    };

    [print presentAnimated:YES completionHandler:completionHandler];
}


//Translates the screen image of a UIWebview into a PDF and prints it
- (IBAction)printPDF:(id)sender 
{
    UIPrintInteractionController *print = [UIPrintInteractionController sharedPrintController];
    print.delegate = self;
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Print for iOS";
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    print.printInfo = printInfo;
    print.showsPageRange = YES;
    
    UIGraphicsBeginImageContext(theWebView.bounds.size);
    [theWebView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    print.printingItem = image;
    
    void (^completionHandler)(UIPrintInteractionController *,BOOL, NSError *) = ^(UIPrintInteractionController *print,BOOL completed, NSError *error)
    {
        if (!completed && error) 
        {
            NSLog(@"Error!");
        }
    };
    
    [print presentAnimated:YES completionHandler:completionHandler];
}

#pragma mark - Webview Delegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription] 
                                                   delegate:nil 
                                          cancelButtonTitle:@"Dismiss" 
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [backButton setEnabled: [webView canGoBack]];
    [forwardButton setEnabled: [webView canGoForward]];
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
