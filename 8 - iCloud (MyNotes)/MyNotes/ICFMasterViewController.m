//
//  ICFMasterViewController.m
//  MyNotes
//
//  Created by Joe Keeley on 10/24/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import "ICFMasterViewController.h"
#import "ICFDetailViewController.h"
#import "ICFMyNoteDocument.h"


@interface ICFMasterViewController () {
    NSMutableArray *noteList;
    NSMetadataQuery *noteQuery;
}

@property (nonatomic, strong) NSString *lastUpdatedNote;

- (NSString *)newMyNoteName;
- (NSMetadataQuery*)noteListQuery;
- (void)processFiles:(NSNotification*)notification;
- (void)updateLastUpdatedNote:(NSNotification *)notification;

@end

@implementation ICFMasterViewController

- (NSString *)newMyNoteName
{
    NSInteger noteCount = 1;
    NSString *newMyNoteName = nil;
    
    BOOL gotName = NO;
    while (!gotName) {
        newMyNoteName = [NSString stringWithFormat:@"MyNote %d.%@",
                         noteCount,kICFMyNoteDocumentExtension];
        
        BOOL noteNameExists = NO;
        
        for (NSURL *noteURL in noteList)
        {
            if ([[noteURL lastPathComponent] isEqualToString:newMyNoteName])
            {
                noteCount++;
                noteNameExists = YES;
            }
        }
        
        if (!noteNameExists)
        {
            gotName = YES;
        }
    }
    return newMyNoteName;
}

- (NSMetadataQuery*)noteListQuery
{
    NSMetadataQuery *setupQuery = [[NSMetadataQuery alloc] init];
    [setupQuery setSearchScopes:
     @[NSMetadataQueryUbiquitousDocumentsScope]];
    
    NSString *filePattern = [NSString stringWithFormat:
    @"*.%@",kICFMyNoteDocumentExtension];
    
    [setupQuery setPredicate:[NSPredicate predicateWithFormat:
    @"%K LIKE %@",NSMetadataItemFSNameKey,filePattern]];
    
    return setupQuery;
}

- (void)processFiles:(NSNotification*)notification
{
    NSMutableArray *foundFiles = [[NSMutableArray alloc] init];
    [noteQuery disableUpdates];
    
    NSArray *queryResults = [noteQuery results];
    for (NSMetadataItem *result in queryResults) {
        
        NSURL *fileURL =
        [result valueForAttribute:NSMetadataItemURLKey];
        
        NSNumber *isHidden = nil;
        
        [fileURL getResourceValue:&isHidden
                           forKey:NSURLIsHiddenKey
                            error:nil];
        
        if (isHidden && ![isHidden boolValue]) {
            [foundFiles addObject:fileURL];
        }
    }
    
    [noteList removeAllObjects];
    [noteList addObjectsFromArray:foundFiles];
    [self.tableView reloadData];
    
    [noteQuery enableUpdates];
}

- (void)updateLastUpdatedNote:(NSNotification *)notification
{
    NSUbiquitousKeyValueStore *iCloudKeyValueStore =
    [NSUbiquitousKeyValueStore defaultStore];
    
    self.lastUpdatedNote =
    [iCloudKeyValueStore stringForKey:kICFLastUpdatedNoteKey];
    
    [self.tableView reloadData];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!noteList) {
        noteList = [[NSMutableArray alloc] init];
    }

    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    if (!noteQuery) {
        noteQuery = [self noteListQuery];
    }
    
    NSNotificationCenter *notifCenter =
    [NSNotificationCenter defaultCenter];
    
    NSString *metadataFinished =
    NSMetadataQueryDidFinishGatheringNotification;
    
    [notifCenter addObserver:self
                    selector:@selector(processFiles:)
                        name:metadataFinished
                      object:nil];
    
    NSString *metadataUpdated =
    NSMetadataQueryDidUpdateNotification;
    
    [notifCenter addObserver:self
                    selector:@selector(processFiles:)
                        name:metadataUpdated
                      object:nil];
    
    NSString *keyValueStoreUpdated =
    NSUbiquitousKeyValueStoreDidChangeExternallyNotification;

    [notifCenter addObserver:self
                    selector:@selector(updateLastUpdatedNote:)
                        name: keyValueStoreUpdated
                      object:nil];
    
    [noteQuery startQuery];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateLastUpdatedNote:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    dispatch_queue_t background =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(background, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *newNoteURL = [fileManager URLForUbiquityContainerIdentifier:nil];
        newNoteURL = [newNoteURL URLByAppendingPathComponent:kICFDocumentDirectoryName isDirectory:YES];
        newNoteURL = [newNoteURL URLByAppendingPathComponent:[self newMyNoteName]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [noteList addObject:newNoteURL];
            NSIndexPath *newCellIndexPath = [NSIndexPath indexPathForRow:([noteList count]-1) inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[newCellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView selectRowAtIndexPath:newCellIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            
            UITableViewCell *newNoteCell = [self.tableView cellForRowAtIndexPath:newCellIndexPath];
            [self performSegueWithIdentifier:kICFDisplayNoteDetailSeque sender:newNoteCell];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
        });
    });
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [noteList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kICFMyNoteCellIdentifier forIndexPath:indexPath];

    NSURL *myNoteURL =
    [noteList objectAtIndex:[indexPath row]];

    NSString *noteName =
    [[myNoteURL lastPathComponent] stringByDeletingPathExtension];

    if ([self.lastUpdatedNote isEqualToString:noteName]) {
        
        NSString *lastUpdatedCellTitle =
        [NSString stringWithFormat:@"★ %@",noteName];
        
        [cell.textLabel setText:lastUpdatedCellTitle];
    }
    else
    {
        [cell.textLabel setText:noteName];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSURL *myNoteURL = [noteList objectAtIndex:[indexPath row]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
            [fileCoordinator coordinateWritingItemAtURL:myNoteURL
                                                options:NSFileCoordinatorWritingForDeleting
                                                  error:nil
                                             byAccessor:^(NSURL *newURL){
                                                 NSFileManager *fileManager = [[NSFileManager alloc] init];
                                                 [fileManager removeItemAtURL:newURL error:nil];
                                             }];
        });
        
        
        [noteList removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kICFDisplayNoteDetailSeque]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSURL *mySelectedNote = noteList[indexPath.row];
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
        [[segue destinationViewController] setMyNoteURL:mySelectedNote];
        [[[segue destinationViewController] navigationItem] setTitle:[[selectedCell textLabel] text]];
    }
}

@end
