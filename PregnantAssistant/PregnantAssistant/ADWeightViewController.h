//
//  ADWeightViewController.h
//  PregnantAssistant
//
//  Created by D on 15/4/1.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADSetWeightPicker.h"
#import "ADSetHeightPicker.h"

@interface ADWeightViewController : ADBaseViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) UILabel *displayLabel;
@property (nonatomic, retain) ADSetWeightPicker *setWeightPicker;
@property (nonatomic, retain) ADSetHeightPicker *setHeightPicker;
@property (nonatomic, retain) NSMutableArray *weightArray;
@property (nonatomic, retain) NSArray *dotweightArray;
@property (nonatomic, retain) NSMutableArray *heightArray;

@property (nonatomic, assign) NSInteger bigWeight;
@property (nonatomic, assign) NSInteger dotWeight;
@property (nonatomic, copy) NSString *weightStr;
@property (nonatomic, assign) NSInteger bigHeight;
@property (nonatomic, copy)NSString *heightStr;
@property (nonatomic, assign)BOOL isWeight;

@end
