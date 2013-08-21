//
//  RootViewController.m
//  Bluetooth Messages
//
//  Created by Kyle Richter on 3/1/12.
//  Copyright 2012 Dragon Forged Software. All rights reserved.
//

#import "RootViewController.h"
#import "ICFChatViewController.h"


@implementation RootViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

}

#pragma mark -
#pragma mark Actions

- (IBAction)connect:(id)sender 
{
    peerPicker = [[GKPeerPickerController alloc] init];
	peerPicker.delegate = self;
	peerPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;    
	[peerPicker show];  	
}


#pragma mark -
#pragma mark GKPeerPickerControllerDelegate Methods

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    NSLog(@"Peer Selected");
        
    [picker dismiss];
    [picker release];
    
    ICFChatViewController *chatViewController = [[ICFChatViewController alloc] init];
    chatViewController.currentSession = session;
    chatViewController.peerID = peerID;

    [[self navigationController] pushViewController:chatViewController animated:YES];
    [chatViewController release];
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    picker.delegate = nil;
    [picker release];
}

#pragma mark -
#pragma mark Memory management


- (void)dealloc 
{
    [super dealloc];
}


@end

