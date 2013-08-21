//
//  ICFAttachmentsViewController.m
//  Dynamics
//
//  Created by Kyle Richter on 7/14/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import "ICFAttachmentsViewController.h"

@interface ICFAttachmentsViewController ()

@end

@implementation ICFAttachmentsViewController

@synthesize attachmentBehavior;

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
    UICollisionBehavior* collisionBehavior = [[[UICollisionBehavior alloc] initWithItems:@[dragonImageView, frogImageView]] autorelease];
    
    CGPoint frogCenter = CGPointMake(frogImageView.center.x, frogImageView.center.y);

    self.attachmentBehavior = [[[UIAttachmentBehavior alloc] initWithItem:dragonImageView attachedToAnchor:frogCenter] autorelease];
    
    [collisionBehavior setCollisionMode: UICollisionBehaviorModeBoundaries];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [animator addBehavior:collisionBehavior];
    [animator addBehavior:self.attachmentBehavior];

}

-(IBAction)handleAttachmentGesture:(UIPanGestureRecognizer*)gesture
{
    CGPoint gesturePoint = [gesture locationInView:self.view];
    
    frogImageView.center = gesturePoint;
    [self.attachmentBehavior setAnchorPoint:gesturePoint];
}


- (void)dealloc
{
    [animator release];
    [frogImageView release];
    [dragonImageView release];
    [super dealloc];
}

@end
