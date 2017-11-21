//
//  ADSetVaccineNotePicker.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/9.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADSetVaccineNotePicker.h"
#import "UIImage+Tint.h"

@implementation ADSetVaccineNotePicker{
    NSArray *_dayArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _dayArray = [NSArray arrayWithObjects:@"当天",@"前1天",@"前3天", nil];
        
        _myPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 216)];
        _myPicker.dataSource = self;
        _myPicker.delegate = self;
        [self addSubview:_myPicker];
        [_myPicker selectRow:12 inComponent:1 animated:NO];
        [_myPicker selectRow:1 inComponent:0 animated:NO];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        label.center = CGPointMake(SCREEN_WIDTH / 3.0 *2, 216 / 2.0 + 40);
        label.text = @":";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        bottomView.backgroundColor = [UIColor title_darkblue];
        [self addSubview:bottomView];
        
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH, 50)];
        tipLabel.text = @"提醒时间";
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 3;
    }else if (component == 1){
        return 24;
    }
    
    return 60;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0){
        return [_dayArray objectAtIndex:row];
    }
    
    return [NSString stringWithFormat:@"%02ld",(long)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    NSInteger selectOne = [pickerView selectedRowInComponent:0];
//    NSInteger selectTwo = [pickerView selectedRowInComponent:1];
//    NSInteger selectThr = [pickerView selectedRowInComponent:2];
//    
//    NSString *str = [NSString stringWithFormat:@"%ld,%ld,%ld",selectOne,selectTwo,selectThr];
//    NSLog(@"str %@",str);
}


@end
