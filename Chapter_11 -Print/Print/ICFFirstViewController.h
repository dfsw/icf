//
//  ICFFirstViewController.h
//  Print
//
//  Created by Kyle Richter on 4/2/12.
//  Copyright (c) 2012 Dragon Forged Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICFFirstViewController : UIViewController <UITextViewDelegate, UIPrintInteractionControllerDelegate>
{
    
    IBOutlet UITextView *theTextView;
    
    
}
- (IBAction)print:(id)sender;
- (IBAction)hideKeyboard:(id)sender;


@end
