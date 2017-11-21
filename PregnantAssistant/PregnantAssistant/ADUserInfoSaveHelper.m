//
//  ADUserInfoSaveHelper.m
//  PregnantAssistant
//
//  Created by D on 15/4/14.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADUserInfoSaveHelper.h"
#import "ADUserInfoSyncManager.h"
#import "ADUserSyncMetaHelper.h"
#import "ADUserSyncTimeDAO.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ADUserInfoSaveHelper

+ (void)saveWithDic:(NSDictionary *)aDic
{
    NSLog(@"dic: %@", aDic);
    NSString *status = aDic[@"userInfo"][@"status"];
    NSString *dueDate = aDic[@"userInfo"][@"duedate"];
    NSString *area = aDic[@"userInfo"][@"area"];
    NSString *birthday = aDic[@"userInfo"][@"birthday"];
    NSString *height = aDic[@"userInfo"][@"height"];
    NSString *weight = aDic[@"userInfo"][@"weight"];
    NSString *babyBirthday = aDic[@"userInfo"][@"babyBirthday"];
    NSString *babyGender = aDic[@"userInfo"][@"babyGender"];
    
    /**  野数据归属  **/
    NSPredicate *noUserpredicate = [NSPredicate predicateWithFormat:@"uid == %@",@"0"];
    RLMResults *noUserInfos = [ADUserInfo objectsWithPredicate:noUserpredicate];
    if (noUserInfos.count > 0) {
        ADUserInfo *noUserOne = noUserInfos[0];
        status = [status isEqualToString:@"0"] ? noUserOne.status:status;
        dueDate = [dueDate isEqualToString:@"0"] ?[NSString stringWithFormat:@"%ld",(long)[noUserOne.dueDate timeIntervalSince1970]]:dueDate;
        babyBirthday = [babyBirthday isEqualToString:@"0"] ?[NSString stringWithFormat:@"%ld",(long)[noUserOne.babyBirthDay timeIntervalSince1970]]:babyBirthday;
        babyGender = [babyGender isEqualToString:@"0"] ? [NSString stringWithFormat:@"%ld",(long)noUserOne.babySex]:babyGender;
    }

    
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *allUserInfos = [ADUserInfo objectsWithPredicate:predicate];
    
    ADAppDelegate *delegate = APP_DELEGATE;
    delegate.userStatus = status;
    
    if (allUserInfos.count == 1) {
        ADUserInfo* one = [allUserInfos objectAtIndex:0];
        [realm beginWriteTransaction];
//        one.uid = uid;
        one.status = status;
        one.dueDate = [NSDate dateWithTimeIntervalSince1970:dueDate.integerValue];
        one.area = area;
        one.birthDay = birthday;
        one.height = height;
        one.weight = weight;
        one.babyBirthDay = [NSDate dateWithTimeIntervalSince1970:babyBirthday.integerValue];
        one.babySex = babyGender.intValue;
        
        delegate.dueDate = one.dueDate;
        delegate.babyBirthday = one.babyBirthDay;
        
        [realm commitWriteTransaction];
    } else {
        ADUserInfo *newUserInfo = [[ADUserInfo alloc]init];
        newUserInfo.uid = uid;
        newUserInfo.status = status;
        newUserInfo.dueDate = [NSDate dateWithTimeIntervalSince1970:dueDate.integerValue];
        newUserInfo.area = area;
        newUserInfo.birthDay = birthday;
        newUserInfo.height = height;
        newUserInfo.weight = weight;
        newUserInfo.babyBirthDay = [NSDate dateWithTimeIntervalSince1970:babyBirthday.integerValue];
        newUserInfo.babySex = babyGender.intValue;
        
        delegate.dueDate = newUserInfo.dueDate;
        delegate.babyBirthday = newUserInfo.babyBirthDay;

        
        [realm beginWriteTransaction];
        [realm addObject:newUserInfo];
        [realm commitWriteTransaction];
        
    }
    /*  纪录本地时间，这时候userinfo 不需要从云端下载新的数据需要上传 */
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:userInfoTimeKey];
    [self saveIconData:aDic[@"face"] andName:aDic[@"nickname"]];
}

+ (void)saveIconData:(NSString *)image andName:(NSString *)aName
{
    if ([image isEqual:[NSNull null]] || image == nil || image.length == 0) {
        [self saveImageDataWithImage:[UIImage imageNamed:@"无头像"] aName:aName];
        return;
    }
    
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:image]
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
     }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (finished) {
             [self saveImageDataWithImage:image aName:aName];
         }
     }];
}

+ (void)saveImageDataWithImage:(UIImage *)image aName:(NSString *)aName
{
    NSData *iconData  = UIImagePNGRepresentation(image);

    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    if ([uid isEqualToString:@"0"]) {
        return;
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *allUserInfos = [ADUserInfo objectsWithPredicate:predicate];
    
    if (allUserInfos.count == 1) {
        //已经有条目了
        //进行更改操作
        ADUserInfo* one = allUserInfos[0];
        [realm beginWriteTransaction];
        one.icon = iconData;
        one.nickName = aName;
        one.uid = uid;
        
        //NSLog(@"已经有的老数据 %@,%d,%@",one.status,one.babySex,one.babyBirthDay);
        if (!one.babyBirthDay) {
            one.babyBirthDay = [NSDate date];
        }
        
        if (!one.dueDate) {
            one.dueDate = [NSDate date];
        }
        
        [realm commitWriteTransaction];
        
//        [self getOldDataAndUpToNewServer];
        [self postnotify];
    } else if (allUserInfos.count == 0) {

        ADUserInfo *newUserInfo = [[ADUserInfo alloc]init];
        newUserInfo.icon = iconData;
        newUserInfo.nickName = aName;
        newUserInfo.uid = uid;

        [realm beginWriteTransaction];
        [realm addObject:newUserInfo];
        [realm commitWriteTransaction];
        [self postnotify];
        //        [self mergeNoMasterUserInfoWithUid:uid aName:aName image:image];
    }
}


+ (void)postnotify
{
     [[NSNotificationCenter defaultCenter]postNotificationName:finishDownloadImgNotification object:nil];
}

+ (UIImage *)readIconData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSLog(@"uid: %@", uid);
    if ( ![uid isEqualToString:@"0"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
        RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
        if (allUserInfos.count > 0) {
            ADUserInfo* one = allUserInfos[0];
//            NSLog(@"data: %@", one.icon);
            
            return [UIImage imageWithData:one.icon];
        }
        return nil;
    } else {
        return nil;
    }
}

+ (NSString *)readUserName
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    if ( ![uid isEqualToString:@"0"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
        RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
        if (allUserInfos.count > 0) {
            ADUserInfo* one = allUserInfos[0];
            NSLog(@"userName %@", one.nickName);
            return one.nickName;
        }
        return @"";
    } else {
        return @"";
    }
}

+ (void)saveUserName:(NSString *)aName
{
    if ([self isEqual0:aName]) {
        return;
    }
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    if ([uid isEqualToString:@"0"]) {
        return;
    }
    RLMRealm *realm=[RLMRealm defaultRealm];
    RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
    
    if (allUserInfos.count == 1) {
        ADUserInfo* one = [allUserInfos objectAtIndex:0];
        [realm beginWriteTransaction];
        one.nickName = aName;
        [realm commitWriteTransaction];
    }
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:userInfoTimeKey];
}

+ (void)saveUserHeight:(NSString *)aHeight
{
    if ([self isEqual0:aHeight]) {
        return;
    }

    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    if ([uid isEqualToString:@"0"]) {
        return;
    }
    RLMRealm *realm=[RLMRealm defaultRealm];
    RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
    
    if (allUserInfos.count == 1) {
        ADUserInfo* one = [allUserInfos objectAtIndex:0];
        [realm beginWriteTransaction];
        one.height = aHeight;
        [realm commitWriteTransaction];
    }
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:userInfoTimeKey];
}

+ (NSString *)readUserHeight
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    if (![uid isEqualToString:@"0"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
        RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
        if (allUserInfos.count > 0) {
            ADUserInfo* one = allUserInfos[0];
            return one.height;
        }
    }
    
    return @"";
}

+ (void)saveUserStatus:(NSString *)aStatus
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    RLMResults *aRes=[ADUserInfo objectsWithPredicate:predicate];
    
    ADUserInfo *aInfo = nil;
    
    RLMRealm *realm=[RLMRealm defaultRealm];
    [realm beginWriteTransaction];

    if (aRes.count > 0) {
        aInfo = aRes[0];
    } else {
        aInfo = [[ADUserInfo alloc]init];
//        aInfo.icon = [NSData data];
        [realm addObject:aInfo];
    }
    
    aInfo.status = aStatus;
    
    ADAppDelegate *delegate = APP_DELEGATE;
    delegate.userStatus = aStatus;
    
    aInfo.uid = uid;
    [realm commitWriteTransaction];
    
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:userInfoTimeKey];
    
    //[self syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
}

+ (NSString *)readUserStatus
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    RLMResults *aRes = [ADUserInfo objectsWithPredicate:predicate];

    ADUserInfo *aInfo = nil;
    if (aRes.count > 0) {
        aInfo = aRes[0];
    } else {
        aInfo = [[ADUserInfo alloc]init];
    }
    
//    NSLog(@"用户的状态%@",aInfo.status);
    return aInfo.status;
}

+ (void)saveUserArea:(NSString *)area
{
    if ([self isEqual0:area]) {
        return;
    }

    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    if ([uid isEqualToString:@"0"]) {
        return;
    }
    
    RLMRealm *realm=[RLMRealm defaultRealm];
    RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
    [realm beginWriteTransaction];
    if (allUserInfos.count == 1) {
        ADUserInfo* one = [allUserInfos objectAtIndex:0];
        one.area = area;
    }
    [realm commitWriteTransaction];
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:userInfoTimeKey];
    
}

+ (NSString *)readUserArea
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    if ( ![uid isEqualToString:@"0"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
        RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
        if (allUserInfos.count > 0) {
            ADUserInfo* one = allUserInfos[0];
            return one.area;
        }
        return @"";
    } else {
        return @"";
    }
}

+ (void)saveBirthDay:(NSString *)aBirthDay
{
    if ([self isEqual0:aBirthDay]) {
        return;
    }

    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    if ([uid isEqualToString:@"0"]) {
        return;
    }
    RLMRealm *realm=[RLMRealm defaultRealm];
    RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
    
    if (allUserInfos.count == 1) {
        ADUserInfo* one = [allUserInfos objectAtIndex:0];
        [realm beginWriteTransaction];
        one.birthDay = aBirthDay;
        [realm commitWriteTransaction];
    }
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:userInfoTimeKey];
}

+ (NSString *)readBirthDay
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    if (![uid isEqualToString:@"0"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
        RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
        if (allUserInfos.count > 0) {
            ADUserInfo* one = allUserInfos[0];
            return one.birthDay;
        }
        return @"";
    } else {
        return @"";
    }
}

+ (void)saveUserWeight:(NSString *)aWeight
{
    if ([self isEqual0:aWeight]) {
        return;
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    if ([uid isEqualToString:@"0"]) {
        return;
    }
    RLMRealm *realm=[RLMRealm defaultRealm];
    RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
    
    if (allUserInfos.count == 1) {
        ADUserInfo* one = [allUserInfos objectAtIndex:0];
        [realm beginWriteTransaction];
        one.weight = aWeight;
        [realm commitWriteTransaction];
    }
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:userInfoTimeKey];
}

+ (NSString *)readUserWeight
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    if (![uid isEqualToString:@"0"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
        RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
        if (allUserInfos.count > 0) {
            ADUserInfo* one = allUserInfos[0];
            return one.weight;
        }
        return @"";
    } else {
        return @"";
    }
}

+ (BOOL)isEqual0:(NSString *)aStr
{
    if ([aStr isEqualToString:@"0"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)saveBabayBirthday:(NSDate *)babyBirthday
{
    if ([self isNullValue:babyBirthday]) {
        return;
    }
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *allUserInfos = [ADUserInfo objectsWithPredicate:predicate];
    
    [realm beginWriteTransaction];
    if (allUserInfos.count == 1) {
        ADUserInfo* one = [allUserInfos objectAtIndex:0];
        one.babyBirthDay = babyBirthday;
    }else{
        ADUserInfo* newUserInfo = [[ADUserInfo alloc] init];
        newUserInfo.icon = [NSData data];
        
        newUserInfo.dueDate = [NSDate date];
        newUserInfo.babyBirthDay = babyBirthday;
        newUserInfo.babySex = 0;
        
        [realm addObject:newUserInfo];
    }
    [realm commitWriteTransaction];
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:userInfoTimeKey];
    
    ADAppDelegate *delegate = APP_DELEGATE;
    delegate.babyBirthday = babyBirthday;
}

+ (NSDate *)readBabyBirthday
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
    if (allUserInfos.count > 0) {
        ADUserInfo* one = allUserInfos[0];
        return one.babyBirthDay;
    }
    return [NSDate date];
}


+ (void)saveBasicUserInfo:(NSDictionary *)aInfo
{
    NSLog(@"ainfo  == %@",aInfo);
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *allUserInfos = [ADUserInfo objectsWithPredicate:predicate];
    
    [realm beginWriteTransaction];
    
    ADAppDelegate *delegate = APP_DELEGATE;
    delegate.userStatus = aInfo[userStatusKey];
    if (allUserInfos.count == 1) {
        ADUserInfo* one = allUserInfos[0];
        one.status = aInfo[userStatusKey];
        if ([one.status isEqualToString:@"1"]) {
            //准妈妈
            NSString *dateStr = aInfo[userDueDateKey];
            one.dueDate = [NSDate dateWithTimeIntervalSince1970:dateStr.integerValue];
            delegate.dueDate = one.dueDate;
        } else {
            //妈妈
            NSString *dateStr = aInfo[babyBirthDayKey];
            NSString *sex = aInfo[babySexKey];
            one.babyBirthDay = [NSDate dateWithTimeIntervalSince1970:dateStr.integerValue];
            one.babySex = sex.integerValue;
            
            delegate.babyBirthday = one.babyBirthDay;
//            delegate.babySex = one.babySex;
        }
    } else {
        ADUserInfo* newUserInfo = [[ADUserInfo alloc] init];
        newUserInfo.uid = uid;
        
        newUserInfo.status = aInfo[userStatusKey];
        if ([newUserInfo.status isEqualToString:@"1"]) {
            //准妈妈
            NSString *dateStr = aInfo[userDueDateKey];
            newUserInfo.dueDate = [NSDate dateWithTimeIntervalSince1970:dateStr.integerValue];
            delegate.dueDate = newUserInfo.dueDate;
            
        } else {
            //妈妈
            NSString *dateStr = aInfo[babyBirthDayKey];
            NSString *sex = aInfo[babySexKey];
            newUserInfo.babyBirthDay = [NSDate dateWithTimeIntervalSince1970:dateStr.integerValue];
            newUserInfo.babySex = sex.integerValue;
            
            delegate.babyBirthday = newUserInfo.babyBirthDay;
//            delegate.babySex = newUserInfo.babySex;
        }
        
        [realm addObject:newUserInfo];
    }
    
    [realm commitWriteTransaction];
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:userInfoTimeKey];
}

+ (NSDictionary *)readBasicUserInfo
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    RLMResults *allUserInfos = [ADUserInfo objectsWithPredicate:predicate];
    if (allUserInfos.count > 0) {
        ADUserInfo* one = allUserInfos[0];
//        NSLog(@"status: %@", one.status);
        if ([one.status isEqualToString:@"1"]) {
            return @{userStatusKey: one.status, userDueDateKey:one.dueDate};
        } else if ([one.status isEqualToString:@"2"]) {
            return @{userStatusKey: one.status, babyBirthDayKey: one.babyBirthDay,
                     babySexKey: [NSString stringWithFormat:@"%ld", (long)one.babySex]};
        }
    }
    
    return nil;
}

+ (void)saveDueDate:(NSDate *)dueDate
{
    if ([self isNullValue:dueDate]) {
        return;
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    
    dueDate = [dueDate setDateToZero];
    RLMRealm *realm=[RLMRealm defaultRealm];
    RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
    
    [realm beginWriteTransaction];
    if (allUserInfos.count == 1) {
        ADUserInfo* one = [allUserInfos objectAtIndex:0];
        one.dueDate = dueDate;
    }else{
        ADUserInfo* newUserInfo = [[ADUserInfo alloc] init];
//        newUserInfo.icon = [NSData data];
        
        newUserInfo.dueDate = dueDate;
        newUserInfo.babyBirthDay = [NSDate date];
        newUserInfo.babySex = 0;
        
        [realm addObject:newUserInfo];
    }
    [realm commitWriteTransaction];
    
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:userInfoTimeKey];
    
    ADAppDelegate *delegate = APP_DELEGATE;
    delegate.dueDate = dueDate;
    
    [self syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
}

+ (NSDate *)readDueDate
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
    if (allUserInfos.count > 0) {
        ADUserInfo* one = allUserInfos[0];
        return one.dueDate;
    }
    return [NSDate date];
}

+ (void)saveBabaySex:(NSInteger)babySex
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    
    RLMRealm *realm=[RLMRealm defaultRealm];
    RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
    
    if (allUserInfos.count == 1) {
        ADUserInfo* one = [allUserInfos objectAtIndex:0];
        [realm beginWriteTransaction];
        one.babySex = babySex;
        [realm commitWriteTransaction];
    }else{
        ADUserInfo* newUserInfo = [[ADUserInfo alloc] init];
//        newUserInfo.icon = [NSData data];
        newUserInfo.uid = @"0";
        
        newUserInfo.dueDate = [NSDate date];//
        newUserInfo.babyBirthDay = [NSDate date];
        newUserInfo.babySex = babySex;
        
        [realm beginWriteTransaction];
        [realm addObject:newUserInfo];
        [realm commitWriteTransaction];
    }
    
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:userInfoTimeKey];
    
    [self syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
}

+ (NSInteger)readBabySex
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
    if (allUserInfos.count > 0) {
        ADUserInfo* one = allUserInfos[0];
        return one.babySex;
    }
    return ADBabySexNotSelected;
}

+ (BOOL)isNullValue:(id)object
{
    if ([object isEqual:[NSNull null]] || object == nil) {
        return YES;
    }
    
    return NO;
}

+ (void)needGetDataOnFinish:(void (^)(BOOL))aFinishBlock
{
    __block BOOL needGet = NO;
    if ([[[NSUserDefaults standardUserDefaults]addingUid] isEqualToString:@"0"]) {
        if (aFinishBlock) {
            aFinishBlock(needGet);
        }
    } else {
        [ADUserSyncMetaHelper is_severDataTimeLater_syncKey:userInfoTimeKey
                                                   onFinish:^(BOOL isLater, NSString *res)
         {
             needGet = isLater;
             NSLog(@"later: %d", isLater);
//             [self syncClientRecordTimeWithTimeSp:res];
             if (aFinishBlock) {
                 aFinishBlock(needGet);
             }
         }];
    }
}

+ (void)addARecord:(ADUserInfo *)aData
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"uid == %@", uid];
    RLMResults *allRes = [ADUserInfo objectsWithPredicate:predicate];
    
    if (allRes.count == 0) {
        [realm beginWriteTransaction];
        [realm addObject:aData];
        [realm commitWriteTransaction];
    }
    
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:userInfoTimeKey];
}

+ (void)createOrUpdate:(ADUserInfo *)aData
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"uid == %@", uid];
    RLMResults *allRes = [ADUserInfo objectsWithPredicate:predicate];
    ADAppDelegate *myappDelegate = APP_DELEGATE;
    myappDelegate.userStatus = aData.status;
    myappDelegate.babyBirthday = aData.babyBirthDay;
    myappDelegate.babySex = aData.babySex;
    myappDelegate.dueDate = aData.dueDate;
    
    [realm beginWriteTransaction];
    if (allRes.count == 0) {
        [realm addObject:aData];
    } else {
        ADUserInfo *oldData = allRes[0];
        if (aData.nickName.length > 0) {
            oldData.nickName = aData.nickName;
        }
        oldData.birthDay = aData.birthDay;
        oldData.dueDate = aData.dueDate;
        oldData.babyBirthDay = aData.babyBirthDay;
        oldData.babySex = aData.babySex;
        oldData.height = aData.height;
        oldData.weight = aData.weight;
        oldData.area = aData.area;
        oldData.status = aData.status;

    }
    [realm commitWriteTransaction];
    
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:userInfoTimeKey];
}

#pragma mark - sync method

+ (void)syncAllDataOnGetData:(void(^)(NSError *error))getDataBlock
             onUploadProcess:(void(^)(NSError *error))processBlock
              onUpdateFinish:(void(^)(NSError *error))finishBlock
{
    if (processBlock) {
        processBlock(nil);
    }
 
    [self needGetDataOnFinish:^(BOOL need) {
        if (need) {
            NSLog(@"con need");
            [ADUserInfoSyncManager getDataOnFinish:^(NSArray *res) {
                NSDictionary *dic = res[0];
                NSLog(@"sync user info dic: %@", dic);
                //合并数据
                [self createOrUpdate:[[ADUserInfo alloc] initWithDic:dic]];
                if (getDataBlock) {
                    getDataBlock(nil);
                }
                [self upDataWithFinishBlock:finishBlock];
            }];
        } else {
            //compare sync and local time
            [self upDataWithFinishBlock:finishBlock];
        }
    }];
}

+ (void)upDataWithFinishBlock:(void (^)(NSError *error))finishBlock
{
    if ([self needUploadData]) {
        // upload data
        NSLog(@"need up");
        [self uploadAllDataOnFinish:^(NSError *error) {
            if (finishBlock) {
                finishBlock(error);
            }
            NSLog(@"upload");
        }];
    } else {
        if (finishBlock) {
            finishBlock(nil);
        }
        
        NSLog(@"don't upload");
    }
}

+ (BOOL)needUploadData
{
    if ([[[NSUserDefaults standardUserDefaults]addingUid] isEqualToString:@"0"]) {
        return NO;
    }
    ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
    if (aRecord.c_userInfo_MTime.intValue > aRecord.s_userInfo_MTime.intValue) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)copyBasicUserInfoDataFromUid:(NSString *)uid
{
    RLMRealm *realm = [RLMRealm defaultRealm];
//    ADAppDelegate *myApp = APP_DELEGATE;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",@"0"];
    RLMResults *allUserInfos=[ADUserInfo objectsWithPredicate:predicate];
    if (allUserInfos.count == 1) {
        ADUserInfo *userInfo = [allUserInfos firstObject];
        [realm beginWriteTransaction];
        
//        userInfo.babySex = myApp.babySex;
        userInfo.babySex = [ADUserInfoSaveHelper readBabySex];
        userInfo.babyBirthDay = [ADUserInfoSaveHelper readBabyBirthday];
        userInfo.status = [ADUserInfoSaveHelper readUserStatus];
        userInfo.dueDate = [ADUserInfoSaveHelper readDueDate];
        [realm commitWriteTransaction];
        
    }else{
        ADUserInfo* userInfo = [[ADUserInfo alloc] init];
//        newUserInfo.icon = [NSData data];
        userInfo.uid = @"0";
        
//        NSLog(@"due :%@ birth :%@", myApp.dueDate, myApp.babyBirthday);
        userInfo.babySex = [ADUserInfoSaveHelper readBabySex];
        userInfo.babyBirthDay = [ADUserInfoSaveHelper readBabyBirthday];
        userInfo.status = [ADUserInfoSaveHelper readUserStatus];
        userInfo.dueDate = [ADUserInfoSaveHelper readDueDate];
        
        [realm beginWriteTransaction];
        [realm addObject:userInfo];
        [realm commitWriteTransaction];
    }
}


+ (void)uploadAllDataOnFinish:(void (^)(NSError *error))aFinishBlock
{
    NSString *addingToken = [[NSUserDefaults standardUserDefaults]addingToken];
    if (addingToken.length > 0) {
        
        NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
        RLMResults *aRes = [ADUserInfo objectsWithPredicate:predicate];
        
        ADUserInfo *aInfo = aRes[0];
        NSLog(@"aduserinfosd : %@",aInfo);
        NSString *weight = aInfo.weight;
        NSString *height = aInfo.height;
//        NSDateComponents* ageComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit
//                                                                          fromDate:[NSDate dateWithTimeIntervalSince1970:[aInfo.birthDay integerValue]]
//                                                                            toDate:[NSDate date]
//                                                                           options:0];
//
//        NSLog(@"年龄： %d",[ageComponents year]);
        
        if ([height rangeOfString:@"cm"].length > 0) {
           height = [height substringWithRange:(NSMakeRange(0, height.length - 3))];
        }
        
        if ([weight rangeOfString:@"kg"].length > 0) {
           weight = [weight substringWithRange:(NSMakeRange(0, weight.length - 3))];
        }
        
        RLMRealm *realm=[RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        aInfo.weight = weight;
        aInfo.height = height;
        [realm commitWriteTransaction];
        
        NSLog(@"rm res:%@", aRes);
        [ADUserInfoSyncManager uploadData:aRes onFinish:^(NSDictionary *res, NSError *error) {
            NSString *serverTime = [NSString stringWithFormat:@"%@", res[@"userInfoSyncTime"]];
            [ADUserSyncMetaHelper syncServerRecordTime:serverTime andSyncKey:userInfoTimeKey];
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