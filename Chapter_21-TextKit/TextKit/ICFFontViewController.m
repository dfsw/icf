//
//  ICFFontViewController.m
//  TextKit
//
//  Created by Kyle Richter on 7/13/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import "ICFFontViewController.h"

@interface ICFFontViewController ()

@end

@implementation ICFFontViewController

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
    // Do any additional setup after loading the view from its nib.
    
    NSArray *fonts = [UIFont familyNames];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
