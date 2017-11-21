//
//  ADFeedNetworkHelper.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/19.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADFeedNetworkHelper : NSObject

@property (nonatomic, strong) AFHTTPRequestOperation *httpOperation;

+ (ADFeedNetworkHelper *)shareManager;

//获取用户订阅媒体列表
+ (void)getFeedArticlListWithStart:(NSString *)start size:(NSString *)size CompliteBlock:(void(^)(NSArray *resArray,BOOL iscomplite))complite failure:(void(^)(NSError *error))failure;
//获取媒体文章列表
+ (void)getFeedContentListWithStart:(NSString *)start size:(NSString *)size mediaID:(NSString *)mediaID compliteBlock:(void(^)(NSArray *resArray,BOOL iscomplite))complite  failure:(void(^)(NSError *errer))failure;
//搜索结果
+ (void)getFeedSearchMediaWithKeyword:(NSString *)keyword start:(NSString *)start size:(NSString *)size compliteBlock:(void(^)(NSArray *resArray,BOOL iscomplite))complite failure:(void(^)(NSError *error))failure;
// 加丁号媒体好信息
+ (void)getFeedMediaModelWithMediaId:(NSString *)mediaId compliteBlock:(void(^)(NSDictionary *resDict))complite failure:(void(^)(NSError *error))failure;
//增加取消订阅
- (void)subscribeFeedMediaWIthMediaId:(NSString *)mediaId compliteBlock:(void(^)(BOOL isSubcribe))complite;
- (void)desSubscribeFeedMediaWIthMediaId:(NSString *)mediaId compliteBlock:(void(^)(BOOL desSubcribe))complite;
- (void)cancelOperationsRequest;
@end
