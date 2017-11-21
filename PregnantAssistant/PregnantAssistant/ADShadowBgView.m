//
//  ADShadowBgView.m
//  PregnantAssistant
//
//  Created by D on 14-9-22.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADShadowBgView.h"

@implementation ADShadowBgView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIView *bgView =
//        [[UIView alloc]initWithFrame:CGRectMake(12, 64, 320 -28, screenRect.size.height - naviHeight - 184)];
        self.backgroundColor = [UIColor bg_Paper_forground];
        [self.layer setShadowColor:[UIColor bg_Paper_background].CGColor];
        [self.layer setShadowOpacity:1];
        [self.layer setShadowRadius:0];
        [self.layer setShadowOffset:CGSizeMake(6.0, 6.0)];
    }
    return self;
}

@end
