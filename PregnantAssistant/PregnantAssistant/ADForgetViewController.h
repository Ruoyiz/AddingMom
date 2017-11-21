//
//  ADForgetViewController.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/7/8.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADLoginControl.h"

@interface ADForgetViewController : ADBaseViewController

@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,strong)ADLoginControl *loginControl;

@end
