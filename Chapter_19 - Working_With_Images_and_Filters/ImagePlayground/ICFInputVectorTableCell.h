//
//  ICFInputVectorTableCell.h
//  ImagePlayground
//
//  Created by Joe Keeley on 12/27/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICFInputInfoCell.h"

@interface ICFInputVectorTableCell : ICFInputInfoCell <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *inputVectorLabel;
@property (nonatomic, strong) IBOutlet UITextField *inputOneTextField;
@property (nonatomic, strong) IBOutlet UITextField *inputTwoTextField;

@property (nonatomic, strong) IBOutlet UITextField *inputXTextField;
@property (nonatomic, strong) IBOutlet UITextField *inputYTextField;
@property (nonatomic, strong) IBOutlet UITextField *inputZTextField;
@property (nonatomic, strong) IBOutlet UITextField *inputWTextField;

@end
