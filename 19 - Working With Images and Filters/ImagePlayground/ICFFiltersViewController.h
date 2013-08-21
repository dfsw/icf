//
//  ICFFiltersViewController.h
//  ImagePlayground
//
//  Created by Joe Keeley on 12/16/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICFViewController.h"

@interface ICFFiltersViewController : UITableViewController

@property (strong, nonatomic) NSString *selectedCategory;
@property (nonatomic, strong) id<ICFFilterProcessingDelegate> filterDelegate;

@end
