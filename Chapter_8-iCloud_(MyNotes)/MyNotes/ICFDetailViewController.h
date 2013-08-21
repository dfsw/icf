//
//  ICFDetailViewController.h
//  MyNotes
//
//  Created by Joe Keeley on 10/24/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICFMyNoteDocument.h"
#import "ICFConflictResolutionViewController.h"

@interface ICFDetailViewController : UIViewController <ICFMyNoteDocumentDelegate, ICFMyNoteConflictDelegate>

@property (strong, nonatomic) NSURL *myNoteURL;

@property (weak, nonatomic) IBOutlet UITextView *myNoteTextView;
@property (weak, nonatomic) IBOutlet UIButton *conflictButton;

- (IBAction)resolveConflictTapped:(id)sender;

@end

