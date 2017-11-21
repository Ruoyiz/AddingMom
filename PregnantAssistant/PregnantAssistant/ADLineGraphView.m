//
//  ADLineGraphView.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADLineGraphView.h"
#import "ADMarkView.h"

#define kXaxisColor    [UIColor colorWithRed:255/255.0 green:176/255.0 blue:170/255.0 alpha:1.0]

#define kXaxisHeight (self.viewForBaselineLayout.frame.size.height   - 80/2)

#define circleSize 24.0
#define labelYaxisOffset 20.0
#define kLabelHeight 20.0

#define kXMargin 32.0
#define kYLineMargin 90/2
#define kCustomeWidth (self.viewForBaselineLayout.frame.size.width - 2 * kXMargin)
#define kCustomeLineHeight (self.viewForBaselineLayout.frame.size.height - 80/2 - kYLineMargin)

@interface ADLineGraphView (){
//    NSMutableArray *circleDotArray;
//    NSMutableArray *circleLineArray;
}

@property (nonatomic, strong) NSMutableArray *lineArray;

@end

@implementation ADLineGraphView

int numberOfPoints; // The number of Points in the Graph.
int numberOfBars;
ADCircle *closestDot;
int currentlyCloser;

- (void)reloadGraph
{
    _isDrawing = YES;
    [self setNeedsLayout];
}

- (void)commenInit
{
    self.labelFont = [UIFont systemFontOfSize:12];//横坐标刻度字体
//    self.colorXaxisLabel = kXaxisColor;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
//        circleDotArray = [[NSMutableArray alloc]initWithCapacity:1];
//        circleLineArray = [[NSMutableArray alloc]initWithCapacity:1];
        _isDrawing = YES;
        [self commenInit];
    }
    return self;
}


- (void)layoutSubviews {
    
    if (_isDrawing) {
        numberOfPoints = [self.delegate numberOfPointsInGraph]; // The number of Points in the Graph.
        self.animations = [[ADAnimations alloc] init];
        self.animations.delegate = self;
        [self drawGraph];
        [self drawXAxis];
    }
}

- (void)drawGraph {
    float gradeOfXAxis = kCustomeWidth/(numberOfPoints);
    float gradeOfYAxis;
    
    // CREATION OF THE DOTS
    
    float maxValue = [self maxValue]; // Biggest Y-axis value from all the points.
    float minValue = [self minValue]; // Smallest Y-axis value from all the points.
    
    float positionOnXAxis; // The position on the X-axis of the point currently being created.
    float positionOnYAxis; // The position on the Y-axis of the point currently being created.
    
    
    if ([self.delegate respondsToSelector:@selector(numberOfGradesInYAxis)]) {
        gradeOfYAxis = kCustomeLineHeight/[self.delegate numberOfGradesInYAxis];
        
    }else{
        gradeOfYAxis = (kCustomeLineHeight)/(maxValue - minValue);
    }
    
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[ADCircle class]])
            [subview removeFromSuperview];
        [subview setAlpha:1];
    }
    
    for (int i = 0; i < numberOfPoints; i++) {
        
        float dotValue = [self.delegate valueForIndex:i];
        
        if (dotValue !=  0) {
            positionOnXAxis = kXMargin + gradeOfXAxis*i + gradeOfXAxis *0.5;
            positionOnYAxis = (kCustomeLineHeight) - (dotValue - minValue) *gradeOfYAxis + kYLineMargin;
            
            ADCircle *circleDot = [[ADCircle alloc] initWithFrame:CGRectMake(positionOnXAxis, positionOnYAxis, circleSize, circleSize)];
            circleDot.center = CGPointMake(positionOnXAxis, positionOnYAxis);
            circleDot.tag = i+100;
            circleDot.alpha = 0;//动画时置为0
            circleDot.value = dotValue;
            [self addSubview:circleDot];

// !
            [self.animations animationForDot:i circleDot:circleDot animationSpeed:self.animationGraphEntranceSpeed];
            
            //创建markView
            ADMarkView *mark = [[ADMarkView alloc] initWithFrame:CGRectMake(positionOnXAxis, 0, 87/2, positionOnYAxis - 10)];//7为经验值
            CGPoint aCenter = mark.center;
            mark.center = CGPointMake(positionOnXAxis, aCenter.y);
            mark.markLabel.text = [NSString stringWithFormat:@"%d次",(int)dotValue];
            mark.alpha = 0.0;
            mark.hidden = YES;
            mark.tag = 2 * circleDot.tag;
            [self addSubview:mark];
           
        }else{
            positionOnXAxis = kXMargin + gradeOfXAxis *i + gradeOfXAxis *0.5;
            positionOnYAxis = (kCustomeLineHeight) - (dotValue - minValue) *gradeOfYAxis + kYLineMargin;
            
            ADCircle *circleDot = [[ADCircle alloc] initWithFrame:CGRectMake(positionOnXAxis, positionOnYAxis, 0, 0)];
            circleDot.center = CGPointMake(positionOnXAxis, positionOnYAxis);
            circleDot.tag = i+100;
            circleDot.alpha = 0.0;//动画时置为0

            circleDot.value = dotValue;
            [self addSubview:circleDot];
            
            [self.animations animationForDot:i circleDot:circleDot animationSpeed:self.animationGraphEntranceSpeed];
        }
        
    }
    // CREATION OF THE LINE AND BOTTOM AND TOP FILL
    
    float xDot1 = 0.0; // Postion on the X-axis of the first dot.
    float yDot1 = 0.0; // Postion on the Y-axis of the first dot.
    float xDot2 = 0.0; // Postion on the X-axis of the next dot.
    float yDot2 = 0.0; // Postion on the Y-axis of the next dot.
    
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[ADLine class]])
            [subview removeFromSuperview];
    }
    
    // per col width
    CGFloat perWidth = self.frame.size.width / numberOfPoints;
    
    _lineArray = [[NSMutableArray alloc]initWithCapacity:numberOfPoints];
    
    for (int i = 0; i < numberOfPoints - 1; i++) {
        
        for (ADCircle *dot in [self.viewForBaselineLayout subviews]) {
            if (dot.tag == i + 100)  {
                xDot1 = dot.center.x;
                yDot1 = dot.center.y;
                
                if (dot.value == 0) {
                    xDot1 = dot.center.x + gradeOfXAxis *0.5;
                }
            } else if (dot.tag == i + 101) {
                xDot2 = dot.center.x;
                yDot2 = dot.center.y;
                if (dot.value == 0) {
                    xDot2 = dot.center.x - gradeOfXAxis *0.5;
                }
            }
        }
        
//        NSLog(@"w: %f h: %f", self.viewForBaselineLayout.frame.size.width, self.viewForBaselineLayout.frame.size.height);
//        NSLog(@"w %f", perWidth *(i + 2));
        ADLine *line = [[ADLine alloc] initWithFrame:CGRectMake(0, 0, perWidth *(i + 2), 158)];
    
        line.opaque = NO;
        line.tag = i + 1000;
        line.alpha = 0.0;//动画时置为0

        line.firstPoint = CGPointMake(xDot1, yDot1);
        line.secondPoint = CGPointMake(xDot2, yDot2);
        line.topColor = _colorTop;
        line.bottomColor = _colorBottom;
        line.color = _colorLine;
        line.topAlpha = _alphaTop;
        line.bottomAlpha = _alphaBottom;
        line.lineAlpha = 1.0;
        line.lineWidth = _widthLine;
        
        [self addSubview:line];
        [self sendSubviewToBack:line];
        
        [_lineArray addObject:line];

        [self.animations animationForLine:i line:line animationSpeed:self.animationGraphEntranceSpeed];
    }
    
    //[self hiddenLineAndPoint];
}

- (void)hiddenLineAndPoint{//隐藏点和线

    for (UIView *subview in [self subviews]) {//point
        if ([subview isKindOfClass:[ADCircle class]])
            [subview setAlpha:0.0];
        
        if ([subview isKindOfClass:[ADLine class]])
            [subview setAlpha:0.0];
    }
}

// Determines the biggest Y-axis value from all the points.
- (float)maxValue {
    
    float dotValue;
    float maxValue = 0;
    
    for (int i = 0; i < numberOfPoints; i++) {
        dotValue = [self.delegate valueForIndex:i];
        
        if (dotValue > maxValue) {
            maxValue = dotValue;
        }
    }
    
    return maxValue;
}

// Determines the smallest Y-axis value from all the points.
- (float)minValue {
    float dotValue;
    float minValue = 0;
    
    for (int i = 0; i < numberOfPoints; i++) {
        dotValue = [self.delegate valueForIndex:i];
        
        if (dotValue < minValue) {
            minValue = dotValue;
        }
    }
    
    return minValue;
}

- (void)drawXAxis {

    if (![self.delegate respondsToSelector:@selector(numberOfGapsBetweenLabels)]) return;
    
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[UILabel class]])
            [subview removeFromSuperview];
    }
    
    int numberOfGaps = [self.delegate numberOfGapsBetweenLabels] + 1;
    
    if (numberOfGaps >= (numberOfPoints - 1)) {
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, self.frame.size.height - (labelYaxisOffset), self.frame.size.width/2, kLabelHeight)];
        firstLabel.text = [self.delegate labelOnXAxisForIndex:0];
        firstLabel.font = self.labelFont;
        firstLabel.textAlignment = 0;
        firstLabel.textColor = [UIColor btn_green_bgColor];
        firstLabel.backgroundColor = [UIColor redColor];
        [self addSubview:firstLabel];
        
        UILabel *lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 3, self.frame.size.height - (labelYaxisOffset), self.frame.size.width/2, kLabelHeight)];
        lastLabel.text = [self.delegate labelOnXAxisForIndex:(numberOfPoints - 1)];
        lastLabel.font = self.labelFont;
        lastLabel.textAlignment = 2;
        lastLabel.textColor = [UIColor btn_green_bgColor];
        lastLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:lastLabel];
    } else {
        for (int i = 1; i <= (numberOfPoints/numberOfGaps) + 1; i++) {
            UILabel *labelXAxis = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 10)];
            labelXAxis.text = [self.delegate labelOnXAxisForIndex:(i * numberOfGaps - 1)];
            //[labelXAxis sizeToFit];
            [labelXAxis setCenter:CGPointMake(kXMargin + (kCustomeWidth/(numberOfPoints))*(i*numberOfGaps - 1) - 5 , self.frame.size.height - labelYaxisOffset +5)];
            labelXAxis.font = self.labelFont;
            labelXAxis.textAlignment = 1;
            labelXAxis.textColor = [UIColor btn_green_bgColor];
            labelXAxis.backgroundColor = [UIColor clearColor];
            labelXAxis.transform = CGAffineTransformMakeRotation(-45*M_PI/180);
            [self addSubview:labelXAxis];
        }
    }
}

- (void)hiddenLine{
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[UILabel class]])
            [subview setAlpha:0];
    }
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, [UIColor btn_green_bgColor].CGColor);
    
    CGContextMoveToPoint(ctx,0, kXaxisHeight);
    CGContextAddLineToPoint(ctx,kXMargin, kXaxisHeight );
    CGContextAddLineToPoint(ctx, kXMargin, kXaxisHeight + 5);
    
    for (int i = 0;i < numberOfPoints + 1 ;i++) {
        if (i == numberOfPoints) {
            CGContextMoveToPoint(ctx,kXMargin +(kCustomeWidth/numberOfPoints)* i, kXaxisHeight);
            CGContextAddLineToPoint(ctx, 1000, kXaxisHeight);
            CGContextStrokePath(ctx);
            break;
        }
        CGContextMoveToPoint(ctx,kXMargin + (kCustomeWidth/numberOfPoints)*i, kXaxisHeight );
        CGContextAddLineToPoint(ctx,kXMargin +(kCustomeWidth/numberOfPoints)* (i+1), kXaxisHeight);
        CGContextAddLineToPoint(ctx, kXMargin +(kCustomeWidth/numberOfPoints)* (i+1), kXaxisHeight + 5);
        CGContextStrokePath(ctx);
    }
}

@end
