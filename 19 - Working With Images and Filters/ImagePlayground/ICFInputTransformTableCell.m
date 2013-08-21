//
//  ICFInputTransformTableCell.m
//  ImagePlayground
//
//  Created by Joe Keeley on 12/27/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import "ICFInputTransformTableCell.h"

@implementation ICFInputTransformTableCell

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
    [self.inputTransformLabel setText:attributeKey];

}

- (id)getAttributeValue
{
    CGFloat tx = [[self.inputTXTextField text] floatValue];
    CGFloat ty = [[self.inputTYTextField text] floatValue];
    CGFloat sx = [[self.inputSXTextField text] floatValue];
    CGFloat sy = [[self.inputSYTextField text] floatValue];
    CGFloat r = [[self.inputRotateTextField text] floatValue];
    
    CGAffineTransform translate = CGAffineTransformMakeTranslation(tx,ty);
    CGAffineTransform scale = CGAffineTransformMakeScale(sx, sy);
    CGAffineTransform rotate = CGAffineTransformMakeRotation(r);
    
    CGAffineTransform translateAndScale = CGAffineTransformConcat(translate, scale);
    
    CGAffineTransform transform = CGAffineTransformConcat(translateAndScale, rotate);
    
    //make updates...
    
    NSValue *attrValue = [NSValue valueWithCGAffineTransform:transform];

    return attrValue;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [super valueChanged:nil];
    return YES;
}

@end
