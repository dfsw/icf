//
//  ICFMovieListViewController.h
//  MyMovies
//
//  Created by Joe Keeley on 7/2/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ICFMovieEditViewController.h"

@interface ICFMovieListViewController : UITableViewController
 <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
