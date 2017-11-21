//
//  UITabBar+ADBadge.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/4/14.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (ADBadge)

//判断是否存在小红点
- (BOOL)isExistBadgeOnItemIndex:(NSInteger)index;

//在指定tab上显示红点
- (void)showBadgeOnItemIndex:(NSInteger)index;

//删除小红点
- (void)removeBadgeOnItemIndex:(NSInteger)index;

@end
