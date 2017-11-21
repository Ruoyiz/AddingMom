//
//  ADRecordView.m
//  PregnantAssistant
//
//  Created by D on 14-10-11.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADTodayRecordNumView.h"

static NSString *tip = @"今日记录胎动总数";

@implementation ADTodayRecordNumView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, 24)];
        tipLabel.font = [UIFont systemFontOfSize:12];
        tipLabel.text = tip;
//        tipLabel.textColor = [UIColor font_Brown];
        tipLabel.textColor = [UIColor font_tip_color];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tipLabel];
        
        self.backgroundColor = [UIColor whiteColor];
        
        // test 1
//        _cnt = 1;
        _cntLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH + 4, 60)];
//        _cntLabel.attributedText = [self getAttributedCnt:[NSString stringWithFormat:@"%ld次",(long)_cnt]];
        _cntLabel.textColor = [UIColor dark_green_Btn];
        _cntLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_cntLabel];
    }
    return self;
}

-(void)setCnt:(NSInteger)cnt
{
    _cnt = cnt;
    _cntLabel.attributedText = [self getAttributedCnt:[NSString stringWithFormat:@"%ld次",(long)_cnt]];
}

- (NSMutableAttributedString *)getAttributedCnt:(NSString *)aString
{
    NSMutableAttributedString* aAttributedString =
    [[NSMutableAttributedString alloc] initWithString:aString
                                           attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:60]}];
    
    [aAttributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}
                               range:NSMakeRange(aString.length -1,1)];
    
    return aAttributedString;
}

@end
