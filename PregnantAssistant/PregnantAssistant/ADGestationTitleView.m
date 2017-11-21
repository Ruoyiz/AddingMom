//
//  ADGestationTitleView.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/18.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADGestationTitleView.h"
#import "UIImage+Tint.h"

@interface ADGestationTitleView (){
    UILabel *_weekLabel;
}

@end

@implementation ADGestationTitleView

- (instancetype)initWithFrame:(CGRect)frame withWeekIndex:(NSInteger)WeekIndex
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutUIWithWeekIndex:WeekIndex];
    }
    return self;
}

#define ROWBUTTON_WIDTH 48
#define WEEKLABEL_WIDTH 200
- (void)layoutUIWithWeekIndex:(NSInteger)weekIndex{
    UIImage *leftArrowImage = [[UIImage imageNamed:@"leftArrow"] imageWithTintColor:UIColorFromRGB(0x00DBB8)];
    UIButton *leftArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftArrowBtn setImage:leftArrowImage forState:UIControlStateNormal];
    [[leftArrowBtn imageView] setContentMode: UIViewContentModeCenter];
    [leftArrowBtn setFrame:CGRectMake(0, 0, ROWBUTTON_WIDTH, ROWBUTTON_WIDTH)];
    [leftArrowBtn addTarget:self action:@selector(subWeek:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftArrowBtn];
    
    UIImage *rightArrowImage = [[UIImage imageNamed:@"rightArrow"] imageWithTintColor:UIColorFromRGB(0x00DBB8)];
    UIButton *rightArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightArrowBtn setImage:rightArrowImage forState:UIControlStateNormal];
    [[rightArrowBtn imageView] setContentMode: UIViewContentModeCenter];
    [rightArrowBtn setFrame:CGRectMake(SCREEN_WIDTH -ROWBUTTON_WIDTH, 0, ROWBUTTON_WIDTH, ROWBUTTON_WIDTH)];
    [rightArrowBtn addTarget:self action:@selector(addWeek:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightArrowBtn];
    
    _weekLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - WEEKLABEL_WIDTH)/2, 0, WEEKLABEL_WIDTH, ROWBUTTON_WIDTH)];
    _weekLabel.textAlignment = NSTextAlignmentCenter;
    _weekLabel.textColor = UIColorFromRGB(0x4d4587);
    _weekLabel.font = [UIFont parentToolTitleViewDetailFontWithSize:16];
    _weekLabel.text = [NSString stringWithFormat:@"第 %ld 周",(long)weekIndex];
    [self addSubview:_weekLabel];
}


- (void)subWeek:(UIButton *)button{
    NSInteger weeks = [[self getWeekIndexStringWithLabelText:_weekLabel.text] integerValue];
    if (weeks > 1) {
        weeks --;
    }
    if ([_delegate respondsToSelector:@selector(weekindexChangedToWeek:)]) {
        [_delegate weekindexChangedToWeek:weeks - 1];
    }
    _weekLabel.text = [NSString stringWithFormat:@"第 %ld 周",(long)weeks];
}

- (void)addWeek:(UIButton *)button{
    NSInteger weeks = [[self getWeekIndexStringWithLabelText:_weekLabel.text] integerValue];
    if (weeks < 40) {
        weeks ++;
    }
    if ([_delegate respondsToSelector:@selector(weekindexChangedToWeek:)]) {
        [_delegate weekindexChangedToWeek:weeks -1];
    }
    _weekLabel.text = [NSString stringWithFormat:@"第 %ld 周",(long)weeks];
}



- (NSString *)getWeekIndexStringWithLabelText:(NSString *)labelText{
    NSString *subString = [labelText substringFromIndex:2];
    subString = [subString substringToIndex:subString.length - 2];
    return subString;
}























@end
