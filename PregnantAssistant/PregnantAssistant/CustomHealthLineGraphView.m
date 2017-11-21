//
//  CustomLineView.m
//  LineGraphDemo
//
//  Created by D on 14/11/21.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import "CustomHealthLineGraphView.h"
#import "CustomDayLabel.h"
#import "ADLine.h"
#import "CustomDotView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CustomHealthLineGraphView ()

@property (nonatomic, assign) NSInteger numberOfPoints;
@property (nonatomic, retain) NSMutableArray *dotViewArray;
@property (nonatomic, retain) NSMutableArray *dot2ViewArray;
@property (nonatomic, retain) NSMutableArray *lineViewArray;
@property (nonatomic, retain) NSMutableArray *line2ViewArray;
@property (nonatomic, assign) float zeroValueYPos;
@property (nonatomic, assign) float perValueYSize; // 每单位Y轴增加值
@property (nonatomic, assign) float lowValue; // 每单位Y轴增加值
@property (nonatomic, retain) NSMutableArray *customLabelArray;
@property (nonatomic, assign) BOOL canDrawLabel;
@property (nonatomic, assign) BOOL canDrawDotLine;

@end

@implementation CustomHealthLineGraphView

- (id)initWithFrame:(CGRect)frame
      withLineColor:(UIColor *)aLineColor
       withLowValue:(NSInteger)aLowValue
      withHighValue:(NSInteger)aHighValue
          haveLabel:(BOOL)isHaveLabel
          isTwoLine:(BOOL)isTwoLine
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        _numberOfPoints = [self.delegate numberOfPointsInCustomLineGraph:self];
        _lineColor = aLineColor;
        _zeroValueYPos = self.frame.size.height -54;
        _perValueYSize = (self.frame.size.height - 54 -6.5)/(aHighValue - aLowValue);
        _lowValue = aLowValue;
        
        _isHaveLabel = isHaveLabel;
        
        _canDrawLabel = YES;
        _canDrawDotLine = YES;
        _selectLast = YES;
        
        _isTwoLine = isTwoLine;
    }
    return self;
}

- (void)drawPointAndLine
{
    if (_canDrawDotLine == NO) {
        return;
    }
    
    self.dotViewArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.dot2ViewArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.lineViewArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.line2ViewArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i = 0; i < [self.delegate numberOfPointsInCustomLineGraph:self]; i++) {
        
        float line1Dot = [self.delegate customLineGraph:self valueForIndex:i];
        CustomDotView *dotView = [[CustomDotView alloc]initWithFrame:CGRectMake(0, 0, 28.0, 28.0)
                                                           withColor:_lineColor
                                                           andSelect:NO];
        float posY = _zeroValueYPos -6.5 - ((line1Dot - _lowValue) *_perValueYSize);
        
        dotView.center = CGPointMake(32 +8 +i*(33), posY);
        dotView.tag = 10000 + i;
        [self.dotViewArray addObject:dotView];
        
        if (line1Dot > [self.delegate recommandHighValue] || line1Dot < [self.delegate recommandLowValue])
        {
            [dotView setWarnStatus:YES];
        }
        
        if (_selectLast == YES) {
            if (i == [self.delegate numberOfPointsInCustomLineGraph:self] -1) {
                [dotView setSelectStatus:YES];
            }
        } else {
            if (i == _toSelectInx) {
                [dotView setSelectStatus:YES];
            }
        }
        
        //线图2
        if (_isTwoLine) {
            float line2Dot = [self.delegate customLineGraph:self value2ForIndex:i];
            
            CustomDotView *line2DotView = [[CustomDotView alloc]initWithFrame:CGRectMake(0, 0, 28.0, 28.0)
                                                                    withColor:[UIColor whiteColor]
                                                                    andSelect:NO];
            float posYLine2 = _zeroValueYPos -6.5 - ((line2Dot - _lowValue) *_perValueYSize);
            
            line2DotView.center = CGPointMake(32 +8 +i*(33), posYLine2);
            line2DotView.tag = 10000 + i;
            [self.dot2ViewArray addObject:line2DotView];
            
            if (line2Dot > [self.delegate recommandHighValue2] || line2Dot < [self.delegate recommandLowValue2])
            {
                [line2DotView setWarnStatus:YES];
            }
            
            if (_selectLast == YES) {
                if (i == [self.delegate numberOfPointsInCustomLineGraph:self] -1) {
                    [line2DotView setSelectStatus:YES];
                }
            } else {
                if (i == _toSelectInx) {
                    [dotView setSelectStatus:YES];
                }
            }
        }
    }
    
    for (int i = 0; i < [self.delegate numberOfPointsInCustomLineGraph:self] -1; i++) {
        ADLine *lineView = [[ADLine alloc]initWithFrame:
                            CGRectMake(0, 0, [self.delegate numberOfPointsInCustomLineGraph:self]*36, self.frame.size.height -58)];
        UIView *firstDot = self.dotViewArray[i];
        UIView *nextDot = self.dotViewArray[i+1];
        lineView.firstPoint = CGPointMake(firstDot.center.x, firstDot.center.y);
        lineView.secondPoint = CGPointMake(nextDot.center.x, nextDot.center.y);
        lineView.color = _lineColor;
        lineView.lineAlpha = 1.0;
        lineView.lineWidth = 1.5;
        lineView.userInteractionEnabled = YES;
        [self addSubview:lineView];
        [self.lineViewArray addObject:lineView];
        
        //线图2
        if (_isTwoLine) {
            ADLine *lineView = [[ADLine alloc]initWithFrame:
                                CGRectMake(0, 0, [self.delegate numberOfPointsInCustomLineGraph:self]*36, self.frame.size.height -58)];
            UIView *firstDot = self.dot2ViewArray[i];
            UIView *nextDot = self.dot2ViewArray[i+1];
            lineView.firstPoint = CGPointMake(firstDot.center.x, firstDot.center.y);
            lineView.secondPoint = CGPointMake(nextDot.center.x, nextDot.center.y);
            lineView.color = [UIColor whiteColor];
            lineView.lineAlpha = 1.0;
            lineView.lineWidth = 1.5;
            lineView.userInteractionEnabled = YES;
            [self.line2ViewArray addObject:lineView];
            [self addSubview:lineView];
        }
    }
    
    for (CustomDotView *aDot in self.dotViewArray) {
        [self addSubview:aDot];
        
        UITapGestureRecognizer *tapRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDot:)];
        [aDot addGestureRecognizer:tapRecognizer];
    }
    
    if (_isTwoLine) {

        for (CustomDotView *aDot in self.dot2ViewArray) {
            [self addSubview:aDot];
            
            UITapGestureRecognizer *tapRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDot:)];
            [aDot addGestureRecognizer:tapRecognizer];
        }
    }
    
    _canDrawDotLine = NO;
}

- (void)layoutSubviews {
    _numberOfPoints = [self.delegate numberOfPointsInCustomLineGraph:self];
 
    if (_isHaveLabel) {
        [self addLabels];
    }

    [self drawPointAndLine];
}

- (void)addLabels
{
    if (_canDrawLabel == NO) {
        return;
    }
    
    _customLabelArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < _numberOfPoints; i++) {
        CustomDayLabel *aDayLabel = nil;
        if ([ADHelper isIphone4]) {
            aDayLabel = [[CustomDayLabel alloc]initWithFrame:CGRectMake(-2 +i*(33), 156, 54, 19)
                                                    andTitle:[self.delegate customLineGraph:self tipForIndex:i]];
        } else {
            aDayLabel = [[CustomDayLabel alloc]initWithFrame:CGRectMake(-2 +i*(33), 208, 54, 19)
                                                    andTitle:[self.delegate customLineGraph:self tipForIndex:i]];
        }

        if (_selectLast == YES) {
            if (i == _numberOfPoints -1) {
                [aDayLabel changeWithSelectStatus:YES];
            }
        } else {
            if (i == _toSelectInx) {
                [aDayLabel changeWithSelectStatus:YES];
            }
        }
    
        aDayLabel.tag = 20 +i;
        [self addSubview:aDayLabel];
        
        [_customLabelArray addObject:aDayLabel];
        
        aDayLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
        [aDayLabel addGestureRecognizer:tapRecognizer];
    }
    
    _canDrawLabel = NO;
}

- (void)reloadGraph {
    _canDrawLabel = YES;
    _canDrawDotLine = YES;
    _selectLast = YES;
    //重置点 不带圈圈
    [self resetDotView];
    //重置线
    [self resetLineView];
    [self resetLabelView];
    [self setNeedsLayout];
}

- (void)reloadGraphWithSelectInx:(NSInteger)aInx
{
    _canDrawLabel = YES;
    _canDrawDotLine = YES;
    _selectLast = NO;
    _toSelectInx = aInx;
    //重置点 不带圈圈
    [self resetDotView];
    //重置线
    [self resetLineView];
    [self resetLabelView];
    [self setNeedsLayout];
}

- (void)resetDotView
{
    for (CustomDotView *aDotView in self.dotViewArray) {
        [aDotView removeFromSuperview];
    }
    if (_isTwoLine) {
        for (CustomDotView *aDotView in self.dot2ViewArray) {
            [aDotView removeFromSuperview];
        }
    }
}

- (void)resetLineView
{
    for (ADLine *aLine in self.lineViewArray) {
        [aLine removeFromSuperview];
    }
    if (_isTwoLine) {
        for (ADLine *aLine in self.line2ViewArray) {
            [aLine removeFromSuperview];
        }
    }
}

- (void)resetLabelView
{
    for (CustomDayLabel *aLabel in self.customLabelArray) {
        [aLabel removeFromSuperview];
    }
}

- (void)tapLabel:(UIGestureRecognizer *)sender {
    NSInteger tapTag = sender.view.tag;
//    NSLog(@"tapTag:%d", tapTag);
    
    [self selectDotAndLabelAtIndex:tapTag -20];
    [self.delegate customLineGraph:self didSelectAtIndex:tapTag -20];
}

- (void)tapDot:(UIGestureRecognizer *)sender {
    NSInteger tapTag = sender.view.tag;
    
    [self selectDotAndLabelAtIndex:tapTag -10000];
    [self.delegate customLineGraph:self didSelectAtIndex:tapTag -10000];
}

- (void)selectDotAndLabelAtIndex:(NSInteger)aIndex
{
    for (CustomDotView *aDotView in self.dotViewArray) {
        [aDotView setSelectStatus:NO];
    }
    
    CustomDotView *aDotView = self.dotViewArray[aIndex];
    [aDotView setSelectStatus:YES];
    
    if (_isTwoLine) {
        for (CustomDotView *aDotView in self.dot2ViewArray) {
            [aDotView setSelectStatus:NO];
        }
        
        CustomDotView *aDotView = self.dot2ViewArray[aIndex];
        [aDotView setSelectStatus:YES];
    }
    
    for (CustomDayLabel *aLabel in self.customLabelArray) {
        [aLabel changeWithSelectStatus:NO];
    }
    
    CustomDayLabel *aSelLabel = self.customLabelArray[aIndex];
    [aSelLabel changeWithSelectStatus:YES];
}

@end