//
//  ICFYearChooserViewController.h
//  MyMovies
//
//  Created by Joe Keeley on 7/7/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ICFYearChooserDelegate <NSObject>
- (void)chooserSelectedYear:(NSString *)year;
@end

@interface ICFYearChooserViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *chooserValueLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSString *selectedYear;
@property (strong, nonatomic) NSArray *yearThousands;
@property (strong, nonatomic) NSArray *yearTens;
@property (strong, nonatomic) NSArray *yearOnes;
@property (weak, nonatomic) id<ICFYearChooserDelegate> delegate;

- (IBAction)saveButtonTouched:(id)sender;

@end

