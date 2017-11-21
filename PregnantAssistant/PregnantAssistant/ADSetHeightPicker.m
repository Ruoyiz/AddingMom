//
//  ADSetHeightPicker.m
//  PregnantAssistant
//
//  Created by D on 15/4/1.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADSetHeightPicker.h"
#import "UIImage+Tint.h"

@implementation ADSetHeightPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _myDatePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 216)];
        [_myDatePicker setBackgroundColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1]];
        [self addSubview:_myDatePicker];
        UIToolbar *bottomView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [self addSubview:bottomView];
        
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH, 44)];
        tipLabel.text = @"选择身高";
        tipLabel.font = [UIFont systemFontOfSize:14];
        [bottomView addSubview:tipLabel];
        _doneBtn =
        [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 -2, 0, 50, 44)];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_doneBtn setTitleColor:[UIColor btn_green_bgColor] forState:UIControlStateNormal];
        [self addSubview:_doneBtn];
    }
    return self;
}

@end
