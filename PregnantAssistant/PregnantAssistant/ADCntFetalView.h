//
//  ADCntFetalView.h
//  PregnantAssistant
//
//  Created by D on 14-10-10.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADOneHourView.h"

@protocol ADCntFetalViewDelegate <NSObject>

@required
//pro 1 hour pressed
- (void)proButtonClick:(UIButton *)sender;

//finish pro 1 hour pressed
- (void)finishProButtonClick;

//add 1 pressed
- (void)addOneBtnClicked:(UIButton *)sender;

@end

@interface ADCntFetalView : UIView

@property (nonatomic, weak) id <ADCntFetalViewDelegate> delegate;
@property (nonatomic, retain) UIButton *proCntBtn;
@property (nonatomic, retain) UIButton *closeCntBtn;
@property (nonatomic, retain) UIButton *addCntBtn;

@property (nonatomic, retain) UIButton *finishBtn;

@property (nonatomic, retain) NSTimer *minuteTimer;

@property (nonatomic, retain) ADOneHourView *oneView;

@property (nonatomic, retain) NSMutableArray *hourDataArray;

//@property (nonatomic, retain) NSDate *validStartTime;
//@property (nonatomic, retain) NSDate *validEndTime;

//- (void)changeCntBtnToText;
- (void)changeCntBtnToNum;

- (void)changeFinishButton;


@end
