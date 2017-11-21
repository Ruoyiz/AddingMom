//
//  ADMarkView.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-4.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADMarkView.h"

@implementation ADMarkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,24)];
        //_aImageView.backgroundColor = [UIColor yellowColor];
        _aImageView.image = [UIImage imageNamed:@"点击出现的黄条"];
        [self addSubview:_aImageView];
        
        
        _linkLineImageView = [[UIImageView alloc]initWithFrame:
                              CGRectMake((self.frame.size.width - 1)/2, _aImageView.frame.size.height - 1,
                                         1, self.frame.size.height - _aImageView.frame.size.height)];
        _linkLineImageView.backgroundColor = [UIColor colorWithRed:1.000 green:0.718 blue:0.161 alpha:1.0];
       
        [self addSubview:_linkLineImageView];
        
        _markLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -4, self.frame.size.width, 67/2)];
        _markLabel.textColor = [UIColor whiteColor];
        _markLabel.numberOfLines = 0;
        _markLabel.font = [UIFont systemFontOfSize:34/2];
        _markLabel.textAlignment = NSTextAlignmentCenter;
        _markLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _markLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_markLabel];

    }
    return self;
}

@end
