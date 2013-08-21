//
//  ICFLocationManager.m
//  FavoritePlaces
//
//  Created by Joe Keeley on 1/23/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "ICFLocationManager.h"
#import "ICFFavoritePlace.h"

static ICFLocationManager *_sharedLocationManager;

@interface ICFLocationManager ()
@property (strong, nonatomic) NSMutableArray *completionBlocks;
@end

@implementation ICFLocationManager

+ (ICFLocationManager *)sharedLocationManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocationManager = [[ICFLocationManager alloc] init];
    });
    
    return _sharedLocationManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setLocationManager:[[CLLocationManager alloc] init]];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager setDistanceFilter:100.0f];
        [self.locationManager setDelegate:self];
        [self setCompletionBlocks:[[NSMutableArray alloc] initWithCapacity:3.0]];
        [self setGeocoder:[[CLGeocoder alloc] init]];
    }
    
    return self;
}

#pragma mark -
- (void)getLocationWithCompletionBlock:(ICFLocationUpdateCompletionBlock)block
{
    if (block)
    {
        [self.completionBlocks addObject:[block copy]];
    }
    
    if (self.hasLocation)
    {
        for (ICFLocationUpdateCompletionBlock completionBlock in self.completionBlocks)
        {
            completionBlock(self.location, nil);
        }
        if ([self.completionBlocks count] == 0) {
            //notify map view of change to location when not requested
            [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdated" object:nil];
        }

        [self.completionBlocks removeAllObjects];
    }
    
    if (self.locationError) {
        for (ICFLocationUpdateCompletionBlock completionBlock in self.completionBlocks)
        {
            completionBlock(nil, self.locationError);
        }
        [self.completionBlocks removeAllObjects];
    }
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    //Filter out inaccurate points
    CLLocation *lastLocation = [locations lastObject];
    if(lastLocation.horizontalAccuracy < 0)
    {
        return;
    }
    
    [self setLocation:lastLocation];
    [self setHasLocation:YES];
    [self setLocationError:nil];
    
    CLLocationCoordinate2D coord = lastLocation.coordinate;
    NSLog(@"Location lat/long: %f,%f",coord.latitude, coord.longitude);
    
    CLLocationAccuracy horizontalAccuracy =
    lastLocation.horizontalAccuracy;

    NSLog(@"Horizontal accuracy: %f meters",horizontalAccuracy);

    CLLocationDistance altitude = lastLocation.altitude;
    NSLog(@"Location altitude: %f meters",altitude);

    CLLocationAccuracy verticalAccuracy =
    lastLocation.verticalAccuracy;

    NSLog(@"Vertical accuracy: %f meters",verticalAccuracy);

    NSDate *timestamp = lastLocation.timestamp;
    NSLog(@"Timestamp: %@",timestamp);
    
    CLLocationSpeed speed = lastLocation.speed;
    NSLog(@"Speed: %f meters per second",speed);

    CLLocationDirection direction = lastLocation.course;
    NSLog(@"Course: %f degrees from true north",direction);
    
    [self getLocationWithCompletionBlock:nil];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    [self setLocationError:error];
    [self getLocationWithCompletionBlock:nil];
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied)
    {
        // Location services are disabled on the device.
        [self.locationManager stopUpdatingLocation];
        
        NSString *errorMessage =
        @"Location Services Permission Denied for this app.  Visit Settings.app to allow.";
        
        NSDictionary *errorInfo =
        @{NSLocalizedDescriptionKey : errorMessage};
        
        NSError *deniedError =
        [NSError errorWithDomain:@"ICFLocationErrorDomain"
                            code:1
                        userInfo:errorInfo];
        
        [self setLocationError:deniedError];
        [self getLocationWithCompletionBlock:nil];
    }
    if (status == kCLAuthorizationStatusAuthorized)
    {
        // Location services have just been authorized on the device, start updating now.
        [self.locationManager startUpdatingLocation];
        [self setLocationError:nil];
    }
}

#pragma mark - Region Monitoring delegate methods

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    NSString *placeIdentifier = [region identifier];
    NSURL *placeIDURL = [NSURL URLWithString:placeIdentifier];

    NSManagedObjectID *placeObjectID =
    [kAppDelegate.persistentStoreCoordinator
    managedObjectIDForURIRepresentation:placeIDURL];
    
    [kAppDelegate.managedObjectContext performBlock:^{
        
        ICFFavoritePlace *place =
        (ICFFavoritePlace *)[kAppDelegate.managedObjectContext
        objectWithID:placeObjectID];

        NSNumber *distance = [place valueForKey:@"displayRadius"];
        NSString *placeName = [place valueForKey:@"placeName"];
        
        NSString *baseMessage =
        @"Favorite Place %@ nearby - within %@ meters.";
        
        NSString *proximityMessage =
        [NSString stringWithFormat:baseMessage,placeName,distance];
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Favorite Nearby!"
                                   message:proximityMessage
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles: nil];
        [alert show];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSString *placeIdentifier = [region identifier];
    NSURL *placeIDURL = [NSURL URLWithString:placeIdentifier];
    
    NSManagedObjectID *placeObjectID =
    [kAppDelegate.persistentStoreCoordinator
     managedObjectIDForURIRepresentation:placeIDURL];
    
    [kAppDelegate.managedObjectContext performBlock:^{
        
        ICFFavoritePlace *place =
        (ICFFavoritePlace *)[kAppDelegate.managedObjectContext
                             objectWithID:placeObjectID];
        
        NSNumber *distance = [place valueForKey:@"displayRadius"];
        NSString *placeName = [place valueForKey:@"placeName"];
        
        NSString *baseMessage =
        @"Favorite Place %@ Geofence exited.";
        
        NSString *proximityMessage =
        [NSString stringWithFormat:baseMessage,placeName,distance];
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Geofence exited"
                                   message:proximityMessage
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles: nil];
        [alert show];
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    
}

@end
