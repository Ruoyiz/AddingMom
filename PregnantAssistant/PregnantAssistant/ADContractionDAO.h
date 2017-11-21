//
//  ADContractionDAO.h
//  PregnantAssistant
//
//  Created by D on 15/4/20.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADContractionSyncManager.h"
#import "ADBaseToolDAO.h"

@interface ADContractionDAO : ADBaseToolDAO

+ (void)updateDataBaseOnfinish:(void (^)(void))aFinishBlock;

+ (void)addARecord:(ADContraction *)aData;
+ (void)delARecord:(ADContraction *)aData;

+ (RLMResults *)readAllData;
+ (RLMResults *)readAllDataDesc;

+ (RLMResults *)getTodayRecords;
+ (RLMResults *)getRecordsAtDay:(NSDate *)aDate;

+ (void)distrubeteData;

+ (void)syncAllDataOnGetData:(void(^)(NSError *error))getDataBlock
             onUploadProcess:(void(^)(NSError *error))processBlock
              onUpdateFinish:(void(^)(NSError *error))finishBlock;

@end
