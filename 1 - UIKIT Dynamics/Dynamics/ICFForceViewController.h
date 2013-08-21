//
//  ICFForceViewController.h
//  Dynamics
//
//  Created by Kyle Richter on 7/14/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICFForceViewController : UIViewController
{
    IBOutlet UIImageView *dragonImageView;
    UIDynamicAnimator* animator;
}

@property (nonatomic, retain) UIPushBehavior* pushBehavior;

@end
