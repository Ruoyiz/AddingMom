//
//  ADPregNotifyViewController.h
//  PregnantAssistant
//
//  Created by D on 15/3/26.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADCalendarView.h"
#import "ADBigBabyTitleView.h"

@interface ADPregNotifyViewController : ADBaseViewController

@property (nonatomic, retain) ADCalendarView *aCalendarView;
@property (nonatomic, retain) UIScrollView *scorllBg;

@property (nonatomic, retain) NSMutableArray *babyData;
@property (nonatomic, assign) int week;
@property (nonatomic, assign) int dueday;
@property (nonatomic, assign) int passDay;

@property (nonatomic, assign) NSInteger betweenDay;

@property (nonatomic, retain) UILabel *dayLabel;
@property (nonatomic, retain) UILabel *descLabel;

@property (nonatomic, retain) UILabel *babyLengthLabel;
@property (nonatomic, retain) UILabel *babyWeightLabel;

@property (nonatomic, retain) UILabel *tip1Label;
@property (nonatomic, retain) UILabel *babyDescLabel;
@property (nonatomic, retain) UILabel *tip2Label;
@property (nonatomic, retain) UILabel *momDescLabel;

@property (nonatomic, retain) NSDictionary *babyDataDict;

@property (nonatomic, retain) ADBigBabyTitleView *aBigTitleView;

@property (nonatomic, copy) void(^disMissNavBlock)(void);


@end