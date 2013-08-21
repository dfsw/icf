//
//  ICFChatViewController.h
//  Bluetooth Messages
//
//  Created by Kyle Richter on 3/2/12.
//  Copyright (c) 2012 Dragon Forged Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface ICFChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, GKSessionDelegate, UITextFieldDelegate>
{
    IBOutlet UITableView *chatTableView;
    
    NSMutableArray *chatObjectArray;   
    
    GKSession *currentSession;
    NSString *peerID;
    
    IBOutlet UITextField *inputTextField;
    IBOutlet UIButton *sendButton;
}

@property(nonatomic, retain) GKSession *currentSession;
@property(nonatomic, retain) NSString *peerID;

- (IBAction)sendMessage:(id)sender;

@end
