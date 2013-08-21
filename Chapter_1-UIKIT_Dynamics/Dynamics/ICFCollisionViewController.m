//
//  ICFCollisionViewController.m
//  Dynamics
//
//  Created by Kyle Richter on 7/14/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import "ICFCollisionViewController.h"

@interface ICFCollisionViewController ()

@end

@implementation ICFCollisionViewController

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
    
    UIGravityBehavior* gravityBehavior = [[[UIGravityBehavior alloc] initWithItems:@[frogImageView, dragonImageView]] autorelease];
    [gravityBehavior setXComponent:0.0f yComponent:1.0f];
    
    
    UICollisionBehavior* collisionBehavior = [[[UICollisionBehavior alloc] initWithItems:@[frogImageView, dragonImageView]] autorelease];
    [collisionBehavior setCollisionMode: UICollisionBehaviorModeEverything];
   
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [animator addBehavior:gravityBehavior];
    [animator addBehavior:collisionBehavior];
    
    collisionBehavior.collisionDelegate = self;
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if([item isEqual:frogImageView])
        collisionOneLabel.text = @"Frog Collided";
    if([item isEqual:dragonImageView])
        collisionTwoLabel.text = @"Dragon Collided";
}


-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier
{
    //collision has ended contact
}

- (void)dealloc {
    [animator release];
    [dragonImageView release];
    [frogImageView release];
    [collisionOneLabel release];
    [collisionTwoLabel release];
    [super dealloc];
}
@end
