//
//  CustomDataBtn.h
//  LineGraphDemo
//
//  Created by D on 14/11/21.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDataBtn : UIButton

@property (nonatomic, retain) UILabel *myTitleLabel;

- (id)initWithFrame:(CGRect)frame
           andTitle:(NSString *)aTitle;

@end
