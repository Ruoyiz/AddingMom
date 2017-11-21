//
//  ADSetDuePicker.h
//  PregnantAssistant
//
//  Created by D on 15/4/1.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADSetDuePicker : UIView

@property (nonatomic, retain) UILabel *tipLabel;
@property (nonatomic, retain) UIButton *doneBtn;
@property (nonatomic, retain) UIDatePicker *myDatePicker;


- (void)setupDateWithLaunchType:(ADLaunchType)launchType;

@end
