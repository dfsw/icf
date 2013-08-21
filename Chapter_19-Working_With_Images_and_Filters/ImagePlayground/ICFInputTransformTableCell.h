//
//  ICFInputTransformTableCell.h
//  ImagePlayground
//
//  Created by Joe Keeley on 12/27/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICFInputInfoCell.h"

@interface ICFInputTransformTableCell : ICFInputInfoCell

@property (nonatomic, strong) IBOutlet UILabel *inputTransformLabel;
@property (nonatomic, strong) IBOutlet UITextField *inputTXTextField;
@property (nonatomic, strong) IBOutlet UITextField *inputTYTextField;
@property (nonatomic, strong) IBOutlet UITextField *inputRotateTextField;
@property (nonatomic, strong) IBOutlet UITextField *inputSXTextField;
@property (nonatomic, strong) IBOutlet UITextField *inputSYTextField;

@end
