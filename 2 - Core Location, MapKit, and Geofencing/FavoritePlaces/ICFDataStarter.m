//
//  ICFDataStarter.m
//  FavoritePlaces
//
//  Created by Joe Keeley on 1/25/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "ICFDataStarter.h"

@implementation ICFDataStarter

+ (void)setupStarterData
{
    NSManagedObjectContext *moc =
    [kAppDelegate managedObjectContext];
    
    NSManagedObject *newPlace1 =
    [NSEntityDescription insertNewObjectForEntityForName:@"FavoritePlace"
                                  inManagedObjectContext:moc];
    
    [newPlace1 setValue:@"Denver Museum of Nature and Science" forKey:@"placeName"];
    [newPlace1 setValue:@"2001 Colorado Blvd" forKey:@"placeStreetAddress"];
    [newPlace1 setValue:@"Denver" forKey:@"placeCity"];
    [newPlace1 setValue:@"CO" forKey:@"placeState"];
    [newPlace1 setValue:@"80205" forKey:@"placePostal"];
    [newPlace1 setValue:@39.748039 forKey:@"latitude"];
    [newPlace1 setValue:@-104.943390 forKey:@"longitude"];
    [newPlace1 setValue:@NO forKey:@"goingNext"];
    [newPlace1 setValue:@NO forKey:@"displayProximity"];
    [newPlace1 setValue:@0.0 forKey:@"displayRadius"];

    NSManagedObject *newPlace2 =
    [NSEntityDescription insertNewObjectForEntityForName:@"FavoritePlace"
                                  inManagedObjectContext:moc];
    
    [newPlace2 setValue:@"Denver Art Museum" forKey:@"placeName"];
    [newPlace2 setValue:@"100 W 14th Ave Pkwy" forKey:@"placeStreetAddress"];
    [newPlace2 setValue:@"Denver" forKey:@"placeCity"];
    [newPlace2 setValue:@"CO" forKey:@"placeState"];
    [newPlace2 setValue:@"80204" forKey:@"placePostal"];
    [newPlace2 setValue:@39.737770 forKey:@"latitude"];
    [newPlace2 setValue:@-104.989598 forKey:@"longitude"];
    [newPlace2 setValue:@NO forKey:@"goingNext"];
    [newPlace2 setValue:@NO forKey:@"displayProximity"];
    [newPlace2 setValue:@0.0 forKey:@"displayRadius"];

    NSManagedObject *newPlace3 =
    [NSEntityDescription insertNewObjectForEntityForName:@"FavoritePlace"
                                  inManagedObjectContext:moc];
    
    [newPlace3 setValue:@"Colorado History Museum" forKey:@"placeName"];
    [newPlace3 setValue:@"1200 Broadway" forKey:@"placeStreetAddress"];
    [newPlace3 setValue:@"Denver" forKey:@"placeCity"];
    [newPlace3 setValue:@"CO" forKey:@"placeState"];
    [newPlace3 setValue:@"80203" forKey:@"placePostal"];
    [newPlace3 setValue:@39.735286 forKey:@"latitude"];
    [newPlace3 setValue:@-104.987536 forKey:@"longitude"];
    [newPlace3 setValue:@NO forKey:@"goingNext"];
    [newPlace3 setValue:@NO forKey:@"displayProximity"];
    [newPlace3 setValue:@0.0 forKey:@"displayRadius"];

    NSManagedObject *newPlace4 =
    [NSEntityDescription insertNewObjectForEntityForName:@"FavoritePlace"
                                  inManagedObjectContext:moc];
    
    [newPlace4 setValue:@"Coors Field" forKey:@"placeName"];
    [newPlace4 setValue:@"2299 Wewatta St" forKey:@"placeStreetAddress"];
    [newPlace4 setValue:@"Denver" forKey:@"placeCity"];
    [newPlace4 setValue:@"CO" forKey:@"placeState"];
    [newPlace4 setValue:@"80202" forKey:@"placePostal"];
    [newPlace4 setValue:@39.758895 forKey:@"latitude"];
    [newPlace4 setValue:@-104.994655 forKey:@"longitude"];
    [newPlace4 setValue:@NO forKey:@"goingNext"];
    [newPlace4 setValue:@NO forKey:@"displayProximity"];
    [newPlace4 setValue:@0.0 forKey:@"displayRadius"];

    NSManagedObject *newPlace5 =
    [NSEntityDescription insertNewObjectForEntityForName:@"FavoritePlace"
                                  inManagedObjectContext:moc];
    
    [newPlace5 setValue:@"City Park Golf Course" forKey:@"placeName"];
    [newPlace5 setValue:@"2500 York St" forKey:@"placeStreetAddress"];
    [newPlace5 setValue:@"Denver" forKey:@"placeCity"];
    [newPlace5 setValue:@"CO" forKey:@"placeState"];
    [newPlace5 setValue:@"80205" forKey:@"placePostal"];
    [newPlace5 setValue:@39.752612 forKey:@"latitude"];
    [newPlace5 setValue:@-104.954844 forKey:@"longitude"];
    [newPlace5 setValue:@NO forKey:@"goingNext"];
    [newPlace5 setValue:@NO forKey:@"displayProximity"];
    [newPlace5 setValue:@0.0 forKey:@"displayRadius"];

    NSManagedObject *newPlace6 =
    [NSEntityDescription insertNewObjectForEntityForName:@"FavoritePlace"
                                  inManagedObjectContext:moc];
    
    [newPlace6 setValue:@"Where I Am Going Next!" forKey:@"placeName"];
    [newPlace6 setValue:@39.745286 forKey:@"latitude"];
    [newPlace6 setValue:@-104.959935 forKey:@"longitude"];
    [newPlace6 setValue:@YES forKey:@"goingNext"];
    [newPlace6 setValue:@NO forKey:@"displayProximity"];
    [newPlace6 setValue:@0.0 forKey:@"displayRadius"];

    NSError *mocSaveError = nil;
    
    if ([moc save:&mocSaveError])
    {
        NSLog(@"Save completed successfully.");
    } else
    {
        NSLog(@"Save did not complete successfully. Error: %@",
              [mocSaveError localizedDescription]);
    }
    
}

@end
