//
//  ICFCollisionViewController.h
//  Dynamics
//
//  Created by Kyle Richter on 7/14/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICFCollisionViewController : UIViewController <UICollisionBehaviorDelegate>
{
    IBOutlet UIImageView *dragonImageView;
    IBOutlet UIImageView *frogImageView;
    
    IBOutlet UILabel *collisionOneLabel;
    IBOutlet UILabel *collisionTwoLabel;

    UIDynamicAnimator* animator;
    
}
@end
