//
//  ICFDynamicTextStorage.m
//  TextKit
//
//  Created by Kyle Richter on 7/21/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import "ICFDynamicTextStorage.h"

NSString *const defaultTokenName = @"defaultTokenName";

@implementation ICFDynamicTextStorage

- (id)init
{
    self = [super init];
    
    if (self)
    {
        backingStore = [[NSMutableAttributedString alloc] init];
    }
    
    return self;
}

- (NSString *)string
{
    return [backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [backingStore attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [self beginEditing];
    [backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters|NSTextStorageEditedAttributes range:range changeInLength:str.length - range.length];
    textNeedsUpdate = YES;
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [self beginEditing];
    [backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)performReplacementsForCharacterChangeInRange:(NSRange)changedRange
{
    NSRange extendedRange = NSUnionRange(changedRange, [[self string] lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [[self string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    
    [self applyTokenAttributesToRange:extendedRange];
}

-(void)processEditing
{
    if(textNeedsUpdate)
    {
        textNeedsUpdate = NO;
        [self performReplacementsForCharacterChangeInRange:[self editedRange]];
    }
    
    [super processEditing];
}

- (void)applyTokenAttributesToRange:(NSRange)searchRange
{
    NSDictionary *defaultAttributes = [self.tokens objectForKey:defaultTokenName];
    
    [[self string] enumerateSubstringsInRange:searchRange options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
    {
        NSDictionary *attributesForToken = [self.tokens objectForKey:substring];
        
        if(!attributesForToken)
        {
            attributesForToken = defaultAttributes;
        }
                
        [self addAttributes:attributesForToken range:substringRange];

    }];
}


@end
