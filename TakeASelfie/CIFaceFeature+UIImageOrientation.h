//
//  CIFaceFeature+UIImageOrientation.h
//  
//
//  Created by Xiaochao Yang on 6/9/13.
//  Copyright (c) 2013 Xiaochao Yang. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>

@interface CIFaceFeature (UIImageOrientation)

// Get converted features with respect to the imageOrientation property
- (CGPoint)leftEyePositionForImage:(UIImage *)image;
- (CGPoint)rightEyePositionForImage:(UIImage *)image;
- (CGPoint)mouthPositionForImage:(UIImage *)image;
- (CGRect)boundsForImage:(UIImage *)image;

// Get normalized features (0-1) with respect to the imageOrientation property
- (CGPoint)normalizedLeftEyePositionForImage:(UIImage *)image;
- (CGPoint)normalizedRightEyePositionForImage:(UIImage *)image;
- (CGPoint)normalizedMouthPositionForImage:(UIImage *)image;
- (CGRect)normalizedBoundsForImage:(UIImage *)image;

// Get feature location inside of a given UIView size with respect to the imageOrientation property
- (CGPoint)leftEyePositionForImage:(UIImage *)image inView:(CGSize)viewSize;
- (CGPoint)rightEyePositionForImage:(UIImage *)image inView:(CGSize)viewSize;
- (CGPoint)mouthPositionForImage:(UIImage *)image inView:(CGSize)viewSize;
- (CGRect)boundsForImage:(UIImage *)image inView:(CGSize)viewSize;

@end
