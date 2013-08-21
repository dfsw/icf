//
//  ICFDynamicDetectionViewController.h
//  TextKit
//
//  Created by Kyle Richter on 7/13/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICFDynamicDetectionViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate>
{
    
    IBOutlet UITextView *textView;
    NSURL *toBeLaunchedURL;
    
}
@end
