//
//  ADCheckArchivesDAO.m
//  PregnantAssistant
//
//  Created by D on 15/4/20.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADCheckArchivesDAO.h"

@implementation ADCheckArchivesDAO

+(RLMResults *)readAllData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    
    return [[ADCheckData objectsWithPredicate:predicate]
            sortedResultsUsingProperty:@"aDate" ascending:YES];
}

+ (void)removeDuplicateWithObject:(RLMResults *)aRes
{
    NSMutableArray *toRemove = [NSMutableArray array];
    for (int i = 0; i < aRes.count; i++) {
        ADCheckData *aData = aRes[i];
        NSString *aDataType = [self getDataType:aData];
        for (int j = i +1; j < aRes.count; j++) {
            ADCheckData *nextData = aRes[j];
            NSString *nDataType = [self getDataType:nextData];
            //            NSLog(@"aData:%@ nData:%@", aData, nextData);
            if ([aData.aDate isEqualToDateIgnoringTime:nextData.aDate] &&
                [aDataType isEqualToString:nDataType]) {
                NSLog(@"real delte");
                [toRemove addObject:nextData];
            }
        }
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteObjects:toRemove];
    [realm commitWriteTransaction];
}

+ (void)addCheckData:(ADCheckData *)aData
{
    [self noSyncAddCheckData:aData];
    [self syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
}

+ (void)noSyncAddCheckData:(ADCheckData *)aData
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:aData];
    
    [realm commitWriteTransaction];
    
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:checkArichveKey];
}

+ (void)delCheckData:(ADCheckData *)aData
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteObject:aData];
    
    [realm commitWriteTransaction];
    
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:checkArichveKey];
    [self syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
}

+ (ADCheckData *)findACheckDataWithDate:(NSDate *)aDate
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"aDate = %@ AND uid = %@", aDate, uid];
    RLMResults *findDatas = [ADCheckData objectsWithPredicate:pred];
    if (findDatas.count > 0) {
        return findDatas[0];
    }
    return nil;
}

+ (void)createOrUpdateCheckRecordWithData:(ADCheckData *)aNewData
{
    RLMResults *allData = [self readAllData];
    
    ADCheckData *sameDayData = nil;
    NSString *newDataType = [self getDataType:aNewData];
    for (ADCheckData *aCheckData in allData) {
        NSString *currentDataType = [self getDataType:aCheckData];
        if ([aCheckData.aDate isEqualToDateIgnoringTime:aNewData.aDate] &&
            [newDataType isEqualToString:currentDataType]) {
            sameDayData = aCheckData;
            
            break;
        }
    }

    if (sameDayData != nil) {
        [self delCheckData:sameDayData];
    }
    
    NSLog(@"check data:%@", aNewData);
    [self addCheckData:aNewData];
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:checkArichveKey];
}

+ (void)distrubeteData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *unSyncDataPre = [NSPredicate predicateWithFormat:@"uid == '0'"];
    
   RLMResults *unSyncRes = [ADCheckData objectsWithPredicate:unSyncDataPre];
//    RLMResults *unSyncRes = [ADCheckData allObjects];
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    for (int i = 0; i < unSyncRes.count;) {
        ADCheckData *aData = unSyncRes[i];
        [realm beginWriteTransaction];
        aData.uid = uid;
        [realm commitWriteTransaction];
        NSLog(@"change uid:%@", uid);
        
//        ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
//        if (aRecord.c_antenatalCareRecord_MTime.integerValue > 0) {
//            [self syncClientRecordTime];
//        }

    }
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:checkArichveKey];
    
    NSPredicate *allPre = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    [self removeDuplicateWithObject:[ADCheckData objectsWithPredicate:allPre]];
}

#pragma mark - sync method

+ (void)needGetDataOnFinish:(void (^)(BOOL))aFinishBlock
{
    __block BOOL needGet = NO;
    if ([[[NSUserDefaults standardUserDefaults]addingUid] isEqualToString:@"0"]) {
        if (aFinishBlock) {
            aFinishBlock(needGet);
        }
    } else {
        [ADUserSyncMetaHelper is_severDataTimeLater_syncKey:checkArichveKey
                                                   onFinish:^(BOOL isLater, NSString *res)
         {
             needGet = isLater;
//             [self syncClientRecordTimeWithTimpSp:res];
             if (aFinishBlock) {
                 aFinishBlock(needGet);
             }
         }];
    }
}

+ (void)syncAllDataOnGetData:(void(^)(NSError *error))getDataBlock
             onUploadProcess:(void(^)(NSError *error))processBlock
              onUpdateFinish:(void(^)(NSError *error))finishBlock
{
    if (processBlock) {
        processBlock(nil);
    }
    
//    if ([self readAllData].count > 0 &&
//        [[ADUserSyncMetaHelper getToolSyncStrDateWithSyncName:checkArichveKey] isEqualToString:@"0"]) {
//        [self syncClientRecordTime];
//    }
    
    [self needGetDataOnFinish:^(BOOL need) {
        
        if (need) {
            NSLog(@"need");
            [ADCheckArichivesSyncManager getDataOnFinish:^(NSArray *res) {
                NSLog(@"sever res:%@", res);
                DISPATCH_ON_GLOBAL_QUEUE_DEFAULT((^{
                //因为 andorid 数据库 不一致 处理数据
                    [self addServerData:res];
                    
//                    [self syncClientRecordTime];
                    
                    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
                    [self removeDuplicateWithObject:[ADCheckData objectsWithPredicate:predicate]];
                    
                    DISPATCH_ON_MAIN_THREAD(^{
                        if (getDataBlock) {
                            getDataBlock(nil);
                        }
                    });
                    
                    [self uploadAllDataOnFinish:finishBlock];
                }));
            }];
        } else {
            //compare sync and local time
            [self uploadAllDataOnFinish:finishBlock];
        }
    }];
}

+ (void)uploadAllDataOnFinish:(void (^)(NSError *error))aFinishBlock
{
    NSString *addingToken = [[NSUserDefaults standardUserDefaults]addingToken];
    if (addingToken.length > 0) {
        RLMResults *aRes = [self readAllData];
        NSLog(@"rm res:%@", aRes);
        [ADCheckArichivesSyncManager uploadData:aRes onFinish:^(NSDictionary *res, NSError *error) {
            
            NSString *serverTime = [NSString stringWithFormat:@"%@", res[@"antenatalCareRecordSyncTime"]];
            [ADUserSyncMetaHelper syncServerRecordTime:serverTime andSyncKey:checkArichveKey];
            if (aFinishBlock) {
                aFinishBlock(error);
            }
        }];
    } else {
        if (aFinishBlock) {
            aFinishBlock([NSError notLoginError]);
        }
    }
}

//  CJDA_TYPE_WEIGHT = 802611; 体重
//  CJDA_TYPE_BP = 802612;  血压
//  CJDA_TYPE_FHR = 802613; 胎心率
//  CJDA_TYPE_FUH = 802614; 宫高
//  CJDA_TYPE_AC = 802615; 腹围
+ (void)addServerData:(NSArray *)aRes
{
    for (int i = 0; i < aRes.count; i++) {
        NSString *time = aRes[i][@"time"];
        NSDate *recordDate = [NSDate dateWithTimeIntervalSince1970:time.intValue];
        NSString *value = aRes[i][@"value"];
        NSString *value1 = aRes[i][@"value1"];
        NSString *type = aRes[i][@"type"];
        
        NSString *weightStr = @"";
        NSString *lowBloodPressStr = @"";
        NSString *highBloodPressStr = @"";
        NSString *heartBeatStr = @"";
        NSString *palaceHeightStr = @"";
        NSString *abCircumferenceStr = @"";
        
//        NSLog(@"type: %@ value:%@", type, value);
        if ([type isEqualToString:@"802611"]) {
            weightStr = value;
        }
        if ([type isEqualToString:@"802612"]) {
            lowBloodPressStr = value;
            highBloodPressStr = value1;
        }
        if ([type isEqualToString:@"802613"]) {
            heartBeatStr = value;
        }
        if ([type isEqualToString:@"802614"]) {
            palaceHeightStr = value;
        }
        if ([type isEqualToString:@"802615"]) {
            abCircumferenceStr = value;
        }
        
        // 保留本地数据 重复的 服务器用户数据 不加
        NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
        NSPredicate *allPre = [NSPredicate predicateWithFormat:@"uid == %@", uid];
        RLMResults *result = [ADCheckData objectsWithPredicate:allPre];
        
        //根据档案数据时间 比较
        // in local data
        BOOL haveSameData = NO;
        for (int i = 0; i < result.count; i++) {
            ADCheckData *aData = result[i];
            
            NSString *currentDataType = [self getDataType:aData];
            
            // 日期不同 添加本地
            if ([aData.aDate isEqualToDateIgnoringTime:recordDate] &&
                [currentDataType isEqualToString:type]) {
                haveSameData = YES;
            }
        }
        
        NSLog(@"haveSame: %d %@", haveSameData, weightStr);
        if ( !haveSameData) {
            [self noSyncAddCheckData:[[ADCheckData alloc] initWithWeight:weightStr
                                                        andLowBloodPress:lowBloodPressStr
                                                       andHighBloodPress:highBloodPressStr
                                                            andHeartBeat:heartBeatStr
                                                         andPalaceHeight:palaceHeightStr
                                                      andAbCircumference:abCircumferenceStr
                                                                 andDate:recordDate]];
        }

        NSLog(@"add once");
    }
}

+ (NSString *)getDataType:(ADCheckData *)aData
{
    NSString * currentDataType;
    if (aData.weight.length > 0) {
        currentDataType = @"802611";
    } else if (aData.lowBloodPress.length > 0) {
        currentDataType = @"802612";
    } else if (aData.heartBeat.length > 0) {
        currentDataType = @"802613";
    } else if (aData.palaceHeight.length > 0) {
        currentDataType = @"802614";
    } else if (aData.abCircumference.length > 0) {
        currentDataType = @"802615";
    }
    return currentDataType;
}

+ (void)updateOldData
{
    if ([[NSUserDefaults standardUserDefaults]everUpdateCheckArchive]) {
        return;
    }
    RLMResults *allData = [ADCheckData allObjects];
    RLMRealm *realm = [RLMRealm defaultRealm];
//    [realm beginWriteTransaction];

    //拆开 老数据
    for (int i = 0; i < allData.count; i++) {
        BOOL haveTwoP = NO;
        ADCheckData *aData = allData[i];
        if (aData.weight.length > 0 &&
            (aData.lowBloodPress.length > 0 || aData.heartBeat.length > 0 ||
             aData.palaceHeight.length > 0 || aData.abCircumference.length > 0))
        {
            ADCheckData *newData = [[ADCheckData alloc]initWithWeight:aData.weight
                                                              andDate:aData.aDate];
            [realm beginWriteTransaction];
            [realm addObject:newData];
            [realm commitWriteTransaction];
            haveTwoP = YES;
        }
        if (aData.lowBloodPress.length > 0 &&
            (aData.weight.length > 0 || aData.heartBeat.length > 0 ||
             aData.palaceHeight.length > 0 || aData.abCircumference.length > 0))
        {
            ADCheckData *newData = [[ADCheckData alloc]initWithLowBloodPress:aData.lowBloodPress
                                                           andHighBloodPress:aData.highBloodPress
                                                                     andDate:aData.aDate];
            [realm beginWriteTransaction];
            [realm addObject:newData];
            [realm commitWriteTransaction];
            haveTwoP = YES;
        }
        if (aData.heartBeat.length > 0 &&
            (aData.lowBloodPress.length > 0 || aData.weight.length > 0 ||
             aData.palaceHeight.length > 0 || aData.abCircumference.length > 0))
        {
            ADCheckData *newData = [[ADCheckData alloc]initWithHeartBeat:aData.heartBeat
                                                                 andDate:aData.aDate];
            [realm beginWriteTransaction];
            [realm addObject:newData];
            [realm commitWriteTransaction];
            haveTwoP = YES;
        }
        if (aData.palaceHeight.length > 0 &&
            (aData.lowBloodPress.length > 0 || aData.heartBeat.length > 0 ||
             aData.weight.length > 0 || aData.abCircumference.length > 0))
        {
            ADCheckData *newData = [[ADCheckData alloc]initWithPalaceHeight:aData.palaceHeight
                                                                    andDate:aData.aDate];
            [realm beginWriteTransaction];
            [realm addObject:newData];
            [realm commitWriteTransaction];
            haveTwoP = YES;
        }
        if (aData.abCircumference.length > 0 &&
            (aData.lowBloodPress.length > 0 || aData.heartBeat.length > 0 ||
             aData.palaceHeight.length > 0 || aData.weight.length > 0))
        {
            ADCheckData *newData = [[ADCheckData alloc]initWithAbCircumference:aData.abCircumference
                                                                       andDate:aData.aDate];
            [realm beginWriteTransaction];
            [realm addObject:newData];
            [realm commitWriteTransaction];
            haveTwoP = YES;
        }
        
        if (haveTwoP) {
            [realm beginWriteTransaction];
            [realm deleteObject:aData];
            [realm commitWriteTransaction];
        }
    }
    
    [[NSUserDefaults standardUserDefaults]setEverUpdateCheckArchive:YES];
}

@end