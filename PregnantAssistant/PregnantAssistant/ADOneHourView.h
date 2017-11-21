//
//  ADOneHoutView.h
//  PregnantAssistant
//
//  Created by D on 14-10-10.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADOneHourView : UIView

@property (nonatomic, assign) int allCnt;
@property (nonatomic, assign) int validCount;

@property (nonatomic, retain) UILabel *beginTimeLabel;
@property (nonatomic, retain) UILabel *validLabel;
@property (nonatomic, retain) UILabel *reminTimeLabel;
@property (nonatomic, retain) UILabel *totalHeadLabel;

@property (nonatomic, retain) NSTimer *durationTimer;
@property (nonatomic, assign) int durationTime;

- (void)resetTimer;
- (void)startTimer;

@end
