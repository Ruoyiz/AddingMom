//
//  ADLoginControl.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/7/6.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADLoginControl.h"
#import "ADPhoneLoginViewController.h"
#import "ADUserInfoListVC.h"
#import "ADGetTextSize.h"
#import "LXMThirdLoginManager.h"
#import "LXMThirdLoginResult.h"
#import "ADNavigationController.h"

#import "PregnantAssistant-Swift.h"

@interface ADLoginControl ()

@end

@implementation ADLoginControl{
    
    //记录自己在navigationController的位置，登录后返回使用
    NSInteger _vcIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myTitle = @"登录";
    //[self setLeftItemWithImage:nil andSelectImage:nil];
    _vcIndex = self.navigationController.viewControllers.count;

    if (_vcIndex == 1) {
        self.isPush = NO;
        [self setLeftBackItemWithImage:[UIImage imageNamed:@"webClose"] andSelectImage:nil];
    }else{
        self.isPush = YES;
        [self setLeftBackItemWithImage:nil andSelectImage:nil];
    }
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loadUI];
}

- (void)dealloc
{
    NSLog(@"移除通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    self.navigationController.navigationBar.translucent = YES;
    if (self.canSkip) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)loadUI
{
    CGFloat buttonCenter = 0.618 * (SCREEN_HEIGHT - NAVIBAT_HEIGHT) + 5;
    NSArray *loginArray;
    if (_subTitle) {
        loginArray = [NSArray arrayWithObjects:@"登录", _subTitle, nil];
    }else{
        loginArray = [NSArray arrayWithObjects:@"登录", @"享受加丁妈妈更多功能", nil];
    }
    
    CGFloat labelWidth = SCREEN_WIDTH;
    int i = 0;
    UIFont *font = [UIFont boldSystemFontOfSize:21];
    CGFloat startY = buttonCenter / 2.0 - 50 + NAVIBAT_HEIGHT / 2.0;
    for (NSString *str in loginArray) {
        if (i == 1) {
            font = [UIFont ADTraditionalFontWithSize:14];
        }
        CGFloat labelHeight = [ADGetTextSize heighForString:str width:labelWidth andFont:font];
        CGRect frame =CGRectMake(0, startY, labelWidth, labelHeight);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.font = font;
        label.text = str;
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor cell_title_Color];
        [self.view addSubview:label];
        
        startY += labelHeight + 18;
        i++;
    }
  
    NSArray *titleArray = [NSArray arrayWithObjects:@"微博登录", @"手机登录", nil];
    NSArray *tagArray = [NSArray arrayWithObjects:@"2" ,@"3", nil];
    if ([WXApi isWXAppInstalled] &&[WXApi isWXAppSupportApi]) {
        titleArray = [NSArray arrayWithObjects: @"微博登录", @"微信登录", @"手机登录", nil];
        tagArray = [NSArray arrayWithObjects:@"2", @"1" ,@"3", nil];
    }
    
    CGFloat buttonWidth = 80;
    CGFloat space = (SCREEN_WIDTH - buttonWidth * titleArray.count) / (titleArray.count + 1);
    i = 0;
    for (NSString *title in titleArray) {
        NSInteger tag = [[tagArray objectAtIndex:i] integerValue];
        
        UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(space + (space + buttonWidth) * i, buttonCenter - buttonWidth *1.5 / 2.0, buttonWidth, buttonWidth*1.5)];
        titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        titleButton.titleLabel.numberOfLines = 0;
        titleButton.tag = tag;
        [titleButton setImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
        [titleButton addTarget:self action:@selector(loginWithSender:) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:titleButton];
        
        i++;
    }
    
    if (_canSkip) {
        _skipButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        if (SCREEN_HEIGHT == 480) {
            _skipButton.center = CGPointMake(SCREEN_WIDTH/ 2.0, SCREEN_HEIGHT - 60);
        }else{
            _skipButton.center = CGPointMake(SCREEN_WIDTH/ 2.0, SCREEN_HEIGHT - 90);
        }
        [_skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipButton setTitleColor:[UIColor cell_title_Color] forState:UIControlStateNormal];
        _skipButton.titleLabel.font = [UIFont ADTraditionalFontWithSize:15];
        [_skipButton addTarget:self action:@selector(skipLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_skipButton];
        
        UIImageView *skipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
        skipImageView.image = [UIImage imageNamed:@"右双箭头"];
       
        skipImageView.center = CGPointMake(90, 20);
        skipImageView.contentMode = UIViewContentModeCenter;
        [_skipButton addSubview:skipImageView];
    }
}

- (void)loginWithSender:(UIButton *)sender
{
    ADAppDelegate *myApp = APP_DELEGATE;
    myApp.isSharing = NO;
    NSLog(@"%ld",(long)sender.tag);
    if (sender.tag == 3) {
        ADPhoneLoginViewController *pvc = [[ADPhoneLoginViewController alloc] init];
        pvc.loginControl = self;
        [self.navigationController pushViewController:pvc animated:YES];
    } else if (sender.tag == 2) {
        
        [self weiboSsoButtonPressed];
    } else if (sender.tag == 1) {
        [self weixinSsoButtonPressed];
    }
}

- (void)weiboSsoButtonPressed
{
    ADAppDelegate *myApp = APP_DELEGATE;
    myApp.loginControl = self;

    [[ADNAccountCenter defaultCenter]setupUserInfoByThirdParty:LXMThirdLoginTypeSinaWeibo
                                                   onReturnApp:^{
                                                       [self showToast];
                                                       [self changeSkipAndBackBtnEnable:NO];
                                                   } onFinish:^(NSError *err) {
                                                      [self changeSkipAndBackBtnEnable:YES];
                                                        if (err) {
                                                            [self addingLoginFailure];
                                                        } else {
                                                            [self addingLoginSuccessfull];
                                                        }
                                                   }];
}

- (void)weixinSsoButtonPressed
{
    [[ADNAccountCenter defaultCenter]setupUserInfoByThirdParty:LXMThirdLoginTypeWeChat
                                                   onReturnApp:^{
                                                       [self showToast];
                                                       [self changeSkipAndBackBtnEnable:NO];
                                                   } onFinish:^(NSError *err) {
                                                       [self changeSkipAndBackBtnEnable:YES];
                                                       if (err) {
                                                           [self addingLoginFailure];
                                                       } else {
                                                           [self addingLoginSuccessfull];
                                                       }
                                                   }];
}

- (BOOL)haveLoginVCInViewControllers:(NSArray *)array
{
    for (UIViewController *vc in array) {
        ADNavigationController *nc = (ADNavigationController *)vc;
        if ([nc.viewControllers.lastObject isKindOfClass:[ADLoginControl class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)changeSkipAndBackBtnEnable:(BOOL)aStatus
{
    _skipButton.enabled = aStatus;
    self.navigationItem.leftBarButtonItem.enabled = aStatus;
    ADNavigationController *nc = (ADNavigationController *)self.navigationController;
    if ([nc isKindOfClass:[ADNavigationController class]]) {
        nc.canDragBack = aStatus;
    }
}

- (void)showToast
{
    ADAppDelegate *myApp = APP_DELEGATE;
    UIViewController *controller = myApp.window.rootViewController;
    if ([controller isKindOfClass:[UINavigationController class]] || [controller isKindOfClass:[ADNavigationController class]]) {
        UINavigationController *nc = (UINavigationController *)controller;
        UIViewController *lastVc = (UIViewController *)nc.viewControllers.lastObject;
        if ([lastVc isKindOfClass:[ADLoginControl class]] || [self haveLoginVCInViewControllers:lastVc.childViewControllers]) {
            [ADToastHelp showSVProgressToastWithTitle:@"正在登录"];
        }
    }else if ([controller isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabBarVc = (UITabBarController *)controller;
        ADNavigationController *nc = (ADNavigationController *)[tabBarVc.viewControllers objectAtIndex:tabBarVc.selectedIndex];
        UIViewController *lastVc = (UIViewController *)nc.viewControllers.lastObject;
        if ([lastVc isKindOfClass:[ADLoginControl class]] || [self haveLoginVCInViewControllers:lastVc.childViewControllers]) {
            [ADToastHelp showSVProgressToastWithTitle:@"正在登录"];
        }
    }
    if (!myApp.isSharing) {
    }else{
        myApp.isSharing = NO;
    }
}

- (void)skipLogin
{
    self.skipAction();
}

- (void)leftItemMethod
{
    [[NSNotificationCenter defaultCenter] postNotificationName:cancelLogin object:nil];
    if (self.isPush || self.canSkip) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self dismissVc];
    }
}

- (void)dismissVc
{
    self.targetVC.navigationController.navigationBarHidden = self.superNavBarHidden;

    [UIView animateWithDuration:0.26 delay:0.05 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.navigationController.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self.navigationController.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)addingLoginSuccessfull
{
    [SVProgressHUD dismiss];
    if (self.canSkip) {
         self.skipAction();
    } else {
        [self disissVCAfterLogin];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:loginWeiSucessNotify object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:loginSucessNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:updateRecommadListNotification object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:updateFeedListNotification object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:updateColloctListNotification object:nil];
}

- (void)disissVCAfterLogin
{
    if (self.isPush) {
        NSMutableArray *vcArray = [NSMutableArray array];
        
        for (int i = 0; i < _vcIndex -1; i++) {
            UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:i];
            [vcArray addObject:vc];
        }
        
        self.navigationController.viewControllers = vcArray;
        
    } else {
//        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"jjjjjj %d",self.superNavBarHidden);
        [self dismissVc];
    }
}

- (void)addingLoginFailure
{
//    [SVProgressHUD dismiss];
    [ADToastHelp showSVProgressToastWithError:@"登陆失败"];
    NSLog(@"登录失败");
}

- (void)loginOAuthFailure:(id)obj
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
