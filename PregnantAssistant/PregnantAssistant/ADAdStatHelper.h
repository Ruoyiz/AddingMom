//
//  ADAdStatHelper.h
//  PregnantAssistant
//
//  Created by D on 15/3/4.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADadConfig.h"
#import "ADStatUserBaseInfo.h"
#import "ADAppDelegate.h"

@interface ADAdStatHelper : NSObject

@property (nonatomic, retain) ADAppDelegate *myDelegate;
@property (nonatomic, copy) NSString *Idfv;
@property (nonatomic, copy) NSString *UIdenc;

+ (ADAdStatHelper *)shareInstance;

// 广告位展现
- (void)showAdOnChannel:(NSString *)aCid atPos:(NSString *)aPosInx;
// 广告展现
//- (void)sendAdShowWithCid:(NSString *)aCid andPositionIndex:(NSString *)aPosInx andAdId:(NSString *)aAdId;
// 广告点击
//- (void)sendAdClickWithCid:(NSString *)aCid andPositionIndex:(NSString *)aPosInx andAdId:(NSString *)aAdId;
// 广告访问
- (void)sendAdReadWithCid:(NSString *)aCid andPositionIndex:(NSString *)aPosInx andAdId:(NSString *)aAdId;

// 内容点击
- (void)clickContentOnChannelId:(NSString *)aCid andPosIndex:(NSString *)aPosInx andContentId:(NSString *)aContentId;
// 内容浏览
- (void)sendContentReadWithCid:(NSString *)aCid andPositionIndex:(NSString *)aPosInx andContentId:(NSString *)aContentId;

// 收藏文章
- (void)sendContentCollectWithCid:(NSString *)aCid andPositionIndex:(NSString *)aPosInx andContentId:(NSString *)aContentId;

// 取消收藏
- (void)sendContentCancelCollectingWithCid:(NSString *)aCid andPositionIndex:(NSString *)aPosInx andContentId:(NSString *)aContentId;

// 文章分享
- (void)sendContentShareWithCid:(NSString *)aCid andPositionIndex:(NSString *)aPosInx andContentId:(NSString *)aContentId shareTo:(NSString *)shareTarget;

@end
