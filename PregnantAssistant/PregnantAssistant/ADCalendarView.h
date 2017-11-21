//
//  ADCalendarView.h
//  PregnantAssistant
//
//  Created by D on 14-9-15.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADCalendarView : UIView

@property (nonatomic, retain) UILabel *dayLabel;

@property (nonatomic, assign) BOOL isCntView;
@property (nonatomic, assign) BOOL isParentingCalendar;
@property (nonatomic, retain) ADAppDelegate *appDelegate;

//@property (nonatomic, retain) NSDate *displayDate;

- (id)initWithFrame:(CGRect)frame
      withIsCntView:(BOOL)isCnt;

- (void)setDayLabelWithDate:(NSDate *)date;

@end
