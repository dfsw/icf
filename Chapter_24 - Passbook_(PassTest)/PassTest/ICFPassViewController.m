//
//  ICFPassViewController.m
//  PassTest
//
//  Created by Joe Keeley on 10/20/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import "ICFPassViewController.h"

@interface ICFPassViewController ()

@end

@implementation ICFPassViewController

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

    self.passLibrary = [[PKPassLibrary alloc] init];
    [self refreshPassStatusView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPassTouched:(id)sender
{
    
    NSString *passPath =
    [[NSBundle mainBundle] pathForResource:self.passFileName
                                    ofType:@"pkpass"];

    NSData *passData = [NSData dataWithContentsOfFile:passPath];

    NSError *passError = nil;
    PKPass *newPass = [[PKPass alloc]
                       initWithData:passData error:&passError];
    
    if (!passError && ![self.passLibrary containsPass:newPass])
    {
        PKAddPassesViewController *newPassVC =
        [[PKAddPassesViewController alloc] initWithPass:newPass];
        
        [newPassVC setDelegate:self];
        
        [self presentViewController:newPassVC
                           animated:YES
                         completion:^(){}];
        
    }
    else
    {
        NSString *passUpdateMessage = @"";
        
        if (passError) {
            
            passUpdateMessage =
            [NSString stringWithFormat:@"Pass Error: %@",
             [passError localizedDescription]];
            
        } else {
            passUpdateMessage = [NSString stringWithFormat:
                                 @"Your %@ has already been added.",
                                 self.passTypeName];
        }
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Pass Not Added"
                                   message:passUpdateMessage
                                  delegate:nil
                         cancelButtonTitle:@"Dismiss"
                         otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)updatePassTouched:(id)sender
{
    NSString *passName =
    [NSString stringWithFormat:@"%@-Update",self.passFileName];

    NSString *passPath =
    [[NSBundle mainBundle] pathForResource:passName ofType:@"pkpass"];

    NSData *passData = [NSData dataWithContentsOfFile:passPath];

    NSError *passError = nil;

    PKPass *updatedPass = [[PKPass alloc] initWithData:passData
                                                 error:&passError];
    
    if (!passError && [self.passLibrary containsPass:updatedPass])
    {
        
        BOOL updated = [self.passLibrary
                        replacePassWithPass:updatedPass];
        
        NSString *passUpdateMessage = @"";
        NSString *passAlertTitle = @"";
        
        if (updated)
        {
            passUpdateMessage = [NSString stringWithFormat:
            @"Your %@ has been updated.",self.passTypeName];
            
            passAlertTitle = @"Pass Updated";
        }
        else
        {
            passUpdateMessage = [NSString stringWithFormat:
            @"Your %@ could not be updated.",self.passTypeName];
            
            passAlertTitle = @"Pass Not Updated";
        }
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:passAlertTitle
                                   message:passUpdateMessage
                                  delegate:nil
                         cancelButtonTitle:@"Dismiss"
                         otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)showPassTouched:(id)sender
{
    PKPass *currentBoardingPass =
    [self.passLibrary passWithPassTypeIdentifier:self.passIdentifier
                                    serialNumber:self.passSerialNum];

    if (currentBoardingPass)
    {
        [[UIApplication sharedApplication]
         openURL:[currentBoardingPass passURL]];
    }
}

- (IBAction)deletePassTouched:(id)sender
{
    PKPass *currentBoardingPass =
    [self.passLibrary passWithPassTypeIdentifier:self.passIdentifier
                                    serialNumber:self.passSerialNum];

    if (currentBoardingPass)
    {
        [self.passLibrary removePass:currentBoardingPass];
        
        [self refreshPassStatusView];
        
        NSString *passUpdateMessage =
        [NSString stringWithFormat:@"Your %@ has been removed.",
        self.passTypeName];
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Pass Removed"
                                   message:passUpdateMessage
                                  delegate:nil
                         cancelButtonTitle:@"Dismiss"
                         otherButtonTitles:nil];
        [alert show];
    }
}

-(void)refreshPassStatusView
{
    if (![PKPassLibrary isPassLibraryAvailable])
    {
        
        [self.passInLabel setText:@"Pass Library not available."];
        
        [self.numPassesLabel setText:@""];
        [self.addButton setHidden:YES];
        [self.updateButton setHidden:YES];
        [self.showButton setHidden:YES];
        [self.deleteButton setHidden:YES];
        return;
    }

    NSArray *passes = [self.passLibrary passes];

    NSString *numPassesString =
    [NSString stringWithFormat:
     @"There are %d passes in Passbook.",[passes count]];

    [self.numPassesLabel setText:numPassesString];
    
    PKPass *currentBoardingPass =
    [self.passLibrary passWithPassTypeIdentifier:self.passIdentifier
                                    serialNumber:self.passSerialNum];
    
    if (currentBoardingPass)
    {
        [self.passInLabel setText:
        [NSString stringWithFormat:@"%@ is in Passbook",
        self.passTypeName]];
        
        [self.updateButton setHidden:NO];
        [self.showButton setHidden:NO];
        [self.deleteButton setHidden:NO];
    } else
    {
        [self.passInLabel setText:
        [NSString stringWithFormat:@"%@ is not in Passbook",
        self.passTypeName]];
        
        [self.updateButton setHidden:YES];
        [self.showButton setHidden:YES];
        [self.deleteButton setHidden:YES];
    }
}

#pragma mark - PKAddPassesViewControllerDelegate

-(void)addPassesViewControllerDidFinish:
(PKAddPassesViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self refreshPassStatusView];
    }];
}

@end
