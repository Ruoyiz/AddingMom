//
//  ADCheckCalDAO.m
//  PregnantAssistant
//
//  Created by D on 15/4/20.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADCheckCalDAO.h"
#import "ADUserSyncMetaHelper.h"

@implementation ADCheckCalDAO

+ (void)updateDataBaseOnfinish:(void (^)(void))aFinishBlock
{
    //old read method
    NSMutableArray *res = [NSKeyedUnarchiver unarchiveObjectWithData:
                           [[NSUserDefaults standardUserDefaults]objectForKey:dateKey]];
    if (res != nil) {
        //new save method
        for (int i = 0; i < res.count; i++) {
            NSDate *aDate = res[i];
            [self addCheckCal:[[ADCheckCalTime alloc]initWithDate:aDate]];
        }
        
        //old delete method
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:dateKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    if (aFinishBlock) {
        aFinishBlock();
    }
    
    //uploadData
    [self uploadOldData];
}

+ (void)uploadAllDataOnFinish:(void (^)(NSError *error))aFinishBlock
{
    NSString *addingToken = [[NSUserDefaults standardUserDefaults]addingToken];
    NSLog(@"token");
    if (addingToken.length > 0) {
        RLMResults *aRes = [self readAllData];
        NSLog(@"rm res:%@", aRes);
        [ADCheckCalSyncManager uploadData:aRes onFinish:^(NSDictionary *res, NSError *error) {
            NSString *serverTime = [NSString stringWithFormat:@"%@", res[@"antenatalCareCalendarSyncTime"]];
//            [self syncClientRecordTimeWithTimeSp:serverTime];
//            [ADUserSyncMetaHelper syncClientRecordTimeKey:serverTime];
            [ADUserSyncMetaHelper syncServerRecordTime:serverTime andSyncKey:@"antenatalCareCalendarSyncTime"];

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

+ (RLMResults *)readAllData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    
    NSPredicate *allPre = [NSPredicate predicateWithFormat:@"uid == %@",uid];
//    if (![uid isEqualToString:@"0"]) {
//        // 检查用户未登录情况下 记录的数据
//        // 分配登陆后的uid
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == '0'"];
//        
//        RLMResults *unSyncRes = [ADCheckCalTime objectsWithPredicate:predicate];
//        RLMRealm *realm = [RLMRealm defaultRealm];
//        [realm beginWriteTransaction];
//        for (int i = 0; i < unSyncRes.count; i++) {
//            ADCheckCalTime *aData = unSyncRes[i];
//            aData.uid = uid;
//        }
//        
//        [realm commitWriteTransaction];
//    }

    RLMResults *result = [ADCheckCalTime objectsWithPredicate:allPre];
    
    return [result sortedResultsUsingProperty:@"aDate" ascending:YES];
}

+ (NSUInteger)getAllDataCount
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *allPre = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    return [ADCheckCalTime objectsWithPredicate:allPre].count;
}

+ (void)distrubuteData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    NSPredicate *unSyncPre = [NSPredicate predicateWithFormat:@"uid == '0'"];
    RLMResults *unSyncRes = [ADCheckCalTime objectsWithPredicate:unSyncPre];
    NSLog(@"un res:%@ cnt:%lu", unSyncRes, (unsigned long)unSyncRes.count);

    for (int i = 0; i < unSyncRes.count;) {
        ADCheckCalTime *aData = unSyncRes[i];
        [realm beginWriteTransaction];
        aData.uid = uid;
        [realm commitWriteTransaction];
//        NSLog(@"i");
        
//        ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
//        if (aRecord.c_antenatalCareCalendar_MTime.integerValue > 0) {
//            [self syncClientRecordTime];
//        }
    }
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:checkCareCalendarKey];
    NSLog(@"un res:%@ cnt:%lu", unSyncRes, (unsigned long)unSyncRes.count);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    [self removeDuplicateWithObject:[ADCheckCalTime objectsWithPredicate:predicate]];
}

+ (void)removeDuplicateWithObject:(RLMResults *)aRes
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];

    NSMutableArray *toRemove = [NSMutableArray array];
    for (int i = 0; i < aRes.count; i++) {
        ADCheckCalTime *aData = aRes[i];
        for (int j = i +1; j < aRes.count; j++) {
            ADCheckCalTime *nextData = aRes[j];
            //            NSLog(@"aData:%@ nData:%@", aData, nextData);
            if ([aData.aDate isEqualToDateIgnoringTime:nextData.aDate]) {
                NSLog(@"real delte");
                [toRemove addObject:nextData];
            }
        }
    }
    [realm deleteObjects:toRemove];
    [realm commitWriteTransaction];
}

+ (void)updateDataWithArray:(NSArray *)array
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@", uid];
    RLMResults *toDel = [ADCheckCalTime objectsWithPredicate:predicate];
    [realm deleteObjects:toDel];
    
    for (ADCheckCalTime *aData in array) {
        [realm addObject:aData];
    }
    
    [realm commitWriteTransaction];
}

+ (void)addCheckCal:(ADCheckCalTime *)aData
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:aData];
    
    [realm commitWriteTransaction];
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:checkCareCalendarKey];
//    [self syncClientRecordTime];
}

+ (void)delCheckCal:(ADCheckCalTime *)aData
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteObject:aData];
    
    [realm commitWriteTransaction];
    
//    [self syncClientRecordTime];
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:checkCareCalendarKey];

}

+ (void)addCheckCalWithDate:(NSDate *)aDate
{
    ADCheckCalTime *actData = [[ADCheckCalTime alloc]initWithDate:aDate];
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:actData];
    
    [realm commitWriteTransaction];
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:checkCareCalendarKey];
}

+ (void)delCheckCalWithDate:(NSDate *)aDate
{
    ADCheckCalTime *actData = [[ADCheckCalTime alloc]initWithDate:aDate];
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteObject:actData];
    
    [realm commitWriteTransaction];
    
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:checkCareCalendarKey];
    
    //sync data
}


+ (BOOL)needUploadData
{
    if ([[[NSUserDefaults standardUserDefaults]addingUid] isEqualToString:@"0"]) {
        return NO;
    }
    ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
    
    if (aRecord.c_antenatalCareCalendar_MTime.intValue > aRecord.s_antenatalCareCalendar_MTime.intValue) {
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
        [ADUserSyncMetaHelper is_severDataTimeLater_syncKey:checkCareCalendarKey
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

//    if ([self getAllDataCount] > 0 &&
//        [[ADUserSyncMetaHelper getToolSyncStrDateWithSyncName:checkCareCalendarKey] isEqualToString:@"0"]) {
//        [self syncClientRecordTime];
//    }

    [self needGetDataOnFinish:^(BOOL need) {
        NSLog(@"! need:%d", need);
        if (need) {
            [ADCheckCalSyncManager getDataOnFinish:^(NSArray *res) {
                NSLog(@"cal res:%@", res);
                
                DISPATCH_ON_GLOBAL_QUEUE_DEFAULT((^{
                    //合并数据
                    for (int i = 0; i < res.count; i++) {
                        NSString *checktimeStr = res[i][@"time"];
                        NSLog(@"a res:%@", checktimeStr);
                        [self addCheckCalWithDate:
                         [NSDate dateWithTimeIntervalSince1970:checktimeStr.intValue]];
                    }
                    
//                    [self syncClientRecordTime];
                    
                    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
                    [self removeDuplicateWithObject:[ADCheckCalTime objectsWithPredicate:predicate]];
                    
                    DISPATCH_ON_MAIN_THREAD(^{
                        if (getDataBlock) {
                            getDataBlock(nil);
                        }
                    });
                    
                    //compare sync and local time
                    [self upDataWithFinishBlock:finishBlock];
                }));
            }];
        } else {
            [self upDataWithFinishBlock:finishBlock];
        }
    }];
}

+ (void)upDataWithFinishBlock:(void (^)(NSError *error))finishBlock
{
    [self uploadAllDataOnFinish:^(NSError *error) {
        if (finishBlock) {
            finishBlock(error);
        }
        NSLog(@"upload");
    }];
}

+ (void)uploadOldData
{
    if ([[NSUserDefaults standardUserDefaults]everUploadCheckCal]) {
        return;
    }
    
    RLMResults *aRes = [self readAllData];
    if (aRes.count > 0) {
        [self uploadAllDataOnFinish:^(NSError *error) {
            if (error == nil) {
                [[NSUserDefaults standardUserDefaults]setEverUploadCheckCal:YES];
            }
        }];
    } else {
        [[NSUserDefaults standardUserDefaults]setEverUploadCheckCal:YES];
    }
}

@end
