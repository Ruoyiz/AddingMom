//
//  ADLoginControl.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/7/6.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"

typedef void (^skipBlock)(void);

@interface ADLoginControl : ADBaseViewController

@property (nonatomic,assign) BOOL canSkip;
@property (nonatomic,copy) NSString *subTitle;
@property (nonatomic,assign) BOOL isPush;
@property (nonatomic,strong) UIButton *skipButton;
@property (nonatomic,assign) BOOL superNavBarHidden;
@property (nonatomic,strong) UIViewController *targetVC;
@property (nonatomic,copy) skipBlock skipAction;

- (void)addingLoginSuccessfull;
- (void)addingLoginFailure;

@end
