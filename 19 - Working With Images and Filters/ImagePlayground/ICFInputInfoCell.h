//
//  ICFInputInfoCell.h
//  ImagePlayground
//
//  Created by Joe Keeley on 12/27/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICFFilterViewController.h"

@interface ICFInputInfoCell : UITableViewCell 

@property (nonatomic, strong) NSString *attributeKey;
@property (nonatomic, weak) id<ICFFilterEditingDelegate>editDelegate;
- (void)configureForInfo:(NSDictionary *)attributeInfo andKey:(NSString *)attributeKey;
- (id)getAttributeValue;
- (IBAction)valueChanged:(id)sender;
@end
