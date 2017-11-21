//
//  ADCircleView.m
//  PregnantAssistant
//
//  Created by yitu on 15/3/23.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADCircleView.h"
@interface ADCircleView ()

@property(nonatomic,strong)UIImageView *circleImage;


@end
@implementation ADCircleView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.circleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _circleImage.image = [UIImage imageNamed:@"refreshing_loading"];
        _circleImage.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:_circleImage];
        
    }
    return self;
}

//开始动画
- (void)circleViewStartAnimating
{
    
    [_circleImage.layer removeAnimationForKey:@"rotationAnimation"];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [_circleImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

}
//停止动画
- (void)circleViewStopAnimating
{
    [_circleImage.layer removeAnimationForKey:@"rotationAnimation"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
