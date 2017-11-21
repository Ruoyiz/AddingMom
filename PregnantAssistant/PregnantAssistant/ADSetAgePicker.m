//
//  ADSetAgePicker.m
//  PregnantAssistant
//
//  Created by D on 15/4/1.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADSetAgePicker.h"
#import "UIImage+Tint.h"

@implementation ADSetAgePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _myDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 216)];
        _myDatePicker.datePickerMode = UIDatePickerModeDate;
        [_myDatePicker setBackgroundColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1]];
        _myDatePicker.maximumDate = [NSDate date];
        _myDatePicker.date = [NSDate date];
        _myDatePicker.timeZone = [NSTimeZone systemTimeZone];
        _myDatePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
//        [_myDatePicker setValue:[UIColor light_green_Btn] forKeyPath:@"textColor"];
//        SEL selector = NSSelectorFromString(@"setHighlightsToday:");
//        NSInvocation *invocation =
//        [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
//        BOOL no = NO;
//        [invocation setSelector:selector];
//        [invocation setArgument:&no atIndex:2];
//        [invocation invokeWithTarget:_myDatePicker];
        
        [self addSubview:_myDatePicker];
        
        UIToolbar *bottomView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [self addSubview:bottomView];
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH, 44)];
        tipLabel.text = @"选择你的生日";
        tipLabel.font = [UIFont systemFontOfSize:14];
        [bottomView addSubview:tipLabel];
        
        _doneBtn =
        [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 -2, 0, 50, 44)];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_doneBtn setTitleColor:[UIColor btn_green_bgColor] forState:UIControlStateNormal];
        //[_doneBtn setImage:[[UIImage imageNamed:@"iconOk"] imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self addSubview:_doneBtn];
    }
    return self;
}

@end