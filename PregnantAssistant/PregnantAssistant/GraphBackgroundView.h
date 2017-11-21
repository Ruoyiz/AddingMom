//
//  GraphBackgroundView.h
//  LineGraphDemo
//
//  Created by D on 14/11/21.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphBackgroundView : UIView

//@property (nonatomic, assign) int barHeight;
@property (nonatomic, copy) NSArray *backgroundValueArray;
@property (nonatomic, copy) NSArray *backgroundColorArray;

-  (id)initWithFrame:(CGRect)frame
withBackgroundValues:(NSArray *)aValueArray
withBackgroundColors:(NSArray *)aColorArray
       withBarHeight:(int)barHeight;

@end
