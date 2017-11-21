//
//  ADWHDatePickView.h
//  PregnantAssistant
//
//  Created by 加丁 on 15/6/3.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADWHDatePickView : UIView

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *doneBtn;

//instancetype方法
- (instancetype)initWithFrame:(CGRect)frame titleString:(NSString *)titleString titleImageName:(NSString *)imageName minimumDate:(NSDate *)minDate maximumDate:(NSDate *)maxDate nowDate:(NSDate *)nowDate;


@end
