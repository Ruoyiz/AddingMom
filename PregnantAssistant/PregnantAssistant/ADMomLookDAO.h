//
//  ADFavVideoManager.h
//  PregnantAssistant
//
//  Created by D on 15/2/3.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADMomLookSaveContent.h"

@interface ADMomLookDAO : NSObject

//+ (void)addFavVideo:(ADVideoInfo *)aVideoInfo;
//+ (void)delFavVideo:(ADVideoInfo *)aVideoInfo;
//+ (void)delFavVideoWithWid:(NSString *)aWid;

//+ (BOOL)isFavVideoByWid:(NSString *)aWid;

//+ (RLMResults *)readAllFavVideo;

//+ (void)saveMomLookContent:(ADMomContentInfo *)aInfo;
//删除收藏的咨询内容
+ (void)deleteCollectedContent:(NSString *)action;
+ (void)deleteCollectedContentWithCollectId:(NSString *)aCollectId;

+ (RLMResults *)getAllMomLookContent;
//+ (RLMResults *)getAllMomLookContentAtLoc:(NSInteger)aLoc andLength:(NSInteger)aLength;

+ (RLMResults *)getSyncMomLookData;
//+ (RLMResults *)getSyncMomLookDataAtLoc:(NSInteger)aLoc andLength:(NSInteger)aLength;

+ (RLMResults *)getUnSyncMomLookContent;

+ (void)deleteAllLocalCollect;

//判断咨询内容是否已经收藏过
+ (BOOL)isHasCollected:(NSString *)action;

+ (NSString *)getCollectIdWithAction:(NSString *)action;

+ (void)changeCollectId:(NSString *)aCid withAction:(NSString *)action;

//+ (void)updateMomLookContent:(ADMomContentInfo *)aInfo andCollectId:(NSString *)aCid;
//
//+ (void)updateMomLookContentWithStartCollectId:(NSInteger)aStartIdx
//                                     andLength:(NSInteger)length
//                                   andContents:(NSArray *)contents;

+ (void)distrubuteData;

+ (RLMResults *)searchLocalDataWithString:(NSString *)aString;
+ (RLMResults *)searchSyncDataWithString:(NSString *)aString;
+ (RLMResults *)searchUnSyncDataWithString:(NSString *)aString;

@end
