//
//  ICFContentHighligtingViewController.m
//  TextKit
//
//  Created by Kyle Richter on 7/21/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import "ICFContentHighligtingViewController.h"
#import "ICFDynamicTextStorage.h"

@interface ICFContentHighligtingViewController ()

@end

@implementation ICFContentHighligtingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    ICFDynamicTextStorage *textStorage = [[[ICFDynamicTextStorage alloc] init] autorelease];

    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    
    NSTextContainer *container = [[[NSTextContainer alloc] initWithSize:CGSizeMake(myTextView.frame.size.width, CGFLOAT_MAX)] autorelease];
    container.widthTracksTextView = YES;
    [layoutManager addTextContainer:container];
    [textStorage addLayoutManager:layoutManager];

    myTextView = [[[UITextView alloc] initWithFrame:self.view.frame textContainer:container] autorelease];
    myTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    myTextView.scrollEnabled = YES;
    myTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:myTextView];
    
    

    textStorage.tokens = @{ @"Mary" : @{ NSForegroundColorAttributeName : [UIColor redColor] },
                            @"lamb" : @{ NSForegroundColorAttributeName : [UIColor blueColor] },
                            @"everywhere" : @{ NSUnderlineStyleAttributeName : @1 },
                            @"that" : @{ NSBackgroundColorAttributeName : [UIColor yellowColor] },
                            @"fleece" : @{ NSFontAttributeName : [UIFont fontWithName:@"Chalkduster" size:14.0f] },
                            @"school" : @{ NSStrikethroughStyleAttributeName : @1 },
                            @"white" : @{ NSStrokeWidthAttributeName : @5 },
                            @"was" : @{ NSFontAttributeName : [UIFont fontWithName:@"Palatino-Bold" size:10.0f], NSForegroundColorAttributeName : [UIColor purpleColor], NSUnderlineStyleAttributeName : @1},
                            defaultTokenName : @{ NSForegroundColorAttributeName : [UIColor blackColor],
                                                  NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                                  NSUnderlineStyleAttributeName : @0,
                                                  NSBackgroundColorAttributeName : [UIColor whiteColor],
                                                  NSStrikethroughStyleAttributeName : @0,
                                                  NSStrokeWidthAttributeName : @0}};

    
    NSString *maryText = @"Mary had a little lamb\nwhose fleece was white as snow.\nAnd everywhere that Mary went,\nthe lamb was sure to go.\nIt followed her to school one day\nwhich was against the rule.\nIt made the children laugh and play,\nto see a lamb at school.";
    
    [myTextView setText:[NSString stringWithFormat:@"%@\n\n%@\n\n%@", maryText, maryText, maryText]];

}



- (void)dealloc {
    [myTextView release];
    [super dealloc];
}
@end
