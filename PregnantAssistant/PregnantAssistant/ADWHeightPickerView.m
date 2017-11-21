//
//  ADWHeightPickerView.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/6/2.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADWHeightPickerView.h"
#import "UIImage+Tint.h"


@interface ADWHeightPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    
    UILabel* pickerLabel;
    NSMutableArray *_decimalArray;
    NSInteger string1;
    CGFloat string2;
    
    BOOL _isselected;
}
@end

@implementation ADWHeightPickerView

- (instancetype)initWithFrame:(CGRect)frame  title:(NSString *)title isHeight:(BOOL)isheight
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _decimalArray = [NSMutableArray array];
        string1 = 0;string2 = 0.0;
        for (NSInteger i = 0; i < 10; i ++) {
            [_decimalArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        _myDatePicker = [[UIPickerView alloc ] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 216)];
        _myDatePicker.delegate = self;
        _myDatePicker.dataSource = self;
        _myDatePicker.showsSelectionIndicator = YES;
        
        [_myDatePicker setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:_myDatePicker];
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        bottomView.backgroundColor = [UIColor title_darkblue];
        [self addSubview:bottomView];
        
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH, 50)];
        tipLabel.text = title;
        tipLabel.textColor = [UIColor whiteColor];
        [bottomView addSubview:tipLabel];
        
        _doneBtn =
        [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 -2, 0, 50, 50)];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn setImage:[[UIImage imageNamed:@"iconOk"] imageWithTintColor:[UIColor whiteColor]]
                  forState:UIControlStateNormal];
        [self addSubview:_doneBtn];
        
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 1) {
        return _decimalArray.count;
    }
    return _contentArray.count;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 40;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    if (component == 1) {
//        return  [NSString stringWithFormat:@".%@",_decimalArray[row]];
//    }
//    return  _contentArray[row];
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    pickerLabel =(UILabel *)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:24]];
    }
    
    pickerLabel.text=_contentArray[row];
    if (component == 1) {
        pickerLabel.text = [NSString stringWithFormat:@".%@",_decimalArray[row]];
    }
    pickerLabel.textColor = [UIColor btn_green_bgColor];
    return pickerLabel;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (!_isselected) {
        string1 = [_defHeight integerValue];
        string2 = [_defWeight integerValue]/10.0;
        _isselected = YES;
    }
    switch (component) {
        case 0:
            string1 = [_contentArray[row] floatValue];
            break;
        case 1:
            string2 = [_decimalArray[row] floatValue]/10.0;
            break;
        default:
            break;
    }
    if ([_delegate respondsToSelector:@selector(heightPickerView:DidselectedRow:inComponent:)]) {
        [_delegate heightPickerView:_myDatePicker DidselectedRow:row inComponent:component];
    }
    if ([_delegate respondsToSelector:@selector(pickViewDidselecedWithWidthHeightText:)]) {
        [_delegate pickViewDidselecedWithWidthHeightText:[NSString stringWithFormat:@"%.1f",(string1 + string2)]];
    }
    
}

@end
