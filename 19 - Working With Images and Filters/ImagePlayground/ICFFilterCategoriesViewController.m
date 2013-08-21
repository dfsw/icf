//
//  ICFFilterCategoriesViewController.m
//  ImagePlayground
//
//  Created by Joe Keeley on 12/16/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import "ICFFilterCategoriesViewController.h"
#import "ICFFiltersViewController.h"

@interface ICFFilterCategoriesViewController ()

@property (strong,nonatomic) NSDictionary *categoryList;
@property (strong,nonatomic) NSArray *categoryKeys;

@end

@implementation ICFFilterCategoriesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.categoryList = @{
        @"Blur" : kCICategoryBlur,
        @"Color Adjustment" : kCICategoryColorAdjustment,
        @"Color Effect" : kCICategoryColorEffect,
        @"Composite" : kCICategoryCompositeOperation,
        @"Distortion" : kCICategoryDistortionEffect,
        @"Generator" : kCICategoryGenerator,
        @"Geometry Adjustment" : kCICategoryGeometryAdjustment,
        @"Gradient" : kCICategoryGradient,
        @"Halftone Effect" : kCICategoryHalftoneEffect,
        @"Sharpen" : kCICategorySharpen,
        @"Stylize" : kCICategoryStylize,
        @"Tile" : kCICategoryTileEffect,
        @"Transition" : kCICategoryTransition
    };
    self.categoryKeys = [self.categoryList allKeys];
    
    [self setContentSizeForViewInPopover:CGSizeMake(540, 512)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kICFCategoryListCellIdentifier forIndexPath:indexPath];
    
    NSString *categoryName = [self.categoryKeys objectAtIndex:indexPath.row];
    [cell.textLabel setText:categoryName];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kICFSelectFilterCategorySegue]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *displayName = self.categoryKeys[indexPath.row];
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSString *category = [self.categoryList valueForKey:displayName];
        [[segue destinationViewController] setSelectedCategory:category];
        [[segue destinationViewController] setFilterDelegate:self.filterDelegate];
        [[[segue destinationViewController] navigationItem] setTitle:[[selectedCell textLabel] text]];
    }
}

@end
