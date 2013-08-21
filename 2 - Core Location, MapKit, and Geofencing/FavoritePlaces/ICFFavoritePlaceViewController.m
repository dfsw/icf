//
//  ICFFavoritePlaceViewController.m
//  FavoritePlaces
//
//  Created by Joe Keeley on 1/27/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "ICFFavoritePlaceViewController.h"
#import "ICFFavoritePlace.h"

@interface ICFFavoritePlaceViewController ()

@property (nonatomic, strong) ICFFavoritePlace *favoritePlace;

@end

@implementation ICFFavoritePlaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.favoritePlaceID)
    {
        [kAppDelegate.managedObjectContext performBlock:^{
            self.favoritePlace = (ICFFavoritePlace *)[kAppDelegate.managedObjectContext objectWithID:self.favoritePlaceID];
            
            [self.nameTextField setText:[self.favoritePlace valueForKey:@"placeName"]];
            [self.addressTextField setText:[self.favoritePlace valueForKey:@"placeStreetAddress"]];
            [self.cityTextField setText:[self.favoritePlace valueForKey:@"placeCity"]];
            [self.stateTextField setText:[self.favoritePlace valueForKey:@"placeState"]];
            [self.postalTextField setText:[self.favoritePlace valueForKey:@"placePostal"]];
            [self.latitudeTextField setText:[[self.favoritePlace valueForKey:@"latitude"] stringValue]];
            [self.longitudeTextField setText:[[self.favoritePlace valueForKey:@"longitude"] stringValue]];
            [self.displayProximitySwitch setOn:[[self.favoritePlace valueForKey:@"displayProximity"] boolValue]];
            [self.displayRadiusSlider setValue:[[self.favoritePlace valueForKey:@"displayRadius"] floatValue]];
            BOOL hideDisplayRadius = ![self.displayProximitySwitch isOn];
            [self.displayRadiusLabel setHidden:hideDisplayRadius];
            [self.displayRadiusSlider setHidden:hideDisplayRadius];
            [self displayProxityRadiusChanged:nil];
        }];
    } else
    {
        [self.displayProximitySwitch setOn:NO];
    }

    BOOL hideGeofence =
    ![CLLocationManager regionMonitoringAvailable];

    [self.displayProximitySwitch setHidden:hideGeofence];

    if (hideGeofence)
    {
        [self.geofenceLabel setText:@"Geofence N/A"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonTouched:(id)sender
{
    [kAppDelegate.managedObjectContext performBlock:^{
        if (!self.favoritePlace) {
            self.favoritePlace =
            [NSEntityDescription insertNewObjectForEntityForName:@"FavoritePlace"
                                          inManagedObjectContext:kAppDelegate.managedObjectContext];
        }
        [self.favoritePlace setValue:[self.nameTextField text] forKeyPath:@"placeName"];
        [self.favoritePlace setValue:[self.addressTextField text] forKeyPath:@"placeStreetAddress"];
        [self.favoritePlace setValue:[self.cityTextField text] forKeyPath:@"placeCity"];
        [self.favoritePlace setValue:[self.stateTextField text] forKeyPath:@"placeState"];
        [self.favoritePlace setValue:[self.postalTextField text] forKeyPath:@"placePostal"];
        NSNumber *latNumber = [NSNumber numberWithFloat:[self.latitudeTextField.text floatValue]];
        [self.favoritePlace setValue:latNumber forKeyPath:@"latitude"];
        NSNumber *longNumber = [NSNumber numberWithFloat:[self.longitudeTextField.text floatValue]];
        [self.favoritePlace setValue:longNumber forKeyPath:@"longitude"];
        NSNumber *displayProx = [NSNumber numberWithBool:[self.displayProximitySwitch isOn]];
        [self.favoritePlace setValue:displayProx forKeyPath:@"displayProximity"];
        NSNumber *displayRadius = [NSNumber numberWithFloat:[self.displayRadiusSlider value]];
        [self.favoritePlace setValue:displayRadius forKeyPath:@"displayRadius"];
        
        NSError *saveError = nil;
        [kAppDelegate.managedObjectContext save:&saveError];
        if (saveError)
        {
            NSLog(@"Core Data save error %@, %@", saveError, [saveError userInfo]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Core Data Error" message:saveError.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        } else
        {
            [self.delegate favoritePlaceViewControllerDidFinish:self];
        }
    }];
}

- (IBAction)cancelButtonTouched:(id)sender
{
    [self.delegate favoritePlaceViewControllerDidFinish:self];
}

- (IBAction)geocodeLocationTouched:(id)sender
{
    NSString *geocodeString = @"";
    if ([self.addressTextField.text length] > 0) {
        geocodeString = self.addressTextField.text;
    }
    if ([self.cityTextField.text length] > 0) {
        if ([geocodeString length] > 0) {
            
            geocodeString =
            [geocodeString stringByAppendingFormat:@", %@",
            self.cityTextField.text];
            
        } else
        {
            geocodeString = self.cityTextField.text;
        }
    }
    if ([self.stateTextField.text length] > 0) {
        if ([geocodeString length] > 0) {
            
            geocodeString =
            [geocodeString stringByAppendingFormat:@", %@",
            self.stateTextField.text];
            
        } else
        {
            geocodeString = self.stateTextField.text;
        }
    }
    if ([self.postalTextField.text length] > 0) {
        if ([geocodeString length] > 0) {
            
            geocodeString =
            [geocodeString stringByAppendingFormat:@" %@",
             self.postalTextField.text];
            
        } else
        {
            geocodeString = self.postalTextField.text;
        }
    }
    
    [self.latitudeTextField setText:@"Geocoding..."];
    [self.longitudeTextField setText:@"Geocoding..."];

    [self.geocodeNowButton setTitle:@"Geocoding now..."
                           forState:UIControlStateDisabled];

    [self.geocodeNowButton setEnabled:NO];
    
    CLGeocoder *geocoder =
    [[ICFLocationManager sharedLocationManager] geocoder];
    
    [geocoder geocodeAddressString:geocodeString
    completionHandler:^(NSArray *placemarks, NSError *error) {
        
        [self.geocodeNowButton setEnabled:YES];
        if (error)
        {
            [self.latitudeTextField setText:@"Not found"];
            [self.longitudeTextField setText:@"Not found"];

            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"Geocoding Error"
                                       message:error.localizedDescription
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles: nil];

            [alert show];
        } else
        {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks lastObject];
                
                NSString *latString =
                [NSString stringWithFormat:@"%f",
                placemark.location.coordinate.latitude];
                
                [self.latitudeTextField setText:latString];
                
                NSString *longString =
                [NSString stringWithFormat:@"%f",
                 placemark.location.coordinate.longitude];
                
                [self.longitudeTextField setText:longString];
            }            
        }
    }];
}

- (IBAction)displayProxitySwitchChanged:(id)sender
{
    BOOL hideDisplayRadius = ![self.displayProximitySwitch isOn];
    [self.displayRadiusLabel setHidden:hideDisplayRadius];
    [self.displayRadiusSlider setHidden:hideDisplayRadius];
    [self displayProxityRadiusChanged:nil];
}

- (IBAction)displayProxityRadiusChanged:(id)sender
{
    NSString *radiusString = [NSString stringWithFormat:@"Geofence Proximity Radius (%3.0f m):",[self.displayRadiusSlider value]];
    [self.displayRadiusLabel setText:radiusString];
}

- (IBAction)getDirectionsButtonTouched:(id)sender
{
    CLLocationCoordinate2D destination =
    [self.favoritePlace coordinate];

    MKPlacemark *destinationPlacemark =
    [[MKPlacemark alloc] initWithCoordinate:destination
                          addressDictionary:nil];

    MKMapItem *destinationItem =
    [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];

    destinationItem.name =
    [self.favoritePlace valueForKey:@"placeName"];

    NSDictionary *launchOptions = @{
    MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
    MKLaunchOptionsMapTypeKey : [NSNumber numberWithInt:MKMapTypeStandard]
    };
    
    NSArray *mapItems = @[destinationItem];

    BOOL success = [MKMapItem openMapsWithItems:mapItems
                             launchOptions:launchOptions];

    if (!success)
    {
        NSLog(@"Failed to open Maps.app");
    }
}

- (IBAction)getDirectionsToButtonTouched:(id)sender
{
    CLLocationCoordinate2D destination =
    [self.favoritePlace coordinate];

    MKPlacemark *destinationPlacemark =
    [[MKPlacemark alloc] initWithCoordinate:destination
                          addressDictionary:nil];

    MKMapItem *destinationItem =
    [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];

    MKMapItem *currentMapItem =
    [self.delegate currentLocationMapItem];

    MKDirectionsRequest *directionsRequest =
    [[MKDirectionsRequest alloc] init];

    [directionsRequest setDestination:destinationItem];
    [directionsRequest setSource:currentMapItem];
    
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:directionsRequest];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error){
        if (error) {
            
            NSString *dirMessage =
            [NSString stringWithFormat:@"Failed to get directions: %@",
             error.localizedDescription];
            
            UIAlertView *dirAlert =
            [[UIAlertView alloc] initWithTitle:@"Directions Error"
                                       message:dirMessage
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles: nil];
            
            [dirAlert show];
        }
        else
        {
            if ([response.routes count] > 0) {
                MKRoute *firstRoute = response.routes[0];
                NSLog(@"Directions received.  Steps for route 1 are: ");
                NSInteger stepNumber = 1;
                for (MKRouteStep *step in firstRoute.steps) {
                    
                    NSLog(@"Step %d, %f meters: %@",stepNumber,
                          step.distance,step.instructions);
                    
                    stepNumber++;
                }
                [self.delegate displayDirectionsForRoute:firstRoute];
            }
            else
            {
                NSString *dirMessage = @"No directions available";
                
                UIAlertView *dirAlert =
                [[UIAlertView alloc] initWithTitle:@"No Directions"
                                           message:dirMessage
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles: nil];
                
                [dirAlert show];
            }
        }
    }];
}


@end
