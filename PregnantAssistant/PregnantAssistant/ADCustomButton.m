//
//  ADCustomButton.m
//  PregnantAssistant
//
//  Created by D on 14-9-17.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADCustomButton.h"

@implementation ADCustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor defaultTintColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        
        [self setClipsToBounds:YES];
        [self.layer setCornerRadius:8];
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr
{
    [self setTitle:titleStr forState:UIControlStateNormal];
}

- (void)setButtonColor:(UIColor *)buttonColor
{
    [self setBackgroundColor:buttonColor];
}

@end
