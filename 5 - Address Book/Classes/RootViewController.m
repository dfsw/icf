//
//  RootViewController.m
//  AddressBook
//
//  Created by Kyle Richter on 2/27/12.
//  Copyright 2012 Dragon Forged Software. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

#pragma mark -
#pragma mark View lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    CFErrorRef creationError = NULL;
    addressBook = ABAddressBookCreateWithOptions(NULL, &creationError);
   
    if(addressBook == NULL)
    {
        NSLog(@"Error loading address book: %@", CFErrorCopyDescription(creationError));
    }
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
    {
        if(!granted)
        {
            NSLog(@"No persmission!");
        }
    });

    //Let the user know if the address book is empty
    if(ABAddressBookGetPersonCount(addressBook) == 0)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
															message:@"Address book is empty!" 
														   delegate:nil 
												  cancelButtonTitle:@"Dismiss"
												  otherButtonTitles: nil];
		[alertView show];
		[alertView release];
        
	}    
    
    //get an array filled with all the records we find in the address book
    addressBookEntryArray = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    //add the plus button
    UIBarButtonItem *addNewBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(addNew:)];
    [[self navigationItem] setRightBarButtonItem:addNewBarButtonItem];
    [addNewBarButtonItem release];
    
    //add address toggle button
    UIBarButtonItem *addressToggleButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Toggle Address" style:UIBarButtonItemStylePlain target:self action:@selector(toggleAddressAction:)];
    [[self navigationItem] setLeftBarButtonItem:addressToggleButtonItem];
    [addressToggleButtonItem release];
    
    //people picker
    //[self showPicker: nil];
    
    //create a new person
    //[self programmaticallyCreatePerson];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [addressBookTableView reloadData];
    [addressBookTableView deselectRowAtIndexPath:[addressBookTableView indexPathForSelectedRow] animated:YES];
}

#pragma mark -
#pragma mark Actions

//create a new entry using the default new person interface
-(void)addNew:(id)sender;
{
    ABNewPersonViewController *newPersonViewController = [[ABNewPersonViewController alloc] init];
    UINavigationController *newPersonNavigationController = [[UINavigationController alloc] initWithRootViewController:newPersonViewController];
    
    //set the delegate
    [newPersonViewController setNewPersonViewDelegate: self];
    
    [self presentViewController:newPersonNavigationController animated:YES completion:nil];
    
    [newPersonNavigationController release];
    [newPersonViewController release];
}

-(void)toggleAddressAction:(id)sender;
{
    if(showingAddress)
        [(UIBarButtonItem *)sender setTitle:@"Toggle Address"];
    else 
        [(UIBarButtonItem *)sender setTitle:@"Toggle Phone"];
    
    showingAddress = !showingAddress;
    
    [addressBookTableView reloadData];
}

-(BOOL)programmaticallyCreatePerson;
{
    ABRecordRef newPersonRecord = ABPersonCreate();

    CFErrorRef error = NULL; 
    
    //set the new persons first and last name
    ABRecordSetValue(newPersonRecord, kABPersonFirstNameProperty, @"Tyler", &error);
    ABRecordSetValue(newPersonRecord, kABPersonLastNameProperty, @"Durden", &error);
    
    //set business name and job title
    ABRecordSetValue(newPersonRecord, kABPersonOrganizationProperty, @"Paperstreet Soap Company", &error);
    ABRecordSetValue(newPersonRecord, kABPersonJobTitleProperty, @"Salesman", &error);
    
    //set the phone numbers
    ABMutableMultiValueRef multiPhoneRef = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhoneRef, @"1-800-555-5555", kABPersonPhoneMainLabel, NULL);
    ABMultiValueAddValueAndLabel(multiPhoneRef, @"1-203-426-1234", kABPersonPhoneMobileLabel, NULL);            
    ABMultiValueAddValueAndLabel(multiPhoneRef, @"1-555-555-0123", kABPersonPhoneIPhoneLabel, NULL);        
    ABRecordSetValue(newPersonRecord, kABPersonPhoneProperty, multiPhoneRef, nil);
    CFRelease(multiPhoneRef);
    
    //set email address
    ABMutableMultiValueRef multiEmailRef = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmailRef, @"tyler@paperstreetsoap.com", kABWorkLabel, NULL);
    ABRecordSetValue(newPersonRecord, kABPersonEmailProperty, multiEmailRef, &error);
    CFRelease(multiEmailRef);
    
    
    //set address
    ABMutableMultiValueRef multiAddressRef = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    [addressDictionary setObject:@"152 Paper Street" forKey:(NSString *) kABPersonAddressStreetKey];
    [addressDictionary setObject:@"Delaware" forKey:(NSString *)kABPersonAddressCityKey];
    [addressDictionary setObject:@"MD" forKey:(NSString *)kABPersonAddressStateKey];
    [addressDictionary setObject:@"19963" forKey:(NSString *)kABPersonAddressZIPKey];
    
    ABMultiValueAddValueAndLabel(multiAddressRef, addressDictionary, kABWorkLabel, NULL);
    ABRecordSetValue(newPersonRecord, kABPersonAddressProperty, multiAddressRef, &error);
    CFRelease(multiAddressRef);
    [addressDictionary release];
    
    ABAddressBookAddRecord(addressBook, newPersonRecord, &error);
    ABAddressBookSave(addressBook, &error);
    
    if(error != NULL)
    {
        NSLog(@"An error occurred");
        return NO;
    }
    
    CFRelease(addressBookEntryArray);
    addressBookEntryArray = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    [addressBookTableView reloadData];
    
    return YES;
}

- (void)showPicker:(id)sender
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    [picker release];
}

#pragma mark -
#pragma mark ABNewPersonViewControllerDelegate

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
    if(person)
    {
        CFErrorRef error = NULL; 
        
        ABAddressBookAddRecord(addressBook, person, &error);
        ABAddressBookSave(addressBook, &error);
        
        if (error != NULL) 
        {
            NSLog(@"An error occurred");
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //refresh
    CFRelease(addressBookEntryArray);
    addressBookEntryArray = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    [addressBookTableView reloadData];
}

#pragma mark -
#pragma mark ABPersonViewControllerDelegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    
    return YES;
}

#pragma mark -
#pragma mark ABPeoplePickerNavigationControllerDelegate

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    NSLog(@"You have selected: %@", person);
    
    [self dismissViewControllerAnimated:YES completion:nil];

    return NO;
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    NSLog(@"Person: %@\nProperty:%i\nIdentifier:%i", person, property, identifier);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    
    return [addressBookEntryArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    ABRecordRef record = [addressBookEntryArray objectAtIndex:indexPath.row];
    NSString *firstName = (NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
    NSString *lastName = (NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);

    NSString *subtitleString = nil;
    
    //show address info
    if(showingAddress)
    {
        ABMultiValueRef streetAddresses = ABRecordCopyValue(record, kABPersonAddressProperty);
       
        //at least one address for this record
        if (ABMultiValueGetCount(streetAddresses) > 0) 
        {
            NSDictionary *streetAddressDictionary = (NSDictionary *)ABMultiValueCopyValueAtIndex(streetAddresses, 0); 
            
            //find the individual address components
            NSString *street = [streetAddressDictionary objectForKey:(NSString *)kABPersonAddressStreetKey];
            NSString *city = [streetAddressDictionary objectForKey:(NSString *)kABPersonAddressCityKey];
            NSString *state = [streetAddressDictionary objectForKey:(NSString *)kABPersonAddressStateKey];
            NSString *zip = [streetAddressDictionary objectForKey:(NSString *)kABPersonAddressZIPKey];

            subtitleString = [NSString stringWithFormat: @"%@ %@, %@ %@", street, city, state, zip];
            
            CFRelease(streetAddressDictionary);
        }
        
        //no addresses for this record
        else 
        {
            subtitleString = @"[None]";
        }
    }
    
    //show phone number info
    else
    {
        CFStringRef phoneNumber = nil;
        
        //get a copy of all the phone numbers for this person
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(record, kABPersonPhoneProperty);
        
        //if we have any numbers use the first one we find
        if (ABMultiValueGetCount(phoneNumbers) > 0) 
        {
            phoneNumber = ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
            CFStringRef phoneTypeRawString = ABMultiValueCopyLabelAtIndex(phoneNumbers, 0);
            
            /*
             Phone type labels are values like "_$!<Mobile>!$_", we need to localize the type for display
            */
            
            NSString *localizedPhoneTypeString =  (NSString *)ABAddressBookCopyLocalizedLabel(phoneTypeRawString);

            subtitleString = [NSString stringWithFormat:@"%@ [%@]", phoneNumber, localizedPhoneTypeString];
                        
            CFRelease(phoneNumber);
            CFRelease(phoneTypeRawString);
            CFRelease(localizedPhoneTypeString);
        } 
        
        //no phone numbers
        else 
        {
            subtitleString = @"[None]";
        }
        
        CFRelease(phoneNumbers);

    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    cell.detailTextLabel.text = subtitleString;   

    if(firstName) //NIL may of been retrieved and CFRelease doesnt gracefully handle nils
        CFRelease(firstName);
    if(lastName) //NIL may of been retrieved and CFRelease doesnt gracefully handle nils
        CFRelease(lastName);
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.personViewDelegate = self;
    personViewController.displayedPerson = [addressBookEntryArray objectAtIndex:indexPath.row];
    personViewController.allowsActions = YES; //allows inline calling and maping
    personViewController.allowsEditing = YES; //we can edit inline
    
    [self.navigationController pushViewController:personViewController animated:YES];
    
    [personViewController release];
}


#pragma mark -
#pragma mark Memory management


- (void)dealloc 
{
    CFRelease(addressBookEntryArray);
    [super dealloc];
}


@end

