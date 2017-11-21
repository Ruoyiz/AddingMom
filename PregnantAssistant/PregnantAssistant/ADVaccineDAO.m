//
//  ADVaccineDAO.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/8.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADVaccineDAO.h"
#import "ADSyncToolTime.h"
#import "ADUserSyncTimeDAO.h"
#import "ADUserSyncMetaHelper.h"
#import "AFNetworking.h"

@implementation ADVaccineDAO

+ (void)addAllVaccineFromVaccineArray:(NSArray *)array
{
    for (ADVaccine *model in array) {
        [self addVaccine:model];
    }
    
    //更新本地同步时间
    //[self syncClientRecordTimeForVaccine];
}

+ (void)addVaccine:(ADVaccine *)model
{
    RLMRealm *realm=[RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    [realm addObject:model];
    
    [realm commitWriteTransaction];
}

+ (void)modifyVaccine:(ADVaccine *)model collect:(NSString *)collect success:(void (^) (ADVaccine *newModel))success
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND vaccineName == %@",uid,model.vaccineName];
    
    RLMResults *aRes = [ADVaccine objectsWithPredicate:predicate];
    if (aRes.count == 1) {
        ADVaccine *aModel = [aRes firstObject];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        aModel.isCollected = collect;
        
        if ([collect isEqualToString:@"0"]) {
            aModel.haveVaccinated = @"0";
            aModel.noteDateStamp = @"0";
            aModel.vaccindateDateStamp = @"0";
            [self removeNotificationWithName:aModel.vaccineName];
        }
        
        [realm commitWriteTransaction];
        
        //更新本地同步时间
        [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:vaccineSyncTimeKey];
        
        if (success) {
            success (aModel);
        }
    }else{
        NSLog(@"查询疫苗出现问题%ld",(long)aRes.count);
    }
}

//更改接种状态
+ (void)modifyVaccine:(ADVaccine *)model vaccindate:(NSString *)vaccindate
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND vaccineName == %@",uid,model.vaccineName];
    
    RLMResults *aRes = [ADVaccine objectsWithPredicate:predicate];
    if (aRes.count == 1) {
        ADVaccine *aModel = [aRes firstObject];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        aModel.haveVaccinated = vaccindate;
        [realm commitWriteTransaction];
        
        //更新本地同步时间
        [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:vaccineSyncTimeKey];
    }else{
        NSLog(@"查询疫苗出现问题%ld",(long)aRes.count);
    }
}

//更改接种时间
+ (void)modifyVaccine:(ADVaccine *)model vaccindeStamp:(NSString *)vaccindateStamp
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND vaccineName == %@",uid,model.vaccineName];
    
    ADAppDelegate *myApp = APP_DELEGATE;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:vaccindateStamp.integerValue];
    NSInteger days = [date daysAfterDate:myApp.babyBirthday];
    
    NSString *str = [NSString stringWithFormat:@"%04ld%02ld",(long)days / 30, (long)days % 30];
    RLMResults *aRes = [ADVaccine objectsWithPredicate:predicate];
    
    if (aRes.count == 1) {
        
        ADVaccine *aModel = [aRes firstObject];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        aModel.vaccindateDateStamp = vaccindateStamp;
        aModel.vaccindateDateStr = str;
        [realm commitWriteTransaction];
        
        //更新本地同步时间
        [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:vaccineSyncTimeKey];
        
    }else{
        NSLog(@"查询疫苗出现问题%ld",(long)aRes.count);
    }
}

+ (void)modifyVaccine:(ADVaccine *)model noteDate:(NSString *)noteDate
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND vaccineName == %@",uid,model.vaccineName];
    
    RLMResults *aRes = [ADVaccine objectsWithPredicate:predicate];
    if (aRes.count == 1) {
        ADVaccine *aModel = [aRes firstObject];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        aModel.noteDateStamp = noteDate;
        [realm commitWriteTransaction];
        
        //更新本地同步时间
        [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:vaccineSyncTimeKey];
    }else{
        NSLog(@"查询疫苗出现问题%ld",(long)aRes.count);
    }
}

+ (void)modifyOldVaccineToCollectWithModel:(ADVaccine *)model
{
    NSLog(@"合并野疫苗数据 %@",model.vaccineName);
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND vaccineName == %@",uid,model.vaccineName];
    
    RLMResults *aRes = [ADVaccine objectsWithPredicate:predicate];
    if (aRes.count == 1) {
        ADVaccine *aModel = [aRes firstObject];
        if ([aModel.isCollected isEqualToString:@"0"]) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            aModel.isCollected = @"1";
            aModel.isCollected = @"1";
            aModel.haveVaccinated = model.haveVaccinated;
            aModel.vaccindateDateStamp = model.vaccindateDateStamp;
            aModel.vaccindateDateStr = model.vaccindateDateStr;
            aModel.noteDateStamp = model.noteDateStamp;
            aModel.vaccineOverDue = model.vaccineOverDue;
            [realm commitWriteTransaction];
        }        
    }else{
        NSLog(@"查询疫苗出现问题%ld",(long)aRes.count);
    }
}

+ (void)modifyVaccineWithServerData:(NSDictionary *)dic
{
    NSString *name = [dic objectForKey:@"vaccineName"];
    
    //NSLog(@"new %@",name);
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND vaccineName == %@",uid,name];
    
    RLMResults *aRes = [ADVaccine objectsWithPredicate:predicate];
    if (aRes.count == 1) {
        ADVaccine *aModel = [aRes firstObject];
        RLMRealm *realm = [RLMRealm defaultRealm];
        NSString *notiTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"noteTime"]];
        NSString *vaccindateStamp = [NSString stringWithFormat:@"%@",[dic objectForKey:@"innoculationTime"]];
        [realm beginWriteTransaction];
        
        aModel.vaccindateDateStamp = vaccindateStamp;
        aModel.noteDateStamp = notiTime;
        
        aModel.isCollected = @"1";
        NSString *status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        
        if ([status isEqualToString:@"1"]) {
            aModel.haveVaccinated = @"0";
        }else{
            aModel.haveVaccinated = @"1";
        }
        
        [realm commitWriteTransaction];
        
        //NSLog(@"%@,%@,%@",name,notiTime,vaccindateStamp);
        if (![notiTime isEqualToString:@"0"] && ![vaccindateStamp isEqualToString:@"0"]) {
            NSInteger time = [notiTime integerValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
            
            NSDate *vaccinteDate = [NSDate dateWithTimeIntervalSince1970:[vaccindateStamp integerValue]];
            
            NSDateFormatter *forrmatter = [[NSDateFormatter alloc] init];
            [forrmatter setDateFormat:@"MM月dd日"];
            NSString *dateStr = [forrmatter stringFromDate:vaccinteDate];
            NSString *str = [NSString stringWithFormat:@"别忘了%@去打疫苗",dateStr];
            [ADVaccineDAO addANotificationWithName:name noteDate:date noteTitle:str];
        }
    }else{
        NSLog(@"查询疫苗出现问题%ld",(long)aRes.count);
    }
    
}

+ (NSMutableArray *)readAllExpenseVaccine
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND vaccineTag == %@",uid,@"自费"];
    
    RLMResults *aRes = [ADVaccine objectsWithPredicate:predicate];
    NSMutableArray *array = [NSMutableArray array];
    for (ADVaccine *model in aRes) {
        [array addObject:model];
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"vaccindateDateStr" ascending:YES]];
    [array sortUsingDescriptors:sortDescriptors];
    
    return array;
}

+ (NSMutableArray *)readAllVaccineCollected:(NSString *)collect
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND isCollected == %@",uid,collect];
    
    RLMResults *aRes = [ADVaccine objectsWithPredicate:predicate];
    NSMutableArray *array = [NSMutableArray array];
    for (ADVaccine *model in aRes) {
        [array addObject:model];
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"vaccindateDateStr" ascending:YES]];
    [array sortUsingDescriptors:sortDescriptors];

    return array;
}

+ (ADVaccine *)getWuLianVaccine
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND vaccineName == %@",uid,@"五联疫苗 第1/4针"];
    
    RLMResults *aRes = [ADVaccine objectsWithPredicate:predicate];
    ADVaccine *model = nil;
    
    if (aRes.count == 1) {
        model = [aRes firstObject];
    }else{
        NSLog(@"获取五联疫苗出错,%ld",(long)aRes.count);
    }
    
    return model;
}

+ (ADVaccine *)getJiHuiVaccine
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND vaccineName == %@",uid,@"脊灰疫苗 第1/4针"];
    
    RLMResults *aRes = [ADVaccine objectsWithPredicate:predicate];
    ADVaccine *model = nil;
    
    if (aRes.count == 1) {
        model = [aRes firstObject];
    }else{
        NSLog(@"获取脊灰疫苗出错,%ld",(long)aRes.count);
    }
    
    return model;
}

+ (ADVaccine *)getHibVaccine
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND vaccineName == %@",uid,@"Hib疫苗 第1/4针"];
    
    RLMResults *aRes = [ADVaccine objectsWithPredicate:predicate];
    ADVaccine *model = nil;
    if (aRes.count == 1) {
        model = [aRes firstObject];
    }else{
        NSLog(@"获取Hib疫苗出错,%ld",(long)aRes.count);
    }
    
    return model;
}

+ (ADVaccine *)getBaiBaiPoVaccine
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND vaccineName == %@",uid,@"百白破疫苗 第1/4针"];
    
    RLMResults *aRes = [ADVaccine objectsWithPredicate:predicate];
    ADVaccine *model = nil;
    if (aRes.count == 1) {
        model = [aRes firstObject];
    }else{
        NSLog(@"获取百白破疫苗出错,%ld",(long)aRes.count);
    }
    
    return model;
}

+ (ADVaccine *)getVaccineFromName:(NSString *)name
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@ AND vaccineName == %@",uid,name];
    
    RLMResults *aRes = [ADVaccine objectsWithPredicate:predicate];
    ADVaccine *aModel = nil;
    if (aRes.count == 1) {
        aModel = [aRes firstObject];
    }else{
        NSLog(@"查询疫苗出现问题%ld",(long)aRes.count);
    }
    return aModel;

}

+ (void)addANotificationWithName:(NSString *)name noteDate:(NSDate *)noteDate noteTitle:(NSString *)noteStr
{
    [ADVaccineDAO removeNotificationWithName:name];
    
    //NSLog(@"疫苗 %@ ,通知的字样 %@,通知的时间 %@",name,noteStr,noteDate);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:name forKey:@"vaccineName"];
    //[dic setObject:_vaccineModel.vaccineId forKey:@"vaccineId"];
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];//新建通知
    notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
    notification.fireDate= noteDate;//距现在多久后触发代理方法
    notification.timeZone=[NSTimeZone localTimeZone];//设置时区
    notification.userInfo=dic;//在字典用存需要的信息
    notification.applicationIconBadgeNumber = 1;
    
    //去掉下面2行就不会弹出提示框
    notification.alertBody= noteStr;//提示信息弹出提示框
    notification.alertAction = @"打开";  //提示框按钮
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];//将新建的消息加到应用消息队列中
    
    //NSArray*arrSchedule=[[UIApplication sharedApplication]scheduledLocalNotifications];
   
}

+ (void)removeNotificationWithName:(NSString *)name
{
    for (UILocalNotification *notification in [[UIApplication sharedApplication]scheduledLocalNotifications]) {
        if ([[notification.userInfo objectForKey:@"vaccineName"] isEqualToString:name]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            
            NSLog(@"移除通知 %@",name);
            return;
        }
    }
}

+ (void)resetAllConflictVaccine
{
    NSMutableArray *array = [self readAllVaccineCollected:@"1"];
    for (ADVaccine *vaccineModel in array) {
        NSString *name = [[vaccineModel.vaccineName componentsSeparatedByString:@" "] firstObject];
        if ([ADVaccine isConflictToWuLianVaccine:name]) {
            [self removeNotificationWithName:vaccineModel.vaccineName];

            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            
            vaccineModel.noteDateStamp = @"0";
            vaccineModel.vaccindateDateStamp = @"0";
            vaccineModel.vaccindateDateStr = vaccineModel.orginVaccineDateStr;
            [realm commitWriteTransaction];
            
        }
    }
    
    //更新本地同步时间
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:vaccineSyncTimeKey];
}

#pragma mark - 同步相关

//+ (void)syncServerTimeToClient
//{
//    [ADUserSyncMetaHelper getSyncDataOnFinish:^(NSDictionary *res, NSError *err) {
//        NSString *timeSp = [NSString stringWithFormat:@"%@",[res objectForKey:vaccineSyncTimeKey]];
//        ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
//        
//        RLMRealm *realm = [RLMRealm defaultRealm];
//        
//        [realm beginWriteTransaction];
//        aRecord.s_vaccineSync_MTime = timeSp;
//        [realm commitWriteTransaction];
//    }];
//}
//
//+ (void)syncClientRecordTimeForVaccine
//{
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
//    [self syncClientRecordTimeForVaccineWithTimeSp:timeSp];
//}
//
//+ (void)syncClientRecordTimeForVaccineWithTimeSp:(NSString *)aTimeSp
//{
//    ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
//    
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    
//    [realm beginWriteTransaction];
//    if (aTimeSp.integerValue > aRecord.s_vaccineSync_MTime.integerValue) {
//        aRecord.s_vaccineSync_MTime = aTimeSp;
//    }
//    
//    [realm commitWriteTransaction];
//}

+ (void)distrubuteData
{
    
    NSLog(@"合并疫苗也数据");
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    RLMResults *aRes = [ADVaccine objectsWithPredicate:predicate];
    if (aRes.count > 0) {
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"uid == %@",@"0"];
        RLMResults *oldRes = [ADVaccine objectsWithPredicate:predicate1];
        if (oldRes.count > 0) {
            for (int i = 0; i < oldRes.count; ) {
                
                ADVaccine *vaccineModel = [oldRes objectAtIndex:i];
                if ([vaccineModel.isCollected isEqualToString:@"1"]) {
                    [self modifyOldVaccineToCollectWithModel:vaccineModel];
                }
                
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                //NSLog(@"删除 %@",vaccineModel.vaccineName);
                [realm deleteObject:vaccineModel];
                [realm commitWriteTransaction];
            }
            
            //[self syncClientRecordTimeForVaccine];
        }
        

    }else{
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"uid == %@",@"0"];
        RLMResults *oldRes = [ADVaccine objectsWithPredicate:predicate1];
        
        if (oldRes.count > 0) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            for (int i = 0; i < oldRes.count; ) {
                ADVaccine *vaccineModel = [oldRes objectAtIndex:i];
                [realm beginWriteTransaction];
                vaccineModel.uid = uid;
                [realm commitWriteTransaction];
            }
            
           //[self syncClientRecordTimeForVaccine];
        }
    }
}

+ (void)syncVaccineDataSuccess:(void (^) (void))success failure:(void (^)(void))failure
{
    ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
    
    [ADUserSyncMetaHelper getSyncDataOnFinish:^(NSDictionary *res, NSError *err) {
        NSLog(@"疫苗同步 本地时间%@, 服务器时间%@",aRecord.s_vaccineSync_MTime,[res objectForKey:vaccineSyncTimeKey]);
        if(aRecord.s_vaccineSync_MTime.integerValue > [[res objectForKey:vaccineSyncTimeKey] integerValue]){
            
            //NSLog(@"上传");
            [self uploadClientToServerSuccess:^{
                if (success) {
                    success();
                }
            } failure:^{
                if (failure) {
                    failure();
                }
            }];
        }else if(aRecord.s_vaccineSync_MTime.integerValue < [[res objectForKey:vaccineSyncTimeKey] integerValue]){
            //NSLog(@"下载");
            [self downloadServerDataSuccess:^{
                if (success) {
                    success();
                }
                [self uploadClientToServerSuccess:^{
                    
                } failure:^{
                    
                }];
            } failure:^{
                if (failure) {
                    failure();
                }
            }];
        }else{
            NSLog(@"两端数据同步");
            if (success) {
                success();
            }
        }
    }];
}

+ (void)downloadServerDataSuccess:(void (^) (void))success failure:(void (^)(void))failure
{
    //拼接请求参数
    NSString *token = [[NSUserDefaults standardUserDefaults] addingToken];
    if ([token isEqualToString:@"0"]) {
        return;
    }
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:token forKey:@"oauth_token"];
    
    //NSLog(@"下载数据参数 %@",parameter);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://api.addinghome.com/pregnantAssistantSync/vaccine/get" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"下载疫苗数据%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (failure) {
                failure();
            }
            return ;
        }
        
        NSArray *array = (NSArray *)responseObject;
        if (array.count != 0) {
            
            for (NSDictionary *subDic in array) {
                [self modifyVaccineWithServerData:subDic];
            }
            
            //从服务器获取同步时间并保存
//            [self syncServerTimeToClient];
            if (success) {
                success();
            }
        }else{
            NSLog(@"下载疫苗为空");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载疫苗失败%@",error.localizedDescription);
        if (failure) {
            failure();
        }
    }];
}

+ (void)uploadClientToServerSuccess:(void (^)(void))success failure:(void (^)(void))failure
{
    NSLog(@"上传数据");
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSMutableArray *paraArray = [NSMutableArray array];
    
    NSArray *vaccineArray = [self readAllVaccineCollected:@"1"];
    for (ADVaccine *vaccineModel in vaccineArray) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:uid forKey:@"uid"];
        [dic setObject:vaccineModel.vaccindateDateStamp forKey:@"innoculationTime"];
        [dic setObject:vaccineModel.noteDateStamp forKey:@"noteTime"];
        [dic setObject:vaccineModel.vaccineName forKey:@"vaccineName"];
        
        if ([vaccineModel.haveVaccinated isEqualToString:@"1"]) {
            [dic setObject:@"2" forKey:@"status"];
        }else{
            [dic setObject:@"1" forKey:@"status"];
        }
        [paraArray addObject:dic];
    }

    //拼接json字符串
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paraArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //拼接请求参数
    NSString *token = [[NSUserDefaults standardUserDefaults] addingToken];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:token forKey:@"oauth_token"];
    [parameter setObject:jsonStr forKey:@"data"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://api.addinghome.com/pregnantAssistantSync/vaccine/put" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *error = [responseObject objectForKey:@"error"];
        if (error) {
            NSLog(@"上传疫苗数据失败");
            if (failure) {
                failure();
            }
        }else{
            NSLog(@"上传数据成功 %@",responseObject);
            NSString *timSp = [NSString stringWithFormat:@"%@",[responseObject objectForKey:vaccineSyncTimeKey]];
            if (timSp.length > 0) {
//                [self syncClientRecordTimeForVaccineWithTimeSp:timSp];
                [ADUserSyncMetaHelper syncServerRecordTime:timSp andSyncKey:vaccineSyncTimeKey];
            }
            if (success) {
                success();
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传疫苗失败%@",error.localizedDescription);
        if (failure) {
            failure();
        }
    }];
}
//
//+ (void)analySisResponseObject:(NSArray *)array complete:()

@end
