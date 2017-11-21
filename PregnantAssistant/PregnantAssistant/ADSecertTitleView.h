//
//  ADSecertTitleView.h
//  PregnantAssistant
//
//  Created by D on 15/3/26.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ADMomSecretViewController.h"

@interface ADSecertTitleView : UIView

@property (nonatomic, retain) UIViewController *parentVc;
@property (nonatomic, retain) UIButton *btn1;
@property (nonatomic, retain) UIButton *btn2;
@property (nonatomic, assign) NSInteger selectInx;

-(id)initWithFrame:(CGRect)frame
       andParentVC:(UIViewController *)aVc;


@end
