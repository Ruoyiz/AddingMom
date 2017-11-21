//
//  ADContractionDAO.m
//  PregnantAssistant
//
//  Created by D on 15/4/20.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADContractionDAO.h"

@implementation ADContractionDAO

+ (void)updateDataBaseOnfinish:(void (^)(void))aFinishBlock
{
    //old read method
    NSMutableArray *res = [[NSMutableArray alloc]initWithArray:
                           [[NSUserDefaults standardUserDefaults]allContractionRecords]];
    if (res != nil) {
        NSLog(@"old data:%@", res);
        //new save method
        for (int i = 0; i < res.count; i++) {
            NSArray *aDayRecord = res[i];
            for (int j = 0; j < aDayRecord.count; j++) {
                NSArray *aRecord = aDayRecord[j];
                ADContraction *aNewRecord = [[ADContraction alloc]initStartTime:aRecord[0]
                                                                     andEndTime:aRecord[1]];
                [self addARecord:aNewRecord];
                
                NSLog(@"aRecord:%@", aRecord);
            }
        }
        
        //old delete method
        [[NSUserDefaults standardUserDefaults]setAllContractionRecords:nil];
    }
    
    if (aFinishBlock) {
        aFinishBlock();
    }
    
    //upload
    [self uploadOldData];
}

+ (void)addARecord:(ADContraction *)aData
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"uid == %@ AND startDate == %@", uid, aData.startDate];
    RLMResults *allRes = [ADContraction objectsWithPredicate:predicate];
    
    if (allRes.count == 0) {
        [realm beginWriteTransaction];
        [realm addObject:aData];
        [realm commitWriteTransaction];
    }
    
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:uterineContractionKey];
}

+ (void)delARecord:(ADContraction *)aData
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteObject:aData];
    [realm commitWriteTransaction];
    
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:uterineContractionKey];
}

+ (RLMResults *)readAllData
{
    return [self readAllDataIsAscending:YES];
}

+ (RLMResults *)readAllDataDesc
{
    return [self readAllDataIsAscending:NO];
}

+ (RLMResults *)readAllDataIsAscending:(BOOL)isAscend
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    
//    [self checkAndAssignUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    RLMResults *result = [ADContraction objectsWithPredicate:predicate];
    
    //sss
    return [result sortedResultsUsingProperty:@"startDate" ascending:isAscend];
}

+ (void)distrubeteData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == '0'"];
    
    RLMResults *unSyncRes = [ADContraction objectsWithPredicate:predicate];
//    RLMResults *unSyncRes = [ADContraction allObjects];
    RLMRealm *realm = [RLMRealm defaultRealm];
    for (int i = 0; i < unSyncRes.count;) {
        ADContraction *aData = unSyncRes[i];
        [realm beginWriteTransaction];
        aData.uid = uid;
        [realm commitWriteTransaction];
    }
    
//    ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
//    if (aRecord.c_uterineContraction_MTime.integerValue > 0) {
//        [self syncClientRecordTime];
//    }
//
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:uterineContractionKey];

    NSPredicate *allPre = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    [self removeDuplicateWithObject:[ADContraction objectsWithPredicate:allPre]];
}

+ (void)removeDuplicateWithObject:(RLMResults *)aRes
{
    NSMutableArray *toRemove = [NSMutableArray array];
    for (int i = 0; i < aRes.count; i++) {
        ADContraction *aData = aRes[i];
        for (int j = i +1; j < aRes.count; j++) {
            ADContraction *nextData = aRes[j];
            //            NSLog(@"aData:%@ nData:%@", aData, nextData);
            if ([aData.startDate isEqual:nextData.startDate]) {
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

+ (RLMResults *)getTodayRecords
{
    RLMResults *todayRecords = [self getRecordsAtDay:[NSDate date]];
    return todayRecords;
}

+ (RLMResults *)getRecordsAtDay:(NSDate *)aDate
{
    NSCalendar* gregorian = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* dateComponents = [gregorian components:unitFlags fromDate:aDate];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    NSDate *startDate = [gregorian dateFromComponents:dateComponents];
    
    [dateComponents setHour:23];
    [dateComponents setMinute:59];
    [dateComponents setSecond:59];

    NSDate *endDate = [gregorian dateFromComponents:dateComponents];
    
    NSPredicate *firstPredicate = [NSPredicate predicateWithFormat:@"startDate >= %@", startDate];
    NSPredicate *secondPredicate = [NSPredicate predicateWithFormat:@"startDate <= %@", endDate];
    
    NSPredicate *predicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:@[firstPredicate, secondPredicate]];
    
    RLMResults *todayRecords = [[ADContraction objectsWithPredicate:predicate]
                                sortedResultsUsingProperty:@"startDate" ascending:NO];
    
    //find user
//    [self checkAndAssignUid];
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    
    NSPredicate *userPre = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    RLMResults *result = [todayRecords objectsWithPredicate:userPre];
    
    return result;
}

//+ (void)checkAndAssignUid
//{
//    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
//
//    if (![uid isEqualToString:@"0"]) {
//        // 检查用户未登录情况下 记录的数据
//        // 分配登陆后的uid
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == '0'"];
//        
//        RLMResults *unSyncRes = [ADContraction objectsWithPredicate:predicate];
//        RLMRealm *realm = [RLMRealm defaultRealm];
//        [realm beginWriteTransaction];
//        for (int i = 0; i < unSyncRes.count; i++) {
//            ADContraction *aData = unSyncRes[i];
//            aData.uid = uid;
//        }
//        
//        [realm commitWriteTransaction];
//    }
//}

#pragma mark - sync method

+ (BOOL)needUploadData
{
    if ([[[NSUserDefaults standardUserDefaults]addingUid] isEqualToString:@"0"]) {
        return NO;
    }

    ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
    if (aRecord.c_uterineContraction_MTime.intValue > aRecord.s_uterineContraction_MTime.intValue) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)needGetDataOnFinish:(void (^)(BOOL))aFinishBlock
{
    __block BOOL needGet = NO;
    if ([[[NSUserDefaults standardUserDefaults]addingUid] isEqualToString:@"0"]) {
        if (aFinishBlock) {
            aFinishBlock(needGet);
        }
    } else {
        [ADUserSyncMetaHelper is_severDataTimeLater_syncKey:@"uterineContractionSyncTime"
                                                   onFinish:^(BOOL isLater, NSString *res)
         {
             needGet = isLater;
//             [self syncClientRecordTimeWithTimeSp:res];
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
    
    //分发数据后 记录时间
//    if ([self readAllData].count > 0 &&
//        [[ADUserSyncMetaHelper getToolSyncStrDateWithSyncName:uterineContractionKey] isEqualToString:@"0"]) {
//        [self syncClientRecordTime];
//    }
    
    [self needGetDataOnFinish:^(BOOL need) {
        if (need) {
            NSLog(@"con need");
            [ADContractionSyncManager getDataOnFinish:^(NSArray *res) {
                NSLog(@"cal res:%@", res);
                //合并数据
//                DISPATCH_ON_GLOBAL_QUEUE_DEFAULT((^{
                    for (int i = 0; i < res.count; i++) {
                        NSString *startTime = res[i][@"startTime"];
                        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime.intValue];
                        NSString *endTime = res[i][@"endTime"];
                        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime.intValue];
                        [self addARecord:[[ADContraction alloc]initStartTime:startDate
                                                                  andEndTime:endDate]];
                        NSLog(@"add once");
                    }
                    
                    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
                    [self removeDuplicateWithObject:[ADContraction objectsWithPredicate:predicate]];
                    
//                    DISPATCH_ON_MAIN_THREAD(^{
                        if (getDataBlock) {
                            getDataBlock(nil);
                        }
//                    });
                
                    [self uploadAllDataOnFinish:finishBlock];
//                }));

            }];
        } else {
            //compare sync and local time
            [self uploadAllDataOnFinish:finishBlock];
        }
    }];
}


+ (void)uploadOldData
{
    if ([[NSUserDefaults standardUserDefaults]everUploadContraction]) {
        return;
    }
    
    RLMResults *aRes = [self readAllData];
    if (aRes.count > 0) {
        [self uploadAllDataOnFinish:^(NSError *error) {
            if (error == nil) {
                [[NSUserDefaults standardUserDefaults]setEverUploadContraction:YES];
            }
        }];
    } else {
        [[NSUserDefaults standardUserDefaults]setEverUploadContraction:YES];
    }
}

+ (void)uploadAllDataOnFinish:(void (^)(NSError *error))aFinishBlock
{
    NSString *addingToken = [[NSUserDefaults standardUserDefaults]addingToken];
    if (addingToken.length > 0) {
        RLMResults *aRes = [self readAllData];
        NSLog(@"rm res:%@", aRes);
        [ADContractionSyncManager uploadData:aRes onFinish:^(NSDictionary *res, NSError *error) {
            NSString *serverTime = [NSString stringWithFormat:@"%@", res[@"uterineContractionSyncTime"]];
            [ADUserSyncMetaHelper syncServerRecordTime:serverTime andSyncKey:@"uterineContractionSyncTime"];

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

@end
