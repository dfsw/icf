//
//  ICFYearChooserViewController.m
//  MyMovies
//
//  Created by Joe Keeley on 7/7/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import "ICFYearChooserViewController.h"

typedef enum {
    ICFYearChooserComponentCentury = 0,
    ICFYearChooserComponentDecade,
    ICFYearChooserComponentYear
} ICFYearChooserComponentType;

@interface ICFYearChooserViewController ()

@end

@implementation ICFYearChooserViewController

- (IBAction)saveButtonTouched:(id)sender
{
    NSString *selYear = [self.chooserValueLabel text];
    [self.delegate chooserSelectedYear:selYear];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.yearThousands = @[@"18",@"19",@"20"];
    self.yearTens = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",
                     @"7",@"8",@"9"];
    
    NSString *selCentury = [self.selectedYear substringToIndex:2];
    NSRange decadeRange = NSMakeRange(2, 1);
    NSString *selDecade = [self.selectedYear substringWithRange:decadeRange];
    NSString *selYear = [self.selectedYear substringFromIndex:3];
    
    [self.chooserValueLabel setText:self.selectedYear];
    [self.pickerView selectRow:[self.yearThousands indexOfObject:selCentury]
                   inComponent:ICFYearChooserComponentCentury
                      animated:NO];
    [self.pickerView selectRow:[self.yearTens indexOfObject:selDecade]
                   inComponent:ICFYearChooserComponentDecade
                      animated:NO];
    [self.pickerView selectRow:[self.yearTens indexOfObject:selYear]
                   inComponent:ICFYearChooserComponentYear
                      animated:NO];
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

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"";
    if (component == 0)
    {
        title = [self.yearThousands objectAtIndex:row];
    }
    else
    {
        title = [self.yearTens objectAtIndex:row];
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *selThousands = [self.yearThousands objectAtIndex:[pickerView selectedRowInComponent:ICFYearChooserComponentCentury]];
    NSString *selTens = [self.yearTens objectAtIndex:[pickerView selectedRowInComponent:ICFYearChooserComponentDecade]];
    NSString *selOnes = [self.yearTens objectAtIndex:[pickerView selectedRowInComponent:ICFYearChooserComponentYear]];
    
    NSString *yearString = [NSString stringWithFormat:@"%@%@%@",selThousands,selTens,selOnes];
    [self.chooserValueLabel setText:yearString];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSUInteger numRows = 0;
    switch (component) {
        case ICFYearChooserComponentCentury:
            numRows = [self.yearThousands count];
            break;
        case ICFYearChooserComponentDecade:
            numRows = [self.yearTens count];
            break;
        case ICFYearChooserComponentYear:
            numRows = [self.yearTens count];
            break;
        default:
            break;
    }
    return numRows;
}

@end
