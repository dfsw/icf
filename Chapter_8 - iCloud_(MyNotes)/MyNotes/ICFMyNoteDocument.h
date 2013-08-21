//
//  ICFMyNoteDocument.h
//  MyNotes
//
//  Created by Joe Keeley on 10/27/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ICFMyNoteDocumentDelegate;

@interface ICFMyNoteDocument : UIDocument

@property (nonatomic, copy) NSString *myNoteText;
@property (nonatomic, weak) id<ICFMyNoteDocumentDelegate> delegate;

@end


@protocol ICFMyNoteDocumentDelegate <NSObject>

@optional
- (void)documentContentsDidChange:(ICFMyNoteDocument *)document;

@end