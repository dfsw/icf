//
//  ICFMainViewController.h
//  FavoritePlaces
//
//  Created by Joe Keeley on 1/21/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "ICFFavoritePlaceViewController.h"
#import <MapKit/MapKit.h>

@interface ICFMainViewController : UIViewController <ICFFavoritePlaceViewControllerDelegate, UIPopoverControllerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) UIPopoverController *favoritePlacePopoverController;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

-(IBAction)mapTypeSelectionChanged:(id)sender;

@end
