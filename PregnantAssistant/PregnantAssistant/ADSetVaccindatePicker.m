//
//  ADSetVaccindatePicker.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/8.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADSetVaccindatePicker.h"
#import "UIImage+Tint.h"

@implementation ADSetVaccindatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _myDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 216)];
        _myDatePicker.datePickerMode = UIDatePickerModeDate;
        
        
        
        //        NSLog(@"%d,max:%@,min%@",self.launchType,newMaxDate,newMinDate);
        
        _myDatePicker.timeZone = [NSTimeZone systemTimeZone];
        _myDatePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        [_myDatePicker setValue:[UIColor btn_green_bgColor] forKeyPath:@"textColor"];
        SEL selector = NSSelectorFromString(@"setHighlightsToday:");
        NSInvocation *invocation =
        [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
        BOOL no = NO;
        [invocation setSelector:selector];
        [invocation setArgument:&no atIndex:2];
        [invocation invokeWithTarget:_myDatePicker];
        
        [self addSubview:_myDatePicker];
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        bottomView.backgroundColor = [UIColor title_darkblue];
        [self addSubview:bottomView];
        
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH, 50)];
        _tipLabel.text = @"选择接种日期";
        _tipLabel.textColor = [UIColor whiteColor];
        [bottomView addSubview:_tipLabel];
        
        _doneBtn =
        [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 -2, 0, 50, 50)];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn setImage:[[UIImage imageNamed:@"iconOk"] imageWithTintColor:[UIColor whiteColor]]
                  forState:UIControlStateNormal];
        [self addSubview:_doneBtn];
        
        [self setupDate];
    }
    return self;
}

- (void)setupDate
{
//    NSDate* now = [NSDate date];
//    int daysToAdd = 0;
//    NSDate *newMinDate = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
//   // NSDate *newMaxDate = [now dateByAddingTimeInterval:279*60*60*24*daysToAdd];
//    //NSInteger launchType = [[NSUserDefaults standardUserDefaults] launchType];
//    
////    if (launchType == ADLaunchTypeDuringParenting) {
////        //newMaxDate = now dateByAddingTimeInterval:-279*60*60*24*daysToAdd];
////        newMaxDate = now;
////        newMinDate = [self dateBeforeYears:7];
////    }
////
    ADAppDelegate *myApp = APP_DELEGATE;
    if ([myApp.userStatus isEqualToString:@"2"]) {
        _myDatePicker.minimumDate = myApp.babyBirthday;
    }
   // _myDatePicker.maximumDate = newMaxDate;
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
