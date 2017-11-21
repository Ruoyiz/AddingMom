//
//  ADRecordContractView.m
//  PregnantAssistant
//
//  Created by D on 14/10/20.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADRecordContractView.h"

@implementation ADRecordContractView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor defaultTintColor];
        self.backgroundColor = [UIColor light_green_Btn];
        [self addButtons];
        
    }
    
    return self;
}

- (void)addButtons
{
    _historyBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 10, 128 /2, 70)];
    
    [_historyBtn setImage:[UIImage imageNamed:@"历史记录"] forState:UIControlStateNormal];
    [_historyBtn setClipsToBounds:YES];
    [_historyBtn.layer setCornerRadius:10];
    [self addSubview:_historyBtn];

    _recordBtn = [[UIButton alloc]initWithFrame:CGRectMake(16 +128/2 +10, 10, SCREEN_WIDTH - (16 +128/2 +10) -16, 70)];
    
    [_recordBtn setImage:[UIImage imageNamed:@"开始计时"] forState:UIControlStateNormal];
    [_recordBtn setImage:[UIImage imageNamed:@"停止计时"] forState:UIControlStateSelected];
    _recordBtn.backgroundColor = [UIColor dark_green_Btn];
    [_recordBtn setClipsToBounds:YES];
    [_recordBtn.layer setCornerRadius:10];
    
    [self addSubview:_recordBtn];
    
}

@end
