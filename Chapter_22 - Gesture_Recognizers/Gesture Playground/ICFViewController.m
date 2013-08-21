//
//  ICFViewController.m
//  Gesture Playground
//
//  Created by Joe Keeley on 2/24/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import "ICFViewController.h"

@implementation ICFViewController

@synthesize myGestureView;
@synthesize scaleFactor;
@synthesize rotationFactor;
@synthesize currentScaleDelta;
@synthesize currentRotationDelta;

#pragma mark - UIGestureRecognizerDelegate methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;    
}


#pragma mark - UIGestureRecognizer handling methods
- (void)myGestureViewTapped:(UIGestureRecognizer *)tapGestureRecognizer {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tap Received" 
                                                    message:@"Received tap in myGestureView" 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK Thanks" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)myGestureViewSingleTapped:(UIGestureRecognizer *)tapGestureRecognizer {
    NSLog(@"Single Tap Received");
}

- (void)myGestureViewDoubleTapped:(UIGestureRecognizer *)doubleTapGestureRecognizer {
    NSLog(@"Double Tap Received");
}

- (void)myGestureViewSoloPinched:(UIPinchGestureRecognizer *)pinchGesture {
    CGFloat pinchScale = [pinchGesture scale];
    
	CGAffineTransform scaleTransform = 	CGAffineTransformMakeScale(pinchScale, pinchScale);
    
	[myGestureView setTransform:scaleTransform];
}

- (void)updateViewTransformWithScaleDelta:(CGFloat)scaleDelta andRotationDelta:(CGFloat)rotationDelta;
{
    if (rotationDelta != 0) {
        [self setCurrentRotationDelta:rotationDelta];
    }
    if (scaleDelta != 0) {
        [self setCurrentScaleDelta:scaleDelta];
    }
    CGFloat scaleAmount = [self scaleFactor]+[self currentScaleDelta];
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scaleAmount, scaleAmount);
    
    CGFloat rotationAmount = [self rotationFactor]+[self currentRotationDelta];
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(rotationAmount);
    
    CGAffineTransform newTransform = CGAffineTransformConcat(scaleTransform, rotateTransform);
    [myGestureView setTransform:newTransform];
}

- (void)myGestureViewPinched:(UIPinchGestureRecognizer *)pinchGesture {
    CGFloat newPinchDelta = [pinchGesture scale] - 1; //scale starts at 1.0
    [self updateViewTransformWithScaleDelta:newPinchDelta andRotationDelta:0];
    if ([pinchGesture state] == UIGestureRecognizerStateEnded) {
        [self setScaleFactor:[self scaleFactor] + newPinchDelta];
        [self setCurrentScaleDelta:0.0];
    }
}

- (void)myGestureViewRotated:(UIRotationGestureRecognizer *)rotateGesture {
    CGFloat newRotateRadians = [rotateGesture rotation];
    
    [self updateViewTransformWithScaleDelta:0.0 andRotationDelta:newRotateRadians];
    if ([rotateGesture state] == UIGestureRecognizerStateEnded) {
        CGFloat saveRotation = [self rotationFactor] + newRotateRadians;
        [self setRotationFactor:saveRotation];
        [self setCurrentRotationDelta:0.0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myGestureViewTapped:)];
    [myGestureView addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
     

    /*
    UIPinchGestureRecognizer *soloPinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(myGestureViewSoloPinched:)];
    //[myGestureView addGestureRecognizer:soloPinchRecognizer];
    [[self view] addGestureRecognizer:soloPinchRecognizer];
    [soloPinchRecognizer release];
    */

    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(myGestureViewPinched:)];
    [pinchRecognizer setDelegate:self];
    [myGestureView addGestureRecognizer:pinchRecognizer];
    [pinchRecognizer release];
     
    UIRotationGestureRecognizer *rotateRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(myGestureViewRotated:)];
    [rotateRecognizer setDelegate:self];
    [myGestureView addGestureRecognizer:rotateRecognizer];
    [rotateRecognizer release];
    

    /*
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myGestureViewDoubleTapped:)];
    [doubleTapRecognizer setNumberOfTapsRequired:2];
    [myGestureView addGestureRecognizer:doubleTapRecognizer];

    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myGestureViewTapped:)];
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    [myGestureView addGestureRecognizer:singleTapRecognizer];
    [singleTapRecognizer release];
    [doubleTapRecognizer release];
     */

    
    //set defaults for scale and rotation
    [self setScaleFactor:1.0];
    [self setRotationFactor:0.0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
