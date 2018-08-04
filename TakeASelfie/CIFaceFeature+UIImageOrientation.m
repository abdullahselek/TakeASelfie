//
//  CIFaceFeature+UIImageOrientation.m
//  
//
//  Created by Xiaochao Yang on 6/9/13.
//  Copyright (c) 2013 Xiaochao Yang. All rights reserved.
//

#import "CIFaceFeature+UIImageOrientation.h"

@implementation CIFaceFeature (UIImageOrientation)

- (CGPoint)leftEyePositionForImage:(UIImage *)image
{
    return [self pointForImage:image fromPoint:self.leftEyePosition];
}

- (CGPoint)rightEyePositionForImage:(UIImage *)image
{
    return [self pointForImage:image fromPoint:self.rightEyePosition];
}

- (CGPoint)mouthPositionForImage:(UIImage *)image
{
    return [self pointForImage:image fromPoint:self.mouthPosition];
}

- (CGRect)boundsForImage:(UIImage *)image
{
    return [self boundsForImage:image fromBounds:self.bounds];
}

- (CGPoint)normalizedLeftEyePositionForImage:(UIImage *)image
{
    return [self normalizedPointForImage:image fromPoint:self.leftEyePosition];
}

- (CGPoint)normalizedRightEyePositionForImage:(UIImage *)image
{
    return [self normalizedPointForImage:image fromPoint:self.rightEyePosition];
}

- (CGPoint)normalizedMouthPositionForImage:(UIImage *)image
{
    return [self normalizedPointForImage:image fromPoint:self.mouthPosition];
}

- (CGRect)normalizedBoundsForImage:(UIImage *)image
{
    return [self normalizedBoundsForImage:image fromBounds:self.bounds];
}

- (CGPoint)leftEyePositionForImage:(UIImage *)image inView:(CGSize)viewSize
{
    CGPoint normalizedPoint = [self normalizedLeftEyePositionForImage:image];
    return [self pointInView:viewSize fromNormalizedPoint:normalizedPoint];
}

- (CGPoint)rightEyePositionForImage:(UIImage *)image inView:(CGSize)viewSize
{
    CGPoint normalizedPoint = [self normalizedRightEyePositionForImage:image];
    return [self pointInView:viewSize fromNormalizedPoint:normalizedPoint];
}

- (CGPoint)mouthPositionForImage:(UIImage *)image inView:(CGSize)viewSize
{
    CGPoint normalizedPoint = [self normalizedMouthPositionForImage:image];
    return [self pointInView:viewSize fromNormalizedPoint:normalizedPoint];
}

- (CGRect)boundsForImage:(UIImage *)image inView:(CGSize)viewSize
{
    CGRect normalizedBounds = [self normalizedBoundsForImage:image fromBounds:self.bounds];
    return [self boundsInView:viewSize fromNormalizedBounds:normalizedBounds];
}

- (CGPoint)pointForImage:(UIImage*) image fromPoint:(CGPoint)originalPoint
{
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGPoint convertedPoint;
    switch (image.imageOrientation) {
        case UIImageOrientationUp:
            convertedPoint.x = originalPoint.x;
            convertedPoint.y = imageHeight - originalPoint.y;
            break;
        case UIImageOrientationDown:
            convertedPoint.x = imageWidth - originalPoint.x;
            convertedPoint.y = originalPoint.y;
            break;
        case UIImageOrientationLeft:
            convertedPoint.x = imageWidth - originalPoint.y;
            convertedPoint.y = imageHeight - originalPoint.x;
            break;
        case UIImageOrientationRight:
            convertedPoint.x = originalPoint.y;
            convertedPoint.y = originalPoint.x;
            break;
        case UIImageOrientationUpMirrored:
            convertedPoint.x = imageWidth - originalPoint.x;
            convertedPoint.y = imageHeight - originalPoint.y;
            break;
        case UIImageOrientationDownMirrored:
            convertedPoint.x = originalPoint.x;
            convertedPoint.y = originalPoint.y;
            break;
        case UIImageOrientationLeftMirrored:
            convertedPoint.x = imageWidth - originalPoint.y;
            convertedPoint.y = originalPoint.x;
            break;
        case UIImageOrientationRightMirrored:
            convertedPoint.x = originalPoint.y;
            convertedPoint.y = imageHeight - originalPoint.x;
            break;
        default:
            break;
    }
    return convertedPoint;
}

- (CGPoint)normalizedPointForImage:(UIImage*) image fromPoint:(CGPoint)originalPoint
{
    CGPoint normalizedPoint = [self pointForImage:image fromPoint:originalPoint];
    normalizedPoint.x /= image.size.width;
    normalizedPoint.y /= image.size.height;
    return normalizedPoint;
}

- (CGPoint)pointInView:(CGSize)viewSize fromNormalizedPoint:(CGPoint)normalizedPoint
{
    return CGPointMake(normalizedPoint.x * viewSize.width, normalizedPoint.y * viewSize.height);
}

- (CGSize)sizeForImage:(UIImage *) image fromSize:(CGSize)originalSize
{
    CGSize convertedSize;
    switch (image.imageOrientation)
    {
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            convertedSize.width = originalSize.width;
            convertedSize.height = originalSize.height;
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
        case UIImageOrientationLeftMirrored:            
        case UIImageOrientationRightMirrored:            
            convertedSize.width = originalSize.height;
            convertedSize.height = originalSize.width;
            break;
        default:
            break;
    }
    return convertedSize;
}

- (CGSize)normalizedSizeForImage:(UIImage *)image fromSize:(CGSize)originalSize
{
    CGSize normalizedSize = [self sizeForImage:image fromSize:originalSize];
    normalizedSize.width /= image.size.width;
    normalizedSize.height /= image.size.height;
    
    return normalizedSize;
}

- (CGSize)sizeInView:(CGSize)viewSize fromNormalizedSize:(CGSize)normalizedSize
{
    return CGSizeMake(normalizedSize.width * viewSize.width, normalizedSize.height * viewSize.height);
}

- (CGRect)boundsForImage:(UIImage *) image fromBounds:(CGRect)originalBounds
{
    CGPoint convertedOrigin = [self pointForImage:image fromPoint:originalBounds.origin];;
    CGSize convertedSize = [self sizeForImage:image fromSize:originalBounds.size];
    switch (image.imageOrientation)
    {
        case UIImageOrientationUp:
            convertedOrigin.y -= convertedSize.height;
            break;
        case UIImageOrientationDown:
            convertedOrigin.x -= convertedSize.width;
            break;
        case UIImageOrientationLeft:
            convertedOrigin.x -= convertedSize.width;
            convertedOrigin.y -= convertedSize.height;
        case UIImageOrientationRight:
            break;
        case UIImageOrientationUpMirrored:
            convertedOrigin.y -= convertedSize.height;
            convertedOrigin.x -= convertedSize.width;
            break;
        case UIImageOrientationDownMirrored:
            break;
        case UIImageOrientationLeftMirrored:
            convertedOrigin.x -= convertedSize.width;
            convertedOrigin.y += convertedSize.height;
        case UIImageOrientationRightMirrored:
            convertedOrigin.y -= convertedSize.height;
            break;
        default:
            break;
    }
    return CGRectMake(convertedOrigin.x, convertedOrigin.y,
                      convertedSize.width, convertedSize.height);
}

- (CGRect)normalizedBoundsForImage:(UIImage *) image fromBounds:(CGRect)originalBounds
{
    CGRect normalizedBounds = [self boundsForImage:image fromBounds:originalBounds];
    normalizedBounds.origin.x /= image.size.width;
    normalizedBounds.origin.y /= image.size.height;
    normalizedBounds.size.width /= image.size.width;
    normalizedBounds.size.height /= image.size.height;
    return normalizedBounds;
}

- (CGRect)boundsInView:(CGSize)viewSize fromNormalizedBounds:(CGRect)normalizedBounds
{
    return CGRectMake(normalizedBounds.origin.x * viewSize.width,
                      normalizedBounds.origin.y * viewSize.height,
                      normalizedBounds.size.width * viewSize.width,
                      normalizedBounds.size.height * viewSize.height);
}

@end
