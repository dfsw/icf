//
//  ICFChatViewController.m
//  Bluetooth Messages
//
//  Created by Kyle Richter on 3/2/12.
//  Copyright (c) 2012 Dragon Forged Software. All rights reserved.
//

#import "ICFChatViewController.h"

#define kMessageTag 101
#define kBackgroundTag 102

@implementation ICFChatViewController

@synthesize currentSession, peerID;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [inputTextField becomeFirstResponder];
    chatObjectArray = [[NSMutableArray alloc] init];
    
    [self.currentSession setDelegate: self];
    [self.currentSession setDataReceiveHandler:self withContext:nil];
    
    [sendButton setEnabled: NO];
    [inputTextField setDelegate: self];
    
    NSString *peerDisplayName = [self.currentSession displayNameForPeer: self.peerID];
    [[self navigationItem] setTitle: [NSString stringWithFormat:@"Chat with %@", peerDisplayName]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    [self.currentSession disconnectFromAllPeers];
    
    [self.currentSession setDelegate: nil];

}

- (void)viewDidUnload 
{
    [inputTextField release];
    inputTextField = nil;
    
    [sendButton release];
    sendButton = nil;
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Actions

- (IBAction)sendMessage:(id)sender 
{
    NSDictionary *messageDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[inputTextField text], @"message", @"myself", @"sender", nil];
    [chatObjectArray addObject: messageDictionary];
    [messageDictionary release];
    
    NSData *messageData = [inputTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    [self.currentSession sendDataToAllPeers:messageData withDataMode:GKSendDataReliable error:&error];
    
    if(error != nil)
    {
        NSLog(@"An error occurred: %@", [error localizedDescription]);
    }
    
    
    [inputTextField setText: @""];
    [sendButton setEnabled: NO];

    [chatTableView reloadData];
    
    //scroll to the last row
    NSIndexPath* indexPathForLastRow = [NSIndexPath indexPathForRow:[chatObjectArray count]-1 inSection:0];
    [chatTableView scrollToRowAtIndexPath:indexPathForLastRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark -
#pragma mark Game Kit Delegates

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
        if(state == GKPeerStateDisconnected)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"The peer has disconnected" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [alert show];
            [alert release];
            
            [self.currentSession disconnectFromAllPeers];
            [[self navigationController] popViewControllerAnimated: YES];
        }
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{    
    NSString *messageString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *messageDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:messageString, @"message", @"peer", @"sender", nil];
    
    [chatObjectArray addObject: messageDictionary];
    
    [messageString release];
    
    [messageDictionary release];
    
    [chatTableView reloadData];
   
    //scroll to the last row
    NSIndexPath* indexPathForLastRow = [NSIndexPath indexPathForRow:[chatObjectArray count]-1 inSection:0];
    [chatTableView scrollToRowAtIndexPath:indexPathForLastRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [chatObjectArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UIImageView *msgBackground = nil;
    UILabel *msgText = nil;

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        msgBackground = [[UIImageView alloc] init];
        msgBackground.backgroundColor = [UIColor clearColor];
        msgBackground.tag = kMessageTag;
        [cell.contentView addSubview:msgBackground];
        [msgBackground release];
        
        msgText = [[UILabel alloc] init];
        msgText.backgroundColor = [UIColor clearColor];
        msgText.tag = kBackgroundTag;
        msgText.numberOfLines = 0;
        msgText.lineBreakMode = NSLineBreakByWordWrapping;
        msgText.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:msgText];
        [msgText release];
    }
    
    else 
    {
        msgBackground = (UIImageView *)[cell.contentView viewWithTag:kMessageTag];
        msgText = (UILabel *)[cell.contentView viewWithTag:kBackgroundTag];
    }
    
    NSString *message = [[chatObjectArray objectAtIndex: indexPath.row] objectForKey:@"message"];

    CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:14]
                                       constrainedToSize:CGSizeMake(180, CGFLOAT_MAX)
                                           lineBreakMode:NSLineBreakByWordWrapping];
    
    UIImage *bubbleImage;

    //green chat bubble on right side of screen
    if([[[chatObjectArray objectAtIndex: indexPath.row] objectForKey:@"sender"] isEqualToString: @"myself"])
    {
        msgBackground.frame = CGRectMake(tableView.frame.size.width-size.width-34.0f, 1.0f, size.width+34.0f, size.height+12.0f);
        
        bubbleImage = [[UIImage imageNamed:@"ChatBubbleGreen.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:13];
        
        msgText.frame = CGRectMake(tableView.frame.size.width-size.width-22.0f, 5.0f, size.width+5.0f, size.height);
        msgBackground.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        msgText.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }

    //gray chat bubble on left side of screen
    else
    {
        msgBackground.frame = CGRectMake(0.0f, 1.0f, size.width+34.0f, size.height+12.0f);
        bubbleImage = [[UIImage imageNamed:@"ChatBubbleGray.png"] stretchableImageWithLeftCapWidth:23 topCapHeight:15];
        msgText.frame = CGRectMake(22.0f, 5.0f, size.width+5.0f, size.height);
        msgBackground.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        msgText.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    }
    
    msgBackground.image = bubbleImage;
    msgText.text = message;  

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString *message = [[chatObjectArray objectAtIndex: indexPath.row] objectForKey:@"message"];

    CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:14]
                                       constrainedToSize:CGSizeMake(180, CGFLOAT_MAX)
                                           lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + 17.0f;
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger textLength = [textField.text length] + [string length] - range.length;
    [sendButton setEnabled:(textLength > 0)];
    
    return YES;
}

#pragma mark -
#pragma mark Dealloc

-(void)dealloc
{
    [peerID release]; peerID = nil;
    [currentSession release]; currentSession = nil;
    [chatObjectArray release];
    [inputTextField release];
    [sendButton release];
    
    [super dealloc];
}




@end
