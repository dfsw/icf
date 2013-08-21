//
//  ICFDynamicTextStorage.h
//  TextKit
//
//  Created by Kyle Richter on 7/21/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString *const defaultTokenName;

@interface ICFDynamicTextStorage : NSTextStorage
{
    NSMutableAttributedString *backingStore;
    BOOL textNeedsUpdate;
    
}

@property (nonatomic, copy) NSDictionary *tokens;

@end
