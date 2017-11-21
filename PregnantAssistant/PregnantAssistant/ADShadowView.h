//
//  ADToolGuideView.h
//  PregnantAssistant
//
//  Created by D on 15/4/10.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADShadowView : UIView

@property (nonatomic, retain) UIView *bgView;

@property (nonatomic, strong) CAShapeLayer *blurFilterMask;
@property (nonatomic, assign) CGPoint blurFilterOrigin;
@property (nonatomic, assign) CGFloat blurFilterDiameter;

- (void)beginBlurMaskingWithOrigin:(CGPoint)origin andDiameter:(CGFloat)aDiameter;

- (void)refreshBlurMask;

@end
