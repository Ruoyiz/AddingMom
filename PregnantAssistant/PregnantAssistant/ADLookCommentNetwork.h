//
//  ADLookCommentNetwork.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/12.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADLookCommentNetwork : NSObject
//获取看看详情
+ (void)getLookContentWithContentId:(NSString *)contentId success:(void (^) (id responseObject)) success failure :(void (^) (NSError *error)) failure;
////获取评论列表
//+ (void)getCommentListFromStartPos:(NSInteger)startPos size:(NSInteger)size contentId:(NSString *)contentId commentId:(NSString *)commentId success:(void (^) (id responseObject))success failure:(void (^) (NSError *error))failure;
//获取评论列表
+ (void)getCommentListFromStartPos:(NSInteger)startPos size:(NSInteger)size contentId:(NSString *)contentId commentId:(NSString *)commentId success:(void (^) (id responseObject, NSInteger commentCount))success failure:(void (^) (NSError *error))failure;

//获取热门评论列表
+ (void)getHotCommentListFromStartPos:(NSInteger)startPos size:(CGFloat)size contentId:(NSString *)contentId commentId:(NSString *)commentId success:(void (^) (id responseObject, NSInteger commentCount))success failure:(void (^) (NSError *error))failure;

//创建评论
+ (void)createCommentForContentId:(NSString *)contentId replyCommentId:(NSString *)replyCommentId commentbody:(NSString *)commentbody success:(void (^) (id responseObject))success failure:(void (^) (NSError *error))failure;

//点赞
+ (void)createPraiseForContentId:(NSString *)contentId commentId:(NSString *)commentId success:(void (^) (id responseObject))success failure:(void (^) (NSError *error))failure;

//取消赞
+ (void)deletePraiseForContentId:(NSString *)contentId commentId:(NSString *)commentId success:(void (^) (id responseObject))success failure:(void (^) (NSError *error))failure;

//举报
+ (void)reportCommentForContentId:(NSString *)contentId commentId:(NSString *)commentId success:(void (^) (id responseObject))success failure:(void (^) (NSError *error))failure;

///删除自己的评论
+ (void)deleteCommentForContentId:(NSString *)contentId commentId:(NSString *)commentId success:(void (^) (id responseObject))success failure:(void (^) (NSError *error))failure;

@end
