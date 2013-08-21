//
//  ICFFiltersViewController.m
//  ImagePlayground
//
//  Created by Joe Keeley on 12/16/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import "ICFFiltersViewController.h"
#import "ICFFilterViewController.h"

@interface ICFFiltersViewController ()

@property (nonatomic, strong) NSArray *filterArray;
@property (nonatomic, strong) NSArray *filterNameArray;
@property (nonatomic, strong) NSArray *notImplementedArray;

@end

@implementation ICFFiltersViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.filterNameArray =
    [CIFilter filterNamesInCategory:self.selectedCategory];
    
    self.notImplementedArray = @[@"CIColorCube"];
    
    [self setContentSizeForViewInPopover:CGSizeMake(540, 512)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filterNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kICFFilterInCategoryCellIdentifier forIndexPath:indexPath];
    
    NSString *filterName =
    [self.filterNameArray objectAtIndex:indexPath.row];
        
    CIFilter *filter = [CIFilter filterWithName:filterName];
    NSDictionary *filterAttributes = [filter attributes];

    NSString *categoryName =
    [filterAttributes valueForKey:kCIAttributeFilterDisplayName];
        
    [cell.textLabel setText:categoryName];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *filterName = [self.filterNameArray objectAtIndex:indexPath.row];

    if ([self.notImplementedArray containsObject:filterName])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Not Implemented" message:@"This filter has not yet been implemented." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    } else
    {
        [self performSegueWithIdentifier:kICFSelectFilterSegue sender:nil];
    }

}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kICFSelectFilterSegue])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *filterName = [self.filterNameArray objectAtIndex:indexPath.row];
        CIFilter *filter = [CIFilter filterWithName:filterName];
        
        [[segue destinationViewController] setSelectedFilter:filter];
        [[segue destinationViewController] setFilterDelegate:self.filterDelegate];
        [[[segue destinationViewController] navigationItem] setTitle:filterName];
    }
}



@end
