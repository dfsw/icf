//
//  ICFMovie.m
//  MyMovies
//
//  Created by Joe Keeley on 7/17/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import "ICFMovie.h"

@implementation ICFMovie

@dynamic lent;
@dynamic lentOn;
@dynamic movieDescription;
@dynamic timesWatched;
@dynamic title;
@dynamic year;
@dynamic lentToFriend;

- (NSString *)cellTitle
{
    return [NSString stringWithFormat:@"%@ (%@)",self.title,self.year];
}

- (NSString *)yearAndTitle
{
    return [NSString stringWithFormat:@"(%@) %@",self.year,self.title];
}

@end
