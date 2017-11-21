//
//  ADMomSecertNetworkHelper.h
//  PregnantAssistant
//
//  Created by D on 14/12/8.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADAppDelegate.h"
#import "ADMomSecertEngine.h"
#import "CommonBlockDefine.h"

@interface ADMomSecertNetworkHelper : NSObject

@property (nonatomic, retain) ADAppDelegate *appDelegate;
@property (nonatomic, strong) ADMomSecertEngine *momSecertEngine;

+ (ADMomSecertNetworkHelper *)shareInstance;

#pragma mark - User methods
- (void)regDeviceWithOAuth:(NSString *)aOAuth andDeviceToken:(NSString *)aDeviceToken;


- (void)getUserPostWithStartInx:(NSString *)startInx
                      andLength:(NSString *)aLength
                      andResult:(void (^)(NSArray *))aFinishBlock;
#pragma mark - 更多小红点
- (void)getBadgeNumWithResult:(void (^)(int))aFinishBlock;
- (void)getSecertBadgeNumwithResult:(void (^)(int result))aFinishBlock;
- (void)updateNotificationTimeComplete:(void(^)(BOOL isremoveSucess))aFinishBlock;

#pragma mark - Like methods
- (void)changeAPostWithId:(NSString *)aPostId
                andStatus:(BOOL)aStatus
             complication:(FinishRequstBlock)aRequstBlock
                   failed:(FailRequstBlock)aFailBlock;

#pragma mark - Secert methods
- (void)getAllSecertWithStartInx:(NSInteger)aInx
                       andLength:(NSInteger)aLength
                     andViewtype:(viewType)aViewType
                  andFinishBlock:(void (^)(NSArray *))aFinishBlock
                          failed:(FailRequstBlock)aFailBlock;

- (void)getAllSecertWithStartInx:(NSInteger)aInx
                       andLength:(NSInteger)aLength
                   andLastPostId:(NSInteger)aLostPostId
                     andViewtype:(viewType)aViewType
                  andFinishBlock:(void (^)(NSArray *))aFinishBlock
                          failed:(FailRequstBlock)aFailBlock
                    oAuthTimeOut:(OAuthTimeOutBlock)aOAuthBlock;

- (void)postSecerrWithBody:(NSString *)body
                 andImgUrl:(NSString *)imageUrl
            andFinishBlock:(FinishRequstBlock)aFinishBlock
                    failed:(FailRequstBlock)aFailBlock;

- (void)getASecretWithId:(NSInteger)aSecretId
          andFinishBlock:(void (^)(NSArray *))aFinishBlock
                  failed:(FailRequstBlock)aFailBlock;
- (void)getUserPostWithStartInx:(NSString *)startInx
                      andLength:(NSString *)aLength
                      andResult:(void (^)(NSArray *))aFinishBlock failed:(void (^)(void))fail;

- (void)deleteSecertWithCommandId:(NSString *)aCommandId
                      PostId:(NSString *)aPostId
                      onFinish:(void(^)(NSDictionary *resultDic))aFinishBlock
                      onFailed:(FailRequstBlock)aFailBlock;
- (void)getAllNotinfoWithStart:(NSString *)start size:(NSString *)size SecretFinishBlock:(void (^)(NSArray *))aFinishBlock failed:(FailRequstBlock)aFailBlock;

- (void)getAllSecretNotinfoWithStart:(NSString *)start size:(NSString *)size SecretFinishBlock:(void (^)(NSArray *))aFinishBlock failed:(FailRequstBlock)aFailBlock;

#pragma mark - Comment methods
- (void)reportCommentWithId:(NSString *)aCommentId andPostId:(NSString *)aPostId;

- (void)createCommentWithPostId:(NSString *)aPostId
                        andBody:(NSString *)aBody
                       onFinish:(FinishRequstBlock)aFinishBlock
                       onFailed:(FailRequstBlock)aFailBlock;

- (void)replayCommentWithId:(NSString *)aCommentId
                    andBody:(NSString *)aBody
                  andPostId:(NSString *)aPostId
             andFinishBlock:(FinishRequstBlock)aFinishBlock;

- (void)getCommentWithPostId:(NSString *)aPostId
                 andStartInx:(NSString *)aStart
                     andSize:(NSString *)aSize
              andFinishBlock:(void (^)(NSArray *))aFinishBlock failed:(void (^) (void))failed;

- (void)changeACommentWithId:(NSString *)aCommentId
                   andPostId:(NSString *)aPostId
                   andStatus:(BOOL)aStatus
              andFinishBlock:(FinishRequstBlock)aFinishBlock
                      failed:(FailRequstBlock)aFailBlock;

#pragma mark - Notice method
- (void)updateNoticeRequestTime;

- (void)getNewsListWithFinishBlock:(void (^)(NSArray *))aFinishBlock;

- (void)getNewsListWithFinishBlock:(void (^)(NSArray *))aFinishBlock failed:(void (^) (void))failed;

@end
