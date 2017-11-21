//
//  CustomDotView.m
//  LineGraphDemo
//
//  Created by D on 14/11/25.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import "CustomDotView.h"

@implementation CustomDotView

- (id)initWithFrame:(CGRect)frame
          withColor:(UIColor *)aColor
          andSelect:(BOOL)isSelect
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        float realDotSize = frame.size.width - 14;
        _realDotView = [[UIView alloc]initWithFrame:CGRectMake(7, 7, realDotSize, realDotSize)];
        _realDotView.backgroundColor = aColor;
        [_realDotView setClipsToBounds:YES];
        [_realDotView.layer setCornerRadius:realDotSize/2.0];
        [self addSubview:_realDotView];
        
        _realDotView.userInteractionEnabled = YES;
        
        [self setClipsToBounds:YES];
        [self.layer setCornerRadius:self.frame.size.width /2.0];
        
        int borderWidth = 1.99;
        
        _strokeView =
        [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width -10, self.frame.size.width -10)];
        _strokeView.layer.borderWidth = borderWidth;
        _strokeView.layer.cornerRadius = _strokeView.frame.size.width /2;
        _strokeView.layer.borderColor = aColor.CGColor;
        
        [self addSubview:_strokeView];
        
        if (isSelect == NO) {
            _strokeView.hidden = YES;
        }
    }
    return self;
}

- (void)setSelectStatus:(BOOL)isSelect
{
    if (isSelect) {
        _strokeView.hidden = NO;
    } else {
        _strokeView.hidden = YES;
    }
}

- (void)setWarnStatus:(BOOL)isWarn
{
    _pinkWarnImgView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 9, 2, 10)];
    if (isWarn) {
        if ([UIColor whiteColor] == _realDotView.backgroundColor) {
            _pinkWarnImgView.image = [UIImage imageNamed:@"warn"];
        } else {
            _pinkWarnImgView.image = [UIImage imageNamed:@"white_warn"];
        }
        [self addSubview:_pinkWarnImgView];
    } else {
        [_pinkWarnImgView removeFromSuperview];
    }
}

@end