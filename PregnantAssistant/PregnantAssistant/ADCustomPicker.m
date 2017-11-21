//
//  ADCustomPicker.m
//  PregnantAssistant
//
//  Created by D on 14-9-20.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADCustomPicker.h"

@implementation ADCustomPicker

- (id)initWithFrame:(CGRect)frame
        withMinDate:(BOOL)haveMin
{
    self = [self initWithFrame:frame];
    self.myDatePicker.minimumDate = nil;
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _myDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 216)];
        _myDatePicker.datePickerMode = UIDatePickerModeDate;
       
        NSDate* now = [NSDate date];
        int daysToAdd = 1;
        NSDate *newMinDate = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
        NSDate *newMaxDate = [now dateByAddingTimeInterval:279*60*60*24*daysToAdd];

        _myDatePicker.minimumDate = newMinDate;
        _myDatePicker.maximumDate = newMaxDate;
        _myDatePicker.date = newMinDate;
        _myDatePicker.timeZone = [NSTimeZone systemTimeZone];
        _myDatePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        [self addSubview:_myDatePicker];
        
        _doneBtn =
        [[ADCustomButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60 -12, 5, 60, 30)];
        _doneBtn.titleStr = @"确定";
        [_doneBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
//        _doneBtn.buttonColor = [UIColor defaultTintColor];
        [_doneBtn.layer setCornerRadius:15];
        [self addSubview:_doneBtn];
        
    }
    return self;
}
- (void)setPickerTitle:(NSString *)pickerTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 5, 300, 30)];
    label.text = pickerTitle;
    label.font = [UIFont systemFontOfSize:14];
    [self addSubview:label];
}
- (void)showPicker
{
    UIWindow *shareWindow = [UIApplication sharedApplication].keyWindow;
    _grayBg =
    [[UIView alloc]initWithFrame:CGRectMake(0, 0, shareWindow.frame.size.width, shareWindow.frame.size.height)];
    _grayBg.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.62];
    _grayBg.alpha = 0;
    _grayBg.tag = 200;
    [shareWindow addSubview:_grayBg];
    
    [_grayBg addSubview:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissSelf)];
    tap.delegate = self;
    [_grayBg addGestureRecognizer:tap];
    
    
    [UIView animateWithDuration:0.4 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _grayBg.alpha = 1;
                         
                         CGRect datepickerFrame = self.frame;
                         datepickerFrame.origin.y -= (216 *2 + 40);
                         self.frame = datepickerFrame;
                     } completion:^(BOOL finished) {
                     }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view.tag == 200) {
        return YES;
    }
    return NO;
}

- (void)hidePicker
{
    [UIView animateWithDuration:0.5 delay:0.1
         usingSpringWithDamping:1 initialSpringVelocity:2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _grayBg.alpha = 0;
                         
                         CGRect datepickerFrame = self.frame;
                         datepickerFrame.origin.y += (216 *2 + 40);
                         self.frame = datepickerFrame;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)dismissSelf
{
    [self hidePicker];
}

@end
