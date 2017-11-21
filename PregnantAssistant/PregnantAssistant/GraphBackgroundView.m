//
//  GraphBackgroundView.m
//  LineGraphDemo
//
//  Created by D on 14/11/21.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import "GraphBackgroundView.h"

@implementation GraphBackgroundView

-  (id)initWithFrame:(CGRect)frame
withBackgroundValues:(NSArray *)aValueArray
withBackgroundColors:(NSArray *)aColorArray
       withBarHeight:(int)barHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundValueArray = [aValueArray copy];
        self.backgroundColorArray = [aColorArray copy];
        for (int i = 0; i < self.backgroundValueArray.count; i++) {
            UIView *backgroundView = [[UIView alloc]initWithFrame:
                                      CGRectMake(0, i*barHeight, self.frame.size.width, barHeight)];
            backgroundView.backgroundColor = self.backgroundColorArray[i];
            [self addSubview:backgroundView];
            
            UILabel *valueLabel = [[UILabel alloc]initWithFrame:
                                   CGRectMake(0, i*barHeight, self.frame.size.width, barHeight)];
            valueLabel.font = [UIFont systemFontOfSize:24];
//            valueLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.35];
            valueLabel.textColor = UIColorFromRGBAndAlpha(0x04af96, 0.3);
            valueLabel.text = self.backgroundValueArray[i];
            valueLabel.textAlignment = NSTextAlignmentCenter;
            
            [self addSubview:valueLabel];
        }
    }
    
    return self;
}

@end
