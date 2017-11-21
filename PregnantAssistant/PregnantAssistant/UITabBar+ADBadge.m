//
//  UITabBar+ADBadge.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/4/14.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "UITabBar+ADBadge.h"

@implementation UITabBar (ADBadge)
//判断是否存在小红点
- (BOOL)isExistBadgeOnItemIndex:(NSInteger)index{
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            NSLog(@"存在");
            return YES;
        }
    }
    return NO;
}

- (void)showBadgeOnItemIndex:(NSInteger)index{
    //如果已经有了小红点，则不再添加
    UIView *hasBadgeView = [self viewWithTag:888+index];
    if (hasBadgeView) {
        return;
    }
    
    NSInteger badgeNumber = 4;
    
    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([myApp.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tbc = (UITabBarController *)myApp.window.rootViewController;
        badgeNumber = tbc.viewControllers.count;
    }
   
    UIView *badgeView = [[UIView alloc]init];
    
    badgeView.tag = 888 + index;
    
    badgeView.layer.cornerRadius = 4;
    
//    badgeView.backgroundColor = UIColorFromRGB(0xff8c8c);
    badgeView.backgroundColor = [UIColor red_Dot_color];
    
    CGRect tabFrame = self.frame;
    
    float percentX = (index + 0.6) / badgeNumber;
    
    CGFloat x = percentX * tabFrame.size.width;
    
    CGFloat y = 0.08 * tabFrame.size.height;
    if(iPhone6Plus){
        y = 0.05 * tabFrame.size.height;
    }else if (iPhone6){
        y = 0.06 * tabFrame.size.height;
    }
    
    badgeView.frame = CGRectMake(x, y, 8, 8);
    
    [self addSubview:badgeView];
    
}

- (void)removeBadgeOnItemIndex:(NSInteger)index{
    
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 888+index) {
            
            [subView removeFromSuperview];
            
        }
    }
}

@end
