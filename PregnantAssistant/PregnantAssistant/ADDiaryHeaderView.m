//
//  ADDiaryHeaderView.m
//  PregnantAssistant
//
//  Created by D on 14-9-20.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADDiaryHeaderView.h"

@implementation ADDiaryHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //add title
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 8, 175, 21)];
        
        [_titleLabel setFont:[UIFont systemFontOfSize:16]];
        
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
//        _titleLabel.textColor = [UIColor defaultTintColor];
        _titleLabel.textColor = [UIColor btn_green_bgColor];
        
        [self addSubview:_titleLabel];
        
        //add point
        UIView *point =[[UIView alloc]initWithFrame:CGRectMake(6.5, 12, 12, 12)];
        [point setClipsToBounds:YES];
        point.backgroundColor = [UIColor btn_green_bgColor];
        [point.layer setCornerRadius:6];
        
        [self addSubview:point];
    }
    
    return self;
}

@end
