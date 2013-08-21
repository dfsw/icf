//
//  ICFConflictVersionViewController.h
//  MyNotes
//
//  Created by Joe Keeley on 10/28/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ICFConflictResolutionDelegate;

@interface ICFConflictVersionViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *versionLabel;
@property (nonatomic, strong) IBOutlet UILabel *versionDate;
@property (nonatomic, strong) IBOutlet UILabel *versionComputer;
@property (nonatomic, strong) NSFileVersion *fileVersion;
@property (nonatomic, weak) id<ICFConflictResolutionDelegate> delegate;

- (IBAction)selectVersionTouched:(id)sender;

@end

@protocol ICFConflictResolutionDelegate <NSObject>

- (void)conflictVersionSelected:(NSFileVersion *)selectedVersion;

@end