//
//  ADUserSyncMetaHelper.m
//  PregnantAssistant
//
//  Created by D on 15/5/6.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADUserSyncMetaHelper.h"
#import "AFNetworking.h"
#import "ADUserSyncTimeDAO.h"

@implementation ADUserSyncMetaHelper

+ (void)getSyncDataOnFinish:(void (^)(NSDictionary *res, NSError *err))aFinishBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *oAuth = [[NSUserDefaults standardUserDefaults]addingToken];
    
    NSDictionary *parameters = @{@"oauth_token":oAuth};
    [manager POST:[NSString stringWithFormat:@"http://%@/pregnantAssistantSync/getSyncMeta", baseApiUrl]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (aFinishBlock) {
                  aFinishBlock(responseObject, nil);
              }
              //NSLog(@"服务器同步时间 : %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if (aFinishBlock) {
                  aFinishBlock(nil, error);
              }
          }];
}

//服务器 返回结果
+ (void)is_severDataTimeLater_syncKey:(NSString *)aSyncKey
                             onFinish:(void (^)(BOOL later, NSString *severStr))aFinishBlock
{
    //本地服务器同步时间
    NSString *L_S_dateStr = [self getToolSyncStrDateWithSyncName:aSyncKey];
    
//    __block NSDate *server_date = nil;
    __block NSString *server_dateStr = @"";
    
    [self getSyncDataOnFinish:^(NSDictionary *res, NSError *err) {
        //NSLog(@"time res:%@", res);
        
        if (aFinishBlock) {
            if (err == nil) {
                //服务器时间
                server_dateStr = [NSString stringWithFormat:@"%@", res[aSyncKey]];
                //NSLog(@"%@ 的同步时间 : %@",aSyncKey, server_dateStr);
                
//                NSLog(@"本地时间%@, 服务器时间%@",client_date,server_date);
                [self syncServerRecordTime:server_dateStr andSyncKey:aSyncKey];
                
                NSLog(@"server:%@ client:%@",server_dateStr, L_S_dateStr);
                if ([L_S_dateStr isEqualToString:server_dateStr]) {
                    aFinishBlock(NO, nil);
                } else if (server_dateStr.integerValue > L_S_dateStr.integerValue /*|| client_dateStr.length == 0*/) {
                    NSLog(@"rt yes");
                    aFinishBlock(YES, server_dateStr);
                } else {
                    NSLog(@"rt no");
                    aFinishBlock(NO, nil);
                }
            } else {
                aFinishBlock(NO, nil);
            }
        }
    }];
}


+ (void)isNeedSynsDataWithSyncKey:(NSString *)aSyncKey complete:(void (^)(bool isNeed))complete{
    NSString *local_C_timer = [self getToolModifyTimeSpWithSyncName:aSyncKey];
    NSString *local_S_timer = [self getToolSyncStrDateWithSyncName:aSyncKey];
    if(local_C_timer.integerValue >= local_S_timer.integerValue){
        if (complete) {
            complete(YES);
        }
    }else{
        if (complete) {
            complete(NO);
        }
    }
}

//+ (void)isHaveUnSyncDataOnFinish:(void (^)(BOOL))aFinishBlock
//{
//    NSArray *allKey = [self allSyncToolKey];
//    
//    if (aFinishBlock) {
//        
//        for (NSString *aKey in allKey) {
//            NSString *client_dateStr = [self getToolModifyTimeSpWithSyncName:aKey];
//            NSString *server_dateStr = [self getToolSyncStrDateWithSyncName:aKey];
//            //                NSDate *server_date = [NSDate dateWithTimeIntervalSince1970:server_dateStr.integerValue];
////            [self syncServerRecordTime:server_dateStr andSyncKey:aKey];
//            
//            //                if ([server_date isLaterThanDate:client_date] || client_date == nil) {
//            if (server_dateStr.integerValue > client_dateStr.integerValue || client_dateStr.length == 0) {
//                aFinishBlock(YES);
//                return;
//            }
//        }
//        aFinishBlock(NO);
//    }
//
////    [self getSyncDataOnFinish:^(NSDictionary *res, NSError *err) {
////        //NSLog(@"time res:%@", res);
////        if (aFinishBlock && err == nil) {
////            
////            for (NSString *aKey in allKey) {
////                NSString *client_dateStr = [self getToolModifyTimeSpWithSyncName:aKey];
////                NSString *server_dateStr = [NSString stringWithFormat:@"%@", res[aKey]];
//////                NSDate *server_date = [NSDate dateWithTimeIntervalSince1970:server_dateStr.integerValue];
////                [self syncServerRecordTime:server_dateStr andSyncKey:aKey];
////                
//////                if ([server_date isLaterThanDate:client_date] || client_date == nil) {
////                if (server_dateStr.integerValue > client_dateStr.integerValue || client_dateStr.length == 0) {
////                    aFinishBlock(YES);
////                    return;
////                }
////            }
////            aFinishBlock(NO);
////        }
////    }];
//}

+ (NSArray *)allSyncToolKey
{
    return @[
             checkCareCalendarKey,
             checkArichveKey,
             fetalMovementKey,
             motherDiaryKey,
             predeliveryBagKey,
             pregDiaryKey,
             uterineContractionKey,
             toolsCollectionKey,
             userInfoTimeKey,
             vaccineSyncTimeKey,
             heightWeightSyncTimeKey
             ];
}

+ (NSDate *)getToolSyncDateWithSyncName:(NSString *)aToolName
{
    NSString *time = [self getToolSyncStrDateWithSyncName:aToolName];
    if (time.length == 0) {
        return nil;
    } else {
        return [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    }
}

+ (NSString *)getToolSyncStrDateWithSyncName:(NSString *)aToolName
{
    ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
    
    NSString *time = nil;
    if ([aToolName isEqualToString:checkCareCalendarKey]) {
        time = aRecord.s_antenatalCareCalendar_MTime;
    }
    if ([aToolName isEqualToString:checkArichveKey]) {
        time = aRecord.s_antenatalCareRecord_MTime;
    }
    if ([aToolName isEqualToString:fetalMovementKey]) {
        time = aRecord.s_fetalMovement_MTime;
    }
    if ([aToolName isEqualToString:motherDiaryKey]) {
        time = aRecord.s_motherDiary_MTime;
    }
    if ([aToolName isEqualToString:predeliveryBagKey]) {
        time = aRecord.s_predeliveryBag_MTime;
    }
    if ([aToolName isEqualToString:pregDiaryKey]) {
        time = aRecord.s_pregDiary_MTime;
    }
    if ([aToolName isEqualToString:toolsCollectionKey]) {
        time = aRecord.s_toolsCollection_MTime;
    }
    if ([aToolName isEqualToString:userInfoTimeKey]) {
        time = aRecord.s_userInfo_MTime;
    }
    if ([aToolName isEqualToString:uterineContractionKey]) {
        time = aRecord.s_uterineContraction_MTime;
    }
    if ([aToolName isEqualToString:vaccineSyncTimeKey]) {
        time = aRecord.s_vaccineSync_MTime;
    }
    if ([aToolName isEqualToString:heightWeightSyncTimeKey]) {
        time = aRecord.s_heightWeightSync_MTime;
    }
    
    return time;
}

+ (NSString *)getToolModifyTimeSpWithSyncName:(NSString *)aToolName
{
    ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
    
    NSString *time = nil;
    if ([aToolName isEqualToString:checkCareCalendarKey]) {
        time = aRecord.c_antenatalCareCalendar_MTime;
    }
    if ([aToolName isEqualToString:checkArichveKey]) {
        time = aRecord.c_antenatalCareRecord_MTime;
    }
    if ([aToolName isEqualToString:fetalMovementKey]) {
        time = aRecord.c_fetalMovement_MTime;
    }
    if ([aToolName isEqualToString:motherDiaryKey]) {
        time = aRecord.c_motherDiary_MTime;
    }
    if ([aToolName isEqualToString:predeliveryBagKey]) {
        time = aRecord.c_predeliveryBag_MTime;
    }
    if ([aToolName isEqualToString:pregDiaryKey]) {
        time = aRecord.c_pregDiary_MTime;
    }
    if ([aToolName isEqualToString:toolsCollectionKey]) {
        time = aRecord.c_toolsCollection_MTime;
    }
    if ([aToolName isEqualToString:userInfoTimeKey]) {
        time = aRecord.c_userInfo_MTime;
    }
    if ([aToolName isEqualToString:uterineContractionKey]) {
        time = aRecord.c_uterineContraction_MTime;
    }
    if ([aToolName isEqualToString:vaccineSyncTimeKey]) {
        time = aRecord.c_vaccineSync_MTime;
    }
    if ([aToolName isEqualToString:heightWeightSyncTimeKey]) {
        time = aRecord.c_heightWeight_MTime;
    }
    
    if (time.integerValue == 0) {
        return nil;
    } else {
        return time;
    }
}



+ (void)syncServerRecordTime:(NSString *)aTime
                  andSyncKey:(NSString *)aSyncKey
{
    ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    if ([aSyncKey isEqualToString:checkCareCalendarKey]) {
        aRecord.s_antenatalCareCalendar_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:checkArichveKey]) {
        aRecord.s_antenatalCareRecord_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:fetalMovementKey]) {
        aRecord.s_fetalMovement_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:motherDiaryKey]) {
        aRecord.s_motherDiary_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:predeliveryBagKey]) {
        aRecord.s_predeliveryBag_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:pregDiaryKey]) {
        aRecord.s_pregDiary_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:toolsCollectionKey]) {
        aRecord.s_toolsCollection_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:userInfoTimeKey]) {
        aRecord.s_userInfo_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:uterineContractionKey]) {
        aRecord.s_uterineContraction_MTime = aTime;
    }
    
    if ([aSyncKey isEqualToString:vaccineSyncTimeKey]) {
        aRecord.s_vaccineSync_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:heightWeightSyncTimeKey]) {
        aRecord.s_heightWeightSync_MTime = aTime;
    }
    
    [realm commitWriteTransaction];
}

+ (void)syncClientRecordTimeByToolKey:(NSString *)aSyncKey
{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    [self syncClientRecordTime:timeSp andSyncKey:aSyncKey];

}

+ (void)syncClientRecordTime:(NSString *)aTime
                  andSyncKey:(NSString *)aSyncKey
{
    ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    if ([aSyncKey isEqualToString:checkCareCalendarKey]) {
        aRecord.c_antenatalCareCalendar_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:checkArichveKey]) {
        aRecord.c_antenatalCareRecord_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:fetalMovementKey]) {
        aRecord.c_fetalMovement_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:motherDiaryKey]) {
        aRecord.c_motherDiary_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:predeliveryBagKey]) {
        aRecord.c_predeliveryBag_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:pregDiaryKey]) {
        aRecord.c_pregDiary_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:toolsCollectionKey]) {
        aRecord.c_toolsCollection_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:userInfoTimeKey]) {
        aRecord.c_userInfo_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:uterineContractionKey]) {
        aRecord.c_uterineContraction_MTime = aTime;
    }
    
    if ([aSyncKey isEqualToString:vaccineSyncTimeKey]) {
        aRecord.c_vaccineSync_MTime = aTime;
    }
    if ([aSyncKey isEqualToString:heightWeightSyncTimeKey]) {
        aRecord.c_heightWeight_MTime = aTime;
    }
    
    [realm commitWriteTransaction];
}



@end
