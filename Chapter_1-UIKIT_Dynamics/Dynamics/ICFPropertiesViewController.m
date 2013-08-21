//
//  ICFPropertiesViewController.m
//  Dynamics
//
//  Created by Kyle Richter on 7/14/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import "ICFPropertiesViewController.h"

@interface ICFPropertiesViewController ()

@end

@implementation ICFPropertiesViewController

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
    
    UIGravityBehavior* gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[dragonImageView, frogImageView]];
    
    UICollisionBehavior* collisionBehavior = [[[UICollisionBehavior alloc] initWithItems:@[dragonImageView, frogImageView]] autorelease];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;

    UIDynamicItemBehavior* propertiesBehavior = [[[UIDynamicItemBehavior alloc] initWithItems:@[frogImageView]] autorelease];
    propertiesBehavior.elasticity = 1.0f;
    propertiesBehavior.allowsRotation = NO;
    propertiesBehavior.angularResistance = 0.0f;
    propertiesBehavior.density = 3.0f;
    propertiesBehavior.friction = 0.5f;
    propertiesBehavior.resistance = 0.5f;
    
    [animator addBehavior:propertiesBehavior];
    [animator addBehavior:gravityBehavior];
    [animator addBehavior:collisionBehavior];
}

- (void)dealloc {
    [animator release];
    [dragonImageView release];
    [frogImageView release];
    [super dealloc];
}
@end
