//
//  ADOneHourDataView.h
//  PregnantAssistant
//
//  Created by D on 14-10-11.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADOneHourDataView : UIView

@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) int num;

@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *numLabel;

@end
