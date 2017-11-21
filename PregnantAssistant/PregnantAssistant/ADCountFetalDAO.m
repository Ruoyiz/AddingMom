//
//  ADCountFetalDAO.m
//  PregnantAssistant
//
//  Created by D on 15/4/21.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADCountFetalDAO.h"
#import "NSDate+Utilities.h"
#import "ADUserSyncTimeDAO.h"
#import "ADUserSyncMetaHelper.h"

@implementation ADCountFetalDAO

+ (void)updateDataBaseOnfinish:(void (^)(void))aFinishBlock
{
    if ([[NSUserDefaults standardUserDefaults] havetUpdateCountFetalToolData]) {
        if (aFinishBlock) {
            aFinishBlock();
        }
        return;
    }
    
    [ADToastHelp showSVProgressToastWithTitle:@"正在升级数据，请稍候"];
    
    DISPATCH_ON_GLOBAL_QUEUE_DEFAULT(^{
    //read old data
    //读取每日数据
    NSDate *now = [NSDate date];
    NSMutableArray *allEveryHourRes = [[NSMutableArray alloc]initWithCapacity:0];
    
    //读取每日专心一小时数据
    NSMutableArray *everyDayOneHourRes = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = -279; i <= 0; i++) {
        NSDate *aDay = [now dateByAddingTimeInterval:60*60*24*i];
        NSString *aEveryHourDayKey = [self getEveryHourKeyWithDate:aDay];
        NSMutableArray *aEveryHourDayRes = [NSKeyedUnarchiver unarchiveObjectWithData:
                                            [[NSUserDefaults standardUserDefaults]objectForKey:aEveryHourDayKey]];
        if (aEveryHourDayRes.count > 0) {
            [allEveryHourRes addObject:aEveryHourDayRes];
        }
        
        //读取每一天所有数据
        for (int i = 0; i < aEveryHourDayRes.count; i++) {
            NSDate *aRecord = aEveryHourDayRes[i];
            //            NSLog(@"aRecord:%@", aRecord);
            [self addAEveryHourRecordWithStartDate:aRecord];
        }
        
        //clean
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:aEveryHourDayKey];
        
        NSString *aDayKey = [self getOneHourKeyWithDate:aDay];
        NSMutableArray *aDayRes = [NSKeyedUnarchiver unarchiveObjectWithData:
                                   [[NSUserDefaults standardUserDefaults]objectForKey:aDayKey]];
        if (aDayRes.count > 0) {
            [everyDayOneHourRes addObject:aDayRes];
        }
        //读取每一天所有专心一小时数据
        for (int i = 0; i < aDayRes.count; i++) {
            //            NSLog(@"one hour aRecord: %@", aDayRes[i]);
            NSArray *aRecord = aDayRes[i];
            
            NSString *dateStr = aRecord[0];
            NSString *startDateStr = [dateStr substringWithRange:NSMakeRange(0, 5)];
            NSString *startHour = [startDateStr substringWithRange:NSMakeRange(0, 2)];
            NSString *startMin = [startDateStr substringWithRange:NSMakeRange(startDateStr.length -2, 2)];
            
            NSString *endDateStr = [dateStr substringWithRange:NSMakeRange(dateStr.length -5, 5)];
            
            NSString *endHour = [endDateStr substringWithRange:NSMakeRange(0, 2)];
            NSString *endMin = [endDateStr substringWithRange:NSMakeRange(endDateStr.length -2, 2)];
            
            //            NSLog(@"start:%@ end:%@", startDateStr, endDateStr);
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *components =
            [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:aDay];
            
            components.hour = startHour.integerValue;
            components.minute = startMin.integerValue;
            components.second = 0;
            
            NSDate *startDate = [calendar dateFromComponents:components];
            
            //            NSLog(@"startDate:%@", startDate);
            components.hour = endHour.integerValue;
            components.minute = endMin.integerValue;
            
            NSDate *endDate = [calendar dateFromComponents:components];
            
            //            NSLog(@"endDate:%@", endDate);
            
            NSString *time = aRecord[1];
            time = [time substringWithRange:NSMakeRange(0, time.length -2)];
            //            NSLog(@"timeStr:%@", time);
            
            [self addAOneHourRecordWithStartDate:startDate andEndDate:endDate andCntTime:time];
        }
        
        //clean
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:aDayKey];
    }
    
    //clean
        [[NSUserDefaults standardUserDefaults] setHavetUpdateCountFetalToolData:YES];
//    NSLog(@"old data:%@", allEveryHourRes);
//    NSLog(@"old one data:%@", everyDayOneHourRes);
        [self uploadOldData];
        
        DISPATCH_ON_MAIN_THREAD(^{
            if (aFinishBlock) {
                aFinishBlock();
            }

            [ADToastHelp dismissSVProgress];
            // upload
        });
        
    });
}

+ (RLMResults *)readAllData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    
//    [self removeDuplicateWithObject:[ADEveryHourCountRecord objectsWithPredicate:predicate]];
//
    RLMResults *result = [ADEveryHourCountRecord objectsWithPredicate:predicate];
    
    return result;
}

+ (void)removeDuplicateWithObject:(RLMResults *)aRes
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    NSMutableArray *toRemove = [NSMutableArray array];
    for (int i = 0; i < aRes.count; i++) {
        ADEveryHourCountRecord *aData = aRes[i];
        for (int j = i +1; j < aRes.count; j++) {
            ADEveryHourCountRecord *nextData = aRes[j];
            NSLog(@"aData:%@ nData:%@", aData, nextData);
            if ([aData.recordTime isEqual:nextData.recordTime]) {
                NSLog(@"real delte");
                [toRemove addObject:nextData];
            }
        }
    }
    [realm deleteObjects:toRemove];
    [realm commitWriteTransaction];
}

+ (void)distrubuteData
{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        // something
//    });
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    
    NSPredicate *unSyncPre = [NSPredicate predicateWithFormat:@"uid == '0'"];
    RLMResults *unSyncRes = [ADEveryHourCountRecord objectsWithPredicate:unSyncPre];
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    if (![uid isEqualToString:@"0"]) {
        RLMResults *hasUidRecord = [ADEveryHourCountRecord objectsWithPredicate:[NSPredicate predicateWithFormat:@"uid == %@",uid]];
        ADEveryHourCountRecord *userlaseData = [hasUidRecord lastObject];
        if (hasUidRecord.count > 0) {
            for (int i = 0; i < unSyncRes.count; i ++) {
                ADEveryHourCountRecord *noUserData = unSyncRes[i];
                if ([userlaseData.recordTime distanceInMinutesToDate:noUserData.recordTime] > 5) {
                    [tempArray addObject:noUserData];
                }
            }
        }else{
            for (int i = 0; i < unSyncRes.count; i ++) {
                ADEveryHourCountRecord *noUserData = unSyncRes[i];
                [tempArray addObject:noUserData];
            }
        }
    }
    
    NSLog(@"un res:%@ cnt:%lu", unSyncRes, (unsigned long)unSyncRes.count);
    if (tempArray.count > 0) {
        for (int i = 0; i < tempArray.count; i++) {
            ADEveryHourCountRecord *aData = tempArray[i];
            [realm beginWriteTransaction];
            aData.uid = uid;
            [realm commitWriteTransaction];
            NSLog(@"change uid:%@", uid);
            
//            ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
//            if (aRecord.c_fetalMovement_MTime.integerValue > 0) {
//                [self syncClientRecordTime];
//            }
        }
    }
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:fetalMovementKey];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
//    [self removeDuplicateWithObject:[ADEveryHourCountRecord objectsWithPredicate:predicate]];
}

+ (NSDate *)getTodayFirstAddOneDate
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSCalendar* gregorian = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* dateComponents = [gregorian components:unitFlags fromDate:[NSDate date]];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    NSDate *startDate = [gregorian dateFromComponents:dateComponents];
    
    [dateComponents setHour:23];
    [dateComponents setMinute:59];
    [dateComponents setSecond:59];
    
    NSDate *endDate = [gregorian dateFromComponents:dateComponents];
    
    NSPredicate *firstPredicate = [NSPredicate predicateWithFormat:@"recordTime >= %@", startDate];
    NSPredicate *secondPredicate = [NSPredicate predicateWithFormat:@"recordTime <= %@", endDate];

    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    NSPredicate *predicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:@[firstPredicate, secondPredicate, userPredicate]];

    RLMResults *result = [[ADEveryHourCountRecord objectsWithPredicate:predicate]
                          sortedResultsUsingProperty:@"recordTime" ascending:YES];

    ADEveryHourCountRecord *firstRecord = [result firstObject];
    if (firstRecord != nil) {
        return firstRecord.recordTime;
    }
    return nil;
}

+ (void)addAEveryHourRecordWithStartDate:(NSDate *)aDate
{
    [self addAEveryHourRecordWithStartDate:aDate autoSync:YES];
}

+ (void)addAEveryHourRecordWithStartDate:(NSDate *)aDate
                                autoSync:(BOOL)autoSync
{
    if (aDate != nil) {
        RLMResults *resultRecord = [self readAllHourArrayWithDate:aDate];
        if (resultRecord.count) {
            ADEveryHourCountRecord *oldRecord = [resultRecord lastObject];
            if ([oldRecord.recordTime distanceInMinutesToDate:aDate] < 5) {
                return;
            }
        }
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm beginWriteTransaction];
        [realm addObject:
         [[ADEveryHourCountRecord alloc] initWithRecordTime:aDate andType:0 andEndTime:nil andCntTime:@"1"]];
        
        [realm commitWriteTransaction];
        [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:fetalMovementKey];
        if (autoSync) {
            [self syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
        }
    }
}

//+ (void)addAeveryHourRecordFormServerWithStartDate:(NSDate *)aDate autoSyns:(BOOL)autoSync{
//    if (aDate != nil) {
//        RLMResults *resultRecord = [self readAllHourArrayWithDate:aDate];
//        if (resultRecord.count) {
//            ADEveryHourCountRecord *oldRecord = [resultRecord lastObject];
//            if ([oldRecord.recordTime distanceInMinutesToDate:aDate] < 5) {
//                return;
//            }
//        }
//        RLMRealm *realm = [RLMRealm defaultRealm];
//        
//        [realm beginWriteTransaction];
//        [realm addObject:
//         [[ADEveryHourCountRecord alloc] initWithRecordTime:aDate andType:0 andEndTime:nil andCntTime:@"1"]];
//        
//        [realm commitWriteTransaction];
//        [self syncClientRecordTime];
//        
//        if (autoSync) {
//            [self syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
//        }
//    }
//
//    
//}

+ (void)addAOneHourRecordWithStartDate:(NSDate *)aDate
                            andEndDate:(NSDate *)aEndDate
                            andCntTime:(NSString *)aCnt
{
    [self addAOneHourRecordWithStartDate:aDate andEndDate:aEndDate  andCntTime:aCnt autoSync:YES];
}

+ (void)addAOneHourRecordWithStartDate:(NSDate *)aDate
                            andEndDate:(NSDate *)aEndDate
                            andCntTime:(NSString *)aCnt
                              autoSync:(BOOL)autoSync
{
    if (aDate != nil) {
        
        RLMResults *resultRecord = [self readTableOneHourArrayWithDate:aDate];
        if (resultRecord.count) {
            ADEveryHourCountRecord *oldRecord = [resultRecord lastObject];
            if ([oldRecord.recordTime distanceInMinutesToDate:aDate] < 5) {
                return;
            }
        }
        NSLog(@"aCnt:%@ %@ %@", aDate, aEndDate, aCnt);
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm beginWriteTransaction];
        [realm addObject:
         [[ADEveryHourCountRecord alloc] initWithRecordTime:aDate andType:1 andEndTime:aEndDate andCntTime:aCnt]];
        
        [realm commitWriteTransaction];
        [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:fetalMovementKey];
        if (autoSync) {
            [self syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
        }
    }
}

+ (RLMResults *)readAllHourArrayWithDate:(NSDate *)aDate
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    if (uid.length == 0) {
        uid = @"0";
    }
    NSCalendar* gregorian = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* dateComponents = [gregorian components:unitFlags fromDate:aDate];
    [dateComponents setHour:0]; [dateComponents setMinute:0]; [dateComponents setSecond:0];
    NSDate *startDate = [gregorian dateFromComponents:dateComponents];
    
    [dateComponents setHour:23]; [dateComponents setMinute:59]; [dateComponents setSecond:59];
    
    NSDate *endDate = [gregorian dateFromComponents:dateComponents];
    
    NSPredicate *firstPredicate = [NSPredicate predicateWithFormat:@"recordTime >= %@", startDate];
    NSPredicate *secondPredicate = [NSPredicate predicateWithFormat:@"recordTime <= %@", endDate];
    
    NSPredicate *predicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:@[firstPredicate, secondPredicate]];

    RLMResults *findThing = [ADEveryHourCountRecord objectsWithPredicate:predicate];
    
//    NSPredicate *finalpredicate = [NSPredicate predicateWithFormat:@"uid == %@ AND type == 0", uid];
    NSPredicate *finalpredicate = [NSPredicate predicateWithFormat:@"uid == %@ AND type == 0", uid];
    RLMResults *finalRes = [findThing objectsWithPredicate:finalpredicate];
    return finalRes;
}

+ (RLMResults *)readTableOneHourArrayWithDate:(NSDate *)aDate
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    if (uid.length == 0) {
        uid = @"0";
    }
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
    
    NSPredicate *firstPredicate = [NSPredicate predicateWithFormat:@"recordTime >= %@", startDate];
    NSPredicate *secondPredicate = [NSPredicate predicateWithFormat:@"recordTime <= %@", endDate];
    
    NSPredicate *predicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:@[firstPredicate, secondPredicate]];
    
    RLMResults *findThing = [ADEveryHourCountRecord objectsWithPredicate:predicate];
    
    NSPredicate *finalpredicate = [NSPredicate predicateWithFormat:@"uid == %@ AND type == 1", uid];
    RLMResults *finalRes = [findThing objectsWithPredicate:finalpredicate];
    return finalRes;
}

#pragma mark - calc method
+ (NSMutableArray *)calcPerHourCntWithAllHourArray:(RLMResults *)allHourArray
{
    NSMutableArray * perHourValuesArray = [@[
                                             @"0", @"0", @"0", @"0", // 0.3
                                             @"0", @"0", @"0", @"0", // 4.7
                                             @"0", @"0", @"0", @"0", // 8.11
                                             @"0", @"0", @"0", @"0", // 12.15
                                             @"0", @"0", @"0", @"0", // 16.19
                                             @"0", @"0", @"0", @"0"] mutableCopy]; //20.23
    
    for (ADEveryHourCountRecord *aRecord in allHourArray) {
        NSDate *recordTime = aRecord.recordTime;
        NSInteger hour = recordTime.hour;
        NSString *hourCnt = perHourValuesArray[hour];
        int hourCntNum = hourCnt.intValue;
        hourCntNum += 1;
        perHourValuesArray[hour] = @(hourCntNum).stringValue;
    }
    return perHourValuesArray;
}

//转换成 每小时内 [开始时间 次数]
+ (void)transHourAndTimeWithAllHourArray:(RLMResults *)allHourArray
                                onFinish:(void(^)(NSMutableArray *))aFinishBlock
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = 0"];
    RLMResults *fliterArray = [allHourArray objectsWithPredicate:predicate];
    
    NSMutableArray *transformedHourArray = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *perHourTimes = [[NSMutableArray alloc]initWithCapacity:1];
    
    //给perHourTimes 赋值
    for (int i = 0; i < fliterArray.count; i++) {
        [perHourTimes addObject:@"1"];
    }
    
    NSLog(@"per:%@ allHourArray:%@", perHourTimes, fliterArray);
        int perHourTime = 0;
        for (int i = 0;i < fliterArray.count; i++) {
            for (int j = i +1; j < fliterArray.count; j++) {
                ADEveryHourCountRecord *aRecord = fliterArray[i];
                ADEveryHourCountRecord *nextRecord = fliterArray[j];
                NSDate *aDate = aRecord.recordTime;
                NSDate *nextDate = nextRecord.recordTime;
                NSLog(@"aDate: %@ nextDate:%@", aRecord, nextRecord);
                if (![ADHelper isDurationBigger1Hour:aDate date2:nextDate]) {
                    //1小时内 添加次数
                    NSLog(@"add");
                    NSString *oldCnt = perHourTimes[i];
                    
                    perHourTime = oldCnt.intValue + 1;
                    
//                    perHourTimes[i] = [NSString stringWithFormat:@"%d", perHourTime];
                    perHourTimes[i] = @(perHourTime).stringValue;
                } else {
                    //1小时外 开始计算下个时间开始 的1小时胎动次数
                    //不再走内层循环
                    break;
                }
            }
        }
    
//    DISPATCH_ON_GLOBAL_QUEUE_DEFAULT((^{
        for (int i = 0; i < perHourTimes.count; i++) {
            [transformedHourArray addObject:@[fliterArray[i], perHourTimes[i]]];
        }
        
        if (fliterArray.count == 1) {
            ADEveryHourCountRecord *aRecord = fliterArray[0];
            [transformedHourArray addObject:@[aRecord, @"1"]];
        }
    
    NSLog(@"trans array:%@", transformedHourArray);
//        DISPATCH_ON_MAIN_THREAD(^{
            if (aFinishBlock) {
                aFinishBlock(transformedHourArray);
            }
//        });
//    }));
}

+ (NSArray *)findTheMaxHourInEveryHourArray:(NSArray *)transArray
{
    if (transArray.count == 0) {
        return nil;
    }
    
    int maxCnt = 0;
    int maxIndex = 0;
    for (int i = 0; i < transArray.count; i++) {
        NSString *perCnt = transArray[i][1];
        int perHourCnt = perCnt.intValue;
        if (perHourCnt > maxCnt) {
            maxCnt = perHourCnt;
            maxIndex = i;
        }
    }
    
    NSDate *mostHour = transArray[maxIndex][0];
    
//    NSString *mostHourNum = [NSString stringWithFormat:@"%d", maxCnt];
    NSString *mostHourNum = @(maxCnt).stringValue;
    
    NSLog(@"mostHour: %@", mostHour);
    return @[mostHour, mostHourNum];
}

+ (NSInteger)calcAverageHourCnt:(NSMutableArray *)transArray
                   withMostHour:(NSDate *)mostHour
                withMostHourNum:(NSString *)mostHourNum
{
    NSMutableArray *filterArray = [[NSMutableArray alloc]initWithCapacity:0];

    NSLog(@"trans:%@", transArray);
    NSLog(@"most hour:%@", mostHour);
    NSDate *judgeDate = mostHour;
    for (int i = 0; i <transArray.count; i++) {
//        NSDate *aDate = transArray[i][0];
        NSArray *aRecordAndTime = transArray[i];
        ADEveryHourCountRecord *aRecord = aRecordAndTime[0];
        NSDate *aDate = aRecord.recordTime;
        
        NSLog(@"aDate:%@ mostHour:%@", aDate, mostHour);
        if ([mostHour isEqualToDate:aDate]) {
            [filterArray addObject:transArray[i]];
            judgeDate = aDate;
        } else if ([ADHelper validDate:aDate withMaxDate:judgeDate] == YES) {
            [filterArray addObject:transArray[i]];
            //更新比较时间 换为下一次记录时间开始比较
            judgeDate = aDate;
            NSLog(@"judge:%@", judgeDate);
        }
    }
    
//    NSString *firstLargeNum = @"0";
    NSString *secondLargeNum = @"0";
    NSString *thirdLargeNum = @"0";
    NSLog(@"filter:%@", filterArray);
    
    //剩余中挑两个最大的
    if (filterArray.count > 0) {
        int firstMaxCnt = 0;
        int firstMaxIndex = 0;

        for (int i = 0; i < filterArray.count; i++) {
            NSString *perCnt = filterArray[i][1];
            int perHourCnt = perCnt.intValue;
            NSLog(@"percnt:%@", perCnt);
            if (perHourCnt > firstMaxCnt) {
                firstMaxCnt = perHourCnt;
                firstMaxIndex = i;
            }
        }
        
//        firstLargeNum = [NSString stringWithFormat:@"%d",firstMaxCnt];
        NSLog(@"first inx:%d", firstMaxIndex);
        [filterArray removeObjectAtIndex:firstMaxIndex];
        
        int secondMaxCnt = 0;
        int secondMaxIndex = 0;
        for (int i = 0; i < filterArray.count; i++) {
            NSString *perCnt = filterArray[i][1];
            int perHourCnt = perCnt.intValue;
            NSLog(@"percnt:%@", perCnt);
            if (perHourCnt > secondMaxCnt) {
                secondMaxCnt = perHourCnt;
                secondMaxIndex = i;
            }
        }
        
        NSLog(@"fiter:%@ second index:%d", filterArray, secondMaxIndex);
//        secondLargeNum = [NSString stringWithFormat:@"%d",secondMaxCnt];
        secondLargeNum = @(secondMaxCnt).stringValue;
        
        if (secondMaxIndex < filterArray.count) {
            [filterArray removeObjectAtIndex:secondMaxIndex];
        }
        NSLog(@"secondLargeNum:%@",secondLargeNum);
        
        int thirdMaxCnt = 0;
        for (int i = 0; i < filterArray.count; i++) {
            NSString *perCnt = filterArray[i][1];
            int perHourCnt = perCnt.intValue;
            if (perHourCnt > thirdMaxCnt) {
                thirdMaxCnt = perHourCnt;
            }
        }
//        thirdLargeNum = [NSString stringWithFormat:@"%d",thirdMaxCnt];
        thirdLargeNum = @(thirdMaxCnt).stringValue;
                NSLog(@"thirdLargeNum:%@",thirdLargeNum);
    }
    
    NSInteger avgHourNum = 0;
    if (secondLargeNum.intValue == 0) {
        avgHourNum = mostHourNum.intValue;
    } else if (thirdLargeNum.intValue == 0) {
        avgHourNum = round((mostHourNum.intValue + secondLargeNum.intValue)/2.0);
    } else {
        avgHourNum =
        round((mostHourNum.intValue + secondLargeNum.intValue + thirdLargeNum.intValue)/3.0);
    }
    
    NSLog(@"calc num:%ld", (long)avgHourNum);
    return avgHourNum;
}

#pragma mark - key method
+ (NSString *)getEveryHourKeyWithDate:(NSDate *)aDate
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:aDate];
    return [NSString stringWithFormat:@"%ld-%ld-%ld-everyHour",
            (long)[dateComponents year], (long)[dateComponents month], (long)[dateComponents day]];
}

+ (NSString *)getOneHourKeyWithDate:(NSDate *)aDate
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:aDate];

    
    return [NSString stringWithFormat:@"%ld-%ld-%ld-oneHour",
            (long)[dateComponents year], (long)[dateComponents month], (long)[dateComponents day]];
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
        [ADUserSyncMetaHelper is_severDataTimeLater_syncKey:fetalMovementKey
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
// type 20101 正常胎动 20102 专心1小时
    if (processBlock) {
        processBlock(nil);
    }
    
//    if ([self readAllData].count > 0 &&
//        [[ADUserSyncMetaHelper getToolSyncStrDateWithSyncName:fetalMovementKey] isEqualToString:@"0"]) {
//        [self syncClientRecordTime];
//    }

    [self needGetDataOnFinish:^(BOOL need) {
        if (need) {
            [ADCountFetalSyncManager getDataOnFinish:^(NSArray *res) {
                NSLog(@"count fe res:%@", res);
                DISPATCH_ON_GLOBAL_QUEUE_DEFAULT((^{
                    for (int i = 0; i < res.count; i++) {
                        NSLog(@"add once");
                        NSString *value = res[i][@"value"];
                        // 值为0 的数据不存
                        if (![value isEqualToString:@"0"]) {
                            // add data
                            NSString *type = res[i][@"type"];
                            // 专心1小时
                            if ([type isEqualToString:@"20102"]) {
                                NSString *start = res[i][@"startTime"];
                                NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start.intValue];
                                NSString *end = res[i][@"endTime"];
                                NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end.intValue];
                                NSString *cntTime = res[i][@"value"];
                                [self addAOneHourRecordWithStartDate:startDate andEndDate:endDate  andCntTime:cntTime  autoSync:NO];
                            } else {
                                NSString *pressTime = res[i][@"time"];
                                NSDate *pressDate = [NSDate dateWithTimeIntervalSince1970:pressTime.intValue];
                                [self addAEveryHourRecordWithStartDate:pressDate autoSync:NO];
                            }
                        }
                    }
                    
                    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
                    [self removeDuplicateWithObject:[ADEveryHourCountRecord objectsWithPredicate:predicate]];
                    
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
        [ADCountFetalSyncManager uploadData:aRes onFinish:^(NSDictionary *res, NSError *error) {
            NSString *serverTime = [NSString stringWithFormat:@"%@", res[@"fetalMovementSyncTime"]];
            [ADUserSyncMetaHelper syncServerRecordTime:serverTime andSyncKey:fetalMovementKey];
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
    if ([[NSUserDefaults standardUserDefaults]everUploadCountFetail]) {
        return;
    }
    
    RLMResults *aRes = [self readAllData];
    if (aRes.count > 0) {
        [self uploadAllDataOnFinish:^(NSError *error) {
            if (error == nil) {
                [[NSUserDefaults standardUserDefaults]setEverUploadCountFetail:YES];
            }
        }];
    } else {
        [[NSUserDefaults standardUserDefaults]setEverUploadCountFetail:YES];
    }
}

+ (NSDate *)getLastValidData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@ AND type = 0",uid];
    
    RLMResults *result = [ADEveryHourCountRecord objectsWithPredicate:predicate];
    
    ADEveryHourCountRecord *lastRecord = [result lastObject];
    return lastRecord.recordTime;
}

@end