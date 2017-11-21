//
//  ADToastCollectView.m
//  PregnantAssistant
//
//  Created by D on 15/3/24.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADToastCollectView.h"

#define BARHEIGHT 44
@implementation ADToastCollectView

- (id)initWithFrame:(CGRect)frame
           andTitle:(NSString *)aTitle
       andParenView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        _myTitle = aTitle;
        _superView = superView;
        [self setupView];
    }
    
    return self;
}

- (void)setupView
{
    self.titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    self.titleImg.center = CGPointMake(35, 25);
    [self addSubview:self.titleImg];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, SCREEN_WIDTH -65, 40)];
    self.titleLabel.center = CGPointMake(_titleLabel.center.x, 25);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"RTWSYueGoTrial-Light" size:12.0f];
    [self addSubview:self.titleLabel];
}

- (void)showCollectToast
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    self.alpha = 0.8;
    
    self.titleLabel.text = [NSString stringWithFormat:@"\"%@\" 已经添加到工具收藏", _myTitle];
    self.titleImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@小", _myTitle]];

    self.backgroundColor = [UIColor toast_collect_bgcolor];
    
    [UIView animateWithDuration:0.3 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = CGRectMake(0, 64, SCREEN_WIDTH, 50);
                         self.alpha = 1.0;
                         [self performSelector:@selector(hideCollectBar) withObject:nil afterDelay:2.0];
                     } completion:^(BOOL finished) {
                     }];
    
    [_superView addSubview:self];
}

- (void)showUnCollectToast
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    self.alpha = 0.8;
    
    self.titleLabel.text = [NSString stringWithFormat:@"\"%@\" 已经从工具收藏移出", _myTitle];
    self.titleImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@小", _myTitle]];
    
    self.backgroundColor = [UIColor toast_collect_bgcolor];
    
    [UIView animateWithDuration:0.3 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = CGRectMake(0, 64, SCREEN_WIDTH, 50);
                         self.alpha = 1.0;
                         [self performSelector:@selector(hideCollectBar) withObject:nil afterDelay:2.0];
                     } completion:^(BOOL finished) {
                     }];
    
    [_superView addSubview:self];
}

- (void)hideCollectBar
{
    [UIView animateWithDuration:0.3 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame= CGRectMake(0, 0, SCREEN_WIDTH, 50);
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end
