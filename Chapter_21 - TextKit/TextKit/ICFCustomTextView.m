//
//  ICFCustomTextView.m
//  TextKit
//
//  Created by Kyle Richter on 7/13/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import "ICFCustomTextView.h"

@implementation ICFCustomTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
        
    return self;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    //points are falling 10 pixels below where they should be, this adjust the point to where it needs to be.
    touchPoint.y -= 10;
    
    NSInteger characterIndex = [self.layoutManager characterIndexForPoint:touchPoint inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:0];
    
    if(characterIndex != 0)
    {
        //calculate the start and stop of the word
        NSRange start = [self.text rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] options:NSBackwardsSearch range:NSMakeRange(0, characterIndex)];
        NSRange stop = [self.text rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] options:NSCaseInsensitiveSearch range:NSMakeRange(characterIndex, self.text.length-characterIndex)];
        
        int length =  stop.location - start.location;
        
        NSString *fullWord = [self.text substringWithRange:NSMakeRange(start.location, length)];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected Word" message:fullWord delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    [super touchesBegan: touches withEvent: event];
}



@end
