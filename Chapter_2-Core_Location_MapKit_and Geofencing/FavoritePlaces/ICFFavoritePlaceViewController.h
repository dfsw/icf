//
//  ICFFavoritePlaceViewController.h
//  FavoritePlaces
//
//  Created by Joe Keeley on 1/27/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICFLocationManager.h"
#import <MapKit/MapKit.h>

@class ICFFavoritePlaceViewController;

@protocol ICFFavoritePlaceViewControllerDelegate
- (void)favoritePlaceViewControllerDidFinish:(ICFFavoritePlaceViewController *)controller;
- (MKMapItem *)currentLocationMapItem;
- (void)displayDirectionsForRoute:(MKRoute *)route;
@end

@interface ICFFavoritePlaceViewController : UIViewController

@property (weak, nonatomic) id <ICFFavoritePlaceViewControllerDelegate> delegate;

@property (nonatomic, strong) NSManagedObjectID *favoritePlaceID;

@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UITextField *addressTextField;
@property (nonatomic, strong) IBOutlet UITextField *cityTextField;
@property (nonatomic, strong) IBOutlet UITextField *stateTextField;
@property (nonatomic, strong) IBOutlet UITextField *postalTextField;
@property (nonatomic, strong) IBOutlet UITextField *latitudeTextField;
@property (nonatomic, strong) IBOutlet UITextField *longitudeTextField;
@property (nonatomic, strong) IBOutlet UILabel *geofenceLabel;
@property (nonatomic, strong) IBOutlet UISwitch *displayProximitySwitch;
@property (nonatomic, strong) IBOutlet UILabel *displayRadiusLabel;
@property (nonatomic, strong) IBOutlet UISlider *displayRadiusSlider;
@property (nonatomic, strong) IBOutlet UIButton *geocodeNowButton;

- (IBAction)saveButtonTouched:(id)sender;
- (IBAction)cancelButtonTouched:(id)sender;
- (IBAction)geocodeLocationTouched:(id)sender;
- (IBAction)displayProxitySwitchChanged:(id)sender;
- (IBAction)displayProxityRadiusChanged:(id)sender;
- (IBAction)getDirectionsButtonTouched:(id)sender;
- (IBAction)getDirectionsToButtonTouched:(id)sender;

@end
