//
//  ADCalcFetalView.h
//  PregnantAssistant
//
//  Created by D on 14-10-11.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADCalcFetalView : UIView

@property (nonatomic, assign) NSInteger todayCnt;
@property (nonatomic, assign) NSInteger perHour;

//@property (nonatomic, assign) int mostHourTime;

@property (nonatomic, retain) UILabel *tip1;
@property (nonatomic, retain) UILabel *tip2;

@property (nonatomic, retain) UILabel *cntLabel;
@property (nonatomic, retain) UILabel *perHourLabel;

@property (nonatomic, retain) UILabel *mostHour;
@property (nonatomic, retain) UILabel *mostHourLabel;
@property (nonatomic, retain) UILabel *mostHourTimeLabel;

@property (nonatomic, retain) UIImageView *emptyHourView;

- (void)showDataWithAnimation:(BOOL)animated;

@end
