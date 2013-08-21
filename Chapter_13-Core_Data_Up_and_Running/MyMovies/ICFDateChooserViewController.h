//
//  ICFDateChooserViewController.h
//  MyMovies
//
//  Created by Joe Keeley on 7/7/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ICFDateChooserDelegate <NSObject>
- (void)chooserSelectedDate:(NSDate *)date;
@end

@interface ICFDateChooserViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *chooserValueLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSDateFormatter *df;
@property (weak, nonatomic) id<ICFDateChooserDelegate> delegate;

- (IBAction)saveButtonTouched:(id)sender;
- (IBAction)datePickerValueChanged:(id)sender;

@end
