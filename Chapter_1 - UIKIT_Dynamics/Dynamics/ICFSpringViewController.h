//
//  ICFAttachmentsViewController.h
//  Dynamics
//
//  Created by Kyle Richter on 7/14/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICFSpringViewController : UIViewController
{
    IBOutlet UIImageView *frogImageView;
    IBOutlet UIImageView *dragonImageView;
    UIDynamicAnimator* animator;
    
}

@property(nonatomic, retain) UIAttachmentBehavior* attachmentBehavior;

@end
