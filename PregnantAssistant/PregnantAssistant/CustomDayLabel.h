//
//  CustomDayLabel.h
//  LineGraphDemo
//
//  Created by D on 14/11/22.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDayLabel : UILabel

- (id)initWithFrame:(CGRect)frame
           andTitle:(NSString *)aTitle;

- (void)changeWithSelectStatus:(BOOL)isSelect;

@end
