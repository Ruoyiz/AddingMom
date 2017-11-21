//
//  UIImage+Rotate.m
//  LineGraphDemo
//
//  Created by D on 14/11/25.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import "UIImage+Rotate.h"

@implementation UIImage (Rotate)

- (UIImage*)flipHorizontal
{
    UIImage *image = nil;
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
        {
            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationUpMirrored];
            break;
        }
        case UIImageOrientationDown:
        {
            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationDownMirrored];
            break;
        }
        case UIImageOrientationLeft:
        {
            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationRightMirrored];
            break;
        }
        case UIImageOrientationRight:
        {
            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationLeftMirrored];
            break;
        }
        case UIImageOrientationUpMirrored:
        {
            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationUp];
            break;
        }
        case UIImageOrientationDownMirrored:
        {
            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationDown];
            break;
        }
        case UIImageOrientationLeftMirrored:
        {
            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationRight];
            break;
        }
        case UIImageOrientationRightMirrored:
        {
            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationLeft];
            break;
        }
        default:
            break;
    }
    
    return image;
}

/*
 * @brief flip vertical
 */
- (UIImage*)flipVertical
{
    UIImage *image = nil;
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
        {
            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationDownMirrored];
            break;
        }
        case UIImageOrientationDown:
        {
            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationUpMirrored];
            break;
        }
        case UIImageOrientationLeft:
        {
            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationLeftMirrored];
            break;
        }
        case UIImageOrientationRight:
        {
            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationRightMirrored];
            break;
        }
        case UIImageOrientationUpMirrored:
        {
            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationDown];
            break;
        }
        case UIImageOrientationDownMirrored:
        {
            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationUp];
            break;
        }
        case UIImageOrientationLeftMirrored:
        {
            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationLeft];
            break;
        }
        case UIImageOrientationRightMirrored:
        {
            image = [UIImage imageWithCGImage:self.CGImage scale:1 orientation:UIImageOrientationRight];
            break;
        }
        default:
            break;
    }
    
    return image;
}

@end
