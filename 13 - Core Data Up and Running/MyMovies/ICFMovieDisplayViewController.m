//
//  ICFMovieDisplayViewController.m
//  MyMovies
//
//  Created by Joe Keeley on 7/2/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import "ICFMovieDisplayViewController.h"
#import "ICFMovie.h"

@interface ICFMovieDisplayViewController ()
- (void)configureView;
- (void)configureViewForMovie:(ICFMovie *)movie;
@end

@implementation ICFMovieDisplayViewController

@synthesize movieDetailID;
@synthesize movieTitleAndYearLabel;
@synthesize movieDescription;
@synthesize movieSharedInfoLabel;

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.movieDetailID) {
        
        ICFMovie *movie = (ICFMovie *)[kAppDelegate.managedObjectContext
                                  objectWithID:self.movieDetailID];
        
        [self configureViewForMovie:movie];
    }
}

- (void)configureViewForMovie:(ICFMovie *)movie

{
    NSString *movieTitleYear = [movie yearAndTitle];

    [self.movieTitleAndYearLabel
     setText:movieTitleYear];

    [self.movieDescription setText:[movie movieDescription]];

    BOOL movieLent = [[movie lent] boolValue];

    NSString *movieShared = @"Not Shared";
    if (movieLent)
    {
        NSManagedObject *friend = 
        [movie valueForKey:@"lentToFriend"];
        
        NSDateFormatter *dateFormatter =
         [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        NSString *sharedDateTxt = 
        [dateFormatter stringFromDate:[movie lentOn]];
        
        movieShared =
         [NSString stringWithFormat:@"Shared with %@ on %@",
          [friend valueForKey:@"friendName"],sharedDateTxt];
    }
    
    [self.movieSharedInfoLabel setText:movieShared];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)viewDidUnload
{
    NSLog(@"viewDidUnload got called for ICFDetailViewController.");

    [self setMovieTitleAndYearLabel:nil];
    [self setMovieDescription:nil];
    [self setMovieSharedInfoLabel:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"editMovie"]) {
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        ICFMovieEditViewController *mEVC = (ICFMovieEditViewController *)[nc visibleViewController];
        [mEVC setEditMovieID:self.movieDetailID];
        [mEVC setDelegate:self];
    }
}

#pragma mark - ICFMovieEditDelegate
- (void)movieChanged:(ICFMovie *)movie
{
    [self setMovieDetailID:[movie objectID]];
    [self configureViewForMovie:movie];
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


@end
