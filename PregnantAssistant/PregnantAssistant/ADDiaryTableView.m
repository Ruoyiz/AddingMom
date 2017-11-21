//
//  ADDiaryTableView.m
//  PregnantAssistant
//
//  Created by D on 14-9-20.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADDiaryTableView.h"

@implementation ADDiaryTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor bg_lightYellow];
        
//        [self addLine];
    }
    return self;
}

//- (void)addLine
//{
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(12, 0, 1.5, self.frame.size.height)];
//    lineView.backgroundColor = [UIColor defaultTintColor];
//    [self addSubview:lineView];
//}

@end
