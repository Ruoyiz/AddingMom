//
//  ADImageButton.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/7/14.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADImageButton.h"

@implementation ADImageButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title titleFont:(UIFont *)titleStringFont titleTextColor:(UIColor *)titleTextColor image:(UIImage *)image edgeinsets:(UIEdgeInsets)edgeInsets{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:titleStringFont,NSForegroundColorAttributeName:titleTextColor}] forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
        [self setImageEdgeInsets:edgeInsets];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame attributedTitle:(NSString *)title titleFont:(UIFont *)titleStringFont titleTextColor:(UIColor *)titleTextColor image:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:titleStringFont,NSForegroundColorAttributeName:titleTextColor}] forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title titleFont:(UIFont *)titleStringFont titleTextColor:(UIColor *)titleTextColor image:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:titleTextColor forState:UIControlStateNormal];
        self.titleLabel.font = titleStringFont;
        [self setImage:image forState:UIControlStateNormal];
    }
    return self;

}

@end
