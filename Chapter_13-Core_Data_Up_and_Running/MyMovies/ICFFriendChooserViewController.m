//
//  ICFFriendChooserViewController.m
//  MyMovies
//
//  Created by Joe Keeley on 7/7/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import "ICFFriendChooserViewController.h"

@interface ICFFriendChooserViewController ()

@end

@implementation ICFFriendChooserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSManagedObjectContext *moc = kAppDelegate.managedObjectContext;

    NSFetchRequest *fetchReq = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity =
     [NSEntityDescription entityForName:@"Friend"
                 inManagedObjectContext:moc];

    [fetchReq setEntity:entity];
    
    NSSortDescriptor *sortDescriptor =
     [[NSSortDescriptor alloc] initWithKey:@"friendName"
                                ascending:YES];

    NSArray *sortDescriptors =
     [NSArray arrayWithObjects:sortDescriptor, nil];

    [fetchReq setSortDescriptors:sortDescriptors];
    
NSError *error = nil;

self.friendList = [moc executeFetchRequest:fetchReq
                                     error:&error];

if (error)
{
    NSString *errorDesc =
     [error localizedDescription];
    
    UIAlertView *alert =
     [[UIAlertView alloc] initWithTitle:@"Error fetching friends"
                                message:errorDesc
                               delegate:nil
                      cancelButtonTitle:@"Dismiss"
                      otherButtonTitles:nil];
    [alert show];
}
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friendList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSManagedObject *friend = [self.friendList objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[friend valueForKey:@"FriendName"]];
    
    if (friend == self.selectedFriend) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *visibleIndexPaths = [tableView indexPathsForVisibleRows];
    for (NSIndexPath *ip in visibleIndexPaths) {
        UITableViewCell *clearCell = [tableView cellForRowAtIndexPath:ip];
        [clearCell setAccessoryType:UITableViewCellAccessoryNone];
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    

    [self.delegate chooserSelectedFriend:[self.friendList objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
