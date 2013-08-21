//
//  ICFMovie.h
//  MyMovies
//
//  Created by Joe Keeley on 7/17/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ICFMovie : NSManagedObject

@property (nonatomic, retain) NSNumber *lent;
@property (nonatomic, retain) NSDate *lentOn;
@property (nonatomic, retain) NSString *movieDescription;
@property (nonatomic, retain) NSNumber *timesWatched;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSManagedObject *lentToFriend;

- (NSString *)cellTitle;
- (NSString *)yearAndTitle;

@end
