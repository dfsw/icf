//
//  ICFMovieListViewController.m
//  MyMovies
//
//  Created by Joe Keeley on 7/2/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import "ICFMovieListViewController.h"
#import "ICFMovieDisplayViewController.h"
#import "ICFMovie.h"

@interface ICFMovieListViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation ICFMovieListViewController

@synthesize fetchedResultsController = __fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo =
     [[self.fetchedResultsController sections]
      objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView
 titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo =
     [[self.fetchedResultsController sections]
      objectAtIndex:section];

    if ([[sectionInfo indexTitle] isEqualToString:@"1"])
    {
        return @"Shared";
    }
    else
    {
        return @"Not Shared";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
     [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView
   commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSManagedObjectContext *context =
         [self.fetchedResultsController managedObjectContext];

        NSManagedObject *objectToBeDeleted =
         [self.fetchedResultsController objectAtIndexPath:indexPath];

        [context deleteObject:objectToBeDeleted];

        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error deleting movie, %@", [error userInfo]);
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        
        NSIndexPath *indexPath =
         [self.tableView indexPathForSelectedRow];
        
        ICFMovie *movie =
         [[self fetchedResultsController]
           objectAtIndexPath:indexPath];
        
        ICFMovieDisplayViewController *movieDisplayVC =
         (ICFMovieDisplayViewController *)
          [segue destinationViewController];
        
        [movieDisplayVC setMovieDetailID:[movie objectID]];
    }
    
    if ([[segue identifier] isEqualToString:@"addMovie"])
    {
        
        NSManagedObjectContext *moc =
         kAppDelegate.managedObjectContext;
        
        ICFMovie *newMovie = [NSEntityDescription
         insertNewObjectForEntityForName:@"Movie"
                  inManagedObjectContext:moc];
        
        [newMovie setTitle:@"New Movie"];
        [newMovie setYear:@"2012"];
        [newMovie setMovieDescription:@"New movie description."];
        [newMovie setLent:@NO];
        [newMovie setLentOn:nil];
        [newMovie setTimesWatched:@0];
        
        NSError *mocSaveError = nil;

        if (![moc save:&mocSaveError])
        {
            NSLog(@"Save did not complete successfully. Error: %@",
                  [mocSaveError localizedDescription]);
        }
        
        UINavigationController *nc =
         (UINavigationController *)[segue destinationViewController];
        
        ICFMovieEditViewController *mEVC =
         (ICFMovieEditViewController *)[nc visibleViewController];
        
        [mEVC setEditMovieID:[newMovie objectID]];
        [mEVC setDelegate:nil];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSManagedObjectContext *moc = kAppDelegate.managedObjectContext;

    NSEntityDescription *entity =
     [NSEntityDescription entityForName:@"Movie"
                 inManagedObjectContext:moc];

    [fetchRequest setEntity:entity];

    [fetchRequest setFetchBatchSize:20];

    NSSortDescriptor *sortDescriptor =
     [[NSSortDescriptor alloc] initWithKey:@"title"
                                 ascending:YES];

    NSSortDescriptor *sharedSortDescriptor =
     [[NSSortDescriptor alloc] initWithKey:@"lent" ascending:NO];

    NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                sharedSortDescriptor,sortDescriptor,
                                nil];

    [fetchRequest setSortDescriptors:sortDescriptors];

    NSFetchedResultsController *aFetchedResultsController =
     [[NSFetchedResultsController alloc]
      initWithFetchRequest:fetchRequest
      managedObjectContext:moc
        sectionNameKeyPath:@"lent"
                 cacheName:nil];

    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return __fetchedResultsController;
}

- (void)controllerWillChangeContent:
   (NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            
                [self.tableView
                   insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                 withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
[self.tableView
   deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
 withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
                [self.tableView
                 insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
                [tableView
                 deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
[self configureCell:[tableView cellForRowAtIndexPath:indexPath]
        atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:
   (NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
    ICFMovie *movie =
     [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [movie cellTitle];
    
    cell.detailTextLabel.text = [movie movieDescription];
}

@end
