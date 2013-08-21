//
//  ICFFavoritePlace.h
//  FavoritePlaces
//
//  Created by Joe Keeley on 1/26/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface ICFFavoritePlace : NSManagedObject <MKAnnotation, MKOverlay>

@end
