//
//  UIImage+Scaling.m
//  ImagePlayground
//
//  Created by Joe Keeley on 1/19/13.
//  Copyright (c) 2013 Joe Keeley. All rights reserved.
//

#import "UIImage+Scaling.h"

@implementation UIImage (Scaling)

- (UIImage *)scaleImageToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);

    CGFloat originX = 0.0;
    CGFloat originY = 0.0;

    CGRect destinationRect =
    CGRectMake(originX, originY, newSize.width, newSize.height);

    [self drawInRect:destinationRect];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return newImage;
}

@end
