//
//  ADBigBabyTitleView.m
//  PregnantAssistant
//
//  Created by D on 15/3/31.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBigBabyTitleView.h"

@implementation ADBigBabyTitleView

-(id)initWithFrame:(CGRect)frame
       andParentVC:(UIViewController *)aVc
{
    if (self = [super initWithFrame:frame]) {
        _bgView =  [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 414, 200)];
        _parentVc = aVc;
        
        [self addSubview:_bgView];
        _aWeatherType = [self getWeatherType];
        
        switch (_aWeatherType) {
            case springType:
                _bgView.image = [UIImage imageNamed:@"春天"];
                [self addAnimaiteView];
                break;
            case summerType:
                _bgView.image = [UIImage imageNamed:@"夏天"];
                [self addAnimaiteSummerView];
                break;
            case autumnType:
                _bgView.image = [UIImage imageNamed:@"秋天"];
                [self addAniLeaves];
                break;
            case winterType:
                _bgView.image = [UIImage imageNamed:@"冬天"];
                [self addAniSnow];
                break;
                
            default:
                break;
        }
        
        [self caleDueDay];
        [self addBabyView];
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)caleDueDay
{
    ADAppDelegate *appDelegate = APP_DELEGATE;
    
    NSTimeInterval time=[appDelegate.dueDate timeIntervalSinceDate:[NSDate date]];
    int days=((int)time)/(3600*24);
    
    int passDay = 280 -days -1;
    
    if (passDay < 0) {
        passDay = 0;
    }
    _week = passDay /7;
}

- (void)addBabyView
{
    _babyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -48 -156, 0, 158, 200)];
    if (iPhone6 || iPhone6Plus) {
        _babyImageView.frame = CGRectMake(SCREEN_WIDTH -200 -SCREEN_WIDTH*0.0625, 0, 158, 200);
    }
    
    _babyImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (_week >= 40) {
        _babyImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"40-%02d", 40]];
    } else {
        _babyImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"40-%02ld", (long)_week +1]];
    }
    
    [self addSubview:_babyImageView];
}

- (WeatherType)getWeatherType
{
    WeatherType aType = 0;
    NSInteger month = [[NSDate date] month];
    switch (month) {
        case 3: case 4: case 5:
            aType = springType;
            return aType;
        case 6: case 7: case 8:
            aType = summerType;
            return aType;
        case 9: case 10: case 11:
            aType = autumnType;
            return aType;
        case 12: case 1: case 2:
            aType = winterType;
            return aType;
            
        default:
            break;
    }
    return aType;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    switch (_aWeatherType) {
        case springType:
            [self addRotateAnimationAtView:_aniView];
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

- (void)addAnimaiteView
{
    _aniView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 16, 414, 200)];
    _aniView.image = [UIImage imageNamed:@"风筝"];
    
    if (iPhone6Plus) {
        _aniView.center = CGPointMake(SCREEN_WIDTH /2 +8, _aniView.center.y +16);
    } else if (iPhone6) {
        _aniView.center = CGPointMake(SCREEN_WIDTH /2 -17, _aniView.center.y +16);
    } else {
        _aniView.center = CGPointMake(SCREEN_WIDTH /2 -29, _aniView.center.y +16);
    }
    
//    [self addRotateAnimationAtView:aniView];
    
    [self addSubview:_aniView];
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

- (void)addAnimaiteSummerView
{
    _aniView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 414, 200)];
    _aniView.image = [UIImage imageNamed:@"气球"];
    
    [self addSubview:_aniView];
    
    if (iPhone6Plus) {
        _aniView.center = CGPointMake(SCREEN_WIDTH /2 +8, _aniView.center.y);
    } else if (iPhone6) {
        _aniView.center = CGPointMake(SCREEN_WIDTH /2 -17, _aniView.center.y);
    } else {
        _aniView.center = CGPointMake(SCREEN_WIDTH /2 -29, _aniView.center.y);
    }
    
    _nextView = [[UIImageView alloc]initWithFrame:CGRectMake(-414, 0, 414, 200)];
    _nextView.image = [UIImage imageNamed:@"气球"];
    [self addSubview:_nextView];
    
    [self bringSubviewToFront:_aniView];
    
    [self startSummerAnimaiton];
}

- (void)startSummerAnimaiton
{
    [UIView animateWithDuration:40 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _aniView.frame = CGRectOffset(_aniView.frame, SCREEN_WIDTH, 0);
        _nextView.frame = CGRectOffset(_nextView.frame, SCREEN_WIDTH, 0);
        
    } completion:^(BOOL finished) {
        _aniView.frame = CGRectMake(0, 0, 414, 200);
        _nextView.frame = CGRectMake(-414, 0, 414, 200);
        [self startSummerAnimaiton];
    }];
}

- (void)addAniLeaves
{
    _aniView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 414, 200)];
    _aniView.image = [UIImage imageNamed:@"枫叶"];
//    _aniView.backgroundColor = [UIColor yellowColor];
    
    [self addSubview:_aniView];
    
    if (iPhone6Plus) {
        _aniView.center = CGPointMake(SCREEN_WIDTH /2 +8, _aniView.center.y);
    } else if (iPhone6) {
        _aniView.center = CGPointMake(SCREEN_WIDTH /2 -17, _aniView.center.y);
    } else {
        _aniView.center = CGPointMake(SCREEN_WIDTH /2 -29, _aniView.center.y);
    }
    
    _nextView = [[UIImageView alloc]initWithFrame:CGRectMake(-414, 0, 414, 200)];
    
    if (iPhone6) {
        _nextView.frame = CGRectMake(-414 -30, 0, 414, 200);
    } else if (iPhone6Plus) {
    } else {
        _nextView.frame = CGRectMake(-480, 0, 414, 200);
    }
    _nextView.image = [UIImage imageNamed:@"枫叶"];
    
//    _nextView.backgroundColor = [UIColor greenColor];
    [self addSubview:_nextView];
    [self bringSubviewToFront:_aniView];
    
//    [self startfallAnimaiton];
    [self startSummerAnimaiton];
}

- (void)addAniSnow
{
    _aniView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 414, 200)];
    _aniView.image = [UIImage imageNamed:@"雪花"];
    
    [self addSubview:_aniView];
    
    if (iPhone6Plus) {
        _aniView.center = CGPointMake(SCREEN_WIDTH /2 +8, _aniView.center.y);
    } else if (iPhone6) {
        _aniView.center = CGPointMake(SCREEN_WIDTH /2 -17, _aniView.center.y);
    } else {
        _aniView.center = CGPointMake(SCREEN_WIDTH /2 -29, _aniView.center.y);
    }
    
    _nextView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -200, 414, 200)];
    _nextView.image = [UIImage imageNamed:@"雪花"];
    [self addSubview:_nextView];
    
    [self bringSubviewToFront:_aniView];
    
    [self startfallAnimaiton];
}

- (void)startfallAnimaiton
{
    [UIView animateWithDuration:52 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _aniView.frame = CGRectOffset(_aniView.frame, 0, _aniView.frame.size.height);
        _nextView.frame = CGRectOffset(_nextView.frame, 0, _nextView.frame.size.height);
        
    } completion:^(BOOL finished) {
        _aniView.frame = CGRectMake(0, 0, 414, 200);
        _nextView.frame = CGRectMake(0, -200, 414, 200);
        [self startSummerAnimaiton];
    }];
}
@end
