//
//  ADBigBabyTitleView.h
//  PregnantAssistant
//
//  Created by D on 15/3/31.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADBigBabyTitleView : UIView

@property (nonatomic, retain) UIImageView *bgView;

@property (nonatomic, retain) UIImageView *babyImageView;
@property (nonatomic, assign) WeatherType aWeatherType;
@property (nonatomic, retain) UIViewController *parentVc;

@property (nonatomic, assign) NSInteger week;

@property (nonatomic, retain) UIImageView *aniView;
@property (nonatomic, retain) UIImageView *nextView;

- (id)initWithFrame:(CGRect)frame
        andParentVC:(UIViewController *)aVc;

@end
