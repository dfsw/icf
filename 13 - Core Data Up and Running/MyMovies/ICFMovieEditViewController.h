//
//  ICFMovieEditViewController.h
//  MyMovies
//
//  Created by Joe Keeley on 7/5/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICFYearChooserViewController.h"
#import "ICFDateChooserViewController.h"
#import "ICFFriendChooserViewController.h"
#import "ICFMovie.h"

@protocol ICFMovieEditDelegate <NSObject>
- (void)movieChanged:(ICFMovie *)movie;
@end

@interface ICFMovieEditViewController : UITableViewController <ICFYearChooserDelegate, ICFDateChooserDelegate, ICFFriendChooserDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSManagedObjectID *editMovieID;
@property (nonatomic, strong) IBOutlet UITextField *movieTitle;
@property (nonatomic, strong) IBOutlet UILabel *movieYearLabel;
@property (nonatomic, strong) IBOutlet UITextView *movieDescription;
@property (nonatomic, strong) IBOutlet UISwitch *sharedSwitch;
@property (nonatomic, strong) IBOutlet UILabel *sharedFriendLabel;
@property (nonatomic, strong) IBOutlet UILabel *sharedOnDateLabel;
@property (nonatomic, strong) IBOutlet UITableViewCell *sharedFriendCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *sharedDateCell;
@property (nonatomic, weak) id<ICFMovieEditDelegate> delegate;

- (IBAction)saveButtonTouched:(id)sender;
- (IBAction)cancelButtonTouched:(id)sender;
- (IBAction)sharedSwitchChanged:(id)sender;

@end
