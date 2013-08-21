//
//  ICFViewController.m
//  Dynamics
//
//  Created by Kyle Richter on 7/14/13.
//  Copyright (c) 2013 Kyle Richter. All rights reserved.
//

#import "ICFViewController.h"
#import "ICFGravityViewController.h"
#import "ICFCollisionViewController.h"
#import "ICFAttachmentsViewController.h"
#import "ICFSpringViewController.h"
#import "ICFSnapViewController.h"
#import "ICFPropertiesViewController.h"
#import "ICFForceViewController.h"

@interface ICFViewController ()

@end

@implementation ICFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"UIKit Dynamics";

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    switch ([indexPath row])
    {
        case 0:
            cell.textLabel.text = @"Gravity";
            break;
        case 1:
            cell.textLabel.text = @"Collisions";
            break;
        case 2:
            cell.textLabel.text = @"Attachments";
            break;
        case 3:
            cell.textLabel.text = @"Springs";
            break;
        case 4:
            cell.textLabel.text = @"Snap";
            break;
        case 5:
            cell.textLabel.text = @"Forces";
            break;
        case 6:
            cell.textLabel.text = @"Properties";
            break;
        default:
            break;
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = nil;
    
    switch ([indexPath row])
    {
        case 0:
            viewController = [[[ICFGravityViewController alloc] init] autorelease];
            break;
        case 1:
            viewController = [[[ICFCollisionViewController alloc] init] autorelease];
            break;
        case 2:
            viewController = [[[ICFAttachmentsViewController alloc] init] autorelease];
            break;
        case 3:
            viewController = [[[ICFSpringViewController alloc] init] autorelease];
            break;
        case 4:
            viewController = [[[ICFSnapViewController alloc] init] autorelease];
            break;
        case 5:
            viewController = [[[ICFForceViewController alloc] init] autorelease];
            break;
        case 6:
            viewController = [[[ICFPropertiesViewController alloc] init] autorelease];
        default:
            break;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}


@end
