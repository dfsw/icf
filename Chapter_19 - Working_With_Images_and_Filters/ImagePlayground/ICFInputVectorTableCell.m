//
//  ICFInputVectorTableCell.m
//  ImagePlayground
//
//  Created by Joe Keeley on 12/27/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import "ICFInputVectorTableCell.h"

@implementation ICFInputVectorTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureForInfo:(NSDictionary *)attributeInfo andKey:(NSString *)attributeKey
{
    [super configureForInfo:attributeInfo andKey:attributeKey];
    [self.inputVectorLabel setText:attributeKey];
    
    CIVector *inputDefault = [attributeInfo valueForKey:kCIAttributeDefault];
    
    NSString *inputXDefault = [NSString stringWithFormat:@"%f",[inputDefault X]];
    [self.inputXTextField setText:inputXDefault];

    NSString *inputYDefault = [NSString stringWithFormat:@"%f",[inputDefault Y]];
    [self.inputYTextField setText:inputYDefault];

    NSString *inputZDefault = [NSString stringWithFormat:@"%f",[inputDefault Z]];
    [self.inputZTextField setText:inputZDefault];

    NSString *inputWDefault = [NSString stringWithFormat:@"%f",[inputDefault W]];
    [self.inputWTextField setText:inputWDefault];
}

- (id)getAttributeValue
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    NSString *inputXString = [self.inputXTextField text];
    NSNumber *inputX = [numberFormatter numberFromString:inputXString];
    
    NSString *inputYString = [self.inputYTextField text];
    NSNumber *inputY = [numberFormatter numberFromString:inputYString];
    
    NSString *inputZString = [self.inputZTextField text];
    NSNumber *inputZ = [numberFormatter numberFromString:inputZString];
    
    NSString *inputWString = [self.inputWTextField text];
    NSNumber *inputW = [numberFormatter numberFromString:inputWString];
    
    CIVector *vector = [CIVector vectorWithX:[inputX floatValue]
                                           Y:[inputY floatValue]
                                           Z:[inputZ floatValue]
                                           W:[inputW floatValue]];
    
    return vector;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [super valueChanged:nil];
    return YES;
}

@end
