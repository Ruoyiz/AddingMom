//
//  ADOneHourDataView.m
//  PregnantAssistant
//
//  Created by D on 14-10-11.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADOneHourDataView.h"

@implementation ADOneHourDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, 140, 14)];
        _timeLabel.textColor = [UIColor font_Brown];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:_timeLabel];
        
//        _num = 10;
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -40 -16, 10, 40, 14)];
        _numLabel.textColor = [UIColor font_Brown];
        _numLabel.font = [UIFont systemFontOfSize:14];
        _numLabel.text = [NSString stringWithFormat:@"%d 次",_num];
        _numLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_numLabel];
        
        UIImageView *clockImg = [[UIImageView alloc]initWithFrame:CGRectMake(124, 9, 14, 15)];
        clockImg.image = [UIImage imageNamed:@"智能解读小闹钟"];
        [self addSubview:clockImg];
    }
    return self;
}

@end
