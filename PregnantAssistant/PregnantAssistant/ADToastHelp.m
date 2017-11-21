//
//  ADToastHelp.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/13.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADToastHelp.h"

@implementation ADToastHelp

+ (void)showSVProgressToastWithTitle:(NSString *)title
{
    [SVProgressHUD setBackgroundColor:[UIColor darkGrayColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    //[SVProgressHUD setOffsetFromCenter:UIOffsetMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0)];
    [SVProgressHUD showWithStatus:title];
}

+ (void)dismissSVProgress
{
    [SVProgressHUD dismiss];
}

+ (void)showSVProgressWithSuccess:(NSString *)str
{
    [SVProgressHUD setBackgroundColor:[UIColor darkGrayColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showSuccessWithStatus:str];
}

+ (void)showSVProgressToastWithError:(NSString *)str{
    [SVProgressHUD setBackgroundColor:[UIColor darkGrayColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showErrorWithStatus:str];
}

@end
