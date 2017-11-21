//
//  ADCheckCalDAO.h
//  PregnantAssistant
//
//  Created by D on 15/4/20.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADBaseToolDAO.h"
#import "ADCheckCalSyncManager.h"

@interface ADCheckCalDAO : ADBaseToolDAO

+ (RLMResults *)readAllData;

+ (void)addCheckCal:(ADCheckCalTime *)aData;
+ (void)delCheckCal:(ADCheckCalTime *)aData;

+ (void)addCheckCalWithDate:(NSDate *)aDate;
+ (void)delCheckCalWithDate:(NSDate *)aDate;

+ (void)distrubuteData;
+ (void)updateDataBaseOnfinish:(void (^)(void))aFinishBlock;

+ (void)uploadAllDataOnFinish:(void (^)(NSError *error))aFinishBlock;

+ (BOOL)needUploadData;
+ (void)needGetDataOnFinish:(void (^)(BOOL))aFinishBlock;

+ (void)syncAllDataOnGetData:(void(^)(NSError *error))getDataBlock
             onUploadProcess:(void(^)(NSError *error))processBlock
              onUpdateFinish:(void(^)(NSError *error))finishBlock;

//+ (void)syncClientRecordTime;

@end
