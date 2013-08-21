//
//  ICFMovieEditViewController.m
//  MyMovies
//
//  Created by Joe Keeley on 7/5/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import "ICFMovieEditViewController.h"

@interface ICFMovieEditViewController ()
@property (nonatomic, strong) ICFMovie *editMovie;

@end

@implementation ICFMovieEditViewController

- (void)configureView
{
    if (self.editMovieID) {
        
        ICFMovie *movie = (ICFMovie *)[kAppDelegate.managedObjectContext
                                  objectWithID:self.editMovieID];
        
        [self setEditMovie:movie];
        
        [self.movieTitle setText:[movie title]];
        [self.movieYearLabel setText:[movie year]];
        
        [self.movieDescription setText: [movie movieDescription]];
        
        BOOL movieLent = [[movie lent] boolValue];
        [self.sharedSwitch setOn:movieLent];
        
        if (movieLent)
        {
            NSManagedObject *friend = [movie lentToFriend];
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateStyle:NSDateFormatterMediumStyle];
            
            NSString *sharedDateText = 
            [df stringFromDate:[movie lentOn]];
            
            [self.sharedFriendLabel setText:
             [friend valueForKey:@"friendName"]];
            
            [self.sharedOnDateLabel setText:sharedDateText];
            [self.sharedFriendCell setHidden:NO];
            [self.sharedDateCell setHidden:NO];
        }
        else
        {
            [self.sharedFriendCell setHidden:YES];
            [self.sharedDateCell setHidden:YES];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 
- (IBAction)saveButtonTouched:(id)sender
{
    if ([self.sharedSwitch isOn] && !self.editMovie.lentToFriend) {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Select Friend"
                                   message:@"Please select friend you have shared movie with"
                                  delegate:nil
                         cancelButtonTitle:@"Dismiss"
                         otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *movieTitle = [self.movieTitle text];
    [self.editMovie setTitle:movieTitle];

    NSString *movieDesc = [self.movieDescription text];
    [self.editMovie setMovieDescription:movieDesc];

    BOOL sharedBool = [self.sharedSwitch isOn];
    NSNumber *shared = [NSNumber numberWithBool:sharedBool];
    [self.editMovie setLent:shared];
    
    NSError *saveError = nil;
    [kAppDelegate.managedObjectContext save:&saveError];
    if (saveError) {
        
        UIAlertView *alert =
         [[UIAlertView alloc]
            initWithTitle:@"Error saving movie"
                     message:[saveError localizedDescription]
                    delegate:nil
           cancelButtonTitle:@"Dismiss"
           otherButtonTitles:nil];
        
        [alert show];
    }
    else{
        NSLog(@"Changes to movie saved.");
    }
    
    [self.delegate movieChanged:self.editMovie];
    
    [self.navigationController.presentingViewController
     dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelButtonTouched:(id)sender
{
    if ([kAppDelegate.managedObjectContext hasChanges]) {
        [kAppDelegate.managedObjectContext rollback];
        NSLog(@"Rolled back changes.");
    }

    [self.navigationController.presentingViewController
     dismissModalViewControllerAnimated:YES];
}

- (IBAction)sharedSwitchChanged:(id)sender
{
    if ([self.sharedSwitch isOn])
    {
        [self.sharedFriendLabel setText:@"Please Select"];

        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateStyle:NSDateFormatterMediumStyle];
        
        NSString *sharedDateText =
        [df stringFromDate:[NSDate date]];
        
        [self.sharedOnDateLabel setText:sharedDateText];
        [self.editMovie setLentOn:[NSDate date]];
        
        [self.sharedFriendCell setHidden:NO];
        [self.sharedDateCell setHidden:NO];
    } else
    {
        [self.sharedFriendCell setHidden:YES];
        [self.editMovie setLentToFriend:nil];

        [self.sharedDateCell setHidden:YES];
        [self.editMovie setLentOn:nil];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"yearSelected"]) {
        ICFYearChooserViewController *mYVC = (ICFYearChooserViewController *)[segue destinationViewController];
        [mYVC setDelegate:self];
        [mYVC setSelectedYear:[self.editMovie year]];
    }
    if ([[segue identifier] isEqualToString:@"dateSelected"]) {
        ICFDateChooserViewController *mDVC = (ICFDateChooserViewController*)[segue destinationViewController];
        [mDVC setDelegate:self];
        NSDate *selDate = [self.editMovie lentOn];
        if (!selDate) {
            selDate = [NSDate date];
        }
        [mDVC setSelectedDate:selDate];
    }
    if ([[segue identifier] isEqualToString:@"friendSelected"]) {
        ICFFriendChooserViewController *mFVC = (ICFFriendChooserViewController *)[segue destinationViewController];
        [mFVC setTitle:@"Choose Friend"];
        [mFVC setDelegate:self];
        [mFVC setSelectedFriend:[self.editMovie lentToFriend]];
    }   
}

#pragma mark - ICFYearChooserDelegate
- (void)chooserSelectedYear:(NSString *)year
{
    [self.editMovie setYear:year];
    [self.movieYearLabel setText:year];
}

#pragma mark - ICFDateChooserDelegate
- (void)chooserSelectedDate:(NSDate *)date
{
    [self.editMovie setLentOn:date];

    NSDateFormatter *dateFormatter =
     [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];

    NSString *sharedDateText =
    [dateFormatter stringFromDate:[self.editMovie lentOn]];
        
    [self.sharedOnDateLabel setText:sharedDateText];
}

#pragma mark - ICFFriendChooserDelegate
- (void)chooserSelectedFriend:(NSManagedObject *)friend
{
    [self.editMovie setLentToFriend:friend];
    [self.sharedFriendLabel setText:[friend valueForKey:@"friendName"]];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end