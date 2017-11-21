//
//  ADToolGuideView.m
//  PregnantAssistant
//
//  Created by D on 15/4/10.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADShadowView.h"

@implementation ADShadowView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


// begin the blur masking operation.
- (void)beginBlurMaskingWithOrigin:(CGPoint)origin andDiameter:(CGFloat)aDiameter
{
    self.blurFilterOrigin = origin;
    self.blurFilterDiameter = aDiameter;
    
    CAShapeLayer *blurFilterMask = [CAShapeLayer layer];

    blurFilterMask.actions = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"path", nil];
    blurFilterMask.fillColor = UIColorFromRGB(0x4d4587).CGColor;
    blurFilterMask.fillRule = kCAFillRuleEvenOdd;
    blurFilterMask.frame = self.bounds;
    blurFilterMask.opacity = 0.9f;
    self.blurFilterMask = blurFilterMask;
    
    [self.blurFilterMask removeFromSuperlayer];
    [self refreshBlurMask];
    [self.layer addSublayer:blurFilterMask];
}

- (void)refreshBlurMask
{
    CGFloat blurFilterRadius = self.blurFilterDiameter * 0.5f;
    
    CGMutablePathRef blurRegionPath = CGPathCreateMutable();
    CGPathAddRect(blurRegionPath, NULL, self.bounds);
    CGPathAddEllipseInRect(blurRegionPath, NULL, CGRectMake(self.blurFilterOrigin.x - blurFilterRadius, self.blurFilterOrigin.y - blurFilterRadius, self.blurFilterDiameter, self.blurFilterDiameter));
    
    self.blurFilterMask.path = blurRegionPath;
    
    CGPathRelease(blurRegionPath);
}


@end
