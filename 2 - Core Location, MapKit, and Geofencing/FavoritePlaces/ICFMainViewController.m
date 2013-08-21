//
//  ICFMainViewController.m
//  FavoritePlaces
//
//  Created by Joe Keeley on 1/21/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "ICFMainViewController.h"
#import "ICFLocationManager.h"
#import <CoreLocation/CLLocation.h>
#import "ICFFavoritePlace.h"

@interface ICFMainViewController ()

- (void)updateMapAnnotations;
- (void)zoomMapToFitAnnotations;
- (void)locationUpdated:(NSNotification *)notification;
- (void)updateFavoritePlace:(ICFFavoritePlace *)place withPlacemark:(CLPlacemark *)placemark;
- (void)reverseGeocodeDraggedAnnotation:(ICFFavoritePlace *)place
               forAnnotationView:(MKAnnotationView *)annotationView;
@end

@implementation ICFMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateMapAnnotations];
}

- (void)viewWillAppear:(BOOL)animated
{
    ICFLocationManager *appLocationManager =
    [ICFLocationManager sharedLocationManager];
    
    [appLocationManager getLocationWithCompletionBlock:
     ^(CLLocation *location, NSError *error){
        if (error)
        {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"Location Error"
                                       message:error.localizedDescription
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles: nil];
            
            [alert show];
        }
         
        [self zoomMapToFitAnnotations];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:@"locationUpdated" object:nil]; 
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Favorite Place View Controller

- (void)favoritePlaceViewControllerDidFinish:(ICFFavoritePlaceViewController *)controller
{
    if (self.favoritePlacePopoverController)
    {
        [self.favoritePlacePopoverController dismissPopoverAnimated:YES];
        self.favoritePlacePopoverController = nil;
    } else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [self updateMapAnnotations];
    [self zoomMapToFitAnnotations];
}

- (MKMapItem *)currentLocationMapItem
{
    CLLocation *currentLocation = self.mapView.userLocation.location;
    CLLocationCoordinate2D currentCoordinate = currentLocation.coordinate;
    
    MKPlacemark *currentPlacemark =
    [[MKPlacemark alloc] initWithCoordinate:currentCoordinate
                          addressDictionary:nil];
    
    MKMapItem *currentItem =
    [[MKMapItem alloc] initWithPlacemark:currentPlacemark];

    return currentItem;
}

- (void)displayDirectionsForRoute:(MKRoute *)route
{
    [self.mapView addOverlay:route.polyline];
    
    if (self.favoritePlacePopoverController)
    {
        [self.favoritePlacePopoverController
         dismissPopoverAnimated:YES];
        
        self.favoritePlacePopoverController = nil;
    } else
    {
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.favoritePlacePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addFavoritePlace"]) {
        [[segue destinationViewController] setDelegate:self];
        UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        self.favoritePlacePopoverController = popoverController;
        popoverController.delegate = self;
    }
    if ([[segue identifier] isEqualToString:@"showFavoritePlaceDetail"]) {
        MKAnnotationView *view = (MKAnnotationView *)sender;
        ICFFavoritePlace *place = (ICFFavoritePlace *)[view annotation];
        
        ICFFavoritePlaceViewController *fpvc = (ICFFavoritePlaceViewController *)[segue destinationViewController];
        [fpvc setDelegate:self];
        [fpvc setFavoritePlaceID:[place objectID]];
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.favoritePlacePopoverController) {
        [self.favoritePlacePopoverController dismissPopoverAnimated:YES];
        self.favoritePlacePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"addFavoritePlace" sender:sender];
    }
}

#pragma mark - 
- (IBAction)mapTypeSelectionChanged:(id)sender
{
    UISegmentedControl *mapSelection =
    (UISegmentedControl *)sender;
    
    switch (mapSelection.selectedSegmentIndex) {
        case 0:
            [self.mapView setMapType:MKMapTypeStandard];
            break;
        case 1:
            [self.mapView setMapType:MKMapTypeSatellite];
            break;
        case 2:
            [self.mapView setMapType:MKMapTypeHybrid];
            break;
            
        default:
            break;
    }
}

#pragma mark - Map Methods

- (void)updateMapAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    
    CLLocationManager *locManager =
    [[ICFLocationManager sharedLocationManager] locationManager];

    NSSet *monitoredRegions = [locManager monitoredRegions];

    for (CLRegion *region in monitoredRegions) {
        [locManager stopMonitoringForRegion:region];
    }

    NSFetchRequest *placesRequest =
    [[NSFetchRequest alloc] initWithEntityName:@"FavoritePlace"];

    NSManagedObjectContext *moc = kAppDelegate.managedObjectContext;

    NSError *error = nil;

    NSArray *places = [moc executeFetchRequest:placesRequest
                                         error:&error];

    if (error) {
        NSLog(@"Core Data fetch error %@, %@", error,
        [error userInfo]);
    }

    [self.mapView addAnnotations:places];
    
    for (ICFFavoritePlace *favPlace in places) {

        BOOL displayOverlay =
        [[favPlace valueForKeyPath:@"displayProximity"] boolValue];

        if (displayOverlay)
        {
            [self.mapView addOverlay:favPlace];
            
            NSString *placeObjectID =
            [[[favPlace objectID] URIRepresentation] absoluteString];


            CLLocationDistance monitorRadius =
            [[favPlace valueForKeyPath:@"displayRadius"] floatValue];

            CLRegion *region = [[CLRegion alloc]
            initCircularRegionWithCenter:[favPlace coordinate]
                                radius:monitorRadius
                                identifier:placeObjectID];

            [locManager startMonitoringForRegion:region];
        }
    }
}

- (void)zoomMapToFitAnnotations
{
    CLLocationCoordinate2D maxCoordinate =
    CLLocationCoordinate2DMake(-90.0, -180.0);

    CLLocationCoordinate2D minCoordinate =
    CLLocationCoordinate2DMake(90.0, 180.0);
    
    NSMutableArray *currentPlaces = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
    [currentPlaces removeObject:self.mapView.userLocation];

    maxCoordinate.latitude =
    [[currentPlaces valueForKeyPath:@"@max.latitude"] doubleValue];
        
    minCoordinate.latitude =
    [[currentPlaces valueForKeyPath:@"@min.latitude"] doubleValue];

    maxCoordinate.longitude =
    [[currentPlaces valueForKeyPath:@"@max.longitude"] doubleValue];

    minCoordinate.longitude =
    [[currentPlaces valueForKeyPath:@"@min.longitude"] doubleValue];
    
    CLLocationCoordinate2D centerCoordinate;

    centerCoordinate.longitude =
    (minCoordinate.longitude + maxCoordinate.longitude) / 2.0;

    centerCoordinate.latitude =
    (minCoordinate.latitude + maxCoordinate.latitude) / 2.0;
    
    MKCoordinateSpan span;

    span.longitudeDelta =
    (maxCoordinate.longitude - minCoordinate.longitude) * 1.2;

    span.latitudeDelta =
    (maxCoordinate.latitude - minCoordinate.latitude) * 1.2;
    
    MKCoordinateRegion newRegion =
    MKCoordinateRegionMake(centerCoordinate, span);

    [self.mapView setRegion:newRegion
                   animated:YES];
}

- (void)locationUpdated:(NSNotification *)notification
{
}

#pragma mark - MapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    MKAnnotationView *view = nil;

    ICFFavoritePlace *place = (ICFFavoritePlace *)annotation;

    if ([[place valueForKeyPath:@"goingNext"] boolValue])
    {
        view = (MKAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:@"arrow"];

        if (view == nil)
        {
            view = [[MKAnnotationView alloc]
            initWithAnnotation:annotation reuseIdentifier:@"arrow"];
        }
            
        [view setCanShowCallout:YES];
        [view setDraggable:YES];
        [view setImage:[UIImage imageNamed:@"next_arrow"]];

        UIImageView *leftView = [[UIImageView alloc]
        initWithImage:[UIImage imageNamed:@"annotation_view_arrow"]];

        [view setLeftCalloutAccessoryView:leftView];
        [view setRightCalloutAccessoryView:nil];
        
    } else
    {
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];

        if (pinView == nil)
        {
            pinView = [[MKPinAnnotationView alloc]
            initWithAnnotation:annotation reuseIdentifier:@"pin"];
        }

        [pinView setPinColor:MKPinAnnotationColorRed];
        [pinView setCanShowCallout:YES];
        [pinView setDraggable:NO];

        UIImageView *leftView = [[UIImageView alloc]
        initWithImage:[UIImage imageNamed:@"annotation_view_star"]];

        [pinView setLeftCalloutAccessoryView:leftView];

        UIButton* rightButton = [UIButton buttonWithType:
                                 UIButtonTypeDetailDisclosure];

        [pinView setRightCalloutAccessoryView:rightButton];
        view = pinView;
    }

    return view;
}

- (void)mapView:(MKMapView *)mapView
regionDidChangeAnimated:(BOOL)animated
{
    MKCoordinateRegion newRegion = [mapView region];
    CLLocationCoordinate2D center = newRegion.center;
    MKCoordinateSpan span = newRegion.span;
    
    NSLog(@"New map region center: <%f/%f>, span: <%f/%f>",
    center.latitude,center.longitude,span.latitudeDelta,
    span.longitudeDelta);
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            viewForOverlay:(id < MKOverlay >)overlay
{
    MKOverlayRenderer *returnView = nil;
    
    if ([overlay isKindOfClass:[ICFFavoritePlace class]]) {
        ICFFavoritePlace *place = (ICFFavoritePlace *)overlay;
        
        CLLocationDistance radius =
        [[place valueForKeyPath:@"displayRadius"] floatValue];
        
        MKCircle *circle =
        [MKCircle circleWithCenterCoordinate:[overlay coordinate]
                                      radius:radius];
        
        MKCircleRenderer *circleView =
        [[MKCircleRenderer alloc] initWithCircle:circle];
        
        circleView.fillColor =
        [[UIColor redColor] colorWithAlphaComponent:0.2];
        
        circleView.strokeColor =
        [[UIColor redColor] colorWithAlphaComponent:0.7];
        
        circleView.lineWidth = 3;
        
        returnView = circleView;
    }
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *line = (MKPolyline *)overlay;
        
        MKPolylineRenderer *polylineRenderer =
        [[MKPolylineRenderer alloc] initWithPolyline:line];
        
        [polylineRenderer setLineWidth:3.0];
        [polylineRenderer setFillColor:[UIColor blueColor]];
        [polylineRenderer setStrokeColor:[UIColor blueColor]];
        returnView = polylineRenderer;
    }

    return returnView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"showFavoritePlaceDetail" sender:view];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding) {
        
        ICFFavoritePlace *draggedPlace =
        (ICFFavoritePlace *)[annotationView annotation];

        UIActivityIndicatorViewStyle whiteStyle =
        UIActivityIndicatorViewStyleWhite;

        UIActivityIndicatorView *activityView =
        [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:whiteStyle];

        [activityView startAnimating];
        [annotationView setLeftCalloutAccessoryView:activityView];

        [self reverseGeocodeDraggedAnnotation:draggedPlace
                     forAnnotationView:annotationView];
    }
}

#pragma mark - 
- (void)reverseGeocodeDraggedAnnotation:(ICFFavoritePlace *)place
               forAnnotationView:(MKAnnotationView *)annotationView
{
    CLGeocoder *geocoder =
    [[ICFLocationManager sharedLocationManager] geocoder];
    
    CLLocationCoordinate2D draggedCoord = [place coordinate];

    CLLocation *draggedLocation =
    [[CLLocation alloc] initWithLatitude:draggedCoord.latitude
                               longitude:draggedCoord.longitude];
    
    [geocoder reverseGeocodeLocation:draggedLocation
    completionHandler:^(NSArray *placemarks, NSError *error) {
        
        UIImage *arrowImage =
        [UIImage imageNamed:@"annotation_view_arrow"];
        
        UIImageView *leftView =
        [[UIImageView alloc] initWithImage:arrowImage];
        
        [annotationView setLeftCalloutAccessoryView:leftView];
        
        if (error)
        {
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
                [self updateFavoritePlace:place withPlacemark:placemark];
            }
            
        }
    }];
}

- (void)updateFavoritePlace:(ICFFavoritePlace *)place
              withPlacemark:(CLPlacemark *)placemark
{
    [kAppDelegate.managedObjectContext performBlock:^{
        NSString *newName =
        [NSString stringWithFormat:@"Next: %@",placemark.name];
        
        [place setValue:newName forKey:@"placeName"];
        
        NSString *newStreetAddress =
        [NSString stringWithFormat:@"%@ %@",
        placemark.subThoroughfare, placemark.thoroughfare];
        
        [place setValue:newStreetAddress
                 forKey:@"placeStreetAddress"];
        
        [place setValue:placemark.subAdministrativeArea
                 forKey:@"placeCity"];
        
        [place setValue:placemark.postalCode
                 forKey:@"placePostal"];
        
        [place setValue:placemark.administrativeArea
                 forKey:@"placeState"];
        
        NSError *saveError = nil;
        [kAppDelegate.managedObjectContext save:&saveError];
        if (saveError) {
            NSLog(@"Save Error: %@",saveError.localizedDescription);
        }
    }];

}

@end
