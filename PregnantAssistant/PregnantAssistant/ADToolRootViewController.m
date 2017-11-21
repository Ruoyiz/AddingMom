//
//  ADToolRootViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-19.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADToolRootViewController.h"

#import "ADToastCollectView.h"
#import "ADCollectToolDAO.h"
#import "ADLogoutAlertView.h"

@interface ADToolRootViewController ()

@end

@implementation ADToolRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightItemCollect];
    
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
}

- (void)setRightItemCollect
{
    [self setRightItemWithImgCollectAndSync];
    
    self.appDelegate = APP_DELEGATE;
    
    _isFav = [ADCollectToolDAO hasCollectAToolWithTitle:_vcName];
    if (_isFav) {
        [self.collectBtn setSelected:YES];
    }
}

- (void)setRightItemShare
{
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

//    NSLog(@"native self.title:%@", self.myIcon.title);
    [MobClick event:_vcName];
    [MobClick beginLogPageView:_vcName];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.disMissNavBlock) {
        self.disMissNavBlock();
    }

    [MobClick endLogPageView:_vcName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)rightItemMethod:(UIButton *)sender
{
    ADToastCollectView *aToastView = [[ADToastCollectView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)
                                                                     andTitle:_vcName
                                                                 andParenView:self.view];

    if (_isFav == YES) {
        //取消收藏
        [ADCollectToolDAO unCollectAToolWithTitle:_vcName onFinish:^(NSError *err) {
            if (err.code == ERRCODE_LESS_TOOL) {
                [ADHelper showToastWithText:atLeastIconNumTip];
            } else {
                _isFav = NO;
                [self.collectBtn setSelected:NO];
                [aToastView showUnCollectToast];
                [MobClick event:tool_cancel_collecting];
            }
        }];
    } else {
        _isFav = YES;
        [self.collectBtn setSelected:YES];
    
        [ADCollectToolDAO collectAToolWithTitle:_vcName recordTime:YES];
        [aToastView showCollectToast];
        [MobClick event:tool_collect];
    }
}

- (void)syncMethod:(UIButton *)sender
{
    [self syncAllDataOnFinish:^(NSError *error) {
    }];
}

- (void)syncAllDataOnFinish:(void(^)(NSError *error))finishBlock
{
}

- (void)showSyncAlert
{
    if ([[NSUserDefaults standardUserDefaults]hasShowSyncAlert] == NO) {
        if ([[NSUserDefaults standardUserDefaults]addingToken].length > 0) {
            // TO CHECK
//            [[[ADLogoutAlertView alloc]init] showSyncWithConfirm:^{
//                [[NSUserDefaults standardUserDefaults]setHasShowSyncAlert:YES];
//            }];
        }
    }
}

@end