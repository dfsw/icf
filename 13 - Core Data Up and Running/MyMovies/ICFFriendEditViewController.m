//
//  ICFFriendEditViewController.m
//  MyMovies
//
//  Created by Joe Keeley on 7/9/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import "ICFFriendEditViewController.h"

@interface ICFFriendEditViewController ()
@property (nonatomic, strong) NSManagedObject *editFriend;
@end

@implementation ICFFriendEditViewController

- (void)configureView
{
    if (self.editFriendID) {
        
        NSManagedObject *friend = [kAppDelegate.managedObjectContext
                                  objectWithID:self.editFriendID];
        
        [self setEditFriend:friend];
        
        [self.friendName setText:[friend valueForKey:@"friendName"]];
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

- (IBAction)saveButtonTouched:(id)sender
{
    NSString *fName = [self.friendName text];
    [self.editFriend setValue:fName forKey:@"friendName"];

    NSError *saveError = nil;
    [kAppDelegate.managedObjectContext save:&saveError];
    if (saveError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error saving friend" message:[saveError localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    else{
        NSLog(@"Changes to friend saved.");
    }
    
    if (self.navigationController.presentingViewController)
    {
        [self.navigationController.presentingViewController dismissModalViewControllerAnimated:YES];
    } else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (IBAction)cancelButtonTouched:(id)sender
{
    if ([kAppDelegate.managedObjectContext hasChanges]) {
        [kAppDelegate.managedObjectContext rollback];
        NSLog(@"Rolled back changes.");
    }
    if (self.navigationController.presentingViewController)
    {
        [self.navigationController.presentingViewController dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];        
    }
 
}

@end
