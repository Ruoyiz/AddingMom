//
//  ADCalcFetalView.m
//  PregnantAssistant
//
//  Created by D on 14-10-11.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADCalcFetalView.h"

@implementation ADCalcFetalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tip1 = [[UILabel alloc]initWithFrame:CGRectMake(26, 8, 112, 12)];
        _tip1.text = @"推算今日胎动总数";
        _tip1.textColor = [UIColor font_Brown];
        _tip1.font = [UIFont systemFontOfSize:12];
        [self addSubview:_tip1];
        
        _tip2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -128-12, 8, 128, 12)];
        _tip2.text = @"推算每小时平均胎动";
        _tip2.textColor = [UIColor font_Brown];
        _tip2.font = [UIFont systemFontOfSize:12];
        [self addSubview:_tip2];

        _perHourLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -120 -22, 32, 120, 43)];
        _perHourLabel.textColor = [UIColor font_Brown];
        _perHourLabel.attributedText = [self getAttributedCnt:[NSString stringWithFormat:@"%ld 次/小时",(long)_perHour]
                                                   withLength:5];
        _perHourLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_perHourLabel];

        _todayCnt = _perHour *12;
        _cntLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 32, 116, 43)];
        _cntLabel.textColor = [UIColor font_Brown];
        _cntLabel.attributedText = [self getAttributedCnt:[NSString stringWithFormat:@"%ld 次",(long)_todayCnt]
                                               withLength:2];
        _cntLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_cntLabel];
        
        _mostHour = [[UILabel alloc]initWithFrame:CGRectMake(16, 92, 140, 14)];
        _mostHour.textColor = [UIColor font_Brown];
        _mostHour.font = [UIFont systemFontOfSize:14];
        _mostHour.text = @"推算最多一小时";
        [self addSubview:_mostHour];
        
        _mostHourLabel = [[UILabel alloc]initWithFrame:CGRectMake(124, 92, 140, 14)];
        _mostHourLabel.textColor = [UIColor font_Brown];
        _mostHourLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_mostHourLabel];
        
        _mostHourTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -40 -16, 92, 40, 14)];
        _mostHourTimeLabel.textColor = [UIColor font_Brown];
        _mostHourTimeLabel.font = [UIFont systemFontOfSize:14];
        _mostHourTimeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_mostHourTimeLabel];
        
        //hide label
        _tip1.hidden = YES;
        _tip2.hidden = YES;
        _perHourLabel.hidden = YES;
        _cntLabel.hidden = YES;
        _mostHour.hidden = YES;
        _mostHourLabel.hidden = YES;
        _mostHourTimeLabel.hidden = YES;
        
        _emptyHourView =
        [[UIImageView alloc]initWithFrame: CGRectMake((SCREEN_WIDTH -438/2)/2, 32, 438 /2, 44)];
        _emptyHourView.image = [UIImage imageNamed:@"暂时没有足够数据"];
        [self addSubview:_emptyHourView];
    }
    return self;
}

- (void)setPerHour:(NSInteger)perHour
{
    _perHour = perHour;
    _perHourLabel.attributedText =
    [self getAttributedCnt:[NSString stringWithFormat:@"%ld 次/小时",(long)_perHour] withLength:5];
    _todayCnt = _perHour *12;
    _cntLabel.attributedText =
    [self getAttributedCnt:[NSString stringWithFormat:@"%ld 次",(long)_todayCnt] withLength:2];
}

- (void)showDataWithAnimation:(BOOL)animated
{
    if (animated) {
        _tip1.alpha = 0;
        _tip2.alpha = 0;
        _perHourLabel.alpha = 0;
        _cntLabel.alpha = 0;
        _mostHour.alpha = 0;
        _mostHourLabel.alpha = 0;
        _mostHourTimeLabel.alpha = 0;
        
        [UIView animateWithDuration:0.3 delay:0.05
             usingSpringWithDamping:1 initialSpringVelocity:5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _emptyHourView.alpha = 0;
                             
                             _tip1.alpha = 1;
                             _tip1.alpha = 1;
                             _tip2.alpha = 1;
                             _perHourLabel.alpha = 1;
                             _cntLabel.alpha = 1;
                             _mostHour.alpha = 1;
                             _mostHourLabel.alpha = 1;
                             _mostHourTimeLabel.alpha = 1;
                             
                             _tip1.hidden = NO;
                             _tip2.hidden = NO;
                             _perHourLabel.hidden = NO;
                             _cntLabel.hidden = NO;
                             _mostHour.hidden = NO;
                             _mostHourLabel.hidden = NO;
                             _mostHourTimeLabel.hidden = NO;
                             
                             [_emptyHourView removeFromSuperview];
                         } completion:^(BOOL finished) {
                         }];
    } else {
        _tip1.hidden = NO;
        _tip2.hidden = NO;
        _perHourLabel.hidden = NO;
        _cntLabel.hidden = NO;
        _mostHour.hidden = NO;
        _mostHourLabel.hidden = NO;
        _mostHourTimeLabel.hidden = NO;
        [_emptyHourView removeFromSuperview];
    }
}

- (NSMutableAttributedString *)getAttributedCnt:(NSString *)aString
                                     withLength:(int)length
{
    NSMutableAttributedString* aAttributedString =
    [[NSMutableAttributedString alloc] initWithString:aString
                                           attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:43]}];
    
    [aAttributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                               range:NSMakeRange(aString.length -length,length)];
    
    return aAttributedString;
}

@end
