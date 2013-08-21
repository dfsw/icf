//
//  ICFSnapViewController.m
//  Dynamics
//
//  Created by Kyle Richter on 7/14/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import "ICFSnapViewController.h"

@interface ICFSnapViewController ()

@end

@implementation ICFSnapViewController

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
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)handleSnapGesture:(UITapGestureRecognizer*)gesture
{
    CGPoint point = [gesture locationInView:self.view];
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UISnapBehavior* snapBehavior = [[[UISnapBehavior alloc] initWithItem:frogImageView snapToPoint:point] autorelease];
    snapBehavior.damping = 0.75f;
    [animator addBehavior:snapBehavior];
    
}

- (void)dealloc {
    
    [animator release];
    [frogImageView release];
    [super dealloc];
}
@end
