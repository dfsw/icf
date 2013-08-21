//
//  ICFFriendsViewController.h
//  MyMovies
//
//  Created by Joe Keeley on 7/9/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICFFriendsViewController : UITableViewController
<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
