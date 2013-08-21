//
//  ICFDateChooserViewController.m
//  MyMovies
//
//  Created by Joe Keeley on 7/7/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import "ICFDateChooserViewController.h"

@interface ICFDateChooserViewController ()

@end

@implementation ICFDateChooserViewController

- (IBAction)saveButtonTouched:(id)sender
{
    [self.delegate chooserSelectedDate:[self.datePickerView date]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)datePickerValueChanged:(id)sender
{
    NSDate *selDate = [self.datePickerView date];
    NSString *newDate = [self.df stringFromDate:selDate];
    [self.chooserValueLabel setText:newDate];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.df = [[NSDateFormatter alloc] init];
    [self.df setDateStyle:NSDateFormatterMediumStyle];

    [self.datePickerView setDate:self.selectedDate];
    NSString *dt = [self.df stringFromDate:self.selectedDate];
    [self.chooserValueLabel setText:dt];
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
