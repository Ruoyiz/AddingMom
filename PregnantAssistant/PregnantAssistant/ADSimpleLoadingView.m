//
//  ADSimpleLoadingView.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/4/22.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADSimpleLoadingView.h"

@implementation ADSimpleLoadingView
{
    NSInteger angle;
    UIImageView *_bgImageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self loadUI];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"%@需要执行initWithFrame方法",self);
        //[self loadUI];
    }
    
    return self;
}

- (void)loadUI
{
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _bgImageView.center = CGPointMake((SCREEN_WIDTH)/2.0, _bgImageView.center.y);
    _bgImageView.image = [UIImage imageNamed:@"refreshing_loading"];
    [self addSubview:_bgImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 20)];
    label.text = @"正在加载";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor lightGrayColor];
    [self addSubview:label];
    
    [self startAnimation];
}

-(void) startAnimation
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 1.0;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.cumulative = YES;
    [_bgImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
}

-(void)endAnimation
{
    [_bgImageView.layer removeAnimationForKey:@"rotationAnimation"];
}

@end
