//
//  CustomDayLabel.m
//  LineGraphDemo
//
//  Created by D on 14/11/22.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import "CustomDayLabel.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation CustomDayLabel

- (id)initWithFrame:(CGRect)frame
           andTitle:(NSString *)aTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.text = aTitle;
        self.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        self.textAlignment = NSTextAlignmentCenter;
        
        self.textColor = [UIColor dot_green];
        
        [self setClipsToBounds:YES];
        [self.layer setCornerRadius:frame.size.height /2.0];
        
        self.transform = CGAffineTransformMakeRotation(-45*M_PI/180);
//        self.userInteractionEnabled = YES;
//        [self addGesture];
    }

    return self;
}

- (void)changeWithSelectStatus:(BOOL)isSelect
{
    if (isSelect) {
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor dot_green];
    } else {
        self.textColor = [UIColor dot_green];
        self.backgroundColor = [UIColor clearColor];
    }
}
//
//- (void)tapLabel:(UITapGestureRecognizer *)aGes
//{
//    NSLog(@"tap a Label");
//}

@end