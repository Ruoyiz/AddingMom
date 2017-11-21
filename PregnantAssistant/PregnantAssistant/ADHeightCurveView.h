//
//  ADHeightCurveView.h
//  PregnantAssistant
//
//  Created by 加丁 on 15/6/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADHeightCurveView : UIView


//instancetype 方法
/*
 title: 标题
 YArray: 纵坐标值
 XArray: 横坐标值
 */
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title YArray:(NSArray *)Yarray XArray:(NSArray *)XArray  patterImageName:(NSString *)imageName isHeight:(BOOL)isheight userCurveColor:(UIColor *)userCurveColor;
@end
