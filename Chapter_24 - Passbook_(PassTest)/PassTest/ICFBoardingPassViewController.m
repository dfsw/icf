//
//  ICFBoardingPassViewController.m
//  PassTest
//
//  Created by Joe Keeley on 9/9/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import "ICFBoardingPassViewController.h"

@interface ICFBoardingPassViewController ()

@end

@implementation ICFBoardingPassViewController

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
    self.passFileName = @"BoardingPass";
    self.passTypeName = @"Boarding Pass";
    self.passIdentifier =
    @"pass.explore-systems.icfpasstest.boardingpass";
    self.passSerialNum = @"12345";

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
