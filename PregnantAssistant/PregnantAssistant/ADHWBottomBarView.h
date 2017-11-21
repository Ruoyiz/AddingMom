//
//  ADHWBottomBarView.h
//  PregnantAssistant
//
//  Created by 加丁 on 15/5/29.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomViewClickDelegate <NSObject>
- (void)bottomViewClickedWithIndex:(NSInteger)index;
@end

@interface ADHWBottomBarView : UIView

@property (nonatomic, strong) id<BottomViewClickDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame ImageArray:(NSArray *)images imageHeight:(CGFloat)height;


@end
