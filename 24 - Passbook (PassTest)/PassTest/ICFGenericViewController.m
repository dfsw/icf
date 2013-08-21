//
//  ICFGenericViewController.m
//  PassTest
//
//  Created by Joe Keeley on 9/9/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import "ICFGenericViewController.h"
#import <PassKit/PassKit.h>

@interface ICFGenericViewController ()

@end

@implementation ICFGenericViewController

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
    self.passFileName = @"Generic";
    self.passTypeName = @"Generic Pass";
    self.passIdentifier =
    @"pass.explore-systems.icfpasstest.generic";
    self.passSerialNum = @"12345";

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
