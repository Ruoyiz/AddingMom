//
//  ADAddBottomBtn.m
//  PregnantAssistant
//
//  Created by D on 14-9-23.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADAddBottomBtn.h"

@implementation ADAddBottomBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setBackgroundColor:[UIColor defaultTintColor]];
        [self setBackgroundColor:[UIColor light_green_Btn]];
        [self setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"添加1"] forState:UIControlStateHighlighted];
        
    }
    return self;
}

@end
