//
//  ADLoginMomViewController.h
//  PregnantAssistant
//
//  Created by D on 14/12/8.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
//登陆页面类型
typedef enum {
    SECRET_VIEW_LOGIN = 1,//秘密页面进行登陆授权
    ACCOUNT_VIEW_LOGIN = 2//账号页面进行登陆授权
}LOGIN_VIEW_TYPE;
//回调block
typedef void(^LoginSuccessfulBlock)(void);
@interface ADLoginMomViewController : ADBaseViewController
//custome initial
- (id)initWithLoginViewType:(LOGIN_VIEW_TYPE)type
       loginSuccessfulBlock:(LoginSuccessfulBlock)callBackBlock;
@end
