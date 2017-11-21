//
//  UIView+ADViewBadge.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/4/14.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ADViewBadge)

//默认小红点位置
- (void)showBadge;

//可改变x坐标的小红点
- (void)showBadgeFromStartY:(CGFloat)x;

- (void)removeBadge;

- (BOOL)haveBadge;

@end
