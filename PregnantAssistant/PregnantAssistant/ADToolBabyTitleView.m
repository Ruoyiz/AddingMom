//
//  ADToolBabyTitleView.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/4/23.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADToolBabyTitleView.h"
#import "ADAppDelegate.h"
#import "NSDate+Utilities.h"
#import "ADGetTextSize.h"

@implementation ADToolBabyTitleView
{
    //CGFloat _screenRate;
    //UILabel *_sizeLabel;
    //UIView *_textContentView;
}

-(id)initWithFrame:(CGRect)frame andParentVC:(UIViewController *)aVc
{
    if (self = [super initWithFrame:frame]) {
        //_screenRate = ((SCREEN_WIDTH - 320) * 0.5 +320)/320.0;
        _bgView =  [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 414, frame.size.height)];
        _parentVc = aVc;
        
        [self addSubview:_bgView];
        
        _aWeatherType = [self getWeatherType];
        
        switch (_aWeatherType) {
            case springType:
                _bgView.image = [UIImage imageNamed:@"springBackground"];
                [self addAnimaiteView];
                break;
            case summerType:
                _bgView.image = [UIImage imageNamed:@"summer"];
                [self addAnimaiteSummerView];
                break;
            case autumnType:
                _bgView.image = [UIImage imageNamed:@"autumn"];
                break;
            case winterType:
                _bgView.image = [UIImage imageNamed:@"winter"];
                break;
                
            default:
                break;
        }
        
        [self caleDueDay];
        [self addBabyView];
        
        [self addShadow];
        
        [self addBabyDataTitle];
        
        [self layoutSubviews];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    switch (_aWeatherType) {
        case springType:
            [self addRotateAnimationAtView:_aniKiteView];
            break;
        case summerType:
            [self startSummerAnimaiton];
            break;
        case autumnType:
            break;
        case winterType:
            break;
            
        default:
            break;
    }
    if (iPhone6) {
        _bgView.frame = CGRectMake( - (117/3.0), 0, 414, self.frame.size.height);
    } else if (iPhone6Plus) {
        _bgView.frame = CGRectMake(0, 0, 414, self.frame.size.height);
    } else {
        _bgView.frame = CGRectMake( - (230/3.0), 0, 414, self.frame.size.height);
    }
}

- (WeatherType)getWeatherType
{
    WeatherType aType = 0;
    NSInteger month = [[NSDate date] month];
    //    aType = summerType;
    //    return aType;
    
    switch (month) {
        case 3: case 4: case 5:
            aType = springType;
            return aType;
        case 6: case 7: case 8:
            aType = summerType;
            return aType;
        case 9: case 10: case 11:
            aType = summerType;
            return aType;
        case 12: case 1: case 2:
            aType = springType;
            return aType;
            
        default:
            break;
    }
    return aType;
}


- (void)caleDueDay
{
    ADAppDelegate *appDelegate = APP_DELEGATE;
    
    NSTimeInterval time=[appDelegate.dueDate timeIntervalSinceDate:[NSDate date]];
    int days=((int)time)/(3600*24);
    if (time <= 0) {
        days = -1;
    }else if(days > 279){
        days = 279;
    }
    
    int passDay = 280 -days -1;
    if (passDay < 0) {
        passDay = 0;
    }
    
    _week = passDay /7;
    _dueDay = passDay %7;
    NSLog(@"_week: %d ,_dueday:%d",_week,_dueDay);
    _leftDay = days+1;
    if (_leftDay < 0) {
        _leftDay = 0;
    }
}

- (void)addAnimaiteView
{
    _aniKiteView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12, 353, 135)];
    _aniKiteView.image = [UIImage imageNamed:@"kites"];
    
    if (iPhone6Plus) {
        _aniKiteView.center = CGPointMake(SCREEN_WIDTH /2 +8, _aniKiteView.center.y +34);
    } else if (iPhone6) {
        _aniKiteView.center = CGPointMake(SCREEN_WIDTH /2 -17, _aniKiteView.center.y +28);
    } else {
        _aniKiteView.center = CGPointMake(SCREEN_WIDTH /2 -29, _aniKiteView.center.y +16);
    }
    
    [self addRotateAnimationAtView:_aniKiteView];
    
    [self addSubview:_aniKiteView];
}

- (void)addAnimaiteSummerView
{
    @autoreleasepool {
        _aniView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 414, 130)];
        _nextView = [[UIImageView alloc]initWithFrame:CGRectMake(-414, 0, 414, 130)];
    }
    _aniView.image = [UIImage imageNamed:@"summerBallon"];
    
    [self addSubview:_aniView];
    
    if (iPhone6Plus) {
        _aniView.center = CGPointMake(SCREEN_WIDTH /2 +8, _aniView.center.y);
    } else if (iPhone6) {
        _aniView.center = CGPointMake(SCREEN_WIDTH /2 -17, _aniView.center.y);
    } else {
        _aniView.center = CGPointMake(SCREEN_WIDTH /2 -29, _aniView.center.y);
    }
    
    _nextView.image = [UIImage imageNamed:@"summerBallon"];
    [self addSubview:_nextView];
    
    [self bringSubviewToFront:_aniView];
    
    [self startSummerAnimaiton];
}

- (void)startSummerAnimaiton
{
//    [UIView animateWithDuration:40 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        _aniView.frame = CGRectOffset(_aniView.frame, _aniView.frame.size.width, 0);
//        _nextView.frame = CGRectOffset(_nextView.frame, _nextView.frame.size.width, 0);
//        
//    } completion:^(BOOL finished) {
//        _aniView.frame = CGRectMake(0, 0, 414, 130);
//        _nextView.frame = CGRectMake(-414, 0, 414, 130);
//        [self startSummerAnimaiton];
//    }];
}

- (void)addShadow
{
    UIView *shadow = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
    shadow.userInteractionEnabled = YES;
    
    switch (_aWeatherType) {
        case springType:
            shadow.backgroundColor = UIColorFromRGBAndAlpha(0xe65463, 0.6);
            break;
        case summerType:
            shadow.backgroundColor = UIColorFromRGBAndAlpha(0x07dbb3, 0.7);
            break;
        case autumnType:
            shadow.backgroundColor = UIColorFromRGBAndAlpha(0xff8533, 0.6);
            break;
        case winterType:
            shadow.backgroundColor = UIColorFromRGBAndAlpha(0x9176ff, 0.8);
            break;
            
        default:
            break;
    }
    
    UITapGestureRecognizer *photoTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self.parentVc action:@selector(tapDetail:)];
    [shadow addGestureRecognizer:photoTap];
    [self addSubview:shadow];
}

- (void)tapDetail:(UITapGestureRecognizer *)aTap
{
}

- (void)addBabyDataTitle
{
//    /CGFloat rate = 1;
//    
//    if (_parentVc == nil) {
//        rate = _screenRate;
//    }
    if (!_textContentView) {
        _textContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _textContentView.backgroundColor = [UIColor clearColor];
        _textContentView.userInteractionEnabled = NO;
        
        [self addSubview:_textContentView];
    }
    
    
    CGFloat startHeight = 44 - 3;
    CGFloat viewHeight = 0;
    CGFloat labelHeight = [ADGetTextSize heighForString:@"体重" width:SCREEN_WIDTH andFont:[UIFont fontWithName:@"RTWSYueGoTrial-Light" size:18]];

    _dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, viewHeight, SCREEN_WIDTH -36, labelHeight)];
    _dayLabel.text = [NSString stringWithFormat:@"孕%ld周%ld天  剩%ld天", (long)_week, (long)_dueDay, (long)_leftDay];
    _dayLabel.font = [UIFont fontWithName:@"RTWSYueGoTrial-Light" size:18];
    _dayLabel.textColor = [UIColor whiteColor];
    [_textContentView addSubview:_dayLabel];
    
    viewHeight += labelHeight + 6;
    
    labelHeight = [ADGetTextSize heighForString:@"体重" width:SCREEN_WIDTH andFont:[UIFont fontWithName:@"RTWSYueGoTrial-Light" size:13]];
    //宝宝体重
    _weightLabel = [[UILabel alloc]initWithFrame:CGRectMake(110 - 4 + 26, viewHeight, SCREEN_WIDTH -36, labelHeight)];
    _weightLabel.font = [UIFont fontWithName:@"RTWSYueGoTrial-Light" size:13];
    _weightLabel.textColor = [UIColor whiteColor];
    [_textContentView addSubview:_weightLabel];
    
    //宝宝体重配图
    _weightView = [[UIImageView alloc]initWithFrame:CGRectMake(110 - 4, viewHeight, 20, 20)];
    _weightView.image = [UIImage imageNamed:@"weight"];
    _weightView.center = CGPointMake(_weightView.center.x, _weightLabel.center.y +1);
    [_textContentView addSubview:_weightView];
    
    //宝宝体长
    _lenLabel = [[UILabel alloc]initWithFrame:CGRectMake(22 +26, viewHeight, SCREEN_WIDTH -36, labelHeight)];
    _lenLabel.font = [UIFont fontWithName:@"RTWSYueGoTrial-Light" size:13];
    _lenLabel.textColor = [UIColor whiteColor];
    [_textContentView addSubview:_lenLabel];
    
    //宝宝体长配图
    _lengthView = [[UIImageView alloc]initWithFrame:CGRectMake(18.5, viewHeight, 20, 20)];
    _lengthView.image = [UIImage imageNamed:@"length"];
    _lengthView.center = CGPointMake(_lengthView.center.x, _lenLabel.center.y +1);
    [_textContentView addSubview:_lengthView];
    
    //箭头配图
    _arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -52, 0, 50, 50)];
    _arrowView.image = [UIImage imageNamed:@"go"];
    _arrowView.center = CGPointMake(_arrowView.center.x, 130 /2 +2);
    [self addSubview:_arrowView];
    
    //宝宝身材描述
//    CGFloat height = _dayLabel.frame.origin.y + _dayLabel.frame.size.height +24;
    viewHeight += labelHeight + 8;
    _sizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18.5, viewHeight, 20, 20)];
    _sizeImageView.image = [UIImage imageNamed:@"fruit"];
    [_textContentView addSubview:_sizeImageView];
    
    _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 + 26, viewHeight, 200, 20)];
    _sizeLabel.textColor = [UIColor whiteColor];
    _sizeLabel.font = [UIFont fontWithName:@"RTWSYueGoTrial-Light" size:13];
    [_textContentView addSubview:_sizeLabel];
    viewHeight += labelHeight;
    _textContentView.frame = CGRectMake(0, startHeight, SCREEN_WIDTH, viewHeight);
}

- (void)addBabyView
{
    //    200
    _babyImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -48 -156, 0, 158, 130)];
    if (iPhone6 || iPhone6Plus) {
        _babyImgView.frame = CGRectMake(SCREEN_WIDTH -64 -156, 0, 158, 130);
    }
    
    _babyImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (_week >= 40) {
        _babyImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"40-%02d", 40]];
    } else {
        _babyImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"40-%02ld", (long)_week+1]];
    }
    
    [self addSubview:_babyImgView];
}

- (void)addRotateAnimationAtView:(UIView *)aView
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @( DEGREES_TO_RADIANS(-6) );
    rotationAnimation.toValue = @( DEGREES_TO_RADIANS(0) );
    rotationAnimation.duration = 2.0;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.autoreverses = YES;
    
    [aView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)refreshData
{
    [self caleDueDay];
    
    if (_week >= 40) {
        _babyImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"40-%02d", 40]];
    } else {
        _babyImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"40-%02ld", (long)_week+1]];
    }
    _dayLabel.text = [NSString stringWithFormat:@"孕%ld周%ld天  剩%ld天", (long)_week, (long)_dueDay, (long)_leftDay];
}

//- (void)reloadDataWithWeight:(NSString *)weight length:(NSString *)length size:(NSString *)size
//{
//    _weightLabel.text = weight;
//    
//    _lenLabel.text = length;
//    _sizeLabel.text = size;
//    
//    CGFloat lenLabelWidth = [ADGetTextSize widthForString:length height:20 andFont:_lenLabel.font];
//    CGFloat weightLabelWidth = [ADGetTextSize widthForString:weight height:20 andFont:_weightLabel.font];
//    _lenLabel.frame = CGRectMake(_lenLabel.frame.origin.x, _lenLabel.frame.origin.y, lenLabelWidth, _lenLabel.frame.size.height);
//    _weightView.frame = CGRectMake(_lenLabel.frame.origin.x + lenLabelWidth + 12, _weightView.frame.origin.y, _weightView.frame.size.width, _weightView.frame.size.height);
//    _weightLabel.frame = CGRectMake(_weightView.frame.origin.x + _weightView.frame.size.width + 10, _weightLabel.frame.origin.y, weightLabelWidth, _weightLabel.frame.size.height);
//}

- (void)setIsFitCell:(BOOL)isFitCell
{
    
    
//    if (isFitCell) {
//        if (iPhone6) {
//            _aniKiteView.center = CGPointMake(SCREEN_WIDTH /2 +8, _aniKiteView.center.y +64);
//            _dayLabel.frame = CGRectMake(24, 30, SCREEN_WIDTH -36, 40);
//        } else if (iPhone6Plus) {
//            _dayLabel.frame = CGRectMake(24, 30, SCREEN_WIDTH -36, 40);
//        } else {
//            _dayLabel.frame = CGRectMake(24, 20, SCREEN_WIDTH -36, 40);
//        }
//        CGFloat height1 = _dayLabel.frame.origin.y + _dayLabel.frame.size.height -6;
//        CGFloat height = _dayLabel.frame.origin.y + _dayLabel.frame.size.height +24;
//        
//        _weightLabel.frame = CGRectMake(24 +26, height1, SCREEN_WIDTH -36, 40);
//        _weightView.center = CGPointMake(_weightView.center.x -8, _weightLabel.center.y +1);
//        _lenLabel.frame = CGRectMake(24 +26, height, SCREEN_WIDTH -36, 40);
//        _lengthView.center = CGPointMake(_lengthView.center.x -8, _lenLabel.center.y +1);
//    } else {
//        if (iPhone6 || iPhone6Plus) {
//        } else {
//            _dayLabel.frame = CGRectMake(18, 20, SCREEN_WIDTH -36, 40);
//            CGFloat height1 = _dayLabel.frame.origin.y + _dayLabel.frame.size.height -6;
//            CGFloat height = _dayLabel.frame.origin.y + _dayLabel.frame.size.height +24;
//            
//            _weightLabel.frame = CGRectMake(16 +26, height1, SCREEN_WIDTH -36, 40);
//            _weightView.center = CGPointMake(_weightView.center.x -12, _weightLabel.center.y +1);
//            _lenLabel.frame = CGRectMake(16 +26, height, SCREEN_WIDTH -36, 40);
//            _lengthView.center = CGPointMake(_lengthView.center.x -12, _lenLabel.center.y +1);
//        }
//    }
    
}

@end
