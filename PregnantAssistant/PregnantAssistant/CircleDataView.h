//
//  CircleDataView.h
//  LineGraphDemo
//
//  Created by D on 14/11/21.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADLine.h"

@interface CircleDataView : UIView

@property (nonatomic, copy) NSString *aDateStr;

@property (nonatomic, copy) NSString *value1;
@property (nonatomic, copy) NSString *value2; // maybe null
@property (nonatomic, copy) NSString *unit; // 单位

@property (nonatomic, retain) UIButton *addBtn;
@property (nonatomic, retain) UIButton *editBtn;

@property (nonatomic, retain) UIViewController *parentVC;

@property (nonatomic, retain) UIImageView *emptyImgView;
@property (nonatomic, retain) ADLine *lineView;

@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *value1Label;
@property (nonatomic, retain) UILabel *value2Label;
@property (nonatomic, retain) UILabel *unitLabel;

-  (id)initWithFrame:(CGRect)frame
            withDate:(NSString *)aDateStr
          withValue1:(NSString *)aValue1
          withValue2:(NSString *)aValue2
            withUnit:(NSString *)aUnit
             isEmpty:(BOOL)isEmpty
         andParentVC:(UIViewController *)aVc;

-  (void)setViewWithDate:(NSString *)aDateStr
              withValue1:(NSString *)aValue1
              withValue2:(NSString *)aValue2
                withUnit:(NSString *)aUnit
                 isEmpty:(BOOL)isEmpty;

@end
