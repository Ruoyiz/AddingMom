//
//  ADCustomHeaderView.m
//  PregnantAssistant
//
//  Created by D on 14-9-18.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADCustomHeaderView.h"

@implementation ADCustomHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 7, 175, 21)];
        
        //style
        [_titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        _titleLabel.textColor = [UIColor btn_green_bgColor];
        
        [self addSubview:_titleLabel];
        
        UIView *bottomView = [[UIView alloc]initWithFrame:
                              CGRectMake(12, self.frame.size.height -0.5, SCREEN_WIDTH -24, 0.5)];
        bottomView.backgroundColor = [UIColor btn_green_bgColor];
        [self addSubview:bottomView];
    }
    
    return self;
}

@end
