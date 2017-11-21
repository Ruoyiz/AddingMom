//
//  ADSettingViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-16.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADSettingViewController.h"
#import "UMFeedback.h"
#import "ADSettingCell.h"
#import "ADUserInfoListVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ADNoticeViewController.h"
#import "ADPersonInfoViewController.h"
#import "UIView+ADViewBadge.h"
#import "ADMomLookDAO.h"
#import "ADGetTextSize.h"
#import "UITabBar+ADBadge.h"
#import "ADUserInfoSaveHelper.h"
#import "ADDebugViewController.h"
#import "ADStatementViewController.h"
#import "ADUserInfoSyncManager.h"
#import "ADMomSecretViewController.h"
#import "PregnantAssistant-Swift.h"
#import "ADFeedViewController.h"
#import "ADLoginControl.h"
#import "ADNavigationController.h"

#define SECRERT_REDDOT_X (iPhone6Plus?67:57)

@interface ADSettingViewController (){
    UIImageView *_redDotImageView;
    UIImageView *_secertRedDotImageView;
    BOOL _secertNotiShow;
}
@end

@implementation ADSettingViewController{
    NSInteger _loginSuccessTo;
}

-(void)dealloc
{
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick event:misc_display];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = YES;
    [ADToastHelp dismissSVProgress];
    [self loadData];
    [self.myTableView reloadData];
    [ADUserInfoSaveHelper syncAllDataOnGetData:^(NSError *error) {
    } onUploadProcess:^(NSError *error) {
    } onUpdateFinish:^(NSError *error) {
        [self.myTableView reloadData];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ADToastHelp dismissSVProgress];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTitle = @"更多";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBadge:)
                                                 name:notiNumChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSecertBadge) name:removeSecretNumChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSecertBadge)
                                                 name:secretNumChangedNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addingLoginSuccess) name:loginWeiSucessNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddingLoginCancel) name:cancelLogin object:nil];
}

- (void)loadData
{
    _addingToken = [[NSUserDefaults standardUserDefaults]addingToken];
    if (_addingToken.length > 0 ) {
        [self loadImage];
        _userName =  [ADUserInfoSaveHelper readUserName];
    } else {
        _userImg = [UIImage imageNamed:@"无头像"];
        _userName =  @"未登录";
    }
    self.settingNameArray = @[
                              @[@"孕育状态",@"我的订阅", @"我的消息", @"我的秘密"],
                              @[@"关于加丁妈妈",@"意见反馈", @"评分"]
                              ];
}


- (void)loadImage
{
    UIImage *image = [ADUserInfoSaveHelper readIconData];
    if (image) {
        _userImg = [ADUserInfoSaveHelper readIconData];
    } else {
//        [self performSelector:@selector(loadImage) withObject:nil afterDelay:0.5];
    }
}

- (void)addTableView
{
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)
                                                   style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
}

#pragma mark - button event
- (void)enterInfoVC:(UIButton *)btn
{
    NSString *addingToken = [[NSUserDefaults standardUserDefaults] addingToken];
    if (addingToken.length == 0) {
        [self jumpToLoginVcWithCompletion:nil];
        return;
    }
    [self.navigationController pushViewController:[[ADUserInfoListVC alloc] init] animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    NSArray *array = self.settingNameArray[section - 1];
    return array.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierIndicate = @"CellIndicate";
    ADSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierIndicate];
    
    if (cell == nil ) {
        if (indexPath.section == 0) {
            cell = [[ADSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierIndicate andIconHeight:42 cellHeight:76];

        } else {
            cell = [[ADSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierIndicate andIconHeight:27 cellHeight:44];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        NSLog(@"icon: %@ %@", _iconImage.image, _userImg);
        cell.iconImage.image = _userImg;

        [cell.iconImage setClipsToBounds:YES];
        [cell.iconImage.layer setCornerRadius:cell.iconImage.frame.size.height /2.0];
        cell.titleLabel.text = _userName;
    } else {
        if (indexPath.section == 1 && indexPath.row == 0)
        {
            NSDate *date = nil;
            NSString *typeTitle = nil;
            NSString *status = [ADUserInfoSaveHelper readUserStatus];
            NSLog(@"status: %@", status);
            if ([status isEqualToString:@"1"]) {
                date = [ADUserInfoSaveHelper readDueDate];
                typeTitle = @"预产期";
            } else {
                date = [ADUserInfoSaveHelper readBabyBirthday];
                NSLog(@"date:%@,readDate:%@",date,[ADUserInfoSaveHelper readBabyBirthday]);
                
                if (self.appDelegate.babySex == 2) {
                    typeTitle = @"女宝";
                }else{
                    typeTitle = @"男宝";
                }
            }
            cell.contentLabel.text = (NSInteger)[date timeIntervalSince1970] == 0 ?@"未设置":[NSString stringWithFormat:@"%@ %ld.%ld.%ld",
                                      typeTitle,(long)date.year, (long)date.month, (long)date.day];
            
            if (self.appDelegate.changeLaunchBadgeUpdate){
                [cell.titleLabel showBadgeFromStartY:70];
            }
        }
        
        ADAppDelegate *myapp = APP_DELEGATE;
        if (indexPath.section == 1 && indexPath.row == 2) {
            _redDotImageView = cell.redDotImageView;
            if (myapp.notiBadgeUpdateNumber > 0) {
                cell.redDotImageView.hidden = NO;
            }
        }else if(indexPath.section == 1 && indexPath.row == 3){
            _secertRedDotImageView = cell.redDotImageView;
            if (myapp.secretBadgeUpdateNumber > 0) {
                cell.redDotImageView.hidden = NO;
                _secertNotiShow = YES;
            }
        }
        cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.settingNameArray[indexPath.section - 1][indexPath.row]]];
        cell.titleLabel.text = self.settingNameArray[indexPath.section -1][indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 76;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 0:
            _loginSuccessTo = 1;
            [self enterInfoVC:nil];
            break;
        case 1:
            [self pushSetOtherInfoWithIndexPath:indexPath];
            break;
        case 2:
            [self pushOtherVcWithIndexPath:indexPath];
            break;
        
        default:
            break;
    }
}

- (void)pushSetOtherInfoWithIndexPath:(NSIndexPath *)indexPath
{
//    孕育状态
//    订阅
//    消息
//    秘密
    switch (indexPath.row) {
        case 0: {
            [self jumpToStatusVc];
        }
            break;
        case 1: {
            [self jumpToFeedVC];
        }
            break;
        case 2: {
            
            [self jumpToNotifyVc];
        }
            break;
        case 3:{
            [self jumpToSecertVc];
        }
            break;
        default:
            break;
    }
}

- (void)pushOtherVcWithIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0://关于
        {
            ADStatementViewController *aboutVC = [[ADStatementViewController alloc]init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
        case 1://意见反馈
        {
            self.navigationController.navigationBar.translucent = YES;
            UIViewController *umVC = [UMFeedback feedbackViewController];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 42)];
            [label setFont:[UIFont ADTraditionalFontWithSize:15]];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:UIColorFromRGB(0x333333)];
            [label setText:@"意见反馈"];
            [label setTextAlignment:NSTextAlignmentCenter];
            umVC.navigationItem.titleView = label;
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [backButton setImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
            [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            [backButton setFrame:CGRectMake(0, 0, 24, 24 +4)];
            [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 4)];
            umVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

            [self.navigationController pushViewController:umVC animated:YES];
        }
            break;
        case 2://评分
        {
            [[UIApplication sharedApplication] openURL:
             [NSURL URLWithString:@"https://itunes.apple.com/us/app/yun-ma-zhu-shou-zui-tie-xin/id931197358?l=zh&ls=1&mt=8"]];
            //            ADDebugViewController *aVc = [[ADDebugViewController alloc]init];
            //            UINavigationController *aNavi = [[UINavigationController alloc]initWithRootViewController:aVc];
            //            [self presentViewController:aNavi animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)jumpToStatusVc
{
    SetMomStatusVC *aVc = [[SetMomStatusVC alloc]init];
    aVc.finishAction = ^(){
        [self.navigationController popViewControllerAnimated:true];
    };
    [self.navigationController pushViewController:aVc animated:YES];
}

- (void)jumpToSecertVc
{
    NSString *token = [[NSUserDefaults standardUserDefaults] addingToken];
    if (token.length == 0) {
        _loginSuccessTo = 3;
        [self jumpToLoginVcWithCompletion:nil];
        return;
    }
    ADMomSecretViewController *secretVC = [[ADMomSecretViewController alloc] init];
    secretVC.secertnotiShow = _secertNotiShow;
    [self.navigationController pushViewController:secretVC animated:YES];
}

- (void)jumpToFeedVC{
    _loginSuccessTo = 0;
    [self.navigationController pushViewController:[[ADFeedViewController alloc] init] animated:YES];
}

- (void)jumpToNotifyVc
{
    NSString *token = [[NSUserDefaults standardUserDefaults] addingToken];
    if (token.length == 0) {
        _loginSuccessTo = 2;
        [self jumpToLoginVcWithCompletion:nil];
        return;
    }
    
    // 消息
    ADNoticeViewController *aVc = [[ADNoticeViewController alloc]init];
    
    //去除红点以及重设时间
    aVc.removeRedDotBlock = ^{
        [[NSUserDefaults standardUserDefaults] setLastUpdateBadgeDate:[NSDate date]];
        [self removeMessageBadge];
        ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
        myApp.notiBadgeUpdateNumber = 0;
        if (myApp.secretBadgeUpdateNumber == 0) {
            [self.tabBarController.tabBar removeBadgeOnItemIndex:self.tabBarController.viewControllers.count - 1];
        }
    };
    [self.navigationController pushViewController:aVc animated:YES];
}

- (void)jumpToLoginVcWithCompletion:(void (^)(void))aFinishBlock
{
    ADLoginControl *loginVc = [[ADLoginControl alloc] init];
    if (_loginSuccessTo == 2) {
        loginVc.subTitle = @"查看消息";
    }else if (_loginSuccessTo == 3){
        loginVc.subTitle = @"跟加丁妈妈们匿名分享秘密";
    }
    [self.navigationController pushViewController:loginVc animated:YES];
}

- (void)logout
{
    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    myApp.secretBadgeUpdateNumber = 0;
    
    [self loadData];
    [self.myTableView reloadData];
    
    [self dismissAllSecretBadge];
}

#pragma mark - 消息小红点显示和移除方法
- (void)showBadge:(NSNotification *)notification
{
    [self showMessageBadge];
}
- (void)showSecertBadge{
    _secertNotiShow = YES;
    _secertRedDotImageView.hidden = NO;
}
- (void)showMessageBadge
{
    _redDotImageView.hidden = NO;
}
- (void)dismissSecertBadge{
    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    myApp.secretBadgeUpdateNumber = 0;
    _secertNotiShow = NO;
    _secertRedDotImageView.hidden = YES;
    if (myApp.notiBadgeUpdateNumber == 0) {
        [self.tabBarController.tabBar removeBadgeOnItemIndex:self.tabBarController.viewControllers.count - 1];
    }
}
- (void)dismissAllSecretBadge
{
    [self removeMessageBadge];
    [self dismissSecertBadge];
}

- (void)addingLoginSuccess
{
    if (self.tabBarController.selectedIndex != 2) {
        return;
    }
    
    NSInteger index = _loginSuccessTo;
    _loginSuccessTo = 0;
    
    switch (index) {
        case 1:
            [self enterInfoVC:nil];
            break;
            
        case 2:
            [self jumpToNotifyVc];
            break;
            
        case 3:
            [self jumpToSecertVc];
            break;
            
        default:
            break;
    }
}

- (void)AddingLoginCancel
{
    _loginSuccessTo = 0;
}

- (void)removeMessageBadge
{
    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    myApp.notiBadgeUpdateNumber = 0;
    _redDotImageView.hidden = YES;
//    [_redDotImageView removeFromSuperview];
//    _redDotImageView= nil;
}

@end