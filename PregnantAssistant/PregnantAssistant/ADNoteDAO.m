//
//  ADNoteDAO.m
//  PregnantAssistant
//
//  Created by D on 15/4/20.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADNoteDAO.h"
#import "ADNote.h" // old model
#import "ADUserSyncTimeDAO.h"
#import "ADUserSyncMetaHelper.h"
#import "ADImageUploader.h"
#import "ADMomNoteSyncManager.h"

static NSString *allNoteKey = @"ALLNOTE";

@implementation ADNoteDAO

+ (void)updateDataBaseOnfinish:(void (^)(void))aFinishBlock
{
    //old read method
    NSMutableArray *res = [NSKeyedUnarchiver unarchiveObjectWithData:
                           [[NSUserDefaults standardUserDefaults]objectForKey:allNoteKey]];
    if (res == nil) {
        res = [[NSMutableArray alloc]initWithCapacity:0];
    }
    
    NSLog(@"note res:%@", res);
    //new save method
    for (int i = 0; i < res.count; i++) {
        ADNote *aNote = res[i];
        
        NSLog(@"date: %@", aNote.dateLabelStr);
        [self addNote:[[ADNewNote alloc]initWithNote:aNote.note
                                         photosNames:aNote.photoNames
                                          photosUrls:@""
                                           photoData:nil
                                      andPublishDate:[NSDate date]]];
    }
    
    //old delete method
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:allNoteKey];
    
    if (aFinishBlock) {
        aFinishBlock();
    }
}

+ (NSDate *)getDateFromStr:(NSString *)dateStr
{
    NSDate *aDate = nil;
    
    int year = [dateStr substringWithRange:NSMakeRange(0, 4)].intValue;
    
    NSRange yearRange = [dateStr rangeOfString:@"年"];
    NSRange monthRange = [dateStr rangeOfString:@"月"];
    NSRange dayRange = [dateStr rangeOfString:@"日"];
//    NSLog(@"pos: %lu loc: %lu", yearRange.length,
//          monthRange.location - (yearRange.location + yearRange.length));
    int month = [dateStr substringWithRange:NSMakeRange(yearRange.location + yearRange.length,
                                                        monthRange.location - (yearRange.location + yearRange.length))].intValue;
    int day = [dateStr substringWithRange:NSMakeRange(monthRange.location + monthRange.length,
                                                      dayRange.location- (monthRange.location + monthRange.length))].intValue;
    int hour = [dateStr substringWithRange:NSMakeRange(dateStr.length -3, 2)].intValue;
    int min = [dateStr substringWithRange:NSMakeRange(dateStr.length -2, 2)].intValue;
    
    aDate = [ADHelper makeDateWithYear:year month:month day:day Hour:hour andMin:min];
    return aDate;
}

+ (RLMResults *)readAllData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    
//    [self checkAndAssignUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    RLMResults *result = [ADNewNote objectsWithPredicate:predicate];
    
    return [result sortedResultsUsingProperty:@"publishDate" ascending:NO];
}

+ (void)removeDuplicateWithObject:(RLMResults *)aRes
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    NSMutableArray *toRemove = [NSMutableArray array];
    for (int i = 0; i < aRes.count; i++) {
        ADNewNote *aData = aRes[i];
        for (int j = i +1; j < aRes.count; j++) {
            ADNewNote *nextData = aRes[j];
//            NSLog(@"aData:%@ nData:%@", aData, nextData);
            if ([aData.publishDate isEqual:nextData.publishDate] &&
                [aData.note isEqualToString:nextData.note]) {
//                NSLog(@"real delte");
                [toRemove addObject:nextData];
            }
        }
    }
    
    [realm deleteObjects:toRemove];
    [realm commitWriteTransaction];
}


+ (void)delNote:(ADNewNote *)aNote
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteObject:aNote];
    
    [realm commitWriteTransaction];
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:motherDiaryKey];
}

+ (void)addNote:(ADNewNote *)aNote
{
//    RLMResults *allNote = [self readAllData];
    
//    BOOL haveSameNote = NO;
//    for (ADNewNote *everyNote in allNote) {
//        if ([everyNote.publishDate isEqualToDate:aNote.publishDate]) {
//            haveSameNote = YES;
//            break;
//        }
//    }
//
//    if (haveSameNote == NO) {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:aNote];
    [realm commitWriteTransaction];

    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:motherDiaryKey];
//    }
}

+ (void)updateNewNoteWithNote:(NSString *)noteText publishTimer:(NSString *)publishTimer {
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *unSyncPre = [NSPredicate predicateWithFormat:@"uid == %@ AND publishTimer == %@",uid,publishTimer];
    RLMResults *unSyncRes = [ADNewNote objectsWithPredicate:unSyncPre];
    RLMRealm *realm = [RLMRealm defaultRealm];
    if (unSyncRes.count > 0) {
        ADNewNote *aNewNote = [unSyncRes firstObject];
        [realm beginWriteTransaction];
        aNewNote.note = noteText;
        aNewNote.publishTimer = publishTimer;
        [realm commitWriteTransaction];
    }
    
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:motherDiaryKey];

}

+ (RLMResults *)readNewNoteWithNSTimer:(NSString *)timer{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *unSyncPre = [NSPredicate predicateWithFormat:@"uid == %@ AND publishTimer == %@",uid,timer];
    return [ADNewNote objectsWithPredicate:unSyncPre];
    
}

+ (void)addDiaryModelWithNote:(NSString *)noteText photosNames:(ADMotherDirPhoto *)photosName photosUrls:(NSString *)photoUrl publishDate:(NSString *)publishTimer imageName:(NSString *)imageName newNotoe:(ADNewNote *)adnewNote{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *unSyncPre = [NSPredicate predicateWithFormat:@"uid == %@ AND publishTimer == %@",uid,publishTimer];
    RLMResults *unSyncRes = [ADNewNote objectsWithPredicate:unSyncPre];
    RLMRealm *realm = [RLMRealm defaultRealm];
    if (unSyncRes.count == 0) {
        ADNewNote *newNote = [[ADNewNote alloc] init];
        newNote.note = noteText;
        [newNote.motherPhotoModes addObject:photosName];
        newNote.photoUrls = photoUrl;
        newNote.publishTimer = publishTimer;
        newNote.publishDate = [NSDate dateWithTimeIntervalSince1970:[publishTimer integerValue]];
        [realm beginWriteTransaction];
        [realm addObject:newNote];
        [realm commitWriteTransaction];
    }else{
        NSPredicate *stringPredicate = [NSPredicate predicateWithFormat:@"imageName == %@ AND uid == %@",imageName,uid];
        RLMResults *stringResult = [ADMotherDirPhoto objectsWithPredicate:stringPredicate];
        if (stringResult.count == 0) {
            [realm beginWriteTransaction];
            [adnewNote.motherPhotoModes addObject:photosName];
            [realm commitWriteTransaction];
        }
    }
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:motherDiaryKey];

}

+ (void)updateWithPublishDate:(NSString *)pubLishTimer photosName:(NSString *)photoName isUpload:(BOOL)isUpload{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *unSyncPre = [NSPredicate predicateWithFormat:@"uid == %@ AND publishTimer == %@",uid,pubLishTimer];
    RLMResults *unSyncRes = [ADNewNote objectsWithPredicate:unSyncPre];
    RLMRealm *realm = [RLMRealm defaultRealm];
    if (unSyncRes.count > 0) {
        ADNewNote *aNewNote = [unSyncRes firstObject];
        for (ADMotherDirPhoto *stringObject in aNewNote.motherPhotoModes) {
            NSPredicate *stringPredicate = [NSPredicate predicateWithFormat:@"imageName == %@ AND uid == %@",photoName,uid];
            RLMResults *stringResult = [ADMotherDirPhoto objectsWithPredicate:stringPredicate];
            if (stringResult.count > 0) {
                [realm beginWriteTransaction];
                stringObject.isUpload = isUpload;
                [realm commitWriteTransaction];
                [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:motherDiaryKey];
            }
        }
    }
}

+ (void)updateWithNote:(NSString *)noteText newNote:(ADNewNote *)adNewnote{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    adNewnote.note = noteText;
    [realm commitWriteTransaction];

}

+ (void)createOrUpdateNote:(ADNewNote *)aNewNote
{
    RLMResults *allNote = [self readAllData];
    
//    NSLog(@"p")
    if (aNewNote.publishDate != nil) {
        ADNewNote *sameNote = nil;
        for (ADNewNote *aNote in allNote) {
            if ([aNote.publishDate isEqualToDate:aNewNote.publishDate]) {
                NSLog(@"HAVE SAME DAY");
                sameNote = aNote;
                break;
            }
        }
        if (sameNote != nil) {
            [self delNote:sameNote];
        }
    }
    
    [self addNote:aNewNote];
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:motherDiaryKey];
}



+ (void)distrubuteData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    
    NSPredicate *unSyncPre = [NSPredicate predicateWithFormat:@"uid == '0'"];
    
    RLMResults *unSyncRes = [ADNewNote objectsWithPredicate:unSyncPre];
//    RLMResults *unSyncRes = [ADNewNote allObjects];
    RLMRealm *realm = [RLMRealm defaultRealm];
    for (int i = 0; i < unSyncRes.count;) {
        ADNewNote *aData = unSyncRes[i];
        [realm beginWriteTransaction];
        aData.uid = uid;
        [realm commitWriteTransaction];
        
//        ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
//        if (aRecord.c_motherDiary_MTime.integerValue > 0) {
//            [self syncClientRecordTime];
//        }
    }
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:motherDiaryKey];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    [self removeDuplicateWithObject:[ADNewNote objectsWithPredicate:predicate]];
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
//    if (aTimeSp.integerValue > aRecord.c_motherDiary_MTime.integerValue) {
//        aRecord.c_motherDiary_MTime = aTimeSp;
//    }
//
//    [realm commitWriteTransaction];
//}
//
//+ (void)syncClientRecordTime
//{
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
//    
//    [self syncClientRecordTimeWithTimeSp:timeSp];
//}


+ (void)needGetDataOnFinish:(void (^)(BOOL))aFinishBlock
{
    __block BOOL needGet = NO;
    if ([[[NSUserDefaults standardUserDefaults]addingUid] isEqualToString:@"0"]) {
        if (aFinishBlock) {
            aFinishBlock(needGet);
        }
    } else {
        [ADUserSyncMetaHelper is_severDataTimeLater_syncKey:@"motherDiarySyncTime"
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
    
//    if ([self readAllData].count > 0 &&
//        [[ADUserSyncMetaHelper getToolSyncStrDateWithSyncName:motherDiaryKey] isEqualToString:@"0"]) {
//        [self syncClientRecordTime];
//    }

    [self needGetDataOnFinish:^(BOOL need) {
        NSLog(@"! need:%d", need);
        if (need) {
            [ADMomNoteSyncManager getDataOnFinish:^(NSArray *res) {
                NSLog(@"cal res:%@", res);
                //合并数据
                DISPATCH_ON_GLOBAL_QUEUE_DEFAULT((^{
                    for (int i = 0; i < res.count; i++) {
                        NSString *shotDateStr = res[i][@"time"];
                        NSDate *noteDate = [NSDate dateWithTimeIntervalSince1970:shotDateStr.integerValue];
                        NSString *url = res[i][@"url"];
                        NSString *content = res[i][@"content"];
                        
                        NSMutableArray *photoNames = [[NSMutableArray alloc]initWithCapacity:0];
                        [self createOrUpdateNote:[[ADNewNote alloc]initWithNote:content
                                                         photosNames:photoNames
                                                          photosUrls:url
                                                           photoData:nil
                                                      andPublishDate:noteDate]];
                    }
                    
                    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
                    [self removeDuplicateWithObject:[ADNewNote objectsWithPredicate:predicate]];
                    
                    DISPATCH_ON_MAIN_THREAD(^{
                        if (getDataBlock) {
                            getDataBlock(nil);
                        }
                    });
                    
                    
                    [self uploadAllDataOnFinish:finishBlock];
                }));
            }];
        } else {
            [self uploadAllDataOnFinish:finishBlock];
        }
    }];
}

+ (void)uploadAllDataOnFinish:(void (^)(NSError *error))aFinishBlock
{
    NSString *addingToken = [[NSUserDefaults standardUserDefaults]addingToken];
    if (addingToken.length > 0) {
        RLMResults *aRes = [self readAllData];
        [ADMomNoteSyncManager uploadData:aRes onFinish:^(NSDictionary *res, NSError *error) {
            NSString *serverTime = [NSString stringWithFormat:@"%@", res[@"motherDiarySyncTime"]];
            [ADUserSyncMetaHelper syncServerRecordTime:serverTime andSyncKey:@"motherDiarySyncTime"];

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

//+ (void)checkAndAssignUid
//{
//    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
//    
//    if (![uid isEqualToString:@"0"]) {
//        // 检查用户未登录情况下 记录的数据
//        // 分配登陆后的uid
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == '0'"];
//        
//        RLMResults *unSyncRes = [ADNewNote objectsWithPredicate:predicate];
//        RLMRealm *realm = [RLMRealm defaultRealm];
//        [realm beginWriteTransaction];
//        for (int i = 0; i < unSyncRes.count; i++) {
//            ADNewNote *aData = unSyncRes[i];
//            aData.uid = uid;
//        }
//        
//        [realm commitWriteTransaction];
//    }
//}

+ (void)uploadOldData
{
    if ([[NSUserDefaults standardUserDefaults]everUploadMomNote]) {
        return;
    }
    
    RLMResults *aRes = [self readAllData];
    
    NSLog(@"note res: %@", aRes);
 
//    ADAppDelegate *delegate = APP_DELEGATE;
    for (ADNewNote *aNote in aRes) {
        // 老数据 生成 url 并上传
        NSString *photoUrls = @"";
        for (ADStringObject *aPicName in aNote.photoNames) {
            NSString *imgPath =
            [NSString stringWithFormat:@"/pa/momNote/%@.jpeg", [ADImageUploader generateImageName]];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = paths[0];
            
            NSString *imagePath =
            [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", aPicName.value]];
            
            UIImage *aImg = [UIImage imageWithContentsOfFile:imagePath];
            NSLog(@"customImg:%@", aImg);
            float width = SCREEN_WIDTH -32;
            float height = width *(aImg.size.height / aImg.size.width);
            aImg = [ADHelper scaleImg:aImg toSize:CGSizeMake(width, height)];
            
            [ADImageUploader uploadWithImage:aImg
                                      toPath:imgPath
                               progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
                               }
                               completeBlock:
             ^(NSError *error, NSDictionary *result, NSString *imgUrl, BOOL completed) {
             }];
            
            NSString *fullPath = [NSString stringWithFormat:@"http://addinghome.b0.upaiyun.com%@",imgPath];
            if (photoUrls.length == 0) {
                photoUrls = fullPath;
            } else {
                photoUrls = [NSString stringWithFormat:@"%@,%@", photoUrls, fullPath];
            }
        }
        
        NSLog(@"note url:%@", photoUrls);
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        aNote.photoUrls = photoUrls;
        [realm commitWriteTransaction];
    }
    
    if (aRes.count > 0) {
        [self uploadAllDataOnFinish:^(NSError *error) {
            if (error == nil) {
                [[NSUserDefaults standardUserDefaults]setEverUploadMomNote:YES];
            }
        }];
    } else {
        [[NSUserDefaults standardUserDefaults]setEverUploadMomNote:YES];
    }
}

@end
