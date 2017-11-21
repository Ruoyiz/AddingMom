//
//  ADAppDelegate.m
//  PregnantAssistant
//
//  Created by D on 14-9-15.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADAppDelegate.h"
#import "UMFeedback.h"
#import "XGPush.h"
#import "XGSetting.h"
#import "NSURL+Parameters.h"
#import "NSString+Contains.h"
#import "ADMomLookNetwork.h"
#import "RNCachingURLProtocol.h"
#import "JRSwizzle.h"
#import "NSArray+ADSafeCategory.h"
#import "NSMutableArray+ADSafeCategory.h"
#import "NSMutableURLRequest+ADUrlRequest.h"
#import "UITabBar+ADBadge.h"
#import "ADUserInfoSaveHelper.h"
#import "ADBaseDataSyncHelper.h"
#import "NSTimer+Pausing.h"
#import "ADPushManager.h"
#import "ADChannelManager.h"
#import "ADUserSyncMetaHelper.h"
#import "ADLoginNetWork.h"
#import "PregnantAssistant-Swift.h"
#import "ADLoginControl.h"
#import "ThirdPartyDefine.h"
#import "LXMThirdLoginManager.h"
#import "ADRootVCManager.h"
#import "ADDataDistributor.h"
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <AdSupport/AdSupport.h>

static NSString *validKey = @"LASTVALIDKEY";

#define checkSyncTime 60 * 30

@implementation ADAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initAppApperance];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];

    if(SCREEN_HEIGHT > 480){
        _autoSizeScaleX = SCREEN_WIDTH/320;
        _autoSizeScaleY = SCREEN_HEIGHT/568;
    } else {
        _autoSizeScaleX = 1.0;
        _autoSizeScaleY = 1.0;
    }
    
    [RLMRealm setSchemaVersion:8
                forRealmAtPath:[RLMRealm defaultRealmPath]
            withMigrationBlock:^(RLMMigration *migration, uint64_t oldSchemaVersion) {
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 8) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            }];
    
    // now that we have called `setSchemaVersion:withMigrationBlock:`, opening an outdated
    // Realm will automatically perform the migration and opening the Realm will succeed
    [RLMRealm defaultRealm];

    
    //启动动画设置根视图
    if (!self.skiped) {
        [[ADRootVCManager sharedManager] showSplash];
    }
    
    [self updateOldDateToNew];
    
    [ADDataDistributor shareInstance];
    self.deviceToken = [[NSUserDefaults standardUserDefaults] xgDeviceToken];

    //添加本地通知，每天早上出一个小红点
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil)
    {
        notification.fireDate = [ADHelper badgeDate];
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    [[[NSArray array] class] jr_swizzleMethod:@selector(objectAtIndex:)
                                   withMethod:@selector(TKSafe_objectAtIndex:)
                                        error:nil];
    
    [[[NSMutableArray array] class] jr_swizzleMethod:@selector(objectAtIndex:)
                                          withMethod:@selector(TKSafe_objectAtIndex:)
                                               error:nil];
    
    
    //角标清0
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    
    [XGPush startApp:2200054655 appKey:@"I575NVX4I7PT"];
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(sysVer < 8) {
        [[ADPushManager shareManager] registerPush];
    } else {
        [[ADPushManager shareManager] registerPushForIOS8];
    }
    
    [MobClick startWithAppkey:umAppKey reportPolicy:REALTIME channelId:@""];
    
    [TalkingData sessionStarted:TalkingDataAppId withChannelId:nil];
    
    [[LXMThirdLoginManager sharedManager] setupWithSinaWeiboAppKey:kSinaWeiboAppKey SinaWeiboRedirectURI:kSinaWeiboRedirectURI WeChatAppKey:kWeChatAppKey WeChatAppSecret:kWeChatAppSecret QQAppKey:@""];
    
    [UMFeedback setAppkey:umAppKey];
    
    
    //添加userAgent
    [ADHelper addUseragent];

    if (launchOptions) {
        
        [[ADRootVCManager sharedManager] webSkipAction];
        [[ADPushManager shareManager] getPushMessageWithOptions:launchOptions];
    }

    [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(updateBadgeNum) userInfo:nil repeats:YES];
    
    //每30min检查 同步数据
    [[NSUserDefaults standardUserDefaults]setCheckSyncDate:[NSDate date]];
    _checkSyncTimer = [NSTimer scheduledTimerWithTimeInterval:checkSyncTime
                                                       target:self
                                                     selector:@selector(syncData)
                                                     userInfo:nil
                                                      repeats:YES];

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(loginWeiSucess:)
                                                name:distrubeDataToUserNotification
                                              object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeTabBadge) name:removeMomLookTitleAllDotNotification object:nil];
    
    self.userStatus = [ADUserInfoSaveHelper readUserStatus];
    self.babyBirthday = [ADUserInfoSaveHelper readBabyBirthday];
    self.dueDate = [ADUserInfoSaveHelper readDueDate];
    
    NSLog(@".......%@",self.deviceToken);
    
    NSString * appKey = @"545064cefd98c508f500e269";
    NSString * deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * mac = [self macString];
    NSString * idfa = [self idfaString];
    NSString * idfv = [self idfvString];
    NSString * urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&mac=%@&idfa=%@&idfv=%@", appKey, deviceName, mac, idfa, idfv];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlString]] delegate:nil];

    
    return YES;
}

- (void)updateOldDateToNew
{
    [self updateUserStatus];
    [self updateDueDate];
    [self updateBabyBirthDay];
//    _babySex = [self babySex];
}

- (void)loginWeiSucess:(NSNotification *)notification
{
    NSString *tStr = [[NSUserDefaults standardUserDefaults]addingToken];
    
    self.deviceToken = [[NSUserDefaults standardUserDefaults]xgDeviceToken];
    if (self.deviceToken.length > 0) {
        [[ADMomSecertNetworkHelper shareInstance]regDeviceWithOAuth:tStr
                                                     andDeviceToken:self.deviceToken];
    }
}

#pragma mark - Get Red Dot Methods
- (void)updateBadgeNum
{
    if(![self.window.rootViewController isKindOfClass:[UITabBarController class]]){
        
        NSLog(@"无法获取红点");
        return;
    }
    [[ADMomSecertNetworkHelper shareInstance] getBadgeNumWithResult:^(int result) {
        if (result > 0) {
            if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
                UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
                [tabVC.tabBar showBadgeOnItemIndex:tabVC.viewControllers.count - 1];
                self.notiBadgeUpdateNumber = result;
                //向 more 页发送通知          
                [[NSNotificationCenter defaultCenter] postNotificationName:notiNumChangedNotification object:nil];
            }            
        }
    }];
    [[ADMomSecertNetworkHelper shareInstance] getSecertBadgeNumwithResult:^(int result) {
        if (result > 0) {
            if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
                UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
                [tabVC.tabBar showBadgeOnItemIndex:tabVC.viewControllers.count - 1];
                self.secretBadgeUpdateNumber = result;
                //向 more 页发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:secretNumChangedNotification object:nil];
            }
        }
    }];
    
    
    [ADMomLookNetwork getMomLookBadgeNumWithChannels:@[@"1", @"7"]
                                        channelTimes:@[[[NSUserDefaults standardUserDefaults]momLookListRequestTime],
                                                       [[NSUserDefaults standardUserDefaults]momLookFeedListRequestTime]]
                                            onFinish:^(NSMutableArray *resArray) {
                                                NSLog(@"dot res: %@", resArray);
                                                NSString *cnt1 = resArray[0];
                                                if (cnt1.intValue > 0) {
                                                    [[NSNotificationCenter defaultCenter]postNotificationName:addMomLookTitleDot1Notification object:nil];
                                                }
                                                //[[NSNotificationCenter defaultCenter]postNotificationName:addMomLookTitleDot1Notification object:nil];

                                                NSString *cnt2 = resArray[1];
                                                if (cnt2.intValue > 0) {
                                                     [[NSNotificationCenter defaultCenter]postNotificationName:addMomLookTitleDot2Notification object:nil];
                                                }

                                                //[[NSNotificationCenter defaultCenter]postNotificationName:addMomLookTitleDot2Notification object:nil];

                                                if (cnt1.intValue > 0 || cnt2.intValue > 0) {
                                                    UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
                                                    [tabVC.tabBar showBadgeOnItemIndex:0];
                                                }
    }];
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{
//    NSLog(@"alarm in");
//    NSLog(@"notif:%@", notif);
}

- (void)removeTabBadge
{
    UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
    [tabVC.tabBar removeBadgeOnItemIndex:0];
}

- (void)setupBabySex:(NSInteger)babySex
{
    self.babySex = babySex;
    
    if ([[NSUserDefaults standardUserDefaults] babySex] > 0) {
        //迁移2.2之前版本的数据(不包括2.2)
        NSLog(@"删除老版本数据 babySex");
        [[NSUserDefaults standardUserDefaults] setBabySex:0];
    }
    [ADUserInfoSaveHelper saveBabaySex:babySex];
}

- (void)updateDueDate
{
    if ([[NSUserDefaults standardUserDefaults] dueDate]) {
        //迁移2.2之前版本的数据 （不包括2.2）
        NSDate *date = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]dueDate]];
        
        NSLog(@"迁移老版本数据 dueDate %@", date);
//        self.dueDate = date;
        [ADUserInfoSaveHelper saveDueDate:date];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:dueDateKey];
    }
}

- (void)updateUserStatus
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:appLaunchType]) {
        
        if ([[NSUserDefaults standardUserDefaults] launchType] == ADLaunchTypeDuringPregnancy) {
//            self.userStatus = @"1";
            [ADUserInfoSaveHelper saveUserStatus:@"1"];
        }else{
            [ADUserInfoSaveHelper saveUserStatus:@"2"];
//            self.userStatu｀s = @"2";
        }
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:appLaunchType];
    }
    
//    NSLog(@"更新后用户状态 %@",self.userStatus);
}

//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"touchStatusBarClick" object:nil];
//}

//- (NSDate *)dueDate
//{
//    return [ADUserInfoSaveHelper readDueDate];
//}

//- (void)setDueDate:(NSDate *)dueDate
//{
//    NSLog(@"保存预产期 %@",dueDate);
//    [ADUserInfoSaveHelper saveDueDate:dueDate];
//}

- (void)updateBabyBirthDay
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:birthdateKey]) {
        //迁移2.2之前版本的数据
        NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:birthdateKey];
        NSLog(@"迁移老版本数据 babyBirthday");
//        self.babyBirthday = date;
        [ADUserInfoSaveHelper saveBabayBirthday:date];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:birthdateKey];
    }
}

- (void)setBabySex:(NSInteger)babySex
{
    [ADUserInfoSaveHelper saveBabaySex:babySex];
}

- (NSInteger)babySex
{
    if ([[NSUserDefaults standardUserDefaults] babySex] > 0) {
        //迁移2.2之前版本的数据
        ADBabySex babaySex = [[NSUserDefaults standardUserDefaults] babySex];
        NSLog(@"迁移老版本数据 babySex");
        [self setupBabySex:babaySex];
        
        [[NSUserDefaults standardUserDefaults] setBabySex:0];
    }
    
    return [ADUserInfoSaveHelper readBabySex];
}

- (void)initAppApperance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [ADAppearance initAppAppearance];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
//    NSLog(@"xg token: %@", deviceTokenStr);
    self.deviceToken = deviceTokenStr;
    
    NSString *tStr = [[NSUserDefaults standardUserDefaults] addingToken];

    if (self.deviceToken.length > 0 && ![tStr isEqualToString:@"0"]) {
        [[ADMomSecertNetworkHelper shareInstance]regDeviceWithOAuth:tStr
                                                     andDeviceToken:self.deviceToken];
    }

    [[NSUserDefaults standardUserDefaults]setXgDeviceToken:deviceTokenStr];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册推送失败 %@",error);
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
        
    }
    else if ([identifier isEqualToString:@"answerAction"]){
        
    }
}
#endif

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        NSString *uid = [(WBAuthorizeResponse *)response userID];
        
        if(self.wbtoken){
            [ADLoginNetWork getWeiboUserInfoWithToken:self.wbtoken weiboUid:uid loginControl:self.loginControl];
        }else{
            [ADToastHelp showSVProgressToastWithError:@"获取授权失败"];
        }
        
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    [[ADRootVCManager sharedManager] webSkipAction];
    [[ADPushManager shareManager] application:application didReceiveRemoteNotification:userInfo];
    [XGPush handleReceiveNotification:userInfo];
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    // Check the calling application Bundle ID
//    if ([sourceApplication isEqualToString:@"com.addinghome.pregnantAssitant"])
//    {
//        NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
//        NSLog(@"URL scheme:%@", [url scheme]);
//        NSLog(@"URL query: %@", [url query]);
//        
//        return YES;
//    }
//    else
//        return NO; 
//}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[ADRootVCManager sharedManager] webSkipAction];
    return [[LXMThirdLoginManager sharedManager] handleOpenUrl:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation
{
    NSLog(@"启动 url: %@", url.absoluteString);

    [[ADRootVCManager sharedManager] webSkipAction];
    
    //跳转到订阅号详情页
    if ([url.absoluteString myContainsString:@"mediaOpen"]) {
        NSString *mediaId = [[url.absoluteString componentsSeparatedByString:@"mediaId="] lastObject];
        [self openMediaWithId:mediaId];
        return YES;
    }else if([url.absoluteString myContainsString:@"adding://adco/content?contentId="]){
        
        NSString *contentId = [[url.absoluteString componentsSeparatedByString:@"contentId="] lastObject];
        [self openContentWithContentId:contentId];
        return YES;
    }
    
    return [[LXMThirdLoginManager sharedManager] handleOpenUrl:url];
}

- (void)openMediaWithId:(NSString *)mediaId
{
    ADFeedDetailsViewController *aVc = [[ADFeedDetailsViewController alloc]init];
    aVc.mediaId = mediaId;
    ADAppDelegate *myApp = APP_DELEGATE;
    if (myApp.customTabBar) {
        [myApp.customTabBar setSelectedIndex:0];
        [myApp.customTabBar.viewControllers[0] pushViewController:aVc animated:YES];
    }
}

- (void)openContentWithContentId:(NSString *)contentId
{
    ADMomLookContentDetailVC *dvc = [[ADMomLookContentDetailVC alloc] init];
    dvc.contentId = contentId;
    ADAppDelegate *myApp = APP_DELEGATE;
    if (myApp.customTabBar) {
        [myApp.customTabBar setSelectedIndex:0];
        [myApp.customTabBar.viewControllers[0] pushViewController:dvc animated:YES];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //从后台或锁屏重新进入程序
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark - sync method
//超过30min 检查数据
- (void)syncData
{
    //登陆
    NSString *tStr = [[NSUserDefaults standardUserDefaults] addingToken];
    if (tStr.length > 0) {
        [ADBaseDataSyncHelper syncAllData];
    }
}

////for mac
//#include
//#include
//#include
//#include
//
////for idfa
//#import

- (NSString * )macString{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}

- (NSString *)idfaString {
    
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            
            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

- (NSString *)idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector( identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}


@end