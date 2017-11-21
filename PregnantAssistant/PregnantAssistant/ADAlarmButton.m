//
//  ADAlarmButton.m
//  PregnantAssistant
//
//  Created by D on 14/10/18.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADAlarmButton.h"

@implementation ADAlarmButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor defaultTintColor];
        self.backgroundColor = [UIColor btn_green_bgColor];
        
        _myTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, self.frame.size.width, 17)];
        _myTitleLabel.font = [UIFont systemFontOfSize:17];
        _myTitleLabel.textColor = [UIColor whiteColor];
        _myTitleLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:_myTitleLabel];
        [self setClipsToBounds:YES];
        [self.layer setCornerRadius:8];
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    _myTitleLabel.text = titleStr;
    
    if ([_myTitleLabel.text isEqualToString:@"设置产检提醒"]) {
        //remove
        [_titleImgView removeFromSuperview];
        
        _myTitleLabel.frame = CGRectMake(0, 12, self.frame.size.width, 17);
    } else {
        //add
        _titleImgView =
        [[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 24, 24)];
        _titleImgView.image = [UIImage imageNamed:@"产检日历提醒icon"];
        
        [self addSubview:_titleImgView];
        
        _myTitleLabel.frame = CGRectMake(14, 12, self.frame.size.width, 17);
    }
}

@end
