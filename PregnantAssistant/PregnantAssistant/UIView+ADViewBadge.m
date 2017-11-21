//
//  UIView+ADViewBadge.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/4/14.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "UIView+ADViewBadge.h"
#import "ADGetTextSize.h"

@implementation UIView (ADViewBadge)

- (void)showBadge
{
    UIView *badgeView = [self viewWithTag:9999];
    
    if (badgeView) {
        return;
    }
    
    CGRect viewFrame = self.frame;
    
    CGFloat x = viewFrame.size.width - 10;
    CGFloat y = 2;
    [self addSubview:[self createBadgeViewWithFrame:CGRectMake(x, y, 8, 8)]];
}

- (BOOL)haveBadge
{
    UIView *badgeView = [self viewWithTag:9999];
    
    if (badgeView) {
        return YES;
    }
    
    return NO;
}

- (void)removeBadge
{
    UIView *badgeView = [self viewWithTag:9999];
    if (badgeView) {
        [badgeView removeFromSuperview];
    }
}

- (void)showBadgeFromStartY:(CGFloat)x
{
    UIView *badgeView = [self viewWithTag:9999];
    
    if (badgeView) {
        return;
    }
    
    CGFloat y = 2;
    [self addSubview:[self createBadgeViewWithFrame:CGRectMake(x, y, 8, 8)]];
}

- (UIView *)createBadgeViewWithFrame:(CGRect)frame
{
    UIView *badgeView = [[UIView alloc]init];
    
    badgeView.tag = 9999;
    
    badgeView.layer.cornerRadius = 4;
    
    badgeView.backgroundColor = UIColorFromRGB(0xff8c8c);
    
    badgeView.frame = frame;
    
    return badgeView;
}

@end
