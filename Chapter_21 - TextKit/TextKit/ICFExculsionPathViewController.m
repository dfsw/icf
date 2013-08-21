//
//  ICFExculsionPathViewController.m
//  TextKit
//
//  Created by Kyle Richter on 7/14/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import "ICFExculsionPathViewController.h"

@interface ICFExculsionPathViewController ()

@end

@implementation ICFExculsionPathViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(110, 100, 100, 102)];
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(110, 110, 100, 102)] autorelease];
    [imageView setImage: [UIImage imageNamed: @"DF.png"]];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [self.myTextView addSubview: imageView];
    
    self.myTextView.textContainer.exclusionPaths = @[circle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_myTextView release];
    [super dealloc];
}
@end
