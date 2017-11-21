//
//  ADCheckArchivesDAO.h
//  PregnantAssistant
//
//  Created by D on 15/4/20.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADCheckData.h"
#import "ADUserSyncTimeDAO.h"
#import "ADUserSyncMetaHelper.h"
#import "ADCheckArichivesSyncManager.h"

@interface ADCheckArchivesDAO : NSObject

+ (RLMResults *)readAllData;

+ (void)addCheckData:(ADCheckData *)aData;
+ (void)delCheckData:(ADCheckData *)aData;

+ (ADCheckData *)findACheckDataWithDate:(NSDate *)aDate;
+ (void)createOrUpdateCheckRecordWithData:(ADCheckData *)aNewData;

+ (void)distrubeteData;

+ (void)syncAllDataOnGetData:(void(^)(NSError *error))getDataBlock
             onUploadProcess:(void(^)(NSError *error))processBlock
              onUpdateFinish:(void(^)(NSError *error))finishBlock;

+ (void)updateOldData;

@end
