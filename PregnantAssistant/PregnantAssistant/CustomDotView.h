//
//  CustomDotView.h
//  LineGraphDemo
//
//  Created by D on 14/11/25.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDotView : UIView

@property (nonatomic, retain) UIView *strokeView;
@property (nonatomic, retain) UIView *realDotView;

@property (nonatomic, retain) UIImageView *pinkWarnImgView;
@property (nonatomic, retain) UIImageView *whiteWarnImgView;

- (id)initWithFrame:(CGRect)frame
          withColor:(UIColor *)aColor
          andSelect:(BOOL)isSelect;

- (void)setSelectStatus:(BOOL)isSelect;

- (void)setWarnStatus:(BOOL)isWarn;

@end
