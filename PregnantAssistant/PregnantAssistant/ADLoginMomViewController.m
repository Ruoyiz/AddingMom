//
//  ADLoginMomViewController.m
//  PregnantAssistant
//
//  Created by D on 14/12/8.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADLoginMomViewController.h"
#import "ADUserInfo.h"
#import "ADUserInfoSaveHelper.h"

@interface ADLoginMomViewController ()
@property(nonatomic,strong)LoginSuccessfulBlock callBackBlock;
@property(nonatomic,assign)LOGIN_VIEW_TYPE loginViewType;
@end

@implementation ADLoginMomViewController
- (id)initWithLoginViewType:(LOGIN_VIEW_TYPE)type
       loginSuccessfulBlock:(LoginSuccessfulBlock)callBackBlock;
{
    self = [super init];
    if (self) {
        self.loginViewType = type;
        self.callBackBlock = callBackBlock;
    }
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTitle = @"登录微信账号";
    self.view.backgroundColor = [UIColor bg_lightYellow];
    
    [self addLabelAndIcon];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addLabelAndIcon
{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, 24, SCREEN_WIDTH -32, 1)];
    line.backgroundColor = [UIColor defaultTintColor];
    [self.view addSubview:line];
    
    UIImageView *handView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 25, 35, SCREEN_HEIGHT *0.33 -25 -64)];
    [handView setImage:[[UIImage imageNamed:@"refresh_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 100, 0)]];
    handView.center = CGPointMake(SCREEN_WIDTH /2, handView.center.y);

    [self.view addSubview:handView];
    
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame = CGRectMake(0, 0, 111, 111);
    weixinBtn.center = CGPointMake(SCREEN_WIDTH /2, SCREEN_HEIGHT*(1- 0.56) -111/2);
    [weixinBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    
    [weixinBtn addTarget:self action:@selector(loginWechatAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinBtn];
    
    UIImageView *label = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 356, 32)];
    label.center = CGPointMake(SCREEN_WIDTH /2, SCREEN_HEIGHT*(1 -0.3) -141/6);
    label.image = [UIImage imageNamed:@"登陆秘密"];
    [self.view addSubview:label];
}

#pragma mark - weixin method
- (void)loginWechatAccount
{
//    [[ADAccountCenter sharedADAccountCenter] oAuthWeiXinWithTarget:self oauthType:ADLogin  success:@selector(loginOAuthSuccessful:) failure:@selector(loginOAuthFailure:)];
}

- (void)loginOAuthSuccessful:(NSString *)iconUrl
{
    [[NSNotificationCenter defaultCenter]postNotificationName:loginWeiSucessNotify object:nil];
}

- (void)loginOAuthFailure:(id)obj
{
}

@end
