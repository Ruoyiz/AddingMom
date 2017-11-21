//
//  UIImage+RoundImg.m
//  
//
//  Created by D on 15/8/3.
//
//

#import "UIImage+RoundImg.h"

@implementation UIImage (RoundImg)

- (UIImage *)imageWithRoundedCornersAndSize:(CGSize)sizeToFit
{
    CGRect rect = (CGRect){0.f, 0.f, sizeToFit};
    
    UIGraphicsBeginImageContextWithOptions(sizeToFit, NO, UIScreen.mainScreen.scale); // 这里不会导致Offscreen rendering，只有使用bitmap image context才会导致offscreen rendering
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:sizeToFit.width].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return output;
}

@end
