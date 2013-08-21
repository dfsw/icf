//
//  ICFInputNumberTableCell.m
//  ImagePlayground
//
//  Created by Joe Keeley on 12/27/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import "ICFInputNumberTableCell.h"

@implementation ICFInputNumberTableCell

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

    [self.inputNumberLabel setText:attributeKey];

    CGFloat maxValue = [[attributeInfo valueForKey:kCIAttributeSliderMax] floatValue];
    [self.inputNumberSlider setMaximumValue:maxValue];
    
    CGFloat minValue = [[attributeInfo valueForKey:kCIAttributeSliderMin] floatValue];
    [self.inputNumberSlider setMinimumValue:minValue];
    
    CGFloat defaultValue = [[attributeInfo valueForKey:kCIAttributeDefault] floatValue];
    [self.inputNumberSlider setValue:defaultValue];
}

- (id)getAttributeValue
{
    CGFloat value = [self.inputNumberSlider value];
    return [NSNumber numberWithFloat:value];
}


@end
