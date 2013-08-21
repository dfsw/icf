//
//  ICFSecondViewController.h
//  Print
//
//  Created by Kyle Richter on 4/2/12.
//  Copyright (c) 2012 Dragon Forged Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICFSecondViewController : UIViewController <UIWebViewDelegate, UIPrintInteractionControllerDelegate>
{
    
    IBOutlet UIWebView *theWebView;
    IBOutlet UITextField *urlBarTextField;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *forwardButton;
    
}
- (IBAction)go:(id)sender;

- (IBAction)print:(id)sender;
- (IBAction)printPDF:(id)sender;


@end
