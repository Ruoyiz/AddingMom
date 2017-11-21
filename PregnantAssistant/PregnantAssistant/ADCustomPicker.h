//
//  ADCustomPicker.h
//  PregnantAssistant
//
//  Created by D on 14-9-20.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADCustomButton.h"

@interface ADCustomPicker : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, retain) ADCustomButton *doneBtn;
@property (nonatomic, retain) NSString *pickerTitle;
@property (nonatomic, retain) UIView *grayBg;
@property (nonatomic, retain) UIDatePicker *myDatePicker;

- (void)showPicker;
- (void)hidePicker;

- (id)initWithFrame:(CGRect)frame
        withMinDate:(BOOL)haveMin;

@end
