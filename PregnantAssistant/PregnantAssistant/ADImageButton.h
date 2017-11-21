//
//  ADImageButton.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/7/14.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADImageButton : UIButton
/*自定制Image位置*/
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title titleFont:(UIFont *)titleStringFont titleTextColor:(UIColor *)titleTextColor image:(UIImage *)image edgeinsets:(UIEdgeInsets)edgeInsets;
/*系统默认Image效果 AttiButedTitle*/
- (instancetype)initWithFrame:(CGRect)frame attributedTitle:(NSString *)title titleFont:(UIFont *)titleStringFont titleTextColor:(UIColor *)titleTextColor image:(UIImage *)image;
/*系统默认效果*/
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title titleFont:(UIFont *)titleStringFont titleTextColor:(UIColor *)titleTextColor image:(UIImage *)image;

@end
