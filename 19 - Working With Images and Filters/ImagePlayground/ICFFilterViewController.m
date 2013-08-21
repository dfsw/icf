//
//  ICFFilterViewController.m
//  ImagePlayground
//
//  Created by Joe Keeley on 12/21/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import "ICFFilterViewController.h"
#import "ICFInputInfoCell.h"
#import "ICFInputImageTableCell.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+Scaling.h"

@interface ICFFilterViewController ()

- (IBAction)cancelButtonTouched:(id)sender;
- (IBAction)addFilterButtonTouched:(id)sender;
- (IBAction)previewButtonTouched:(id)sender;
@property (nonatomic, strong) NSIndexPath *imageSelectionIndexPath;

@end

@implementation ICFFilterViewController

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
	
    NSLog(@"Filter attributes: %@",[self.selectedFilter attributes]);
    NSLog(@"Filter input keys: %@",[self.selectedFilter inputKeys]);
    NSLog(@"Filter output keys: %@",[self.selectedFilter outputKeys]);

    CGColorRef darkGreyColor = [[UIColor darkGrayColor] CGColor];
    CGColorRef whiteColor = [[UIColor whiteColor] CGColor];
    [self.previewImageContainer.layer setBorderColor:whiteColor];
    [self.previewImageContainer.layer setBorderWidth:4.0f];
    
    [self.previewImageContainer.layer setShadowColor:darkGreyColor];
    [self.previewImageContainer.layer setShadowOpacity:0.8f];
    [self.previewImageContainer.layer setShadowRadius:6.0f];

    NSString *filterName = [[self.selectedFilter attributes] valueForKey:kCIAttributeFilterDisplayName];
    [self.filterNameLabel setText:filterName];
    
    [self setContentSizeForViewInPopover:CGSizeMake(540, 512)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button methods

- (IBAction)cancelButtonTouched:(id)sender
{
    [self.filterDelegate cancelAddingFilter];
}

- (IBAction)addFilterButtonTouched:(id)sender
{
    [self.filterDelegate addFilter:self.selectedFilter];
}

- (IBAction)previewButtonTouched:(id)sender
{
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = self.selectedFilter;
    CIImage *resultImage = [filter valueForKey:kCIOutputImageKey];
    CGRect imageRect = CGRectMake(0, 0, 200, 200);
    
    CGImageRef resultCGImage =
    [context createCGImage:resultImage fromRect:imageRect];
        
    UIImage *resultUIImage =
    [UIImage imageWithCGImage:resultCGImage];

    [self.previewImageView setImage:resultUIImage];
}

#pragma mark - Table View Methods
- (NSString *)getCellIdentifierForAttributeType:(NSDictionary *)attributeInfo
{
    NSString *attributeType = @"";
    if ([attributeInfo objectForKey:kCIAttributeType]) {
        attributeType = [attributeInfo objectForKey:kCIAttributeType];
    }

    NSString *attributeClass =
    [attributeInfo objectForKey:kCIAttributeClass];

    NSString *cellIdentifier = @"";

    if ([attributeType isEqualToString:kCIAttributeTypeColor] ||
        [attributeClass isEqualToString:@"CIColor"])
    {
        cellIdentifier = kICSInputColorCellIdentifier;
    }

    if ([attributeType isEqualToString:kCIAttributeTypeImage] ||
        [attributeClass isEqualToString:@"CIImage"])
    {
        cellIdentifier = kICSInputImageCellIdentifier;
    }

    if ([attributeType isEqualToString:kCIAttributeTypeScalar] ||
        [attributeType isEqualToString:kCIAttributeTypeDistance] ||
        [attributeType isEqualToString:kCIAttributeTypeAngle] ||
        [attributeType isEqualToString:kCIAttributeTypeTime])
    {
        cellIdentifier = kICSInputNumberCellIdentifier;
    }

    if ([attributeType isEqualToString:kCIAttributeTypePosition] ||
        [attributeType isEqualToString:kCIAttributeTypeOffset] ||
        [attributeType isEqualToString:kCIAttributeTypeRectangle] ||
        [attributeClass isEqualToString:@"CIVector"])
    {
        cellIdentifier = kICSInputVectorCellIdentifier;
    }

    if ([attributeClass isEqualToString:@"NSValue"])
    {
        cellIdentifier = kICSInputTransformCellIdentifier;
    }

    return cellIdentifier;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 64.0f;
    
    NSString *attributeName =
    [[self.selectedFilter inputKeys] objectAtIndex:indexPath.row];
    
    NSDictionary *attributeDictionary =
    [[self.selectedFilter attributes] valueForKey:attributeName];
    
    NSString *attributeType =
    [attributeDictionary valueForKey:kCIAttributeType];

    NSString *attributeClass =
    [attributeDictionary valueForKey:kCIAttributeClass];
    
    if ([attributeType isEqualToString:kCIAttributeTypeColor] ||
        [attributeClass isEqualToString:@"CIColor"])
    {
        rowHeight = 120.0f;
    }

    if ([attributeType isEqualToString:kCIAttributeTypeImage])
    {
        rowHeight = 80.0f;
    }
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.selectedFilter inputKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *attributeName =
    [[self.selectedFilter inputKeys] objectAtIndex:indexPath.row];

    NSDictionary *attributeInfo =
    [[self.selectedFilter attributes] valueForKey:attributeName];
    
    NSString *cellIdentifier =
    [self getCellIdentifierForAttributeType:attributeInfo];

    ICFInputInfoCell *cell = (ICFInputInfoCell *)
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                    forIndexPath:indexPath];

    [cell configureForInfo:attributeInfo andKey:attributeName];
    [cell setEditDelegate:self];
    
    if ([attributeName isEqualToString:@"inputImage"])
    {
        UIImage *sourceImage =
        [self.filterDelegate imageWithLastFilterApplied];
        
        [[(ICFInputImageTableCell *)cell inputImageView]
         setImage:sourceImage];
        
        CIImage *inputImage = nil;
        if ([sourceImage CIImage])
        {
            inputImage = [sourceImage CIImage];
        } else
        {
            CGImageRef inputImageRef = [sourceImage CGImage];
            inputImage = [CIImage imageWithCGImage:inputImageRef];
        }
        
        [self.selectedFilter setValue:inputImage
                               forKey:attributeName];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ICFInputInfoCell *cell = (ICFInputInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isMemberOfClass:[ICFInputImageTableCell class]])
    {
        [self setImageSelectionIndexPath:indexPath];
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setAllowsEditing:YES];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePicker setMediaTypes:@[(NSString*)kUTTypeImage]];
        [imagePicker setDelegate:self];
        
        UIPopoverController *popover = [self.filterDelegate currentPopoverController];
        [popover setContentViewController:imagePicker animated:YES];
        [popover setPopoverContentSize:[imagePicker contentSizeForViewInPopover] animated:YES];
    }
}

#pragma mark - ICFFilterEditingDelegate Methods
- (void)updateFilterAttribute:(NSString *)attributeKey withValue:(id)value
{
    [self.selectedFilter setValue:value forKey:attributeKey];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    CGSize scaleSize = CGSizeMake(200.0f, 200.0f);
    UIImage *scaleImage = [selectedImage scaleImageToSize:scaleSize];
    
    ICFInputImageTableCell *cell = (ICFInputImageTableCell *)[self.filterTableView cellForRowAtIndexPath:self.imageSelectionIndexPath];

    [cell.inputImageView setImage:scaleImage];
    
    CGImageRef scaleImageRef = [scaleImage CGImage];
    CIImage *scaleCIImage = [CIImage imageWithCGImage:scaleImageRef];
    
    [self updateFilterAttribute:cell.attributeKey withValue:scaleCIImage];
    [self setImageSelectionIndexPath:nil];
    
    UIPopoverController *popover = [self.filterDelegate currentPopoverController];
    UINavigationController *navController = [self.filterDelegate currentFilterController];
    
    [popover setContentViewController:navController animated:YES];
    [popover setPopoverContentSize:[navController contentSizeForViewInPopover] animated:YES];
}

@end
