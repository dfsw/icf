//
//  ICFConflictResolutionViewController.h
//  MyNotes
//
//  Created by Joe Keeley on 10/28/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICFConflictVersionViewController.h"

@protocol ICFMyNoteConflictDelegate;

@interface ICFConflictResolutionViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource,ICFConflictResolutionDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *versionList;
@property (nonatomic, strong) NSFileVersion *currentVersion;
@property (nonatomic, strong) NSURL *conflictNoteURL;
@property (nonatomic, weak) id<ICFMyNoteConflictDelegate> delegate;

- (ICFConflictVersionViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(ICFConflictVersionViewController *)viewController;

@end

@protocol ICFMyNoteConflictDelegate <NSObject>

- (void)noteConflictResolved:(NSFileVersion *)selectedVersion forCurrentVersion:(BOOL)isCurrentVersion;

@end
