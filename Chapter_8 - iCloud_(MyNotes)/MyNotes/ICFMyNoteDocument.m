//
//  ICFMyNoteDocument.m
//  MyNotes
//
//  Created by Joe Keeley on 10/27/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import "ICFMyNoteDocument.h"

@implementation ICFMyNoteDocument

@synthesize myNoteText = _myNoteText;

- (void)setMyNoteText:(NSString *)newMyNoteText
{
    NSString *oldNoteText = _myNoteText;
    _myNoteText = [newMyNoteText copy];
    
    SEL setNoteText = @selector(setMyNoteText:);
    
    [self.undoManager setActionName:@"Text Change"];
    [self.undoManager registerUndoWithTarget:self
                                    selector:setNoteText
                                      object:oldNoteText];
}

- (id)contentsForType:(NSString *)typeName
               error:(NSError *__autoreleasing *)outError
{
    if (!self.myNoteText)
    {
        [self setMyNoteText:@""];
    }
    
    NSData *myNoteData =
    [self.myNoteText dataUsingEncoding:NSUTF8StringEncoding];
    
    return myNoteData;
}

- (BOOL)loadFromContents:(id)contents
                  ofType:(NSString *)typeName
                   error:(NSError *__autoreleasing *)outError
{
    if ([contents length] > 0)
    {
        NSString *textFromData =
        [[NSString alloc] initWithData:contents
                              encoding:NSUTF8StringEncoding];

        [self setMyNoteText:textFromData];
    }
    else
    {
        [self setMyNoteText:@""];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:
                          @selector(documentContentsDidChange:)])
        [self.delegate documentContentsDidChange:self];
    
    return YES;
}

@end
