//
//  ADFavVideoManager.m
//  PregnantAssistant
//
//  Created by D on 15/2/3.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADMomLookDAO.h"

@implementation ADMomLookDAO

+ (void)saveMomLookContent:(ADMomContentInfo *)aInfo
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    ADMomLookSaveContent *aContent = [[ADMomLookSaveContent alloc]initWithInfo:aInfo];
    NSLog(@"content: %@", aContent);
    for (int i = 0; i < aInfo.imgUrls.count; i++) {
        [realm beginWriteTransaction];
        ADMomLookImage *aImage = [[ADMomLookImage alloc]initWithUrl:aInfo.imgUrls[i]];
        [realm addObject:aImage];
        
        [realm commitWriteTransaction];
        [aContent.images addObject:aImage];
    }
    
    [realm beginWriteTransaction];
    
    //NSLog(@"aInfo:%@", aInfo);
    [realm addObject:aContent];
    
    [realm commitWriteTransaction];
}

+ (void)delMomLookContent:(ADMomContentInfo *)aInfo
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    ADMomLookSaveContent *aContent = [[ADMomLookSaveContent alloc]initWithInfo:aInfo];
    for (int i = 0; i < aInfo.imgUrls.count; i++) {
        [realm beginWriteTransaction];
        
        ADMomLookImage *aImage = [[ADMomLookImage alloc]initWithUrl:aInfo.imgUrls[i]];
        [realm addObject:aImage];
        
        [realm commitWriteTransaction];
        [aContent.images addObject:aImage];
    }

    [realm beginWriteTransaction];
    [realm deleteObject:aContent];
    [realm commitWriteTransaction];
}

+ (RLMResults *)getSyncMomLookData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"uid == %@ and collectId != 0",uid];
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"uid = %@", uid];
    RLMResults *res = [[ADMomLookSaveContent objectsWithPredicate:pred]
                       sortedResultsUsingProperty:@"collectId" ascending:NO];
//    NSLog(@"res: %@", res);
    return res;
}

+ (void)deleteCollectedContentWithCollectId:(NSString *)aCollectId
{
//    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    
    NSString *action = [NSString stringWithFormat:@"adding://adco/content?contentId=%@", aCollectId];
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"action == %@", action];
    
    NSLog(@"pred: %@", action);
    RLMResults *contents = [ADMomLookSaveContent objectsWithPredicate:pred];
    if (contents.count > 0) {
        
        NSLog(@"delete collect look %@",action);
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm beginWriteTransaction];
        
        [realm deleteObjects:contents];
        
        [realm commitWriteTransaction];
    }
}
//+ (RLMResults *)getSyncMomLookDataAtLoc:(NSInteger)aLoc andLength:(NSInteger)aLength
//{
//    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"uid == %@ and collectId != 0",uid];
//
//    RLMResults *res = [[ADMomLookSaveContent objectsWithPredicate:pred]
//                       sortedResultsUsingProperty:@"collectId" ascending:NO];
//    
//    return res;
//}

+ (RLMResults *)getAllMomLookContent
//+ (RLMResults *)getAllMomLookContentAtLoc:(NSInteger)aLoc andLength:(NSInteger)aLength
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"uid = %@",uid];
    [self removeDuplicateWithObject:[ADMomLookSaveContent allObjects]];
    return [[ADMomLookSaveContent objectsWithPredicate:pred]
            sortedResultsUsingProperty:@"collectId" ascending:NO];
}

+ (void)removeDuplicateWithObject:(RLMResults *)aRes
{
//    NSLog(@"aRes: %@", aRes);
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    NSMutableArray *toRemove = [NSMutableArray array];
    for (int i = 0; i < aRes.count; i++) {
        ADMomLookSaveContent *aData = aRes[i];
        for (int j = i +1; j < aRes.count; j++) {
            ADMomLookSaveContent *nextData = aRes[j];
            //            NSLog(@"aData:%@ nData:%@", aData, nextData);
            if ([aData.action isEqual:nextData.action]) {
//                NSLog(@"real delte one");
                [toRemove addObject:nextData];
            }
        }
    }
    
    [realm deleteObjects:toRemove];
    [realm commitWriteTransaction];
}

+ (RLMResults *)getUnSyncMomLookContent
{
    return [[ADMomLookSaveContent allObjects]sortedResultsUsingProperty:@"saveDate" ascending:NO];
//    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"uid = %@",uid];
//    NSLog(@"res %@", [ADMomLookSaveContent objectsWithPredicate:pred]);
//    return [[ADMomLookSaveContent objectsWithPredicate:pred]sortedResultsUsingProperty:@"saveDate" ascending:NO];
}

//判断咨询内容是否已经收藏过
+ (BOOL)isHasCollected:(NSString *)action
{
    if (action.length == 0) {
        return NO;
    }
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"action = %@ AND uid = %@", action, uid];
    NSLog(@"res %@", [ADMomLookSaveContent objectsWithPredicate:pred]);
    RLMResults *contents = [ADMomLookSaveContent objectsWithPredicate:pred];
    
    if (contents.count > 0) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)getCollectIdWithAction:(NSString *)action
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"action = %@ AND uid = %@", action, uid];
    RLMResults *contents = [ADMomLookSaveContent objectsWithPredicate:pred];
    NSLog(@"res %@", contents);
    
    if (contents.count > 0) {
        ADMomLookSaveContent *aData = contents[0];
        return [NSString stringWithFormat:@"%ld", (long)aData.collectId];
    }
    return 0;
}

//删除收藏的咨询内容
+ (void)deleteCollectedContent:(NSString *)action
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"action = %@", action];
    RLMResults *contents = [ADMomLookSaveContent objectsWithPredicate:pred];
    if (contents.count > 0) {
        
        NSLog(@"delete collect look %@",action);
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm beginWriteTransaction];
        
        [realm deleteObjects:contents];
        
        [realm commitWriteTransaction];
    }
    
//    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"action = %@ AND uid = %@", action, uid];
//    RLMResults *contents = [ADMomLookSaveContent objectsWithPredicate:pred];
//    if (contents.count > 0) {
//        RLMRealm *realm = [RLMRealm defaultRealm];
//        [realm beginWriteTransaction];
//        [realm deleteObjects:contents];
//        [realm commitWriteTransaction];
//    }
}

+ (void)changeCollectId:(NSString *)aCid withAction:(NSString *)action
{
//    NSLog(@"change: %@", aCid);
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"action = %@ AND uid = %@", action, uid];
    RLMResults *contents = [ADMomLookSaveContent objectsWithPredicate:pred];
    if (contents.count > 0) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        ADMomLookSaveContent *aContent = contents[0];
        aContent.collectId = aCid.integerValue;
        [realm commitWriteTransaction];
    }
}

+ (void)deleteAllLocalCollect
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *res = [self getUnSyncMomLookContent];
    [realm beginWriteTransaction];
    [realm deleteObjects:res];
    [realm commitWriteTransaction];
}

+ (void)updateMomLookContent:(ADMomContentInfo *)aInfo andCollectId:(NSString *)aCid
{
    //没有 添加 有 改 collectId
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"action = %@ AND uid = %@", aInfo.action, uid];
    RLMResults *contents = [ADMomLookSaveContent objectsWithPredicate:pred];

    if (contents.count > 0) {
        [self changeCollectId:aCid withAction:aInfo.action];
    } else {
        [self saveMomLookContent:aInfo];
    }
}

+ (void)delMomLookContentWithStartCollectId:(NSInteger)aStartIdx andLength:(NSInteger)length
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"uid = %@ and collectId != 0",uid];
    RLMResults *contents = [[ADMomLookSaveContent objectsWithPredicate:pred]
                            sortedResultsUsingProperty:@"collectId" ascending:NO];

    if (length > contents.count) {
        length = contents.count;
    }

    if (aStartIdx >= contents.count) {
        return;
    }
    
    NSLog(@"del idx: %ld length: %ld", (long)aStartIdx, (long)length);
    for (NSInteger i = aStartIdx; i < length;) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:contents[i]];
        [realm commitWriteTransaction];
        length--;
    }
}

+ (void)updateMomLookContentWithStartCollectId:(NSInteger)aStartIdx
                                     andLength:(NSInteger)length
                                   andContents:(NSArray *)contents
{
    NSLog(@"start: %ld length: %ld", (long)aStartIdx, (long)length);
    [self delMomLookContentWithStartCollectId:aStartIdx andLength:length];

    for (int i = 0; i < contents.count; i++) {
        [self saveMomLookContent:contents[i]];
    }
}

+ (void)distrubuteData
{
//    DISPATCH_ON_GLOBAL_QUEUE_DEFAULT((^{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    NSPredicate *unSyncPre = [NSPredicate predicateWithFormat:@"uid = '0'"];
    RLMResults *unSyncRes = [ADMomLookSaveContent objectsWithPredicate:unSyncPre];
    //    NSLog(@"un res:%@ cnt:%lu", unSyncRes, (unsigned long)unSyncRes.count);
    NSPredicate *allPre = [NSPredicate predicateWithFormat:@"uid = %@", uid];
    
    RLMResults *allRes = [ADMomLookSaveContent objectsWithPredicate:allPre];
    for (int i = 0; i < unSyncRes.count;) {
        ADMomLookSaveContent *aUnSyncData = unSyncRes[i];
        for (int j = 0; j < allRes.count; j++) {
            
            NSLog(@"cur i:%d j:%d", i, j);
            ADMomLookSaveContent *aData = allRes[j];
            if ([aUnSyncData.action isEqualToString:aData.action]) {
                //不继续比较
                i++;
//                    break;
            } else {
                //比较 到 最后
                if (j == allRes.count -1) {
                    [realm beginWriteTransaction];
                    aUnSyncData.uid = uid;
                    [realm commitWriteTransaction];
                }
            }
        }
    }
    
    [realm beginWriteTransaction];
    [realm deleteObjects:unSyncRes];
    [realm commitWriteTransaction];
//    }))
}

+ (RLMResults *)searchLocalDataWithString:(NSString *)aString
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"uid = %@ AND title contains %@", uid, aString];
//    return [res objectsWhere:@"title contains %@",aString];
    return [ADMomLookSaveContent objectsWithPredicate:pre];
}

+ (RLMResults *)searchSyncDataWithString:(NSString *)aString
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"uid = %@ AND collectId != 0 AND title contains %@", uid, aString];
    return [ADMomLookSaveContent objectsWithPredicate:pre];
}

+ (RLMResults *)searchUnSyncDataWithString:(NSString *)aString
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"uid = %@ AND collectId = 0 AND title contains %@", uid, aString];
    return [ADMomLookSaveContent objectsWithPredicate:pre];
}

@end
