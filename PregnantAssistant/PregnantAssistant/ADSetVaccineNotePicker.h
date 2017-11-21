//
//  ADSetVaccineNotePicker.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/9.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ADSetVaccineNotePicker : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, retain) UIButton *doneBtn;
@property (nonatomic, retain) UIPickerView *myPicker;

@end
