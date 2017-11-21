//
//  ADLable.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/30.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    VerticalAlignmentTop = 0,//labelText 顶端显示
    VerticalAlignmentMiddle,//labelText 竖直方向居中
    VerticalAlignmentBottom,//labelText 靠底显示
} VerticalAlignment;

@interface ADLable : UILabel
//已知title
- (instancetype)initWithFrame:(CGRect)frame titleText:(NSString *)title textColor:(UIColor *)textColor textFont:(UIFont *)textFont lineSpace:(CGFloat)lineSpace;
//未知title
- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor textFont:(UIFont *)textFont lineSpace:(CGFloat)lineSpace;
@property (nonatomic, strong) NSString *LabelText;
@property (nonatomic) VerticalAlignment verticalAlignment;
@end
