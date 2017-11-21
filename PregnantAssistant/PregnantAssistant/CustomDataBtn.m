//
//  CustomDataBtn.m
//  LineGraphDemo
//
//  Created by D on 14/11/21.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import "CustomDataBtn.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation CustomDataBtn

- (id)initWithFrame:(CGRect)frame
           andTitle:(NSString *)aTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xE5DFD6);
        
        _myTitleLabel = [[UILabel alloc]initWithFrame:
                         CGRectMake(0, (self.frame.size.height -17)/2, self.frame.size.width, 17)];
        _myTitleLabel.font = [UIFont systemFontOfSize:17];
        _myTitleLabel.textColor = [UIColor whiteColor];
        _myTitleLabel.textAlignment = NSTextAlignmentCenter;
        _myTitleLabel.text = aTitle;
        
        [self addSubview:_myTitleLabel];
        [self setClipsToBounds:YES];
        [self.layer setCornerRadius:frame.size.height /2];
    }
    return self;
}

@end
