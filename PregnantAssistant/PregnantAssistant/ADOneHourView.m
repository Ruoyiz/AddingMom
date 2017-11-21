//
//  ADOneHoutView.m
//  PregnantAssistant
//
//  Created by D on 14-10-10.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADOneHourView.h"
#import "NSTimer+Pausing.h"

#define totalLabelHeight (RETINA_INCH4?390:320+(IOS7_OR_LATER?0:(-15)))
#define validLabelOrigin (105)

@implementation ADOneHourView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        UIColor *textColor = [UIColor dark_green_Btn];
        UILabel *titleLabel = [[UILabel alloc]init];

        titleLabel.text = @"专心一小时记录";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = textColor;

        [self addSubview:titleLabel];
        
        //begin time
        _beginTimeLabel = [[UILabel alloc]init];
        //when show view set text   see caller
        _beginTimeLabel.font = [UIFont systemFontOfSize:15];
        _beginTimeLabel.textColor = textColor;
        _beginTimeLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:_beginTimeLabel];
        
        _reminTimeLabel = [[UILabel alloc]init];
        _reminTimeLabel.text = @"60:00";
        [self addSubview:_reminTimeLabel];

        _reminTimeLabel.font = [UIFont systemFontOfSize:70.0f];
        _reminTimeLabel.textColor = textColor;
        _reminTimeLabel.textAlignment = NSTextAlignmentCenter;
        
        [self setReminTime];

        _validCount = 0;
        //valid count
        _validLabel = [[UILabel alloc]init];
        _validLabel.attributedText = [self getAttributedCnt:[NSString stringWithFormat:@"%d次",_validCount]];
        _validLabel.textColor = textColor;
        _validLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_validLabel];

        _allCnt = 0;
        //valid count
        _totalHeadLabel = [[UILabel alloc]init];
        _totalHeadLabel.font = [UIFont systemFontOfSize:20];
        _totalHeadLabel.text = [NSString stringWithFormat:@"实际记录%d次", _allCnt];
        _totalHeadLabel.textColor = textColor;
        _totalHeadLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_totalHeadLabel];
        
        //notice 5 minutes
        UILabel *noticeLabel = [[UILabel alloc]init];
        noticeLabel.text = @"5分钟内连续记录算作一次";
        noticeLabel.textColor = textColor;
        noticeLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:noticeLabel];
        
        if ([ADHelper isIphone4]) {
            _totalHeadLabel.frame = CGRectMake(0, SCREEN_HEIGHT -148, SCREEN_WIDTH, 20);
            titleLabel.frame = CGRectMake(0, 40, SCREEN_WIDTH, 20);
            _beginTimeLabel.frame = CGRectMake(0, 48 + 24, SCREEN_WIDTH, 20);
            _validLabel.frame = CGRectMake(0, 174, 324, 148);
            _reminTimeLabel.frame = CGRectMake(0, 110, 320, 60);
            noticeLabel.frame =
            CGRectMake(0, _totalHeadLabel.frame.origin.y + _totalHeadLabel.frame.size.height + 8, SCREEN_WIDTH, 25);
        }else{
            _totalHeadLabel.frame = CGRectMake(0, SCREEN_HEIGHT -188, SCREEN_WIDTH, 20);
            titleLabel.frame = CGRectMake(0, 48, SCREEN_WIDTH, 20);
            _beginTimeLabel.frame = CGRectMake(0, 48 + 24, SCREEN_WIDTH, 20);
            _validLabel.frame = CGRectMake(0, 220, SCREEN_WIDTH +4, 148);
            _reminTimeLabel.frame = CGRectMake(0, 110, SCREEN_WIDTH, 60);
            noticeLabel.frame =
            CGRectMake(0, _totalHeadLabel.frame.origin.y + _totalHeadLabel.frame.size.height + 28, SCREEN_WIDTH, 25);
        }
    }
    
    return self;
}

- (void)setValidCount:(int)validCount
{
    _validCount = validCount;
    _validLabel.attributedText = [self getAttributedCnt:[NSString stringWithFormat:@"%d次",_validCount]];
}

- (void)setReminTime
{
    _durationTimer =
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateDurTime) userInfo:nil repeats:YES];
}

- (void)updateDurTime
{
    _durationTime += 1;
    //test
    int remSec = 3600 - _durationTime;
    
    int min = remSec /60 %60;
    int sec = remSec %60;
    
    if (sec >= 0) {
        _reminTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", min, sec];
    }
    
    // 改变按钮 为完成
    if (remSec == 0) {
        NSLog(@"send finish once");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FINISH_ONEHOUR
                                                            object:nil];
        //停止计时
        [_durationTimer pause];
    }
}

- (void)startTimer
{
    [_durationTimer setFireDate:[NSDate date]];
}

- (void)resetTimer
{
    [_durationTimer pause];

    _durationTime = 0;
    _reminTimeLabel.text = @"60:00";
    _allCnt = 0;
    _totalHeadLabel.text = @"实际记录0次";
}

- (NSMutableAttributedString *)getAttributedCnt:(NSString *)aString
{
    NSMutableAttributedString* aAttributedString =
    [[NSMutableAttributedString alloc] initWithString:aString
                                           attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:148]}];
    
    [aAttributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}
                               range:NSMakeRange(aString.length -1,1)];
    
    return aAttributedString;
}

@end
