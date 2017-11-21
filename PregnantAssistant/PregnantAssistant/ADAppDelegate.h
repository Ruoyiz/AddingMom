//
//  ADAppDelegate.h
//  PregnantAssistant
//
//  Created by D on 14-9-15.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "ADUserLoction.h"
#import "SVProgressHUD.h"
#import "ADToastHelp.h"
#import "TalkingData.h"

@class ADLoginControl;

typedef enum {
    weiboShare = 2,
    weixinShare = 3
} SharedType;

//no longer use
typedef enum {
    ADLaunchTypeDuringPregnancy = -1, //孕期模式
    ADLaunchTypeDuringParenting,      //育儿模式
} ADLaunchType;

typedef enum {
    ADBabySexNotSelected = 0,
    ADBabySexBoy,
    ADBabySexGirl,
} ADBabySex;

@interface ADAppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate, WeiboSDKDelegate,UITabBarControllerDelegate,UIWebViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *customTabBar;
@property (strong, nonatomic) UINavigationController *navController;

//预产期
@property (strong, nonatomic) NSDate *dueDate;

@property (strong, nonatomic) NSDate *babyBirthday;

@property (nonatomic,assign) NSInteger babySex;
@property (nonatomic,strong) NSString *userStatus;
@property (strong, nonatomic) NSDate *displayDate;

@property (strong, nonatomic) NSDate *cntDisplayDate;

@property (copy, nonatomic) NSString *wbtoken;

@property (assign, nonatomic) SharedType aShareType;

@property (copy, nonatomic) NSString *deviceToken;
@property (copy, nonatomic) NSString *addingToken;

@property (nonatomic,strong) NSDictionary *pushNotificationKey;

@property (assign, nonatomic) int unReadSecretNum;

@property (assign, nonatomic) float autoSizeScaleX;
@property (assign, nonatomic) float autoSizeScaleY;

@property (assign, nonatomic) NSInteger momLookNewNum;

@property (nonatomic,assign) NSInteger secretBadgeUpdateNumber;
@property (nonatomic, assign) NSInteger notiBadgeUpdateNumber;

@property (nonatomic, assign) BOOL changeLaunchBadgeUpdate;
@property (nonatomic, retain) NSTimer *checkSyncTimer;

@property (nonatomic, assign) BOOL isUploadingImg;

@property (nonatomic,strong) ADLoginControl *loginControl;

@property (nonatomic,strong) NSDictionary *noticeDic;

@property (nonatomic,assign) BOOL isSharing;
@property (nonatomic, assign)BOOL skiped;//防止多次加载rootVC

- (void)setupBabySex:(NSInteger)babySex;
- (void)updateBadgeNum;

@end