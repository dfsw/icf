//
//  ICFConflictVersionViewController.m
//  MyNotes
//
//  Created by Joe Keeley on 10/28/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import "ICFConflictVersionViewController.h"
#import "ICFMyNoteDocument.h"

@interface ICFConflictVersionViewController ()

@end

@implementation ICFConflictVersionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    NSString *dateString =
    [dateFormatter stringFromDate:
     [self.fileVersion modificationDate]];

    [self.versionLabel setText:[self.fileVersion localizedName]];
    [self.versionDate setText:dateString];

    [self.versionComputer setText:
    [self.fileVersion localizedNameOfSavingComputer]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectVersionTouched:(id)sender
{
    [self.delegate conflictVersionSelected:self.fileVersion];
}


@end
