//
//  ICFPassViewController.h
//  PassTest
//
//  Created by Joe Keeley on 10/20/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>

@interface ICFPassViewController : UIViewController <PKAddPassesViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UILabel *numPassesLabel;
@property (nonatomic, retain) IBOutlet UILabel *passInLabel;
@property (nonatomic, retain) IBOutlet UIButton *addButton;
@property (nonatomic, retain) IBOutlet UIButton *updateButton;
@property (nonatomic, retain) IBOutlet UIButton *showButton;
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;
@property (nonatomic, retain) NSString *passFileName;
@property (nonatomic, retain) NSString *passTypeName;
@property (nonatomic, retain) NSString *passIdentifier;
@property (nonatomic, retain) NSString *passSerialNum;
@property (nonatomic, retain) PKPassLibrary *passLibrary;

- (IBAction)addPassTouched:(id)sender;
- (IBAction)updatePassTouched:(id)sender;
- (IBAction)showPassTouched:(id)sender;
- (IBAction)deletePassTouched:(id)sender;
- (void)refreshPassStatusView;

@end
