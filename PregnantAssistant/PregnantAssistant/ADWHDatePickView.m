//
//  ADWHDatePickView.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/6/3.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADWHDatePickView.h"
#import "UIImage+Tint.h"

@interface ADWHDatePickView (){

    UILabel *_titleLabel;
}

@end

@implementation ADWHDatePickView

- (id)initWithFrame:(CGRect)frame titleString:(NSString *)titleString titleImageName:(NSString *)imageName minimumDate:(NSDate *)minDate maximumDate:(NSDate *)maxDate nowDate:(NSDate *)nowDate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 216)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.timeZone = [NSTimeZone systemTimeZone];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.minimumDate = minDate;
        _datePicker.maximumDate = maxDate;
        _datePicker.date = nowDate;
        [_datePicker setValue:[UIColor btn_green_bgColor] forKeyPath:@"textColor"];
        SEL selector = NSSelectorFromString(@"setHighlightsToday:");
        NSInvocation *invocation =
        [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
        BOOL no = NO;
        [invocation setSelector:selector];
        [invocation setArgument:&no atIndex:2];
        [invocation invokeWithTarget:_datePicker];
        [self addSubview:_datePicker];
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        bottomView.backgroundColor = [UIColor title_darkblue];
        [self addSubview:bottomView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH, 50)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = titleString;
        [bottomView addSubview:_titleLabel];
        
        _doneBtn =
        [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 -2, 0, 50, 50)];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn setImage:[[UIImage imageNamed:imageName] imageWithTintColor:[UIColor whiteColor]]
                  forState:UIControlStateNormal];
        [self addSubview:_doneBtn];
    }
    return self;
}

@end
