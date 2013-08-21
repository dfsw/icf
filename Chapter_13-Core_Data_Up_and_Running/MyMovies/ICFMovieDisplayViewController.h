//
//  ICFMovieDisplayViewController.h
//  MyMovies
//
//  Created by Joe Keeley on 7/2/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICFMovieEditViewController.h"

@interface ICFMovieDisplayViewController : UITableViewController <ICFMovieEditDelegate>

@property (strong, nonatomic) NSManagedObjectID *movieDetailID;
@property (strong, nonatomic) IBOutlet UILabel *movieTitleAndYearLabel;
@property (strong, nonatomic) IBOutlet UITextView *movieDescription;
@property (strong, nonatomic) IBOutlet UILabel *movieSharedInfoLabel;

@end
