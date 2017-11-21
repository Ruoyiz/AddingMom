//
//  UIImage+Round.swift
//  PregnantAssistant
//
//  Created by D on 15/8/3.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

import UIKit

extension UIImage {
    
    func imageToRound(size: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPointZero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        CGContextAddPath(UIGraphicsGetCurrentContext(), UIBezierPath(roundedRect: rect, cornerRadius: size.width).CGPath)
        CGContextClip(UIGraphicsGetCurrentContext())
        
        self.drawInRect(rect)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output
    }
    
    /*
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
*/
}
