//
//  ADLogoutView.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/14.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADLogoutAlertView.h"

typedef void (^myblock)(void);

@implementation ADLogoutAlertView{
    UIView *_alertView;
    myblock _myBlock;
    myblock _cacenlBlock;
}

- (id)initWithLogoutType:(ADLogoutType)logoutType
{
    NSString *alertString = @"退出登录将不能永远保存你的孕育记录";
    if (logoutType == ADLogoutTypeSyncing) {
        alertString = @"有记录还未同步\n退出登录将不能永远保存你的记录";
    }
    self = [super initWithTitle:@"确认退出吗" message:alertString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [self show];
    
    return self;
}

- (void)showSyncWithConfirm:(void (^) (void))confirmBlock cancelBlock:(void (^) (void))cancelBlock
{
    _myBlock = confirmBlock;
}

- (void)showWithConfirm:(void (^) (void))confirmBlock
{
    _myBlock = confirmBlock;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        _myBlock();
    }
}

@end
