//
//  ADSetDuePicker.m
//  PregnantAssistant
//
//  Created by D on 15/4/1.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADSetDuePicker.h"
#import "UIImage+Tint.h"

@implementation ADSetDuePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _myDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 216)];
        _myDatePicker.datePickerMode = UIDatePickerModeDate;
        
        //NSLog(@"%d,max:%@,min%@",self.launchType,newMaxDate,newMinDate);
        
        _myDatePicker.timeZone = [NSTimeZone systemTimeZone];
        _myDatePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        [_myDatePicker setValue:[UIColor btn_green_bgColor] forKeyPath:@"textColor"];
        SEL selector = NSSelectorFromString(@"setHighlightsToday:");
        NSInvocation *invocation =
        [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
        BOOL no = NO;
        [invocation setSelector:selector];
        [invocation setArgument:&no atIndex:0];
        [invocation invokeWithTarget:_myDatePicker];
        
        [self addSubview:_myDatePicker];
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        bottomView.backgroundColor = [UIColor title_darkblue];
        [self addSubview:bottomView];
        
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH, 50)];
        _tipLabel.text = @"选择预产期";
        _tipLabel.textColor = [UIColor whiteColor];
        [bottomView addSubview:_tipLabel];
        
        _doneBtn =
        [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 -2, 0, 50, 50)];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn setImage:[[UIImage imageNamed:@"iconOk"] imageWithTintColor:[UIColor whiteColor]]
                  forState:UIControlStateNormal];
        [self addSubview:_doneBtn];
    }
    return self;
}

- (void)setupDateWithLaunchType:(ADLaunchType)launchType
{
    NSDate* now = [NSDate date];
    NSDate *newMinDate = now;
    NSDate *newMaxDate = [now dateByAddingTimeInterval:279*60*60*24];
    //NSInteger launchType = [[NSUserDefaults standardUserDefaults] launchType];
    
    if (launchType == ADLaunchTypeDuringParenting) {
        //newMaxDate = now dateByAddingTimeInterval:-279*60*60*24*daysToAdd];
        newMaxDate = now;
        newMinDate = [self dateBeforeYears:7];
    }
    
    _myDatePicker.minimumDate = newMinDate;
    _myDatePicker.maximumDate = newMaxDate;
}

- (NSDate *)dateBeforeYears:(int)years
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    
    [componentsToAdd setYear: - years];
    
    NSDate *dateBeforeYears = [calendar dateByAddingComponents:componentsToAdd toDate:[NSDate date] options:0];
    
    return dateBeforeYears;
    
}

@end
