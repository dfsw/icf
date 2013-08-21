//
//  ICFViewController.m
//  ImagePlayground
//
//  Created by Joe Keeley on 11/3/12.
//  Copyright (c) 2012 Joe Keeley. All rights reserved.
//

#import "ICFViewController.h"
#import "ICFFilterCategoriesViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+Scaling.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ICFViewController ()

@property (nonatomic, strong) NSMutableArray *filterArray;
@property (nonatomic, strong) NSMutableArray *filteredImageArray;

@end

@implementation ICFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.filterArray = [NSMutableArray arrayWithCapacity:3];
    self.filteredImageArray = [NSMutableArray arrayWithCapacity:3];
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
    {
        [self.takePhotoButton setHidden:NO];
    } else
    {
        [self.takePhotoButton setHidden:YES];
    }
    
    CGColorRef darkGreyColor = [[UIColor darkGrayColor] CGColor];
    CGColorRef whiteColor = [[UIColor whiteColor] CGColor];
    
    [self.sourceImageContainer.layer setBorderColor:whiteColor];
    [self.sourceImageContainer.layer setBorderWidth:4.0f];

    [self.sourceImageContainer.layer setShadowColor:darkGreyColor];
    [self.sourceImageContainer.layer setShadowOpacity:0.8f];
    [self.sourceImageContainer.layer setShadowRadius:6.0f];

    [self.resultImageContainer.layer setBorderColor:whiteColor];
    [self.resultImageContainer.layer setBorderWidth:4.0f];
    
    [self.resultImageContainer.layer setShadowColor:darkGreyColor];
    [self.resultImageContainer.layer setShadowOpacity:0.8f];
    [self.resultImageContainer.layer setShadowRadius:6.0f];

    [self.filterListContainer.layer setBorderColor:whiteColor];
    [self.filterListContainer.layer setBorderWidth:4.0f];
    
    CGSize filterViewOffset = CGSizeMake(0.0f, 4.0f);
    [self.filterListContainer.layer setShadowOffset:filterViewOffset];
    [self.filterListContainer.layer setShadowColor:darkGreyColor];
    [self.filterListContainer.layer setShadowOpacity:0.8f];
    [self.filterListContainer.layer setShadowRadius:4.0f];
    
    UIImage *startImage =
    [UIImage imageNamed:@"ch_20_stretch_button"];

    CGFloat topInset = 10.0f;
    CGFloat bottomInset = 10.0f;
    CGFloat leftInset = 10.0f;
    CGFloat rightInset = 10.0f;

    UIEdgeInsets edgeInsets =
    UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset);

    UIImage *stretchImage =
    [startImage resizableImageWithCapInsets:edgeInsets];

    [self.selectImageButton setBackgroundImage:stretchImage
                                      forState:UIControlStateNormal];
    [self.selectImageButton setBackgroundImage:stretchImage
                                      forState:UIControlStateSelected];
    [self.selectImageButton setBackgroundImage:stretchImage
                                      forState:UIControlStateHighlighted];
    [self.selectImageButton setBackgroundImage:stretchImage
                                      forState:UIControlStateDisabled];

    [self.takePhotoButton setBackgroundImage:stretchImage
                                    forState:UIControlStateNormal];
    [self.takePhotoButton setBackgroundImage:stretchImage
                                    forState:UIControlStateSelected];
    [self.takePhotoButton setBackgroundImage:stretchImage
                                    forState:UIControlStateHighlighted];
    [self.takePhotoButton setBackgroundImage:stretchImage
                                    forState:UIControlStateDisabled];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Methods

- (IBAction)clearFiltersTouched:(id)sender
{
    [self.filterArray removeAllObjects];
    [self.filteredImageArray removeAllObjects];
    [self.resultImageView setImage:nil];
    [self.filterList reloadData];
}

- (void)addTextForFaceInfo:(NSString *)addFaceInfoString
{
    NSString *updateFaceInfoText = nil;
    if ([self.faceInfoTextView.text length] > 0)
    {
        updateFaceInfoText = [@"\n" stringByAppendingString:addFaceInfoString];
    } else
    {
        updateFaceInfoText = addFaceInfoString;
    }
    NSString *currentFaceInfoText = self.faceInfoTextView.text;
    [self.faceInfoTextView setText:[currentFaceInfoText stringByAppendingString:updateFaceInfoText]];
}

- (CGRect)adjustCoordinateSpaceForMarker:(CGRect)marker andHeight:(CGFloat)height
{
    if (height > 200) {
        //adjust for aspect fill
        if (marker.size.height > marker.size.width) {
            //
        }
    }
    CGAffineTransform scale = CGAffineTransformMakeScale(1, -1);

    CGAffineTransform flip =
    CGAffineTransformTranslate(scale, 0, -height);

    CGRect flippedRect = CGRectApplyAffineTransform(marker, flip);
    return flippedRect;
}

- (IBAction)detectFacesTouched:(id)sender
{
    UIImage *detectUIImage = [self.sourceImageView image];
    CGImageRef detectCGImageRef = [detectUIImage CGImage];

    CIImage *detectImage =
    [CIImage imageWithCGImage:detectCGImageRef];
    
    NSDictionary *options =
    @{CIDetectorAccuracy : CIDetectorAccuracyHigh};

    CIDetector *faceDetector =
    [CIDetector detectorOfType:CIDetectorTypeFace
                       context:nil
                       options:options];
    
    NSArray *features = [faceDetector featuresInImage:detectImage];
    
    [self addTextForFaceInfo:@"Detecting faces."];
    for (CIFaceFeature *face in features) {
        
        CGRect faceRect = [self adjustCoordinateSpaceForMarker:face.bounds andHeight:detectImage.extent.size.height];
        
        [self addTextForFaceInfo:@"---------- Found face ----------"];
        NSString *faceDims = [NSString stringWithFormat:@"Face Dimensions: origin (%f,%f), size (%f,%f), smiling: %@", faceRect.origin.x,faceRect.origin.y,faceRect.size.width,faceRect.size.height,(face.hasSmile ? @"Yes": @"No")];
        [self addTextForFaceInfo:faceDims];
        UIView *faceMarker = [[UIView alloc] initWithFrame:faceRect];
        faceMarker.layer.borderWidth = 2;
        faceMarker.layer.borderColor = [[UIColor redColor] CGColor];
        [self.sourceImageView addSubview:faceMarker];
        
        CGFloat eyeMarkerWidth = 12.0f;

        if (face.hasLeftEyePosition)
        {
            CGFloat leftEyeXPos = face.leftEyePosition.x - eyeMarkerWidth/2;
            CGFloat leftEyeYPos = face.leftEyePosition.y - eyeMarkerWidth/2;

            CGRect leftEyeRect =
            CGRectMake(leftEyeXPos, leftEyeYPos, eyeMarkerWidth, eyeMarkerWidth);

            CGRect flippedLeftEyeRect =
            [self adjustCoordinateSpaceForMarker:leftEyeRect
            andHeight:self.sourceImageView.bounds.size.height];

            NSString *leftEyeDims = [NSString stringWithFormat:@"Adjusted left eye: origin (%f,%f), size (%f,%f), closed: %@", flippedLeftEyeRect.origin.x, flippedLeftEyeRect.origin.y,flippedLeftEyeRect.size.height,flippedLeftEyeRect.size.width,face.leftEyeClosed ? @"Yes": @"No"];
            [self addTextForFaceInfo:leftEyeDims];

            UIView *leftEyeMarker =
            [[UIView alloc] initWithFrame:flippedLeftEyeRect];

            leftEyeMarker.layer.borderWidth = 2;
            leftEyeMarker.layer.borderColor = [[UIColor yellowColor] CGColor];
            [self.sourceImageView addSubview:leftEyeMarker];
        } else
        {
            [self addTextForFaceInfo:@"No left eye found."];
        }
        
        if (face.hasRightEyePosition) {
            CGRect rightEyeRect = CGRectMake(face.rightEyePosition.x - eyeMarkerWidth/2, face.rightEyePosition.y - eyeMarkerWidth/2, eyeMarkerWidth, eyeMarkerWidth);
            CGRect flippedRightEyeRect = [self adjustCoordinateSpaceForMarker:rightEyeRect andHeight:self.sourceImageView.bounds.size.height];
            NSString *rightEyeDims = [NSString stringWithFormat:@"Adjusted right eye: origin (%f,%f), size (%f,%f), closed: %@", flippedRightEyeRect.origin.x, flippedRightEyeRect.origin.y,flippedRightEyeRect.size.height,flippedRightEyeRect.size.width,face.rightEyeClosed ? @"Yes": @"No"];
            [self addTextForFaceInfo:rightEyeDims];
            UIView *rightEyeMarker = [[UIView alloc] initWithFrame:flippedRightEyeRect];
            rightEyeMarker.layer.borderWidth = 2;
            rightEyeMarker.layer.borderColor = [[UIColor yellowColor] CGColor];
            [self.sourceImageView addSubview:rightEyeMarker];
        }else
        {
            [self addTextForFaceInfo:@"No right eye found."];
        }

        
        if (face.hasMouthPosition) {
            CGRect mouthRect = CGRectMake(face.mouthPosition.x - eyeMarkerWidth/2, face.mouthPosition.y - eyeMarkerWidth/2, eyeMarkerWidth, eyeMarkerWidth);
            CGRect flippedMouthRect = [self adjustCoordinateSpaceForMarker:mouthRect andHeight:self.sourceImageView.bounds.size.height];
            NSString *mouthDims = [NSString stringWithFormat:@"Adjusted mouth: %f,%f,%f,%f", flippedMouthRect.origin.x, flippedMouthRect.origin.y,flippedMouthRect.size.height,flippedMouthRect.size.width];
            [self addTextForFaceInfo:mouthDims];
            UIView *mouthMarker = [[UIView alloc] initWithFrame:flippedMouthRect];
            mouthMarker.layer.borderWidth = 2;
            mouthMarker.layer.borderColor = [[UIColor yellowColor] CGColor];
            [self.sourceImageView addSubview:mouthMarker];
        }else
        {
            [self addTextForFaceInfo:@"No mouth found."];
        }
        [self addTextForFaceInfo:@"---------- End of face ----------"];
    }
    
    if ([features count] == 0) {
        [self addTextForFaceInfo:@"No faces detected."];
    }
    [self addTextForFaceInfo:@"Face detection complete."];
}

- (IBAction)clearFacesTouched:(id)sender
{
    NSArray *faceMarkers = [self.sourceImageView subviews];
    for (UIView *subview in faceMarkers) {
        [subview removeFromSuperview];
    }
    [self.faceInfoTextView setText:nil];
}

- (IBAction)selectImageTouched:(id)sender
{
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];

    [imagePicker setAllowsEditing:YES];

    [imagePicker setSourceType:
     UIImagePickerControllerSourceTypePhotoLibrary];

    [imagePicker setMediaTypes:@[(NSString*)kUTTypeImage]];
    [imagePicker setDelegate:self];
    
    self.imagePopoverController = [[UIPopoverController alloc]
     initWithContentViewController:imagePicker];

    [self.imagePopoverController
     presentPopoverFromRect:self.sourceImageContainer.frame
     inView:self.view
     permittedArrowDirections:UIPopoverArrowDirectionAny
     animated:YES];
}

- (IBAction)takePhotoTouched:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setAllowsEditing:YES];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePicker setMediaTypes:@[(NSString*)kUTTypeImage]];
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)saveToCameraRollTouched:(id)sender
{
    CIImage *_image = [self.resultImageView.image CIImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImg = [context createCGImage:_image fromRect:[_image extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImg];
    UIImageWriteToSavedPhotosAlbum(resultImage, self, @selector(savetoCameraRollCompletedForImage:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)savetoCameraRollCompletedForImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Image Save" message:@"Your image has been saved to the Camera Roll" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage =
    [info objectForKey:UIImagePickerControllerEditedImage];

    CGSize scaleSize = CGSizeMake(200.0f, 200.0f);

    UIImage *scaleImage =
    [selectedImage scaleImageToSize:scaleSize];

    [self.sourceImageView setImage:scaleImage];
    
    if (self.imagePopoverController)
    {
        [self.imagePopoverController dismissPopoverAnimated:YES];
        self.imagePopoverController = nil;
    } else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filterArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kICFFilterCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kICFFilterCellIdentifier];
        UIFont *cellFont = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16.0f];
        [cell.textLabel setFont:cellFont];
    }
    
    CIFilter *filter = [self.filterArray objectAtIndex:indexPath.row];
    NSString *filterName = [[filter attributes] valueForKey:kCIAttributeFilterDisplayName];
    [cell.textLabel setText:filterName];
    [cell.imageView setImage:[self.filteredImageArray objectAtIndex:indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

#pragma mark - ICFFilterProcessingDelegate method

- (void)addFilter:(CIFilter *)filter
{
    CIFilter *lastFilter = [self.filterArray lastObject];

    if (lastFilter)
    {
        if ([[filter inputKeys] containsObject:@"inputImage"] )
        {
            [filter setValue:[lastFilter outputImage]
                      forKey:@"inputImage"];
        }
    }

    [self.filterArray addObject:filter];

    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *resultImage = [filter valueForKey:kCIOutputImageKey];

    CGImageRef resultCGImage =
    [context createCGImage:resultImage
                  fromRect:CGRectMake(0, 0, 200, 200)];

    UIImage *resultUIImage =
    [UIImage imageWithCGImage:resultCGImage];

    [self.resultImageView setImage:resultUIImage];

    [self.filteredImageArray addObject:self.resultImageView.image];
    [self.filterList reloadData];

    [self.filterPopoverController dismissPopoverAnimated:YES];
}

- (void)cancelAddingFilter
{
    [self.filterPopoverController dismissPopoverAnimated:YES];
}

- (UIImage *)imageWithLastFilterApplied
{
    UIImage *returnImage = nil;
    if ([self.filteredImageArray count] == 0) {
        returnImage = [self.sourceImageView image];
    }
    else
    {
        returnImage = [self.filteredImageArray lastObject];
    }
    
    return returnImage;
}

- (UIPopoverController *)currentPopoverController
{
    return self.filterPopoverController;
}

- (UINavigationController *)currentFilterController
{
    return self.filterNavigationController;
}

#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kICFAddFilterSegue]) {
        UIStoryboardPopoverSegue *sbSegue = (UIStoryboardPopoverSegue *)segue;
        [self setFilterPopoverController:sbSegue.popoverController];
        //[self.filterPopoverController setPopoverContentSize:CGSizeMake(540, 512) animated:YES];
        
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        ICFFilterCategoriesViewController *filterCategoriesVC = (ICFFilterCategoriesViewController *)[navController topViewController];
        [filterCategoriesVC setFilterDelegate:self];
        self.filterNavigationController = navController;
    }
}

#pragma mark - UIPopoverControllerDelegate methods
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.filterNavigationController = nil;
}

@end
