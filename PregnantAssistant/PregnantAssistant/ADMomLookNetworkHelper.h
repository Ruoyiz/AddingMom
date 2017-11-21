//
//  ADMomLookNetworkHelper.h
//  PregnantAssistant
//
//  Created by D on 15/1/24.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADMomLookNetworkEngine.h"

@interface ADMomLookNetworkHelper : NSObject

@property (nonatomic, retain) ADAppDelegate *appDelegate;

@property (nonatomic, strong) ADMomLookNetworkEngine *momLookEngine;

+ (ADMomLookNetworkHelper *)shareInstance; 

#pragma mark - Get List methods
- (void)getAllVideoWithStartInx:(NSInteger)aInx
                      andLength:(NSInteger)aLength
            andVideoCatalogType:(NSString *)aType
                  andParentType:(NSString *)aParentType
                 andFinishBlock:(void (^)(NSArray *))aFinishBlock
                         failed:(FailRequstBlock)aFailBlock;

- (void)getVideoListOnFinish:(void (^)(NSArray *))aFinishBlock
                      onFail:(FailRequstBlock)aFailBlock;

- (void)recordPlayVideoOnceWithWid:(NSString *)aWid
                          onFinish:(void (^)(NSArray *))aFinishBlock
                            onFail:(FailRequstBlock)aFailBlock;

- (void)getAllVideoWithStartInx:(NSInteger)aInx
                      andLength:(NSInteger)aLength
                        dueDate:(NSString *)dueDate
                      channelId:(NSInteger)aChannelId
                      contentId:(NSInteger)aContentId
                      longitude:(NSString *)aLongitude
                       latitude:(NSString *)aLatitude
                       onFinish:(void (^)(NSArray *))aFinishBlock
                         failed:(FailRequstBlock)aFailBlock;
/**
 *  获取某一项咨询的详细内容
 *
 *  @param aContentId   咨询id
 *  @param aFinishBlock 成功的block
 *  @param aFailBlock   失败的block
 */
//- (void)getDetailContentWithContentId:(NSInteger)aContentId
//                             onFinish:(void (^)(NSArray *))aFinishBlock
//                               failed:(FailRequstBlock)aFailBlock;
/**
 *  取消获取某一项咨询的详细内容的网络请求
 */

- (void)cancelGetDetailContentRequest;
/**
 *  获取频道
 *
 *  @param aFinishBlock 成功的block
 *  @param aFailBlock   失败的block
 */
//- (void)getChannelListOnFinish:(void (^)(NSArray *))aFinishBlock
//                        failed:(FailRequstBlock)aFailBlock;
//
////获取频道列表新 数量
//- (void)getMomLookBadgeNumWithChannels:(NSArray *)channels
//                              onFinish:(void (^)(NSInteger))aFinishBlock;
//
#pragma mark - Fav methods

@end
