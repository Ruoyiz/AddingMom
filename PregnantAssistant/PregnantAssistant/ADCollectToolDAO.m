//
//  ADCollectToolDAO.m
//  PregnantAssistant
//
//  Created by D on 15/4/27.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADCollectToolDAO.h"
#import "ADCollectionToolSyncManager.h"
#import "ADUserSyncTimeDAO.h"
#import "ADUserSyncMetaHelper.h"

@implementation ADCollectToolDAO

+ (BOOL)isParentMode
{
    if ([[ADUserInfoSaveHelper readUserStatus] isEqualToString:@"1"]) {
        return NO;
    } else {
        return YES;
    }
}

+ (void)updateDataBaseOnfinish:(void (^)(void))aFinishBlock
{
    NSMutableArray *favArray =
    [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]favToolArray]];
    
    if (favArray != nil) {
    
        NSLog(@"favArray:%@", favArray);
        
        for (int i = 0; i < favArray.count; i++) {
            ADIcon *aIcon = favArray[i];
            [self autoCollectAToolWithTitle:aIcon.title];
        }
        
        //old delete method
        [[NSUserDefaults standardUserDefaults]setFavToolArray:nil];
    }
    
    if (aFinishBlock) {
        aFinishBlock();
    }

    [self uploadOldData];
}

+ (RLMResults *)readAllData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    RLMResults *result = [ADTool objectsWithPredicate:predicate];
    
    return result;
}

+ (RLMResults *)readAllPregToolData
{
    //去除 孕期模式下 非孕期小工具
//    [self removeIllegalPregTool];
    return [self readCollectToolisParentTool:NO];
}

+ (RLMResults *)readAllParentToolData
{
    return [self readCollectToolisParentTool:YES];
}

+ (RLMResults *)readCollectToolisParentTool:(BOOL)isParentTool
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    
    NSPredicate *predicate;
    if (isParentTool) {
        predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    }else{
        predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND toolId != %@ And toolId != %@",uid ,@"100025",@"100026"];
    }
    RLMResults *allObject = [ADTool objectsWithPredicate:predicate];
    [self removeDuplicateWithObject:allObject];
    return [ADTool objectsWithPredicate:predicate];
}

//+ (void)removeIllegalPregTool
//{
//    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND isParentTool == %d",uid, NO];
//    RLMResults *allObject = [ADTool objectsWithPredicate:predicate];
//    
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    
//    [realm transactionWithBlock:^{
//        if (allObject.count > 0) {
//            NSMutableArray *toRemove = [NSMutableArray array];
//            for (ADTool *aTool in allObject) {
//                if ([aTool.title isEqualToString:@"身高体重"] ||
//                    [aTool.title isEqualToString:@"疫苗提醒"] ||
//                    [aTool.title isEqualToString:@"问卷调查"])
//                {
//                    [toRemove addObject:aTool];
//                }
//            }
//
//            [realm deleteObjects:toRemove];
//        }
//    }];
//}

+ (void)removeDuplicateWithObject:(RLMResults *)aRes
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm transactionWithBlock:^{
        NSMutableArray *toRemove = [NSMutableArray array];
        for (int i = 0; i < aRes.count; i++) {
            ADTool *aData = aRes[i];
            for (int j = i +1; j < aRes.count; j++) {
                ADTool *nextData = aRes[j];
                //            NSLog(@"aData:%@ nData:%@", aData, nextData);
                if ([aData.title isEqualToString:nextData.title]) {
//                    NSLog(@"real delte");
                    [toRemove addObject:nextData];
                }
            }
            if ([aData.title isEqualToString:@""]) {
                [toRemove addObject:aData];
            }
        }
        [realm deleteObjects:toRemove];
    }];
}

+ (void)unCollectAToolWithTitle:(NSString *)aTitle recordTime:(BOOL)isrecord{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"title = %@", aTitle];
    RLMResults *contents = [ADTool objectsWithPredicate:pred];
    if (contents.count > 0) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObjects:contents];
        [realm commitWriteTransaction];
    }
    if (isrecord) {
        [self syncClientRecordTime];
    }
}

+ (void)collectAToolWithTitle:(NSString *)aTitle recordTime:(BOOL)isrecord
{
    ADTool *aCollectTool = [[ADTool alloc]initWithTitle:aTitle];
    aCollectTool.isMananullyCollect = YES;
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND title == %@",
                           uid, aTitle];
    RLMResults *res = [ADTool objectsWithPredicate:predicate];
    if (res.count) {
        return;
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    
    if (res.count == 0) {
        [realm addObject:aCollectTool];
    }
    
    [realm commitWriteTransaction];
    
    NSLog(@"aCollectTool: %@", aCollectTool);
    if (isrecord) {
        [self syncClientRecordTime];
    }
}

+ (void)changeWebToVCWithTitle:(NSString *)title VCName:(NSString *)vcName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",title];
    RLMResults *results = [ADTool objectsWithPredicate:predicate];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (ADTool *tool in results) {
        ADTool *aTool = [[ADTool alloc] initWithIoolId:tool.toolId];
        aTool.uid = tool.uid;
        [tempArray addObject:aTool];
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:results];
    [realm addObjects:tempArray];
    [realm commitWriteTransaction];
}

+ (void)autoCollectAToolWithTitle:(NSString *)aTitle
{
    ADTool *aCollectTool = [[ADTool alloc]initWithTitle:aTitle];
    aCollectTool.isMananullyCollect = NO;
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"uid == %@ AND title == %@", uid , aTitle];
    
    RLMResults *res = [ADTool objectsWithPredicate:predicate];
    
    if (res.count == 0) {
        [realm addObject:aCollectTool];
    }

    [realm commitWriteTransaction];
    
    //不要同步时间
}

+ (void)autoCollectAToolWithToolId:(NSString *)toolId
{
    ADTool *aCollectTool = [[ADTool alloc]initWithIoolId:toolId];
    aCollectTool.isMananullyCollect = YES;
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"uid == %@ AND toolId == %@", uid , toolId];
    
    RLMResults *res = [ADTool objectsWithPredicate:predicate];
    
    if (res.count == 0) {
        [realm addObject:aCollectTool];
    }
    
    [realm commitWriteTransaction];
    
    //不要同步时间
}


+ (void)unCollectAToolWithTitle:(NSString *)aTitle
                       onFinish:(void (^)(NSError *))aFinishBlock
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    
    BOOL isParentMode = [self isParentMode];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND title == %@",
                              uid, aTitle];
    
    NSLog(@"pre:%@ title:%@", uid, aTitle);

    RLMResults *allObject = nil;
    if (isParentMode) {
        allObject = [self readAllParentToolData];
    } else {
        allObject = [self readAllPregToolData];
    }

    if (allObject.count <= 5) {
        if (aFinishBlock) {
            aFinishBlock([NSError lessToolError]);
        }
    } else {
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm beginWriteTransaction];
        RLMResults *toDel = [ADTool objectsWithPredicate:predicate];
        
        NSLog(@"toDel:%@", toDel);
        
        [realm deleteObjects:toDel];
     
        [realm commitWriteTransaction];
        
        [self syncClientRecordTime];
        
        if (aFinishBlock) {
            aFinishBlock(nil);
        }
    }
}

+ (BOOL)hasCollectAToolWithTitle:(NSString *)aTitle
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"uid == %@ AND title == %@ ",uid, aTitle ];
    
    RLMResults *toDel = [ADTool objectsWithPredicate:predicate];
    
    if (toDel.count > 0) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)sortLocalArrayOnCompletion:(void (^)(void))completion{

    NSMutableArray *oldDateArray = [NSMutableArray array];
    NSMutableArray *oldAutoDateArray = [NSMutableArray array];
    RLMResults *oldResults = [self readAllData];
    NSLog(@"olsresults : %@",oldResults);
    for (ADTool *oldTool in oldResults) {
        if (oldTool.isMananullyCollect) {
            [oldDateArray addObject:oldTool.title];
        }else{
            [oldAutoDateArray addObject:oldTool.title];
        }
    }
    NSLog(@"oldDate:%@,oldAutoData:%@",oldDateArray,oldAutoDateArray);
    [self updateDataWithArray:nil withOldDateArray:oldDateArray andOldAutoDataArray:oldAutoDateArray  onCompletion:^{
        if (completion) {
            completion();
        }
    }];

}

+ (void)updateDataWithArray:(NSArray *)array withOldDateArray:(NSArray *)oldToolArray andOldAutoDataArray:(NSArray *)oldAutoDataArray onCompletion:(void (^)(void))completion
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"uid == %@ ", uid];
    RLMResults *toDel = [ADTool objectsWithPredicate:predicate];
   
//    [realm transactionWithBlock:^{
//        [realm deleteObjects:toDel];
//        
////        NSLog(@"update array:%@", array);
//        [realm addObjects:array];
//    }];
    //        [realm deleteObjects:toDel];
//    [realm commitWriteTransaction];

    [realm beginWriteTransaction];
    [realm deleteObjects:toDel];
    [realm commitWriteTransaction];
    for (NSString *title in oldAutoDataArray) {
        [self collectAToolWithTitle:title recordTime:NO];
    }
    NSLog(@"array : %@",array);
    if (array.count) {
        for (NSString *toolId in array) {
            [self autoCollectAToolWithToolId:toolId];
        }
    }
    
    for (NSString *title in oldToolArray) {
        [self collectAToolWithTitle:title recordTime:NO];
    }

    [self syncClientRecordTime];
    if (completion) {
        completion();
    }
}

+ (void)updateDataWithArray:(NSArray *)array
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"uid == %@",uid];
    RLMResults *toDel = [ADTool objectsWithPredicate:predicate];
    [realm deleteObjects:toDel];
    [realm commitWriteTransaction];
    
    [realm beginWriteTransaction];
    
    for (ADTool *aTool in array) {
        [realm addObject:aTool];
    }
    [realm commitWriteTransaction];
    [self syncClientRecordTime];
}

#pragma mark - sync method
+ (void)syncClientRecordTime
{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    
    [self syncClientRecordTimeWithTimeSp:timeSp];
}

+ (void)syncClientRecordTimeWithTimeSp:(NSString *)aTimeSp
{
    ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    
    if (aTimeSp.integerValue > aRecord.c_toolsCollection_MTime.integerValue) {
        aRecord.c_toolsCollection_MTime = aTimeSp;
    }
    [realm commitWriteTransaction];
}


+ (void)needGetDataOnFinish:(void (^)(BOOL need))aFinishBlock
{
    if ([[[NSUserDefaults standardUserDefaults]addingUid] isEqualToString:@"0"]) {
        if (aFinishBlock) {
            aFinishBlock(NO);
        }
    } else {
        [ADUserSyncMetaHelper is_severDataTimeLater_syncKey:@"toolsCollectionSyncTime"
                                                   onFinish:
         ^(BOOL isLater, NSString *res) {
             NSLog(@"isLater:%d res:%@",isLater, res);
//             [self syncClientRecordTimeWithTimeSp:res];
             
             if (aFinishBlock) {
                 aFinishBlock(isLater);
             }
         }];
    }
}

+ (void)sortLocaToolsDataWithServerArray:(NSMutableArray *)array complete:(void(^)(void))complete{
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    //排序
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1[@"toolIndex"] localizedStandardCompare:obj2[@"toolIndex"]];
    }];
    //快速去重
    NSLog(@"arraydkfjkl: %@",array);
    NSArray *sortArray = [self distinctUnionOfObjectsWithArray:array];
    NSLog(@"sortArray: %@",sortArray);
    for (int i = 0; i < sortArray.count; i ++) {
        [tempArray addObject:array[i][@"toolId"]];
    }
    
    NSMutableArray *oldDateArray = [NSMutableArray array];
    NSMutableArray *oldAutoDateArray = [NSMutableArray array];
    RLMResults *oldResults = [self readCollectToolisParentTool:[self isParentMode]];
    NSLog(@"olsresults : %@",oldResults);
    for (ADTool *oldTool in oldResults) {
        if (oldTool.isMananullyCollect) {
            [oldDateArray addObject:oldTool.title];
        }else{
            [oldAutoDateArray addObject:oldTool.title];
        }
    }
    NSLog(@"oldDate:%@,oldAutoData:%@",oldDateArray,oldAutoDateArray);
    [self updateDataWithArray:tempArray withOldDateArray:oldDateArray andOldAutoDataArray:oldAutoDateArray  onCompletion:^{
        if (complete) {
            complete();
        }
    }];
    
}

+ (void)syncAllDataOnGetData:(void(^)(NSArray *responseObject, NSError *error))getDataBlock
             onUploadProcess:(void(^)(NSError *error))processBlock
              onUpdateFinish:(void(^)(NSError *error))finishBlock
{
    if (processBlock) {
        processBlock(nil);
    }
    
    [self needGetDataOnFinish:^(BOOL need) {
        if (need) {
            [ADCollectionToolSyncManager getDataOnFinish:^(NSArray *res) {
                [self sortLocaToolsDataWithServerArray:[NSMutableArray arrayWithArray:res] complete:^{
                    if (getDataBlock) {
                        getDataBlock(res,nil);
                    }
                    [self uploadAllDataOnFinish:finishBlock];
                }];
                
            }];
        } else {
            [self uploadAllDataOnFinish:finishBlock];
//            [self sortLocalArrayOnCompletion:^{
//                [self uploadAllDataOnFinish:finishBlock];
//            }];
        }
    }];
}
+ (NSMutableArray *)distinctUnionOfObjectsWithArray:(NSArray *)array
{
//    NSMutableArray *ddarray = [NSMutableArray array];
//    [ddarray addObject:[[ADTool alloc]initWithIoolId:@"10013"]];
//    [ddarray addObject:[[ADTool alloc]initWithIoolId:@"10013"]];
//    [ddarray addObject:[[ADTool alloc]initWithIoolId:@"10012"]];
//
    NSSet *distinctItems = [NSSet setWithArray:array];
    return [NSMutableArray arrayWithArray:[distinctItems allObjects]];
//    return [ddarray valueForKeyPath:@"@distinctUnionOfObjects.self.toolId"];
}

+ (void)uploadAllDataOnFinish:(void (^)(NSError *error))aFinishBlock
{
    NSString *addingToken = [[NSUserDefaults standardUserDefaults]addingToken];
    if (addingToken.length > 0) {
        RLMResults *aRes = [self readAllData];
        NSLog(@"rm res:%@", aRes);
        [ADCollectionToolSyncManager uploadData:aRes onFinish:^(NSDictionary *res, NSError *error) {
            NSString *serverTime = [NSString stringWithFormat:@"%@", res[@"toolsCollectionSyncTime"]];
            [ADUserSyncMetaHelper syncServerRecordTime:serverTime andSyncKey:@"toolsCollectionSyncTime"];

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

+ (void)uploadOldData
{
    [ADCollectionToolSyncManager getDataOnFinish:^(NSArray *res) {
        if (res.count == 0 && [[NSUserDefaults standardUserDefaults]everUploadCollectTool] == NO) {
            RLMResults *aRes = [self readAllData];
            if (aRes.count > 0) {
                [self uploadAllDataOnFinish:^(NSError *error) {
                    if (error == nil) {
                        [[NSUserDefaults standardUserDefaults]setEverUploadCollectTool:YES];
                    }
                }];
            }
        } else {
            [[NSUserDefaults standardUserDefaults]setEverUploadCollectTool:YES];
        }
    }];
}

+ (void)distrubuteData
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    NSPredicate *unSyncPre = [NSPredicate predicateWithFormat:@"uid == '0'"];
    RLMResults *unSyncRes = [ADTool objectsWithPredicate:unSyncPre];
    NSLog(@"usnsylskdfl: %@",unSyncRes);
    
    for (ADTool *aData in unSyncRes) {
        ADTool *newData = [[ADTool alloc]initWithTitle:aData.title];
        newData.isParentTool = aData.isParentTool;
        newData.isMananullyCollect = aData.isMananullyCollect;
        [realm addObject:newData];
//        NSLog(@"unSyncRes:%@", newData);
    }
    
    [realm commitWriteTransaction];
    [self syncClientRecordTime];
}

@end