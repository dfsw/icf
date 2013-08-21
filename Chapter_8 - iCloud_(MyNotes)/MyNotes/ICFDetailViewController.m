//
//  ICFDetailViewController.m
//  MyNotes
//
//  Created by Joe Keeley on 10/24/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import "ICFDetailViewController.h"
#import "ICFConflictResolutionViewController.h"

@interface ICFDetailViewController () {
    ICFMyNoteDocument *myNoteDocument;
}
- (void)configureView;
@end

@implementation ICFDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{        
    // Update the view.
    [self configureView];
}

- (void)configureView
{
    [self.myNoteTextView setText:@""];

    myNoteDocument =
    [[ICFMyNoteDocument alloc] initWithFileURL:[self myNoteURL]];

    [myNoteDocument setDelegate:self];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    if ([fileManager fileExistsAtPath:[self.myNoteURL path]]) {
        
        [myNoteDocument openWithCompletionHandler:^(BOOL success) {
            
            [self.myNoteTextView
             setText:[myNoteDocument myNoteText]];
            
            UIDocumentState state = myNoteDocument.documentState;
            
            if (state == UIDocumentStateNormal) {
                [self.myNoteTextView becomeFirstResponder];
            }
        }];
    }
    else
    {
        [myNoteDocument saveToURL:[self myNoteURL]
                 forSaveOperation:UIDocumentSaveForCreating
                completionHandler:nil];
        [self.myNoteTextView becomeFirstResponder];
    }

    NSUbiquitousKeyValueStore *iCloudKeyValueStore =
    [NSUbiquitousKeyValueStore defaultStore];

    NSString *noteName = [[[self myNoteURL] lastPathComponent]
                          stringByDeletingPathExtension];

    [iCloudKeyValueStore setString:noteName
                            forKey:kICFLastUpdatedNoteKey];

    [iCloudKeyValueStore synchronize];
}

#pragma mark - ICFMyNoteDocumentDelegate

- (void)documentContentsDidChange:(ICFMyNoteDocument *)document
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myNoteTextView setText:[document myNoteText]];
    });
}

#pragma mark - VC lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(documentStateChanged)
                                                 name:UIDocumentStateChangedNotification object:myNoteDocument];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSString *newText = [self.myNoteTextView text];
    [myNoteDocument setMyNoteText:newText];
    
    [myNoteDocument closeWithCompletionHandler:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDocumentStateChangedNotification
                                                  object:myNoteDocument];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showConflictButton
{
    [self.conflictButton setHidden:NO];
    [self.myNoteTextView resignFirstResponder];
}

- (void)hideConflictButton
{
    [self.conflictButton setHidden:YES];
}

- (IBAction)resolveConflictTapped:(id)sender
{
    NSArray *versions = [NSFileVersion
    unresolvedConflictVersionsOfItemAtURL:self.myNoteURL];
    
    NSFileVersion *currentVersion =
    [NSFileVersion currentVersionOfItemAtURL:self.myNoteURL];
    
    NSMutableArray *conflictVersions =
    [NSMutableArray arrayWithObject:currentVersion];
    
    [conflictVersions addObjectsFromArray:versions];
    
    ICFConflictResolutionViewController *conflictResolver =
    [self.storyboard instantiateViewControllerWithIdentifier:
     @"ICFConflictResolutionViewController"];
    
    [conflictResolver setVersionList:conflictVersions];
    [conflictResolver setCurrentVersion:currentVersion];
    [conflictResolver setConflictNoteURL:self.myNoteURL];
    [conflictResolver setDelegate:self];
    [self presentViewController:conflictResolver
                       animated:YES
                     completion:nil];    
}

#pragma mark - UIDocument notification
- (void)documentStateChanged {
    UIDocumentState state = myNoteDocument.documentState;
    if (state & UIDocumentStateEditingDisabled) {
        [self.myNoteTextView resignFirstResponder];
        return;
    }
    if (state & UIDocumentStateInConflict) {
        [self showConflictButton];
        return;
    }
    else {
        [self hideConflictButton];
        [self.myNoteTextView becomeFirstResponder];
    }
}

#pragma mark - Keyboard methods

- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGRect kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]
                     CGRectValue];
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey]
                       doubleValue];
    
    UIEdgeInsets insets = self.myNoteTextView.contentInset;
    insets.bottom += kbSize.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        self.myNoteTextView.contentInset = insets;
    }];
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey]
                       doubleValue];
    
    // Reset the text view's bottom content inset.
    UIEdgeInsets insets = self.myNoteTextView.contentInset;
    insets.bottom = 0;
    
    [UIView animateWithDuration:duration animations:^{
        self.myNoteTextView.contentInset = insets;
    }];
}

#pragma mark - Delegate methods
- (void)noteConflictResolved:(NSFileVersion *)selectedVersion
           forCurrentVersion:(BOOL)isCurrentVersion
{
    //resolve conflict
    if (isCurrentVersion) {
        [NSFileVersion
         removeOtherVersionsOfItemAtURL:myNoteDocument.fileURL
         error:nil];
        
        NSArray* conflictVersions =
        [NSFileVersion unresolvedConflictVersionsOfItemAtURL:
         myNoteDocument.fileURL];
        
        for (NSFileVersion* fileVersion in conflictVersions)
        {
            fileVersion.resolved = YES;
        }
    }
    else
    {
        [selectedVersion replaceItemAtURL:myNoteDocument.fileURL
                                  options:0
                                    error:nil];
        
        [NSFileVersion
         removeOtherVersionsOfItemAtURL:myNoteDocument.fileURL
         error:nil];
        
        NSArray* conflictVersions =
        [NSFileVersion unresolvedConflictVersionsOfItemAtURL:
         myNoteDocument.fileURL];
        
        for (NSFileVersion* fileVersion in conflictVersions)
        {
            fileVersion.resolved = YES;
        }
    }
    
    [self configureView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
