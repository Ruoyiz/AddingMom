//
//  CircleDataView.m
//  LineGraphDemo
//
//  Created by D on 14/11/21.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import "CircleDataView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation CircleDataView

-  (id)initWithFrame:(CGRect)frame
            withDate:(NSString *)aDateStr
          withValue1:(NSString *)aValue1
          withValue2:(NSString *)aValue2
            withUnit:(NSString *)aUnit
             isEmpty:(BOOL)isEmpty
         andParentVC:(UIViewController *)aVc
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = UIColorFromRGB(0xFC5570);
        self.backgroundColor = UIColorFromRGB(0x06F0C7);
        [self setClipsToBounds:YES];
        [self.layer setCornerRadius:frame.size.width/2];
        
        _parentVC = aVc;
        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 41, 41)];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"plusCircle"] forState:UIControlStateNormal];
        [_addBtn addTarget:_parentVC action:@selector(plusData:) forControlEvents:UIControlEventTouchUpInside];
        if ([ADHelper isIphone4]) {
            _addBtn.center = CGPointMake(frame.size.width /2 +64, frame.size.height /2);
        } else {
            _addBtn.center = CGPointMake(frame.size.width /2 +72, frame.size.height /2);
        }
        [self addSubview:_addBtn];
        

        if (isEmpty || aValue1.length == 0) {
            // add Empty img
            [self addAEmptyImg];
        } else {
            _aDateStr = aDateStr;
            _value1 = aValue1;
            _value2 = aValue2;
            _unit = aUnit;
            //date label
            [self addLabelsWithDate:aDateStr withValue1:aValue1 withValue2:aValue2 withUnit:aUnit];
            
            [self addAEditBtn];
        }
        
        [self addGestureAtLabel];
    }
    
    return self;
}

-  (void)setViewWithDate:(NSString *)aDateStr
              withValue1:(NSString *)aValue1
              withValue2:(NSString *)aValue2
                withUnit:(NSString *)aUnit
                 isEmpty:(BOOL)isEmpty
{
    [_dateLabel removeFromSuperview];
    [_value1Label removeFromSuperview];
    [_value2Label removeFromSuperview];
    [_unitLabel removeFromSuperview];
    [_emptyImgView removeFromSuperview];
    [_lineView removeFromSuperview];
    [_editBtn removeFromSuperview];
    
    if (isEmpty || aValue1.length == 0) {
        [self addAEmptyImg];
    } else {
        [self addAEditBtn];
        _aDateStr = aDateStr;
        _value1 = aValue1;
        _value2 = aValue2;
        _unit = aUnit;

        [self addLabelsWithDate:aDateStr withValue1:aValue1 withValue2:aValue2 withUnit:aUnit];
    }
}

- (void)addAEditBtn
{
    _editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    [_editBtn setBackgroundImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [_editBtn addTarget:_parentVC action:@selector(editData:) forControlEvents:UIControlEventTouchUpInside];
    if ([ADHelper isIphone4]) {
        _editBtn.center = CGPointMake(self.frame.size.width /2, self.frame.size.height /2 +56);
    } else {
        NSInteger centerY = self.frame.size.height /2 +56;
        if (iPhone6) {
            centerY += 4;
        } else if (iPhone6Plus) {
            centerY += 16;
        }
        _editBtn.center = CGPointMake(self.frame.size.width /2, centerY);
    }
    [self addSubview:_editBtn];
}

- (void)addAEmptyImg
{
    _emptyImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 130)];
    _emptyImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 68, 68 *(161. /105))];
    _emptyImgView.image = [UIImage imageNamed:@"暂无记录绿色"];
    _emptyImgView.center = CGPointMake(self.frame.size.width /2.0, self.frame.size.height /2.0);
    [self addSubview:_emptyImgView];
}

- (void)addLabelsWithDate:(NSString *)aDate
               withValue1:(NSString *)aValue1
               withValue2:(NSString *)aValue2
                 withUnit:(NSString *)aUnit
{
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 14, self.frame.size.width, 24)];
    _dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.text = aDate;
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    
    _value1Label = [[UILabel alloc]init];
    _value1Label.textColor = [UIColor whiteColor];
    _value1Label.textAlignment = NSTextAlignmentCenter;
    _value1Label.text = aValue1;
    
    //血压
    if (aValue2.length > 0) {
        _lineView = [[ADLine alloc]initWithFrame:
                     CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _lineView.firstPoint = CGPointMake(self.frame.size.width /2.0 -36, self.frame.size.height /2.0 +8);
        _lineView.secondPoint = CGPointMake(self.frame.size.width /2.0 +38, self.frame.size.height /2.0 -8);
        _lineView.backgroundColor = [UIColor clearColor];
        _lineView.color = [UIColor whiteColor];
        _lineView.lineAlpha = 1.0;
        _lineView.lineWidth = 1.5;
        [self insertSubview:_lineView belowSubview:_addBtn];

        _value1Label.frame = CGRectMake(0, 0, self.frame.size.width, 44);
        _value1Label.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0 -30);
        [self insertSubview:_value1Label belowSubview:_addBtn];
        
        _value2Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        _value2Label.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0 +26);
        _value2Label.textColor = [UIColor whiteColor];
        _value2Label.textAlignment = NSTextAlignmentCenter;
        _value2Label.text = aValue2;
        
        [self insertSubview:_value2Label belowSubview:_addBtn];
        
        if ([ADHelper isIphone4]) {
            _value1Label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:36];
            _value2Label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:36];
        } else {
            _value1Label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40];
            _value2Label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40];
        }

    } else {
        _value1Label.frame = CGRectMake(0, 0, self.frame.size.width, 44);
        _value1Label.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
        
        if (_value1Label.text.length > 3) {
            if ([ADHelper isIphone4]) {
                _value1Label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:34];
            } else {
                _value1Label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40];
            }
        } else {
            if ([ADHelper isIphone4]) {
                _value1Label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40];
            } else {
                _value1Label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:50];
            }
        }
        
        [self insertSubview:_value1Label belowSubview:_addBtn];
    }
    
    [self addGestureAtLabel];
    
    _unitLabel = [[UILabel alloc]initWithFrame:
                  CGRectMake(0, self.frame.size.height -16 -24, self.frame.size.width, 24)];
    _unitLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    _unitLabel.textColor = [UIColor whiteColor];
    _unitLabel.text = aUnit;
    _unitLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_dateLabel];
    [self addSubview:_unitLabel];
}

- (void)addGestureAtLabel
{
    _value1Label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:_parentVC action:@selector(tapLabel:)];
    [_value1Label addGestureRecognizer:tapGes];
    
    _value2Label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes2 = [[UITapGestureRecognizer alloc]initWithTarget:_parentVC action:@selector(tapLabel:)];
    [_value2Label addGestureRecognizer:tapGes2];
}

- (void)plusData:(UIButton *)sender
{
}

- (void)editData:(UIButton *)sender
{
}

- (void)tapLabel:(UITapGestureRecognizer *)sender
{
}

@end