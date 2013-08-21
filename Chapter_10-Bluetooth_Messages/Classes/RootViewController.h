//
//  RootViewController.h
//  Bluetooth Messages
//
//  Created by Kyle Richter on 3/1/12.
//  Copyright 2012 Dragon Forged Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface RootViewController : UIViewController <GKPeerPickerControllerDelegate>
{
    
    GKPeerPickerController *peerPicker;
    
}
- (IBAction)connect:(id)sender;

@end
