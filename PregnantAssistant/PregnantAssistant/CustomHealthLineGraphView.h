//
//  CustomLineView.h
//  LineGraphDemo
//
//  Created by D on 14/11/21.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomHealthLineGraphView;

@protocol CustomHealthLineGraphViewDelegate <NSObject>

@required
- (NSInteger)numberOfPointsInCustomLineGraph:(CustomHealthLineGraphView *)aLineGraph;
- (float)customLineGraph:(CustomHealthLineGraphView *)aLineGraph
           valueForIndex:(NSInteger)index;
- (float)customLineGraph:(CustomHealthLineGraphView *)aLineGraph
          value2ForIndex:(NSInteger)index;
- (NSString *)customLineGraph:(CustomHealthLineGraphView *)aLineGraph
                  tipForIndex:(NSInteger)index;
//其实应该弄两个代理...懒一下
- (void)customLineGraph:(CustomHealthLineGraphView *)aLineGraph didSelectAtIndex:(NSInteger)aIndex;

@optional
- (NSInteger)recommandHighValue;
- (NSInteger)recommandLowValue;

- (NSInteger)recommandHighValue2; //for line 2
- (NSInteger)recommandLowValue2; //for line 2
@end

@interface CustomHealthLineGraphView : UIView

@property (nonatomic, weak) id <CustomHealthLineGraphViewDelegate> delegate;
@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, assign) BOOL isHaveLabel;
@property (nonatomic, assign) BOOL isTwoLine;
@property (nonatomic, assign) BOOL selectLast;
@property (nonatomic, assign) NSInteger toSelectInx;
//@property (nonatomic, retain) UIImageView *emptyImgView;

- (id)initWithFrame:(CGRect)frame
      withLineColor:(UIColor *)aLineColor
       withLowValue:(NSInteger)aLowValue
      withHighValue:(NSInteger)aHighValue
          haveLabel:(BOOL)isHaveLabel
          isTwoLine:(BOOL)isTwoLine;

- (void)reloadGraph;
- (void)reloadGraphWithSelectInx:(NSInteger)aInx;

- (void)selectDotAndLabelAtIndex:(NSInteger)aIndex;

@end
