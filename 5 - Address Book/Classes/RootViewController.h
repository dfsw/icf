//
//  RootViewController.h
//  AddressBook
//
//  Created by Kyle Richter on 2/27/12.
//  Copyright 2012 Dragon Forged Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface RootViewController : UITableViewController <ABNewPersonViewControllerDelegate, ABPersonViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate>
{
    ABAddressBookRef addressBook;
    NSArray *addressBookEntryArray;
    
    IBOutlet UITableView *addressBookTableView;
    BOOL showingAddress;
}

-(void)addNew:(id)sender;
-(BOOL)programmaticallyCreatePerson;
-(void)toggleAddressAction:(id)sender;

@end
