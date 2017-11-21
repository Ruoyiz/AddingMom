//
//  ADSecertTitleView.m
//  PregnantAssistant

//
//  Created by D on 15/3/26.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADSecertTitleView.h"
#import "UIViewController+ADReloadViewData.h"

@implementation ADSecertTitleView

-(id)initWithFrame:(CGRect)frame
       andParentVC:(UIViewController *)aVc
{
    if (self = [super initWithFrame:frame]) {
        _parentVc = aVc;
        //add btns
        _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn1.titleLabel.font = [UIFont fontWithName:@"RTWSYueGoTrial-Light" size:15.0f];
        [_btn1 setTitle:@"全部" forState:UIControlStateNormal];
        _btn1.frame = CGRectMake(0, 0, 68, 28);
        _btn1.tag = 10;
        _btn1.selected = YES;
        [_btn1 setClipsToBounds:YES];
        [_btn1.layer setCornerRadius:_btn1.frame.size.height /2];
        _btn1.layer.borderWidth = 1;
        _btn1.layer.borderColor = UIColorFromRGB(0x00DBB8).CGColor;
        [_btn1 setTitleColor:UIColorFromRGB(0x00DBB8) forState:UIControlStateSelected];
        [_btn1 setTitleColor:UIColorFromRGB(0x85818D) forState:UIControlStateNormal];

        _btn1.center = CGPointMake(frame.size.width /2 - 68 -16, 22);
        [_btn1 addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn1];
        
        _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn2.titleLabel.font = [UIFont fontWithName:@"RTWSYueGoTrial-Light" size:15.0f];
        [_btn2 setTitle:@"热门" forState:UIControlStateNormal];
        _btn2.frame = CGRectMake(-4, 0, 68, 28);
        
        [_btn2 setClipsToBounds:YES];
        [_btn2.layer setCornerRadius:_btn1.frame.size.height /2];
        _btn2.layer.borderWidth = 1;
        _btn2.layer.borderColor = UIColorFromRGB(0x85818D).CGColor;
        [_btn2 setTitleColor:UIColorFromRGB(0x85818D) forState:UIControlStateNormal];
        [_btn2 setTitleColor:UIColorFromRGB(0x00DBB8) forState:UIControlStateSelected];

        _btn2.center = CGPointMake(frame.size.width /2, 22);
        [_btn2 addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn2];

        _selectInx = 1;
    }
    return self;
}

- (void)tapBtn:(UIButton *)sender
{
    if (sender.tag == 10) {
        // btn1 clicked
        if (_btn1.selected == YES) {
            [_parentVc performSelector:@selector(showRefreshView) withObject:nil afterDelay:0];
        }
        _btn1.layer.borderColor = UIColorFromRGB(0x00DBB8).CGColor;
        _btn1.selected = YES;
        _btn2.selected = NO;
        _btn2.layer.borderColor = UIColorFromRGB(0x85818D).CGColor;
        _selectInx = 1;
    } else {
        if (_btn2.selected == YES) {
            [_parentVc performSelector:@selector(showRefreshView) withObject:nil afterDelay:0];
        }
        // btn2 clicked
        _btn1.layer.borderColor = UIColorFromRGB(0x85818D).CGColor;
        _btn1.selected = NO;
        _btn2.selected = YES;
        _btn2.layer.borderColor = UIColorFromRGB(0x00DBB8).CGColor;
        
        _selectInx = 2;
    }
    
    if ([_parentVc respondsToSelector:@selector(reloadViewData)]) {
        [_parentVc performSelector:@selector(reloadViewData) withObject:nil afterDelay:0];
    }else{
        NSLog(@"%@找不到reloadViewData方法",_parentVc.class);
    }
}

@end
