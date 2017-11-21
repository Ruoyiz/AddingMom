//
//  ADRootVCManager.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/7/31.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADRootVCManager.h"
#import "ADLoginControl.h"
#import "PregnantAssistant-Swift.h"
#import "ADChannelManager.h"
#import "ADImageButton.h"
#import "ADPregNotifyViewController.h"
#import "ADTool.h"
#import "ADHtmlToolViewController.h"
#import "ADLocationManager.h"

@implementation ADRootVCManager

static ADRootVCManager *rootVCManager = nil;

+ (ADRootVCManager *)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rootVCManager = [[ADRootVCManager alloc] init];
        rootVCManager.myAppDelegate = APP_DELEGATE;
    });
    
    return rootVCManager;
}

- (void)showSplash{

    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    UIWebView * aWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    aWebView.backgroundColor = UIColorFromRGB(0x21c3b1);
    aWebView.scrollView.backgroundColor = UIColorFromRGB(0x21c3b1);
    aWebView.scrollView.showsVerticalScrollIndicator = NO;
    aWebView.opaque = NO;
    aWebView.scrollView.scrollEnabled = NO;
    
    NSString *fileString = [self getFileString];
    
    NSURL *url = [NSURL URLWithString:fileString];
    aWebView.delegate = self;
    [aWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
    ADImageButton *skipButton = [[ADImageButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 40, 40, 20) attributedTitle:@"跳过" titleFont:[UIFont ADTraditionalFontWithSize:16] titleTextColor:[UIColor whiteColor] image:nil];
    skipButton.alpha = 160/255.0;
    [skipButton addTarget:self action:@selector(webSkipAction) forControlEvents:UIControlEventTouchUpInside];
    [aWebView addSubview:skipButton];
    
    CGFloat ratao = 96.0/527.0;
    CGFloat width = SCREEN_WIDTH - 68*2;
    CGFloat height = width *ratao;
    UIImageView *bottomImageVIew = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - width)/2.0, SCREEN_HEIGHT - 30 - height,width, height)];
    bottomImageVIew.image = [UIImage imageNamed:@"矢量智能对象"];
    [aWebView addSubview:bottomImageVIew];
    
    UIViewController *firstLanchVC = [[UIViewController alloc] init];
    [firstLanchVC.view addSubview:aWebView];
    self.myAppDelegate.navController = [[UINavigationController alloc] initWithRootViewController:firstLanchVC];
    self.myAppDelegate.navController.navigationBarHidden = YES;
    self.myAppDelegate.window.rootViewController = self.myAppDelegate.navController;

}

- (void)webSkipAction{

    if (self.myAppDelegate.skiped) {
        return;
    }
    self.myAppDelegate.skiped = YES;
//    [self.myAppDelegate.navController removeFromParentViewController];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if (![[NSUserDefaults standardUserDefaults] everLaunched]) {
        [[NSUserDefaults standardUserDefaults] setEverLaunched:YES];
        [[NSUserDefaults standardUserDefaults] setFirstLauch:YES];
    }
    
    if([[NSUserDefaults standardUserDefaults] firstUseAppDate] == nil){
        //记录第一次启动时间
        [[NSUserDefaults standardUserDefaults] setFirstUseAppDate:[NSDate date]];
    }
    
    if ([[NSUserDefaults standardUserDefaults] firstLauch]) {
        
        SetMomStatusVC *aSetVc = [[SetMomStatusVC alloc]init];
        aSetVc.isGuiding = YES;
        aSetVc.finishAction = ^() {
            [self setRootVcDelay];
        };
        
        ADLoginControl *aVc = [[ADLoginControl alloc]init];
        aVc.canSkip = YES;
        aVc.skipAction = ^(){
            [self.myAppDelegate.navController pushViewController:aSetVc animated:true];
        };
        
        self.myAppDelegate.navController = [[UINavigationController alloc]initWithRootViewController:aVc];
        [self.myAppDelegate.window setRootViewController:self.myAppDelegate.navController];
    } else {
        [[ADLocationManager shareLocationManager] startLocate];
        [self setRootVc];
    }
}

#define ACTION_MEDIACLICK @"adding://adco/mediaOpen?mediaId="
#define ACTION_SPLASH_FINSH @"adding://splash/finish"
#define ACTION_CONTENT_COMMENT @"adding://adco/content?contentId="
#define ACTION_TOOL @"adding://adco/adTool?toolId="
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlString = [NSString stringWithFormat:@"%@",request.URL];
    NSLog(@"urlstringdfld : %@",urlString);
    if ([urlString isEqualToString:ACTION_SPLASH_FINSH]) {
        [self webSkipAction];
        return  NO;
    }else if ([urlString myContainsString:ACTION_MEDIACLICK]) {
        NSString *mediaid = [[urlString componentsSeparatedByString:ACTION_MEDIACLICK ]lastObject];
        ADFeedDetailsViewController *dvc = [[ADFeedDetailsViewController alloc] init];
        dvc.mediaId = mediaid;
        dvc.disMissNavBlock = ^{
            self.myAppDelegate.navController.navigationBarHidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        };
        [self.myAppDelegate.navController pushViewController:dvc animated:YES];
        return NO;
    }else if ([urlString myContainsString:ACTION_CONTENT_COMMENT]) {
        NSString *commentId = [[urlString componentsSeparatedByString:ACTION_CONTENT_COMMENT]lastObject];
        ADMomLookContentDetailVC *contentDetailVC = [[ADMomLookContentDetailVC alloc] init];
        contentDetailVC.contentId = commentId;
        contentDetailVC.disMissNavBlock = ^{
            self.myAppDelegate.navController.navigationBarHidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            
        };
        [self.myAppDelegate.navController pushViewController:contentDetailVC animated:YES];
        return NO;
    }else if ([urlString myContainsString:ACTION_TOOL]) {
        [self openToolWithUrlString:urlString];
        return NO;
    }
    
    if (navigationType != UIWebViewNavigationTypeLinkClicked) {
        
        return YES;
    }
    
    ADAdWebVC *webVc = [[ADAdWebVC alloc] init];
    webVc.adUrl = [NSString stringWithFormat:@"%@",request.URL];
    webVc.disMissNavBlock = ^{
        self.myAppDelegate.navController.navigationBarHidden = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
    };
    [self.myAppDelegate.navController pushViewController:webVc animated:YES];
    return NO;
    
}

- (void)openToolWithUrlString:(NSString *)urlString{
    
    NSString *toolId = [[urlString componentsSeparatedByString: ACTION_TOOL] lastObject];
    if([toolId isEqualToString:@"100099"]){
        ADPregNotifyViewController *aNotifyVc = [[ADPregNotifyViewController alloc]init];
        aNotifyVc.disMissNavBlock = ^{
            self.myAppDelegate.navController.navigationBarHidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            
        };
        [self.myAppDelegate.navController pushViewController:aNotifyVc animated:YES];
        return;
    }
    ADTool *aTool = [[ADTool alloc] initWithIoolId:toolId];
    if (aTool.isWeb == YES) {
        ADHtmlToolViewController *aHtmlToolVc = [[ADHtmlToolViewController alloc]init];
        aHtmlToolVc.vcName = aTool.title;
        aHtmlToolVc.disMissNavBlock = ^{
            self.myAppDelegate.navController.navigationBarHidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        };
        [self.myAppDelegate.navController pushViewController:aHtmlToolVc animated:YES];
    } else {
        ADToolRootViewController *aVc = [[NSClassFromString(aTool.myVc) alloc] init];
        aVc.vcName = aTool.title;
        aVc.disMissNavBlock = ^{
            self.myAppDelegate.navController.navigationBarHidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            
        };
        [self.myAppDelegate.navController pushViewController:aVc animated:YES];
    }
    
}


- (NSString *)getFileString{
    
    NSString *urlString = [[NSBundle mainBundle] pathForResource:@"firstentry" ofType:@"html" inDirectory:@"Html"];
    NSString *token = [[NSUserDefaults standardUserDefaults] addingToken];
    NSString *userStatus = [ADUserInfoSaveHelper readUserStatus];
    if ([userStatus isEqualToString:@"2"]) {
        NSString *birdthDay = [NSString stringWithFormat:@"%ld",(long)[[ADUserInfoSaveHelper readBabyBirthday] timeIntervalSince1970]];
        
        NSString *fileString = [NSString stringWithFormat:@"%@?oauth_token=%@&userStatus=%@&duedate=%@&birthdate=%@", urlString, token, userStatus,@"", birdthDay];
        return fileString;
    }
    
    NSString *dueDate = [NSString stringWithFormat:@"%ld",(long)[[ADUserInfoSaveHelper readDueDate] timeIntervalSince1970]];
    
    NSString *fileString = [NSString stringWithFormat:@"%@?oauth_token=%@&userStatus=%@&duedate=%@&birthdate=%@", urlString, token, userStatus, dueDate, @""];
    return fileString;
}

- (void)setRootVcDelay{
    
    [[ADChannelManager sharedManager]setCustomBar];
    [self performSelector:@selector(setRoot) withObject:nil afterDelay:0.5];
}

-(void)setRoot{
    
    [self.myAppDelegate.window setRootViewController:self.myAppDelegate.customTabBar];
}

- (void)setRootVc{
    
    [[ADChannelManager sharedManager]setCustomBar];
    [self.myAppDelegate.window setRootViewController:self.myAppDelegate.customTabBar];
}



@end
