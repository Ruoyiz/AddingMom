//
//  ADResetPasswordVC.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/7/8.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADLoginControl.h"

@interface ADResetPasswordVC : ADBaseViewController

@property (nonatomic,strong)NSString *code;
@property (nonatomic,strong)NSString *codeId;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)ADLoginControl *loginControl;

@end
