//
//  ADCheckCalendarViewController.h
//  PregnantAssistant
//
//  Created by D on 14-9-19.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADToolRootViewController.h"
#import "ADAlarmButton.h"
#import "ADCustomPicker.h"
#import "ADCheckCalDAO.h"

@interface ADCheckCalViewController : ADToolRootViewController

@property (nonatomic, retain) UILabel *tipLabel;
@property (nonatomic, retain) ADAlarmButton *alarmBtn;
@property (nonatomic, copy) NSArray *buttonArray;

@property (nonatomic, copy) NSArray *buttonNameArray;

//@property (nonatomic, retain) NSDate *selectDate;
//@property (nonatomic, retain) NSMutableArray *selectDateArray;
@property (nonatomic, retain) RLMResults *selectDateArray;
@property (nonatomic, retain) ADCustomPicker *datePicker;

@property (nonatomic, retain) UIScrollView *myScrollView;

@property (nonatomic, retain) NSDate *currentDisplayDate;

@end
