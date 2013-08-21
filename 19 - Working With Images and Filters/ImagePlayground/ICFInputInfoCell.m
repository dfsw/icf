//
//  ICFInputInfoCell.m
//  ImagePlayground
//
//  Created by Joe Keeley on 12/27/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import "ICFInputInfoCell.h"

@implementation ICFInputInfoCell

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

#pragma mark - Custom methods
- (void)configureForInfo:(NSDictionary *)attributeInfo andKey:(NSString *)attributeKey
{
    [self setAttributeKey:attributeKey];
}

- (id)getAttributeValue
{
    return nil;
}

- (IBAction)valueChanged:(id)sender
{
    [self.editDelegate updateFilterAttribute:self.attributeKey
                                   withValue:[self getAttributeValue]];
}

@end
