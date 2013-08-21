//
//  ICFFriendChooserViewController.h
//  MyMovies
//
//  Created by Joe Keeley on 7/7/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ICFFriendChooserDelegate <NSObject>
- (void)chooserSelectedFriend:(NSManagedObject *)friend;
@end

@interface ICFFriendChooserViewController : UITableViewController

@property (weak, nonatomic) NSManagedObject *selectedFriend;
@property (strong, nonatomic) NSArray *friendList;
@property (weak, nonatomic) id<ICFFriendChooserDelegate> delegate;

@end
