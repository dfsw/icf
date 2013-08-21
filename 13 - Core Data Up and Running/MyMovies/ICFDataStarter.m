//
//  ICFDataStarter.m
//  MyMovies
//
//  Created by Joe Keeley on 6/25/12.
//  Copyright (c) 2012 Explore Systems, Inc. All rights reserved.
//

#import "ICFDataStarter.h"
#import "ICFAppDelegate.h"

@implementation ICFDataStarter

+ (void)setupStarterData
{
    NSManagedObjectContext *moc =
     [kAppDelegate managedObjectContext];

    NSManagedObject *newMovie1 =
     [NSEntityDescription insertNewObjectForEntityForName:@"Movie"
                                   inManagedObjectContext:moc];

    [newMovie1 setValue:@"The Matrix" forKey:@"title"];
    [newMovie1 setValue:@"1999" forKey:@"year"];

    [newMovie1 setValue:@"Why oh why didn't I take the BLUE pill? "
                 forKey:@"movieDescription"];

    [newMovie1 setValue:@NO forKey:@"lent"];
    [newMovie1 setValue:nil forKey:@"lentOn"];
    [newMovie1 setValue:@20 forKey:@"timesWatched"];
    
    NSManagedObject *newMovie2 = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:moc];
    [newMovie2 setValue:@"Casablanca" forKey:@"title"];
    [newMovie2 setValue:@"1942" forKey:@"year"];
    [newMovie2 setValue:@"Only the best movie ever made." forKey:@"movieDescription"];
    [newMovie2 setValue:@NO forKey:@"lent"];
    [newMovie2 setValue:nil forKey:@"lentOn"];
    [newMovie2 setValue:@4 forKey:@"timesWatched"];

    NSManagedObject *newMovie3 = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:moc];
    [newMovie3 setValue:@"The Princess Bride" forKey:@"title"];
    [newMovie3 setValue:@"1987" forKey:@"year"];
    [newMovie3 setValue:@"Is this a kissing book?" forKey:@"movieDescription"];
    [newMovie3 setValue:@NO forKey:@"lent"];
    [newMovie3 setValue:nil forKey:@"lentOn"];
    [newMovie3 setValue:@4 forKey:@"timesWatched"];

    NSManagedObject *newMovie4 =
    [NSEntityDescription insertNewObjectForEntityForName:@"Movie"
                                  inManagedObjectContext:moc];
    
    [newMovie4 setValue:@"The Bourne Identity" forKey:@"title"];
    [newMovie4 setValue:@"2002" forKey:@"year"];
    
    [newMovie4 setValue:@"Do you have ID?  Not really."
                 forKey:@"movieDescription"];
    
    [newMovie4 setValue:@NO forKey:@"lent"];
    [newMovie4 setValue:nil forKey:@"lentOn"];
    [newMovie4 setValue:@20 forKey:@"timesWatched"];

    NSManagedObject *newMovie5 =
    [NSEntityDescription insertNewObjectForEntityForName:@"Movie"
                                  inManagedObjectContext:moc];
    
    [newMovie5 setValue:@"The Matrix Reloaded" forKey:@"title"];
    [newMovie5 setValue:@"2003" forKey:@"year"];
    
    [newMovie5 setValue:@"Neo versus the machines!"
                 forKey:@"movieDescription"];
    
    [newMovie5 setValue:@NO forKey:@"lent"];
    [newMovie5 setValue:nil forKey:@"lentOn"];
    [newMovie5 setValue:@5 forKey:@"timesWatched"];

    NSManagedObject *newMovie6 =
    [NSEntityDescription insertNewObjectForEntityForName:@"Movie"
                                  inManagedObjectContext:moc];
    
    [newMovie6 setValue:@"The Matrix Revolutions" forKey:@"title"];
    [newMovie6 setValue:@"2003" forKey:@"year"];
    
    [newMovie6 setValue:@"More Matrix action with Neo and Agent Smith."
                 forKey:@"movieDescription"];
    
    [newMovie6 setValue:@NO forKey:@"lent"];
    [newMovie6 setValue:nil forKey:@"lentOn"];
    [newMovie6 setValue:@3 forKey:@"timesWatched"];

    NSManagedObject *newMovie7 =
    [NSEntityDescription insertNewObjectForEntityForName:@"Movie"
                                  inManagedObjectContext:moc];
    
    [newMovie7 setValue:@"The Maltese Falcon" forKey:@"title"];
    [newMovie7 setValue:@"1941" forKey:@"year"];
    
    [newMovie7 setValue:@"What is the Maltese Falcon? The stuff that dreams are made of."
                 forKey:@"movieDescription"];
    
    [newMovie7 setValue:@NO forKey:@"lent"];
    [newMovie7 setValue:nil forKey:@"lentOn"];
    [newMovie7 setValue:@5 forKey:@"timesWatched"];

    NSManagedObject *newMovie8 =
    [NSEntityDescription insertNewObjectForEntityForName:@"Movie"
                                  inManagedObjectContext:moc];
    
    [newMovie8 setValue:@"Notorious" forKey:@"title"];
    [newMovie8 setValue:@"1946" forKey:@"year"];
    
    [newMovie8 setValue:@"Nazis, spies, wine, and Ingrid Bergman.  Classic."
                 forKey:@"movieDescription"];
    
    [newMovie8 setValue:@NO forKey:@"lent"];
    [newMovie8 setValue:nil forKey:@"lentOn"];
    [newMovie8 setValue:@6 forKey:@"timesWatched"];

    
    //Friends
    NSManagedObject *newFriend1 =
     [NSEntityDescription insertNewObjectForEntityForName:@"Friend"
                                   inManagedObjectContext:moc];

    [newFriend1 setValue:@"Joe" forKey:@"friendName"];
    [newFriend1 setValue:@"joe@dragonforged.com" forKey:@"email"];

    NSManagedObject *newFriend2 = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:moc];
    [newFriend2 setValue:@"Kyle" forKey:@"friendName"];
    [newFriend2 setValue:@"kyle@dragonforged.com" forKey:@"email"];

    NSManagedObject *newFriend3 = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:moc];
    [newFriend3 setValue:@"Jared" forKey:@"friendName"];
    [newFriend3 setValue:@"jared@myfriend.com" forKey:@"email"];

    NSManagedObject *newFriend4 = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:moc];
    [newFriend4 setValue:@"Zoe" forKey:@"friendName"];
    [newFriend4 setValue:@"zoe@myfriend.com" forKey:@"email"];

    NSManagedObject *newFriend5 = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:moc];
    [newFriend5 setValue:@"Anna" forKey:@"friendName"];
    [newFriend5 setValue:@"anna@myfriend.com" forKey:@"email"];

    NSManagedObject *newFriend6 = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:moc];
    [newFriend6 setValue:@"Chris" forKey:@"friendName"];
    [newFriend6 setValue:@"chris@myfriend.com" forKey:@"email"];

    NSManagedObject *newFriend7 = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:moc];
    [newFriend7 setValue:@"Karl" forKey:@"friendName"];
    [newFriend7 setValue:@"Karl@myfriend.com" forKey:@"email"];

    
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
