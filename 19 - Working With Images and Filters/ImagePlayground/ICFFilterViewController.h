//
//  ICFFilterViewController.h
//  ImagePlayground
//
//  Created by Joe Keeley on 12/21/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICFViewController.h"
#import <GLKit/GLKit.h>

@protocol ICFFilterEditingDelegate <NSObject>

- (void)updateFilterAttribute:(NSString *)attributeKey withValue:(id)value;

@end

@interface ICFFilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ICFFilterEditingDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) CIFilter *selectedFilter;
@property (nonatomic, strong) IBOutlet UITableView *filterTableView;
@property (nonatomic, strong) IBOutlet UILabel *filterNameLabel;
@property (nonatomic, strong) IBOutlet UIView *previewImageContainer;
@property (nonatomic, strong) IBOutlet UIImageView *previewImageView;
@property (nonatomic, strong) IBOutlet GLKView *livePreview;
@property (nonatomic, strong) id<ICFFilterProcessingDelegate> filterDelegate;

@end

