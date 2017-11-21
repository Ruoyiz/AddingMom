//
//  ADUserSyncMetaHelper.h
//  PregnantAssistant
//
//  Created by D on 15/5/6.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *checkCareCalendarKey = @"antenatalCareCalendarSyncTime";
static NSString *checkArichveKey = @"antenatalCareRecordSyncTime";
static NSString *fetalMovementKey = @"fetalMovementSyncTime";
static NSString *motherDiaryKey = @"motherDiarySyncTime";
static NSString *predeliveryBagKey = @"predeliveryBagSyncTime";
static NSString *pregDiaryKey = @"pregDiarySyncTime";
static NSString *uterineContractionKey = @"uterineContractionSyncTime";
static NSString *toolsCollectionKey = @"toolsCollectionSyncTime";
static NSString *userInfoTimeKey = @"userInfoSyncTime";
static NSString *vaccineSyncTimeKey = @"vaccineSyncTime";
static NSString *heightWeightSyncTimeKey = @"heightWeightSyncTime";


@interface ADUserSyncMetaHelper : NSObject
//判断是否需要执行同步这个动作
+ (void)isNeedSynsDataWithSyncKey:(NSString *)aSyncKey complete:(void(^)(BOOL isNeed))complete;
+ (void)getSyncDataOnFinish:(void (^)(NSDictionary *res, NSError *err))aFinishBlock;
//确定同步动作后，比较同步时间戳，看看需要上传还是需要下载
+ (void)is_severDataTimeLater_syncKey:(NSString *)aSyncKey
                             onFinish:(void (^)(BOOL later, NSString *severStr))aFinishBlock;

//+ (void)isHaveUnSyncDataOnFinish:(void (^)(BOOL))aFinishBlock;

+ (void)syncServerRecordTime:(NSString *)aTime
                  andSyncKey:(NSString *)aSyncKey;//记录服务器同步时间

+ (void)syncClientRecordTimeByToolKey:(NSString *)aSyncKey;//记录本地数据改动时间
+ (void)syncClientRecordTime:(NSString *)aTime
                  andSyncKey:(NSString *)aSyncKey;

+ (NSDate *)getToolSyncDateWithSyncName:(NSString *)aToolName;
+ (NSString *)getToolSyncStrDateWithSyncName:(NSString *)aToolName;

+ (NSArray *)allSyncToolKey;

@end
