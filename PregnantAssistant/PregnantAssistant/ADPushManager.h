//
//  ADPushManager.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/15.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADPushManager : NSObject<UIAlertViewDelegate>

+ (ADPushManager *)shareManager;

- (void)getPushMessageWithOptions:(NSDictionary *)launchOptions;

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo;

- (void)registerPush;

- (void)registerPushForIOS8;

@end
