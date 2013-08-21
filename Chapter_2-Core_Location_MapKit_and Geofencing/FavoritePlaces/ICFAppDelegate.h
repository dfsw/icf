//
//  ICFAppDelegate.h
//  FavoritePlaces
//
//  Created by Joe Keeley on 1/21/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
