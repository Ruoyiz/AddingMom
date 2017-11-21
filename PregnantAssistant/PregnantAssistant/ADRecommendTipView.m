//
//  ADRecommendTipView.m
//  PregnantAssistant
//
//  Created by D on 14/12/31.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADRecommendTipView.h"

@implementation ADRecommendTipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *rLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, frame.size.width, frame.size.height -12)];
        rLabel.text = @"荐";
        [rLabel setTextColor:[UIColor whiteColor]];
        [rLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:rLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //设置背景颜色
    [[UIColor clearColor]set];
    
    UIRectFill([self bounds]);
    
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    
    CGContextMoveToPoint(context, 0, 0);//设置起点
    
    CGContextAddLineToPoint(context, 30, 0);
    
    CGContextAddLineToPoint(context, 0, 30);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [[UIColor defaultTintColor] setFill]; //设置填充色
    
//    [[UIColor whiteColor] setStroke]; //设置边框颜色
    
    CGContextDrawPath(context,
                      kCGPathFillStroke);//绘制路径path
    
}

@end
