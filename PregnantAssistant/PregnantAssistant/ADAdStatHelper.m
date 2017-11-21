
//
//  ADAdStatHelper.m
//  PregnantAssistant
//
//  Created by D on 15/3/4.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADAdStatHelper.h"
#import "ADHelper.h"
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"

@implementation ADAdStatHelper

+ (ADAdStatHelper *)shareInstance {
    
    static dispatch_once_t onceToken;
    static ADAdStatHelper *sharedClient = nil;

    dispatch_once(&onceToken, ^{
        sharedClient = [[ADAdStatHelper alloc] init];
        sharedClient.myDelegate = APP_DELEGATE;
    });
    
    return sharedClient;
}

- (void)sendRequstWithParam:(NSDictionary *)aParam
{
    ADBaseRequest *manager = [ADBaseRequest shareInstance];

//   NSLog(@"统计事件%@,参数：%@",manager.requestSerializer.HTTPRequestHeaders,aParam);
    [manager POST:@"http://stat.ad.addinghome.com/s.gif" parameters:aParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
         }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

// 广告位展现
- (void)showAdOnChannel:(NSString *)aCid atPos:(NSString *)aPosInx
{
    [self getBaseInfoDicWithEvent:@"adpDisplay" onFinish:^(NSMutableDictionary *param) {
        [param setObject:aCid forKey:@"cid"];
        if (aPosInx) {
            [param setObject:aPosInx forKey:@"positionIndex"];
        }
        [self sendRequstWithParam:param];
    }];
}

// 广告展现
- (void)sendAdShowWithCid:(NSString *)aCid andPositionIndex:(NSString *)aPosInx andAdId:(NSString *)aAdId
{
    [self getBaseInfoDicWithEvent:@"adDisplay" onFinish:^(NSMutableDictionary *param) {
        [param setObject:aCid forKey:@"cid"];
        if (aPosInx) {
            [param setObject:aPosInx forKey:@"positionIndex"];
        }
        if (!([aAdId isEqual:[NSNull null]] || aAdId == nil)) {
            [param setObject:aAdId forKey:@"adId"];
        }
        [self sendRequstWithParam:param];
    }];
}

// 广告点击
- (void)sendAdClickWithCid:(NSString *)aCid andPositionIndex:(NSString *)aPosInx andAdId:(NSString *)aAdId
{
    [self getBaseInfoDicWithEvent:@"adClick"
                         onFinish:^(NSMutableDictionary *param) {
         
                             [param setObject:aCid forKey:@"cid"];
                             if (aPosInx) {
                                 [param setObject:aPosInx forKey:@"positionIndex"];
                             }
         
                             [param setObject:aAdId forKey:@"adId"];
         
        
                             [self sendRequstWithParam:param];
     }];
}

// 广告访问
- (void)sendAdReadWithCid:(NSString *)aCid andPositionIndex:(NSString *)aPosInx andAdId:(NSString *)aAdId
{
    [self getBaseInfoDicWithEvent:@"adAction"
                         onFinish:^(NSMutableDictionary *param) {
                             [param setObject:aCid forKey:@"cid"];
                             if (aPosInx) {
                                 [param setObject:aPosInx forKey:@"positionIndex"];
                             }
                             [param setObject:aAdId forKey:@"adId"];
                             
                             [self sendRequstWithParam:param];
                         }];
}

// 内容点击
- (void)clickContentOnChannelId:(NSString *)aCid
                    andPosIndex:(NSString *)aPosInx
                   andContentId:(NSString *)aContentId
{
    [self getBaseInfoDicWithEvent:@"contentClick"
                         onFinish:^(NSMutableDictionary *param) {
                             [param setObject:aCid forKey:@"cid"];
                             if (aPosInx) {
                                 [param setObject:aPosInx forKey:@"positionIndex"];
                             }
                             [param setObject:aContentId forKey:@"contentId"];
                             
                             [self sendRequstWithParam:param];
                         }];
}

// 内容浏览
- (void)sendContentReadWithCid:(NSString *)aCid
              andPositionIndex:(NSString *)aPosInx
                  andContentId:(NSString *)aContentId
{
    
    [self getBaseInfoDicWithEvent:@"contentView"
                         onFinish:^(NSMutableDictionary *param) {
                             [param setObject:aCid forKey:@"cid"];
                             if (aPosInx) {
                                 [param setObject:aPosInx forKey:@"positionIndex"];
                             }
                             [param setObject:aContentId forKey:@"contentId"];
                             
                             [self sendRequstWithParam:param];
                         }];
}

- (void)getBaseInfoDicWithEvent:(NSString *)aEvent
                       onFinish:(void (^)(NSMutableDictionary *))aFinishBlock
{
    NSMutableDictionary *baseInfoDic = [[NSMutableDictionary alloc]initWithCapacity:0];

    [baseInfoDic setObject:@"1" forKey:@"pid"];  // pid
    [baseInfoDic setObject:aEvent forKey:@"e"]; //event
    [baseInfoDic setObject:@"mobile" forKey:@"ot"]; // osType
    [baseInfoDic setObject:@"iOS" forKey:@"ost"]; // osSubType
    
    ADAppDelegate *appDelegate = APP_DELEGATE;
//    NSLog(@"status: %@", appDelegate.userStatus);
    
    [baseInfoDic setObject:appDelegate.userStatus forKey:@"userStatus"];
    if ([appDelegate.userStatus isEqualToString:@"1"]) {
        NSString *duedateStr = [NSString stringWithFormat:@"%ld", (long)[[ADHelper getDueDate] timeIntervalSince1970]];
        [baseInfoDic setObject:duedateStr forKey:@"duedate"];
    } else {
        NSTimeInterval interval = [appDelegate.babyBirthday timeIntervalSince1970];
        [baseInfoDic setObject:[NSString stringWithFormat:@"%ld",(long)interval] forKey:@"birthdate"];
    }
    
    [baseInfoDic setObject:[[UIDevice currentDevice] systemVersion] forKey:@"ov"]; // osSubTypeVersion ios 8 7
    [baseInfoDic setObject:[ADHelper getVersion] forKey:@"av"]; // appVersion
    
    ADLocationManager *locManager = [ADLocationManager shareLocationManager];
    [locManager getUserLocationOnFinish:^{
        if (locManager.location.province.length > 0) {
            [baseInfoDic setObject:locManager.location.province forKey:@"pr"]; // province
            [baseInfoDic setObject:locManager.location.city forKey:@"ci"]; // city
        } else {
            [baseInfoDic setObject:@"" forKey:@"pr"]; // province
            [baseInfoDic setObject:@"" forKey:@"ci"]; // city
        }
        
        if (aFinishBlock) {
            aFinishBlock(baseInfoDic);
        }
    }];
}

//统计收藏文章
- (void)sendContentCollectWithCid:(NSString *)aCid andPositionIndex:(NSString *)aPosInx andContentId:(NSString *)aContentId
{
    [self getBaseInfoDicWithEvent:@"contentCollect" onFinish:^(NSMutableDictionary *param) {
        if(aCid){
            [param setObject:aCid forKey:@"cid"];
        }
        if (aPosInx) {
            [param setObject:aPosInx forKey:@"positionIndex"];
            
        }
        
        if (aContentId) {
            [param setObject:aContentId forKey:@"contentId"];
        }
        
        [self sendRequstWithParam:param];
    }];
}

//统计取消收藏
- (void)sendContentCancelCollectingWithCid:(NSString *)aCid andPositionIndex:(NSString *)aPosInx andContentId:(NSString *)aContentId
{
    [self getBaseInfoDicWithEvent:@"contentCancelCollecting" onFinish:^(NSMutableDictionary *param) {
//        [param setObject:aCid forKey:@"cid"];
//        [param setObject:aPosInx forKey:@"positionIndex"];
//        [param setObject:aContentId forKey:@"contentId"];
        if(aCid){
            [param setObject:aCid forKey:@"cid"];
        }
        if (aPosInx) {
            [param setObject:aPosInx forKey:@"positionIndex"];
            
        }
        
        if (aContentId) {
            [param setObject:aContentId forKey:@"contentId"];
        }
        
        [self sendRequstWithParam:param];
    }];
}


//统计文章分享
- (void)sendContentShareWithCid:(NSString *)aCid andPositionIndex:(NSString *)aPosInx andContentId:(NSString *)aContentId shareTo:(NSString *)shareTarget
{
    [self getBaseInfoDicWithEvent:@"contentShare" onFinish:^(NSMutableDictionary *param) {
        
        if(aCid){
            [param setObject:aCid forKey:@"cid"];
        }
        if (aPosInx) {
            [param setObject:aPosInx forKey:@"positionIndex"];

        }
        
        if (aContentId) {
            [param setObject:aContentId forKey:@"contentId"];
        }
        
        if (shareTarget) {
            [param setObject:shareTarget forKey:@"shareTarget"];
        }
        
        NSLog(@"%@",param);
        [self sendRequstWithParam:param];
    }];
}

@end
