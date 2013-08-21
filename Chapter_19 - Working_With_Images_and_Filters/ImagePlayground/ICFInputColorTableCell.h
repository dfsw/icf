//
//  ICFInputColorTableCell.h
//  ImagePlayground
//
//  Created by Joe Keeley on 12/27/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICFInputInfoCell.h"

@interface ICFInputColorTableCell : ICFInputInfoCell

@property (nonatomic, strong) IBOutlet UILabel *inputColorLabel;
@property (nonatomic, strong) IBOutlet UISlider *inputRedSlider;
@property (nonatomic, strong) IBOutlet UISlider *inputGreenSlider;
@property (nonatomic, strong) IBOutlet UISlider *inputBlueSlider;
@property (nonatomic, strong) IBOutlet UISlider *inputAlphaSlider;
@property (nonatomic, strong) IBOutlet UIView *displayColorView;

- (IBAction)colorSliderChanged:(id)sender;

@end
