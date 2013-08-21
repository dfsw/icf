//
//  ICFViewController.h
//  ImagePlayground
//
//  Created by Joe Keeley on 11/3/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ICFFilterProcessingDelegate <NSObject>

- (void)addFilter:(CIFilter *)filter;
- (void)cancelAddingFilter;
- (UIImage *)imageWithLastFilterApplied;
- (UIPopoverController *)currentPopoverController;
- (UINavigationController *)currentFilterController;

@end


@interface ICFViewController : UIViewController <ICFFilterProcessingDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) IBOutlet UIView *sourceImageContainer;
@property (nonatomic, strong) IBOutlet UIImageView *sourceImageView;
@property (nonatomic, strong) IBOutlet UIView *resultImageContainer;
@property (nonatomic, strong) IBOutlet UIImageView *resultImageView;
@property (nonatomic, strong) IBOutlet UIView *filterListContainer;
@property (nonatomic, strong) IBOutlet UITableView *filterList;
@property (nonatomic, strong) IBOutlet UITextView *faceInfoTextView;
@property (nonatomic, strong) IBOutlet UIButton *selectImageButton;
@property (nonatomic, strong) IBOutlet UIButton *takePhotoButton;
@property (nonatomic, strong) UIPopoverController *filterPopoverController;
@property (nonatomic, strong) UINavigationController *filterNavigationController;
@property (nonatomic, strong) UIPopoverController *imagePopoverController;

- (IBAction)clearFiltersTouched:(id)sender;
- (IBAction)detectFacesTouched:(id)sender;
- (IBAction)clearFacesTouched:(id)sender;
- (IBAction)selectImageTouched:(id)sender;
- (IBAction)takePhotoTouched:(id)sender;
- (IBAction)saveToCameraRollTouched:(id)sender;

@end

