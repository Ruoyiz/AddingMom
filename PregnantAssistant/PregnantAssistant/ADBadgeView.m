//
//  ADBadgeView.m
//  PregnantAssistant
//
//  Created by D on 14/12/6.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBadgeView.h"

@implementation ADBadgeView

- (id)initWithFrame:(CGRect)frame
             andNum:(int)aNum
         andBgColor:(UIColor *)aColor
{
    self = [super initWithFrame:frame];
    if (self) {
        _badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        if (aNum > 99) {
            _badgeLabel.text = @"N";
        } else {
            _badgeLabel.text = [NSString stringWithFormat:@"%ld", (long)aNum];
        }
        _badgeLabel.font = [UIFont systemFontOfSize:9];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.backgroundColor = aColor;
        [_badgeLabel setClipsToBounds:YES];
        [_badgeLabel.layer setCornerRadius:frame.size.height /2.0];

        [self addSubview:_badgeLabel];
    }
    
    return self;
}

- (void)clearBadgeNo
{
    _badgeLabel.text = @"0";
}

@end
