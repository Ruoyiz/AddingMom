//
//  ADWHeightPickerView.h
//  PregnantAssistant
//
//  Created by 加丁 on 15/6/2.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADWHeightPickerView;
@protocol heightPickerViewDidselected <NSObject>
@optional
- (void)heightPickerView:(UIPickerView *)pickerView DidselectedRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)pickViewDidselecedWithWidthHeightText:(NSString *)text;
@end

@interface ADWHeightPickerView : UIView

@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, strong) UIPickerView *myDatePicker;
@property (nonatomic, assign) id<heightPickerViewDidselected>delegate;
@property (nonatomic, strong) NSString *defHeight;
@property (nonatomic, strong) NSString *defWeight;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title isHeight:(BOOL)isheight;

@end
