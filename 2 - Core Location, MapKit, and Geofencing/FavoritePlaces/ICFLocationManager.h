//
//  ICFLocationManager.h
//  FavoritePlaces
//
//  Created by Joe Keeley on 1/23/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^ICFLocationUpdateCompletionBlock)(CLLocation *location, NSError *error);

@interface ICFLocationManager : NSObject <CLLocationManagerDelegate>

+ (ICFLocationManager *)sharedLocationManager;

@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL hasLocation;
@property (nonatomic, strong) NSError *locationError;
@property (strong, nonatomic) CLGeocoder *geocoder;

- (void)getLocationWithCompletionBlock:(ICFLocationUpdateCompletionBlock)block;

@end
