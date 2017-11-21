//
//  ADPushManager.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/15.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADPushManager.h"
#import "ADMomLookContentDetailVC.h"
//#import "ADMomLookVideoDetailVc.h"
#import "ADAdWebVC.h"
#import "ADStoryDetailViewController.h"

#define SecPushTag 100

#define LookPushTag 200

@implementation ADPushManager{
    //NSString *_contentId;
}

static ADPushManager *sharedPushManager = nil;

+ (ADPushManager *)shareManager {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedPushManager = [[ADPushManager alloc] init];
    });
    
    return sharedPushManager;
}

- (void)getPushMessageWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary* pushNotificationKey = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"启动获得的推送消息：%@",pushNotificationKey);
    if (pushNotificationKey) {
        ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
        myApp.pushNotificationKey = pushNotificationKey;
        [self analysisRemoteNotification];
    }
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    myApp.pushNotificationKey = userInfo;
    
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"活跃状态接收的推送消息： %@",userInfo);
        NSDictionary *dic = [userInfo objectForKey:@"aps"];
        NSString *alertMessage = [dic objectForKey:@"alert"];
        NSString *alertTitle = nil;
        NSString *type = [userInfo objectForKey:@"type"];
        if (type && [type isEqualToString:@"protocol"]) {
            NSString *protocolContent = userInfo[@"protocol"];
            if ([protocolContent myContainsString:@"adco/content"]) {
                alertTitle = @"资讯推荐";
            }else if ([protocolContent myContainsString:@"adco/video"]){
                alertTitle = @"视频推荐";
            }else if ([protocolContent myContainsString:@"adco/webview"]){
                alertTitle = @"资讯推荐";
            }
        }
        
        UIAlertView  *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"查看", nil];
        [alertView show];
        
    }else{
        
        [self performSelector:@selector(analysisRemoteNotification) withObject:nil afterDelay:1];
    }
}

- (void)analysisRemoteNotification
{
    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *pushNotificationKey = myApp.pushNotificationKey;
    NSLog(@"%@",pushNotificationKey);
    if (pushNotificationKey) {
        NSString  *allUrl = pushNotificationKey[@"type"];
        
        if ([allUrl isEqualToString:@"protocol"]) {

            NSString *protocolContent = pushNotificationKey[@"protocol"];
            //                NSLog(@"proContent:%@", _protocolContent);
            
            if ([protocolContent myContainsString:@"content/messageContent"]) {
                //跳转 暖心时刻 废弃
            } else if ([protocolContent myContainsString:@"lfm"]) {
                [self judgeUrlAndJumpToDetailStoryVc];
            } else if ([protocolContent myContainsString:@"adco/content"]) {
                NSRange rangeOne = [protocolContent rangeOfString:@"contentId="];
                NSRange range = NSMakeRange(rangeOne.length+rangeOne.location,
                                            protocolContent.length-(rangeOne.length+rangeOne.location));
                NSString *codeString = [protocolContent substringWithRange:range];
                //                    NSLog(@"code: %@",codeString);
                [self jumpToContentVcWithCid:codeString];
            } else if ([protocolContent myContainsString:@"adco/video"]) {
                NSRange rangeOne = [protocolContent rangeOfString:@"wid="];
                NSRange range = NSMakeRange(rangeOne.length+rangeOne.location,
                                            protocolContent.length-(rangeOne.length+rangeOne.location));
                NSString *codeString = [protocolContent substringWithRange:range];
                //                    NSLog(@"finish code: %@",codeString);
                [self jumpToVideoVcWithWid:codeString];
            } else if ([protocolContent myContainsString:@"adco/webview"]) {
                NSRange rangeOne = [protocolContent rangeOfString:@"url="];
                NSRange range = NSMakeRange(rangeOne.length+rangeOne.location,
                                            protocolContent.length-(rangeOne.length+rangeOne.location));
                NSString *codeString = [protocolContent substringWithRange:range];
                //                    NSLog(@"code: %@",codeString);
                [self jumpToWebViewWithUrl:codeString];
            }else if ([protocolContent myContainsString:@"adm"]){
                
                NSString *contentId = [[protocolContent componentsSeparatedByString:@"pi="] lastObject];
                [self performSelector:@selector(jumpToContentVcWithCid:) withObject:contentId afterDelay:1.5];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self analysisRemoteNotification];
    }
}


#pragma mark --- 分界线
- (void)jumpToContentVcWithCid:(NSString *)aCid
{
    [MobClick event:push_adco_content_normal_click];
    ADMomLookContentDetailVC *aDetialVc = [[ADMomLookContentDetailVC alloc]init];
    aDetialVc.contentId = aCid;
    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    [myApp.customTabBar setSelectedIndex:0];
    [myApp.customTabBar.viewControllers[0] pushViewController:aDetialVc animated:YES];
}

- (void)jumpToVideoVcWithWid:(NSString *)aWid
{
//    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
//
//    ADMomLookVideoDetailVc *aVideoVc = [[ADMomLookVideoDetailVc alloc]init];
//    aVideoVc.videoWid = aWid;
//    [myApp.customTabBar setSelectedIndex:0];
//    
//    //    [_customTabBar.viewControllers[0] popToRootViewControllerAnimated:NO];
//    [myApp.customTabBar.viewControllers[0] pushViewController:aVideoVc animated:YES];
}

- (void)jumpToWebViewWithUrl:(NSString *)aUrl
{
    [MobClick event:push_adco_content_normal_click];

    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];

    ADAdWebVC *aWebVc = [[ADAdWebVC alloc]init];
    aWebVc.adUrl = aUrl;
    //    [self.navController pushViewController:aWebVc animated:YES];
    [myApp.customTabBar setSelectedIndex:0];
    
    //    [_customTabBar.viewControllers[0] popToRootViewControllerAnimated:NO];
    [myApp.customTabBar.viewControllers[0] pushViewController:aWebVc animated:YES];
}

- (void)judgeUrlAndJumpToDetailStoryVc
{
    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *pushNotificationKey = myApp.pushNotificationKey;
    NSString *protocolContent = pushNotificationKey[@"protocol"];

    NSRange rangeOne = [protocolContent rangeOfString:@"t="];
    NSRange range =
    NSMakeRange(rangeOne.length + rangeOne.location, 1);
    NSString *type = [protocolContent substringWithRange:range];
    
    NSRange rangeTwo = [protocolContent rangeOfString:@"pi="];
    NSRange range2 =
    NSMakeRange(rangeTwo.length + rangeTwo.location, protocolContent.length - (rangeTwo.length + rangeTwo.location));
    NSString *postIdStr = [protocolContent substringWithRange:range2];
    
    if ([type isEqualToString:@"100"]) {
        [MobClick event:Jump_secret_PA];
    } else {
        [MobClick event:Jump_secret_User];
    }
    
    if ([type isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:haveSomeOneLikeSecretNotification
                                                            object:nil
                                                          userInfo:nil];
        
        [self jumpToStoryDetailWithPostId:postIdStr andSrollToBottom:YES];
    } else {
        [self jumpToStoryDetailWithPostId:postIdStr andSrollToBottom:NO];
    }
}

- (void)jumpToStoryDetailWithPostId:(NSString *)aId andSrollToBottom:(BOOL)scrollToBottom
{
    //    self.navController.navigationItem.rightBarButtonItem = nil;
    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];

    ADStoryDetailViewController *aStory = [[ADStoryDetailViewController alloc]init];
    aStory.postId = aId.intValue;
    aStory.scrollBottom = scrollToBottom;
    
    [myApp.customTabBar setSelectedIndex:2];
    
    [myApp.customTabBar.viewControllers[2] pushViewController:aStory animated:YES];
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

@end
