//
//  ICFFilterCategoriesViewController.h
//  ImagePlayground
//
//  Created by Joe Keeley on 12/16/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICFViewController.h"

@interface ICFFilterCategoriesViewController : UITableViewController

@property (nonatomic, weak) id<ICFFilterProcessingDelegate> filterDelegate;

@end
