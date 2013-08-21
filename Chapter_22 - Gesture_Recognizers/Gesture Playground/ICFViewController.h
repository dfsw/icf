//
//  ICFViewController.h
//  Gesture Playground
//
//  Created by Joe Keeley on 2/24/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICFViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, retain) IBOutlet UIView *myGestureView;
@property (nonatomic, assign) CGFloat scaleFactor;
@property (nonatomic, assign) CGFloat rotationFactor;
@property (nonatomic, assign) CGFloat currentScaleDelta;
@property (nonatomic, assign) CGFloat currentRotationDelta;

- (void)myGestureViewTapped:(UIGestureRecognizer *)tapGesture;
- (void)myGestureViewPinched:(UIPinchGestureRecognizer *)pinchGesture;
- (void)myGestureViewRotated:(UIRotationGestureRecognizer *)rotateGesture;

@end
