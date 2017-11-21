//
//  ADBabyTitleView.h
//  PregnantAssistant
//
//  Created by D on 15/3/24.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADBabyTitleView : UIView

@property (nonatomic, retain) UIImageView *bgView;
@property (nonatomic, assign) WeatherType aWeatherType;
@property (nonatomic, retain) UILabel *dayLabel;
@property (nonatomic, retain) UILabel *lenLabel;
@property (nonatomic, retain) UILabel *weightLabel;
@property (nonatomic, retain) UIViewController *parentVc;

@property (nonatomic, retain) UIImageView *weightView;
@property (nonatomic, retain) UIImageView *lengthView;
@property (nonatomic, retain) UIImageView *arrowView;

@property (nonatomic, retain) UIImageView *aniView;
@property (nonatomic, retain) UIImageView *nextView;

@property (nonatomic, retain) UIImageView *babyImgView;

@property (nonatomic, assign) NSInteger week;
@property (nonatomic, assign) NSInteger dueDay;
@property (nonatomic, assign) NSInteger leftDay;

@property (nonatomic, retain) UIImageView *aniKiteView;

//@property (nonatomic, retain) UIVisualEffectView *blurView;

@property (nonatomic, assign) BOOL isFitCell;

- (id)initWithFrame:(CGRect)frame
        andParentVC:(UIViewController *)aVc;

- (void)refreshData;

@end
