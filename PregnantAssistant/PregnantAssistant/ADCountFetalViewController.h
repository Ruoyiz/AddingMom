//
//  ADCountFetalViewController.h
//  PregnantAssistant
//
//  Created by D on 14-10-10.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADToolRootViewController.h"
#import "ADCalendarView.h"
#import "ADCntFetalView.h"
#import "ADOneHourView.h"
#import "ADTodayRecordNumView.h"
#import "ADCalcFetalView.h"
#import "ADLineGraphView.h"
#import "ADCountFetalDAO.h"

@interface ADCountFetalViewController : ADToolRootViewController <
ADLineGraphDelegate,
ADCntFetalViewDelegate
>

@property (nonatomic, retain) UIView *emptyBgView;
@property (nonatomic, retain) ADCalendarView *aCalendarView;
@property (nonatomic, retain) ADCntFetalView *aCntView;
@property (nonatomic, retain) ADOneHourView *oneView;

@property (nonatomic, retain) UIView *noticeBgView;
@property (nonatomic, retain) UIScrollView *myScrollView;
@property (nonatomic, retain) UIScrollView *graphBackgroundScrollView;

@property (nonatomic, assign) BOOL isOneViewShow;

@property (nonatomic, retain) UIImageView *howImgView;
@property (nonatomic, retain) UIImageView *tipImgView;
@property (nonatomic, retain) UIImageView *cloadImageView;

@property (nonatomic, retain) ADTodayRecordNumView *todayView;
@property (nonatomic, retain) ADCalcFetalView *calcCntView;

@property (nonatomic, retain) NSMutableArray *perHourValuesArray;
@property (nonatomic, retain) RLMResults *allHourArray;

@property (nonatomic, retain) ADLineGraphView *lineGraph;

@property (nonatomic, retain) NSTimer *showDataTimer;

@property (nonatomic, assign) int originTablePerHourValuesArrayCnt;

@property (nonatomic, retain) UIView *ADOneHourDataCardView;

@property (nonatomic, retain) NSMutableArray *perOneHourViewArray;

@property (nonatomic, retain) NSMutableArray *transformedHourArray;

@property (nonatomic, retain) NSDate *mostHour;
@property (nonatomic, copy) NSString *mostHourNum;
@property (nonatomic, assign) NSInteger avgHourNum;

@property (nonatomic, retain) NSDate *todayFirstClickDate;

@property (nonatomic, retain) NSDate *showOneViewDate;
@property (nonatomic, retain) NSDate *oneHourValidStartTime;
@property (nonatomic, retain) NSDate *oneHourValidEndTime;

@property (nonatomic, retain) NSDate *valiedClickDate;

@property (nonatomic, retain) RLMResults *todayOneHourArray;

@property (nonatomic, assign) BOOL isAnimatingOneView;
@property (nonatomic, retain) UILabel *fiveMinLabel;

@end