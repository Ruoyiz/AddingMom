//
//  ADMomLookNetwork.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/15.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADMomLookNetwork : NSObject

//获取频道列表
+ (void)getChannelListSuccess:(void (^) (id responseObject))success failure:(void (^) (NSString * errorMessage))failure;

//获取feed列表
+ (void)getFeedListWithChannelId:(NSInteger)channelId startPos:(NSInteger)startPos length:(NSInteger)length contentId:(NSString *)contentId succsee:(void (^) (id responseObject) )success failure:(void (^)(NSString *errorMessage))failure;

//获取看看红点
//+ (void)getMomLookBadgeNumWithChannels:(NSArray *)channelIds;
+ (void)getMomLookBadgeNumWithChannels:(NSArray *)channelIds
                          channelTimes:(NSArray *)channelTimes
                              onFinish:(void (^)(NSMutableArray *))aFininshBlock;


@end
