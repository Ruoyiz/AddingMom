//
//  ADCountFetalDAO.h
//  PregnantAssistant
//
//  Created by D on 15/4/21.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADEveryHourCountRecord.h"
#import "ADCountFetalSyncManager.h"

@interface ADCountFetalDAO : NSObject

+ (RLMResults *)readAllData;

+ (NSDate *)getTodayFirstAddOneDate;
+ (RLMResults *)readAllHourArrayWithDate:(NSDate *)aDate;
+ (RLMResults *)readTableOneHourArrayWithDate:(NSDate *)aDate;

+ (void)updateDataBaseOnfinish:(void (^)(void))aFinishBlock;
+ (void)distrubuteData;

+ (void)addAEveryHourRecordWithStartDate:(NSDate *)aDate;

+ (void)addAOneHourRecordWithStartDate:(NSDate *)aDate
                            andEndDate:(NSDate *)aEndDate
                            andCntTime:(NSString *)aCnt;
//sync
+ (void)syncAllDataOnGetData:(void(^)(NSError *error))getDataBlock
             onUploadProcess:(void(^)(NSError *error))processBlock
              onUpdateFinish:(void(^)(NSError *error))finishBlock;

//get
+ (NSDate *)getLastValidData;

//calc
+ (NSMutableArray *)calcPerHourCntWithAllHourArray:(RLMResults *)allHourArray;
//+ (NSMutableArray *)transHourAndTimeWithAllHourArray:(RLMResults *)allHourArray;
+ (void)transHourAndTimeWithAllHourArray:(RLMResults *)allHourArray
                                onFinish:(void(^)(NSMutableArray *))aFinishBlock;

+ (NSArray *)findTheMaxHourInEveryHourArray:(NSArray *)transArray;

+ (NSInteger)calcAverageHourCnt:(NSMutableArray *)transArray
                   withMostHour:(NSDate *)mostHour
                withMostHourNum:(NSString *)mostHourNum;

@end