//
//  ADHWBottomBarView.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/5/29.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADHWBottomBarView.h"

#define TABBAR_HEIGHT 49
#define SIGLE_VIEW_HEIGHT 36
#define LEFTVIEW_DISTANCE 40

@implementation ADHWBottomBarView


- (instancetype)initWithFrame:(CGRect)frame ImageArray:(NSArray *)images imageHeight:(CGFloat)height{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self layoutImageFrameWithFrame:frame images:images imageHeight:height];
    }
    return self;
}

- (void)layoutImageFrameWithFrame:(CGRect)frame images:(NSArray *)images imageHeight:(CGFloat)height{
    
    NSInteger indexY;
    indexY = (TABBAR_HEIGHT - height)/2;
    UIButton *firstButton = [[UIButton alloc] initWithFrame:CGRectMake(LEFTVIEW_DISTANCE, indexY, height, height)];
    firstButton.tag = 100;
    [firstButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",images[0]]] forState:UIControlStateNormal];
    [firstButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:firstButton];
    
    UIButton *secendtButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - height)/2, indexY, height, height)];
    [secendtButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",images[1]]] forState:UIControlStateNormal];
    secendtButton.tag = 101;
    [secendtButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:secendtButton];
    
    UIButton *thirdButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - LEFTVIEW_DISTANCE - height, indexY, height, height)];
    [thirdButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",images[2]]] forState:UIControlStateNormal];
    thirdButton.tag = 102;
    [thirdButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:thirdButton];
}

- (void)buttonClicked:(UIButton *)button{

    if ([_delegate respondsToSelector:@selector(bottomViewClickedWithIndex:)]) {
        [_delegate bottomViewClickedWithIndex:button.tag-100];
    }
}

@end
