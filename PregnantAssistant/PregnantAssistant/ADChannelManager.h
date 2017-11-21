//
//  ADChannelManager.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/22.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADChannelManager : NSObject <UITabBarControllerDelegate>

+ (ADChannelManager *)sharedManager;

- (void)setCustomBar;

//- (void)resetViewControllersSuccess:(void (^) (void))success failure:(void (^)(void))failure;

////更改看看的频道
//- (void)changeMomLookChannels;
//
//- (void)getMomLookBadgeNum;
//- (void)getChannelIds;

@end
