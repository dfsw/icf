//
//  ICFForceViewController.m
//  Dynamics
//
//  Created by Kyle Richter on 7/14/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import "ICFForceViewController.h"

@interface ICFForceViewController ()

@end

@implementation ICFForceViewController

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
    
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UICollisionBehavior* collisionBehavior = [[[UICollisionBehavior alloc] initWithItems:@[dragonImageView]] autorelease];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [animator addBehavior:collisionBehavior];
    
    UIPushBehavior *pushBehavior = [[[UIPushBehavior alloc] initWithItems:@[dragonImageView] mode:UIPushBehaviorModeInstantaneous] autorelease];
    pushBehavior.angle = 0.0;
    pushBehavior.magnitude = 0.0;
    
    self.pushBehavior = pushBehavior;
    [animator addBehavior:self.pushBehavior];
}

-(IBAction)handlePushGesture:(UITapGestureRecognizer*)gesture
{
    CGPoint point = [gesture locationInView:self.view];
    CGPoint origin = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    CGFloat distance = sqrtf(powf(point.x-origin.x, 2.0)+powf(point.y-origin.y, 2.0));
    CGFloat angle = atan2(point.y-origin.y,point.x-origin.x);
    distance = MIN(distance, 100.0);
    
    [self.pushBehavior setMagnitude:distance / 100.0];
    [self.pushBehavior setAngle:angle];

    [self.pushBehavior setActive:TRUE];
}


- (void)dealloc
{
    [animator release];
    [dragonImageView release];
    [super dealloc];
}
@end
