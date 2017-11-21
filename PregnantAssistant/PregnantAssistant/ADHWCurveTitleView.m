//
//  ADHWCurveTitleView.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/6/8.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADHWCurveTitleView.h"

@interface ADHWCurveTitleView (){

    CGPoint _circle;
    CGFloat _outsideRadius;
    CGFloat _insideRadius;
    UIColor *_outsideColor;
    UIColor *_insideColor;
}

@end

@implementation ADHWCurveTitleView

- (instancetype)initWithFrame:(CGRect)frame radiusOfOutside:(CGFloat)outsideRadius andCGColor:(UIColor *)outsideColor insideRadius:(CGFloat)insideRadius andCGColor:(UIColor *)insideColor{

    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _circle = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
        _outsideRadius = outsideRadius;
        _insideRadius = insideRadius;
        _outsideColor = outsideColor;
        _insideColor = insideColor;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(context, _circle.x, _circle.y, _outsideRadius, 0, M_PI * 2, 1);
    [_outsideColor setFill];
    [_insideColor setStroke];
    CGContextDrawPath(context, kCGPathEOFillStroke);
    
    CGContextAddArc(context, _circle.x, _circle.y, _insideRadius, 0, M_PI * 2, 1);
    [_insideColor setFill];
    CGContextDrawPath(context, kCGPathFill);


}


@end
