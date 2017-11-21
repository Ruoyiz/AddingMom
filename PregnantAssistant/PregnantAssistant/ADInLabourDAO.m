//
//  ADInLabourDAO.m
//  PregnantAssistant
//
//  Created by D on 15/4/20.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADInLabourDAO.h"
#import "ADInLabourSyncManager.h"

@implementation ADInLabourDAO

+ (void)updateDataBaseOnfinish:(void (^)(void))aFinishBlock
{
    //want thing
    //old read
    NSArray *headerTitles = @[
                              @"住院清单", @"产妇卫生用品",
                              @"产妇护理", @"宝宝日用",
                              @"宝宝洗护", @"宝宝喂养",
                              @"宝宝服饰", @"宝宝护肤",
                              @"宝宝床上用品", @"宝宝出行"
                              ];
    
    NSMutableArray *allWantThing = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < headerTitles.count; i++) {
        NSString *aTitle = headerTitles[i];
        NSMutableArray *aKindThing = [NSKeyedUnarchiver unarchiveObjectWithData:
                                      [[NSUserDefaults standardUserDefaults]objectForKey:aTitle]];
        if (aKindThing == nil) {
            aKindThing = [[NSMutableArray alloc]initWithCapacity:0];
        }
        [allWantThing addObject:aKindThing];
        
        NSLog(@"aKindThing:%@", aKindThing);
        for (int i = 0; i < aKindThing.count; i++) {
            
            NSArray *aThing = aKindThing[i];
            NSString *scoreStr = aThing[3];
            NSLog(@"score 0:%@ 1:%@ 2:%@ 3:%@", aThing[0], aThing[1], aThing[2], scoreStr);
            ADNewLabourThing *aNewLabourThing = [[ADNewLabourThing alloc]initWithName:aThing[0]
                                                                               reason:aThing[1]
                                                                      recommendCntStr:aThing[2]
                                                                       recommentScore:scoreStr
                                                                            kindTitle:aTitle
                                                                              haveBuy:NO];
            [self addAWantLabourThing:aNewLabourThing];
        }
    }
    
    NSLog(@"allWantThing:%@", allWantThing);
    
    //clean
    for (int i = 0; i < headerTitles.count; i++) {
        NSString *aTitle = headerTitles[i];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:aTitle];
    }

    //have thing
    NSMutableArray * haveBuyArray = [NSKeyedUnarchiver unarchiveObjectWithData:
                                     [[NSUserDefaults standardUserDefaults]objectForKey:buyKey]];
    
    if (haveBuyArray == nil) {
        haveBuyArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    
    NSLog(@"buyThing: %@", haveBuyArray);
    for (int i = 0; i < haveBuyArray.count; i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",haveBuyArray[i]];
        RLMResults *sameThing = [ADNewLabourThing objectsWithPredicate:predicate];
        ADNewLabourThing *aThing = sameThing[0];
        RLMRealm* realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        aThing.haveBuy = YES;
        [realm commitWriteTransaction];
    }
    
    //clean
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:buyKey];
    
    [self uploadOldData];
}

+ (RLMResults *)readAllData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    
    RLMResults *result = [ADNewLabourThing objectsWithPredicate:predicate];
    
    return result;
}

+ (void)distrubuteData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    NSPredicate *unSyncPre = [NSPredicate predicateWithFormat:@"uid == '0'"];
    RLMResults *unSyncRes = [ADNewLabourThing objectsWithPredicate:unSyncPre];
//    RLMResults *unSyncRes = [ADNewLabourThing allObjects];

//    NSLog(@"unSync:%@", unSyncRes);
    
    for (int i = 0; i < unSyncRes.count;) {
        ADNewLabourThing *aData = unSyncRes[i];
        [realm beginWriteTransaction];
        aData.uid = uid;
        [realm commitWriteTransaction];
        
//        ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
//        if (aRecord.c_predeliveryBag_MTime.integerValue > 0) {
//            [self syncClientRecordTime];
//        }
    }
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:predeliveryBagKey];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    [self removeDuplicateWithObject:[ADNewLabourThing objectsWithPredicate:predicate]];
}

+ (void)removeDuplicateWithObject:(RLMResults *)aRes
{
    NSLog(@"aRes: %@", aRes);
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];

    NSMutableArray *toRemove = [NSMutableArray array];
    for (int i = 0; i < aRes.count; i++) {
        ADNewLabourThing *aData = aRes[i];
        for (int j = i +1; j < aRes.count; j++) {
            ADNewLabourThing *nextData = aRes[j];
//            NSLog(@"aData:%@ nData:%@", aData, nextData);
            if ([aData.name isEqual:nextData.name]) {
                NSLog(@"real delte one");
                [toRemove addObject:nextData];
            }
        }
    }
    
    [realm deleteObjects:toRemove];
    [realm commitWriteTransaction];
}

+ (void)addAWantLabourThing:(ADNewLabourThing *)aThing
{
    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND name == %@",uid, aThing.name];
    
    RLMResults *res = [ADNewLabourThing objectsWithPredicate:predicate];
    if (res.count == 0) {
        [realm addObject:aThing];
    }
    
    [realm commitWriteTransaction];
    
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:predeliveryBagKey];
}

+ (void)delAWantLabourThing:(ADNewLabourThing *)aThing
{
    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:aThing];
    [realm commitWriteTransaction];
    
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:predeliveryBagKey];
}

+ (void)delAWantLabourThingWithName:(NSString *)aName
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND name == %@",uid, aName];

    RLMResults * findThings = [ADNewLabourThing objectsWithPredicate:predicate];

    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:findThings];
    [realm commitWriteTransaction];
    
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:predeliveryBagKey];
}

+ (void)markALabourThingName:(NSString *)aName withBuyStatus:(BOOL)aStatus
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", aName];
    RLMResults * findThings = [[self readAllData] objectsWithPredicate:predicate];
    
    ADNewLabourThing *aThing = findThings[0];
    
    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    aThing.haveBuy = aStatus;
    [realm commitWriteTransaction];
    
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:predeliveryBagKey];
}

+ (RLMResults *)readWantThingWithKindTitle:(NSString *)aTitle
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"aKindTitle == %@",aTitle];

    RLMResults *aKindWantThing = [ADNewLabourThing objectsWithPredicate:predicate];

    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"uid == %@", uid];

    RLMResults *aUserThing = [aKindWantThing objectsWithPredicate:predicate3];
    
    return aUserThing;
}

+ (BOOL)isContainAThing:(NSString *)aThingName inKind:(NSString *)aKindTitle
{
    NSLog(@"aThing:%@", aThingName);
    NSLog(@"aKindTitle:%@", aKindTitle);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"aKindTitle == %@",aKindTitle];
    RLMResults *aKindWantThing = [ADNewLabourThing objectsWithPredicate:predicate];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"name == %@", aThingName];
    RLMResults * findThings = [aKindWantThing objectsWithPredicate:predicate2];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"uid == %@", uid];
    RLMResults *aUserThing = [findThings objectsWithPredicate:predicate3];
    if (aUserThing.count) {
        return YES;
    }
    
    return NO;
}

+ (void)addAKindWantThing:(NSArray *)aKindThing andKindTitle:(NSString *)aKindTitle
{
    NSLog(@"add thing:%@", aKindThing);
    for (int i = 0; i < aKindThing.count; i++) {
        NSArray *aThing = aKindThing[i];
        NSLog(@"add once");
        //查找已添加物品 已有不添加
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"aKindTitle == %@ AND name == %@",aKindTitle, aThing[0]];
        RLMResults *sameThing = [[self readAllData] objectsWithPredicate:predicate2];
        
        if (sameThing.count == 0) {
            [self addAWantLabourThing:[[ADNewLabourThing alloc]initWithName:aThing[0]
                                                                     reason:aThing[1]
                                                            recommendCntStr:aThing[2]
                                                             recommentScore:aThing[3]
                                                                  kindTitle:aKindTitle
                                                                    haveBuy:NO]];
        }
    }
}

#pragma mark - sync method
//+ (void)syncClientRecordTimeWithTimeSp:(NSString *)aTimeSp
//{
//    ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
//    
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    
//    [realm beginWriteTransaction];
//    
//    if (aTimeSp.integerValue > aRecord.c_predeliveryBag_MTime.integerValue) {
//        aRecord.c_predeliveryBag_MTime = aTimeSp;
//    }
//
//    [realm commitWriteTransaction];
//}
//
//+ (void)syncClientRecordTime
//{
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
//    [self syncClientRecordTimeWithTimeSp:timeSp];
//}

+ (BOOL)needUploadData
{
    if ([[[NSUserDefaults standardUserDefaults]addingUid] isEqualToString:@"0"]) {
        return NO;
    }
    
    ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
    if (aRecord.c_predeliveryBag_MTime.intValue > aRecord.s_predeliveryBag_MTime.intValue) {
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
        [ADUserSyncMetaHelper is_severDataTimeLater_syncKey:@"predeliveryBagSyncTime"
                                                   onFinish:^(BOOL isLater, NSString *res)
         {
             needGet = isLater;
             
             NSLog(@"needGet:%d", needGet);
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
    
//    if ([self readAllData].count > 0 &&
//        [[ADUserSyncMetaHelper getToolSyncStrDateWithSyncName:predeliveryBagKey] isEqualToString:@"0"]) {
//        [self syncClientRecordTime];
//    }

    [self needGetDataOnFinish:^(BOOL need) {
        if (need) {
            NSLog(@"need");
            [ADInLabourSyncManager getDataOnFinish:^(NSArray *res) {
                NSLog(@"inLabour res:%@", res);
                //合并数据
                DISPATCH_ON_GLOBAL_QUEUE_DEFAULT((^{
                    for (int i = 0; i < res.count; i++) {
                        
                        NSString *type = res[i][@"type"];
                        
                        NSString *title = [ADInLabourSyncManager getTitleFromType:type.intValue];
                        NSString *content = res[i][@"content"];
                        NSString *count = res[i][@"count"];
                        NSString *isCheckedStr = res[i][@"isChecked"];
                        bool isChecked = isCheckedStr.boolValue;
                        [self addAWantLabourThing:[[ADNewLabourThing alloc] initWithName:content
                                                                                  reason:@""
                                                                         recommendCntStr:count
                                                                          recommentScore:@""
                                                                               kindTitle:title
                                                                                 haveBuy:isChecked]];
                        //                    NSLog(@"add once");
                    }
                    
//                    [self syncClientRecordTime];
                    
                    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
                    [self removeDuplicateWithObject:[ADNewLabourThing objectsWithPredicate:predicate]];
                    
                    
                    DISPATCH_ON_MAIN_THREAD(^{
                        if (getDataBlock) {
                            getDataBlock(nil);
                        }
                    });
                    
                    [self uploadAllDataOnFinish:finishBlock];
                }));
            }];
        } else {
            //        //compare sync and local time
            
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
        [ADInLabourSyncManager uploadData:aRes onFinish:^(NSDictionary *res, NSError *error) {
            NSString *serverTime = [NSString stringWithFormat:@"%@", res[@"predeliveryBagSyncTime"]];
            [ADUserSyncMetaHelper syncServerRecordTime:serverTime andSyncKey:predeliveryBagKey];
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

@end
