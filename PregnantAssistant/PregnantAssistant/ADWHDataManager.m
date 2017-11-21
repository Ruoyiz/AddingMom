//
//  ADWHDataManager.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/5/27.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADWHDataManager.h"
#import "ADWeightHeightModel.h"
#import "ADSyncToolTime.h"
#import "ADWeightHeightNetManager.h"
#import "ADUserSyncTimeDAO.h"

@interface ADWHDataManager (){

    NSMutableArray *_dataArray;
}

@end

@implementation ADWHDataManager

+ (ADWeightHeightModel *)readFirstModel{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",
                              uid];
    RLMResults *resultsModel = [ADWeightHeightModel objectsWithPredicate:predicate];
    if (!resultsModel.count) {
        return nil;
    }
    return [resultsModel firstObject];
}

+ (ADWeightHeightModel *)readSecendModel{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",
                              uid];
    RLMResults *resultsModel = [ADWeightHeightModel objectsWithPredicate:predicate];
    if (resultsModel.count < 2) {
        return nil;
    }
    return resultsModel[1];
}


+ (RLMResults *)readAllModel{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",
                              uid];
    return [ADWeightHeightModel objectsWithPredicate:predicate];
}

+ (void)sortModelData{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",
                              uid];
    NSMutableArray *sortArray = [NSMutableArray array];
    NSArray *tempArray = [NSArray array];
    RLMResults *resultsModel = [ADWeightHeightModel objectsWithPredicate:predicate];
    if (resultsModel.count) {
        for (ADWeightHeightModel *model in resultsModel) {
            [sortArray addObject:model];
        }
        tempArray = [self sortArrayWithArray:sortArray];
    }
    
    if (tempArray.count) {
        [self updateDateWithdateArray:tempArray];
    }
}

#pragma mark - sync method
//+ (void)syncClientRecordTime
//{
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
//    [self syncClientRecordTimeWithTimeSp:timeSp];
//}
//
//+ (void)syncClientRecordTimeWithTimeSp:(NSString *)aTimeSp
//{
//    ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
//    
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    
//    [realm beginWriteTransaction];
//    
//    if ([aTimeSp integerValue] > [aRecord.c_heightWeight_MTime integerValue]) {
//        aRecord.c_heightWeight_MTime = aTimeSp;
//    }
//    
//    [realm commitWriteTransaction];
//}
//+ (void)syncLocalServerseTimeWithTimeSp: (NSString *)aTimeSp{
//
//    ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    [realm beginWriteTransaction];
//    if ([aTimeSp integerValue] > [aRecord.s_heightWeightSync_MTime integerValue]) {
//        aRecord.s_heightWeightSync_MTime = aTimeSp;
//    }
//    [realm commitWriteTransaction];
//
//}

+ (void)updateDateWithdateArray:(NSArray *)dateArray{
    
    NSMutableArray *copyArray = [[NSMutableArray alloc] init];
    for (ADWeightHeightModel *model in dateArray) {
        NSDictionary *dic = @{@"time":model.time,@"height":model.height,@"weight":model.weight,@"uid":model.uid};
        ADWeightHeightModel *aModel = [ADWeightHeightModel statusWithDictionary:dic];
        [copyArray addObject:aModel];
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:dateArray];
    [realm addObjects:copyArray];
    [realm commitWriteTransaction];
//    [self syncClientRecordTime];
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:heightWeightSyncTimeKey];

}



+ (void)saveWhDataWithDic:(NSDictionary *)dic{
    ADWeightHeightModel *model = [ADWeightHeightModel statusWithDictionary:dic];
    [self deleteModelWithCreatDate:[NSDate dateWithTimeIntervalSince1970:[model.time doubleValue]]];//判断是否有同一天的，有则去掉
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:model];
    [realm commitWriteTransaction];
    [self sortModelData];
}

+ (void)deleteModelArrayWithResultArray:(RLMResults *)ResultArray{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:ResultArray];
    [realm commitWriteTransaction];
 
}

+ (void)deleteModelWithCreatDate:(NSDate *)date{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    NSMutableArray *toRemoveArray = [[NSMutableArray alloc] init];

    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults *res = [ADWeightHeightModel objectsWithPredicate:predicate];
    for (ADWeightHeightModel *model in res) {
        NSDate *anotherDate =[NSDate dateWithTimeIntervalSince1970:[model.time doubleValue]];//oldTime
        if ([date isSameDayMonthYearsAdDate:anotherDate])
        {
            [toRemoveArray addObject:model];
        }
    }
    [realm deleteObjects:toRemoveArray];
    
    [realm commitWriteTransaction];
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:heightWeightSyncTimeKey];
    
}

+ (NSArray *)sortArrayWithArray:(NSArray *)array{
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
    if (mArray.count < 2) {
        return mArray;
    }
    for (int i = 0; i < array.count -1; i ++) {
        for (int j = 0; j < array.count - 1 - i; j++) {
            ADWeightHeightModel *model1 = mArray[j];
            ADWeightHeightModel *model2 = mArray[j + 1];
            if([model1.time intValue] < [model2.time intValue]){
                [mArray exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            };
        }
    }
    return mArray;
}

+ (void)distrubuteData{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == '0'"];
    RLMResults *resultsModel = [ADWeightHeightModel objectsWithPredicate:predicate];
    
    if (resultsModel.count) {
        for (ADWeightHeightModel *model in resultsModel) {
            if([self isSaveNoUserWhModeWithModel:model]){
                NSDictionary *dic = @{@"time":model.time, @"height":model.height,@"weight":model.weight,@"uid":uid};
                [self saveWhDataWithDic:dic];
            };
        }
        [self deleteModelArrayWithResultArray:resultsModel];
    }
    
    //合并但是不记录时间
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"uid == %@",
                              uid];
    NSMutableArray *sortArray = [NSMutableArray array];
    NSArray *tempArray = [NSArray array];
    RLMResults *resultsModel1 = [ADWeightHeightModel objectsWithPredicate:predicate1];
    if (resultsModel1.count) {
        for (ADWeightHeightModel *model in resultsModel1) {
            [sortArray addObject:model];
        }
        tempArray = [self sortArrayWithArray:sortArray];
    }
    
    if (tempArray.count) {
        [self updateDateWithdateArray:tempArray];
    }
}

+ (BOOL)isSaveNoUserWhModeWithModel:(ADWeightHeightModel *)noUserModel{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",
                              uid];
    RLMResults *results = [ADWeightHeightModel objectsWithPredicate:predicate];
    for (ADWeightHeightModel *userModel in results) {
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[userModel.time doubleValue]];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[noUserModel.time doubleValue]];
        if ([date1 isSameDayMonthYearsAdDate:date2]) {
            return NO;
        }
    }
    return YES;
}


+ (void)needUploadOrDownloadComplete:(void(^)(BOOL isNeedDownload))complete{
    NSString *token = [NSUserDefaults standardUserDefaults].addingToken;
    if ([token isEqualToString:@""]) {
        if (complete) {
            complete(NO);
        }
        return;
    }
    
    [ADUserSyncMetaHelper is_severDataTimeLater_syncKey:heightWeightSyncTimeKey onFinish:^(BOOL later, NSString *severStr) {
        if (later) {
            if (complete) {
                complete(YES);
            }
        }else{
            if (complete) {
                complete(NO);
            }
        }
    }];
}


+ (void)syncAllDataOnGetData:(void(^)(BOOL iscomplete))getDataBlock
              getDataFailure:(void (^)(NSError *))getDateFailure
             onUploadProcess:(void(^)(BOOL iscomplete))processBlock
               uploadFailure:(void (^)(NSError *))failure
                      noNeed:(void(^)(bool netWork))noNeed
{
    [self needUploadOrDownloadComplete:^( BOOL isNeedDownload) {
        if (isNeedDownload/*下载*/) {
            [ADWeightHeightNetManager getHeightWidthDataOnFinish:^(NSArray *responseArray)
             {
                 NSLog(@"responseArray == %@",responseArray);
                 for (NSDictionary *dict in responseArray) {
                     [ADWHDataManager saveWhDataWithDic:dict];
                 }
                 [ADWHDataManager sortModelData];
                 if (getDataBlock) {
                     getDataBlock(YES);
                 }
                 NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",
                                           uid];
                 RLMResults *results = [ADWeightHeightModel objectsWithPredicate:predicate];
                 [ADWeightHeightNetManager uploadHeightWidthData:results onFinish:^(NSDictionary *res, NSError *error) {
                     if (res[@"result"]) {
                         [ADUserSyncMetaHelper syncServerRecordTime:[NSString stringWithFormat:@"%@",res[@"heightWeightSyncTime"]]
                                                         andSyncKey:heightWeightSyncTimeKey];
                         
                     }
                 }failure:^(NSError *error) {
                     if (failure) {
                         failure(error);
                     }
                 }];
             }failer:^(NSError *error) {
                 if (getDateFailure) {
                     getDateFailure(error);
                 }
             }];
        }else{
            NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",
                                      uid];
            RLMResults *results = [ADWeightHeightModel objectsWithPredicate:predicate];
            
            [ADWeightHeightNetManager uploadHeightWidthData:results onFinish:^(NSDictionary *res, NSError *error) {
                if (res[@"result"]) {
                    [ADUserSyncMetaHelper syncServerRecordTime:[NSString stringWithFormat:@"%@",res[@"heightWeightSyncTime"]]
                                                    andSyncKey:heightWeightSyncTimeKey];
                    if (processBlock) {
                        processBlock(YES);
                    }
                }
            }failure:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
            
        }
        
    }];
}

@end
