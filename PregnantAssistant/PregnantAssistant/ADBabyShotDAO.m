//
//  ADBabyShotDAO.m
//  PregnantAssistant
//
//  Created by D on 15/4/20.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBabyShotDAO.h"
#import "ADBabyShotSyncManager.h"
#import "NSDate+Utilities.h"
//#import "Reachability.h"
#import "ADUserSyncMetaHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ADImageUploader.h"

@implementation ADBabyShotDAO

+ (void)savePhotoWithUrl:(NSString *)aUrl
                 andDate:(NSDate *)aDate
                onFinish:(void (^)())aFinishBlock
{
    [self savePhotoWithImage:nil andUrl:aUrl andDate:aDate isUpload:YES onFinish:aFinishBlock];
}

+ (void)savePhotoWithImage:(UIImage *)aImg
                    andUrl:(NSString *)aUrl
                   andDate:(NSDate *)aDate
                  isUpload:(BOOL)isupload
                  onFinish:(void (^)())aFinishBlock
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@",aUrl];
    RLMResults *predicateResult = [ADShotPhoto objectsWithPredicate:predicate];
    ADShotPhoto *aphoto = [predicateResult firstObject];
    if ([aphoto.url isEqualToString:aUrl]) {
        return;
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    ADShotPhoto *toSavePhoto = [[ADShotPhoto alloc]initWithImg:aImg shotDate:aDate];
    toSavePhoto.url = aUrl;
    toSavePhoto.isUpload = isupload;
    [realm addObject:toSavePhoto];
    
    [realm commitWriteTransaction];
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:pregDiaryKey];
    if (aFinishBlock) {
        aFinishBlock();
    }
}

+ (void)updatePhotoWithUrl:(NSString *)aUrl
                  toNewUrl:(NSString *)newUrl
                  isUpload:(BOOL)isupload{
    NSLog(@"aurlssdj: %@,newUrl:%@",aUrl,newUrl);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@",aUrl];
    RLMResults *predicateResult = [ADShotPhoto objectsWithPredicate:predicate];
    if (predicateResult.count) {
        ADShotPhoto *aphoto = [predicateResult lastObject];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        aphoto.isUpload = isupload;
        aphoto.url = newUrl;
        [realm commitWriteTransaction];
    }
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:pregDiaryKey];
}

+ (RLMResults *)readAllData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    
    RLMResults *result = nil;
    if (![uid isEqualToString:@"0"]) {
        [self removeDuplicateWithObject:[ADShotPhoto objectsWithPredicate:predicate]];
    }
    result = [ADShotPhoto objectsWithPredicate:predicate];
    
    return [result sortedResultsUsingProperty:@"shotDate" ascending:NO];
}

+ (void)deleteAllData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    RLMResults *result = [ADShotPhoto objectsWithPredicate:predicate];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:result];
    [realm commitWriteTransaction];
}


+ (void)removeDuplicateWithObject:(RLMResults *)aRes
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];

    NSMutableArray *toRemove = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < aRes.count; i++) {
        ADShotPhoto *aData = aRes[i];
        for (int j = i +1; j < aRes.count; j++) {
            ADShotPhoto *nextData = aRes[j];
            //            NSLog(@"aData:%@ nData:%@", aData, nextData);
            if ([aData.url isEqual:nextData.url] && aData.url.length > 0) {
                NSLog(@"real delte");
                [toRemove addObject:nextData];
            }
        }
    }
    
    [realm deleteObjects:toRemove];
    [realm commitWriteTransaction];
}

+ (void)removeAPhoto:(ADShotPhoto *)aPhoto
            onFinish:(void (^)())aFinishBlock
{
    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:aPhoto];
    [realm commitWriteTransaction];
    
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:pregDiaryKey];
    
    if (aFinishBlock) {
        aFinishBlock();
    }
}

+ (void)distrubuteData
{
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *unSyncPre = [NSPredicate predicateWithFormat:@"uid == '0'"];
    
    RLMResults *unSyncRes = [ADShotPhoto objectsWithPredicate:unSyncPre];
//    RLMResults *unSyncRes = [ADShotPhoto allObjects];
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    for (int i = 0; i < unSyncRes.count;) {
        ADShotPhoto *aData = unSyncRes[i];
        [realm beginWriteTransaction];
        aData.uid = uid;
        [realm commitWriteTransaction];

//        NSLog(@"change uid:%@", uid);
        
//        ADSyncToolTime *aRecord = [ADUserSyncTimeDAO findUserSyncTimeRecord];
//        if (aRecord.c_pregDiary_MTime.integerValue > 0) {
//            [self syncClientRecordTime];
//        }
    }
    [ADUserSyncMetaHelper syncClientRecordTimeByToolKey:pregDiaryKey];
    
}

+ (void)uploadAllImageDataOnFinish:(void(^)(void))FinshBlock{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"uid == %@", uid];
    RLMResults *aRes = [ADShotPhoto objectsWithPredicate:pre];
    NSMutableArray *unUploadPhoto = [NSMutableArray array];
    
    for (int i = 0; i < aRes.count; i ++) {
        ADShotPhoto *shotPhoto = aRes[i];
        if (!shotPhoto.isUpload) {
            [unUploadPhoto addObject:shotPhoto];
        }
    }
    if (unUploadPhoto.count > 0) {
        for (int i = 0; i < unUploadPhoto.count; i ++) {
            ADShotPhoto *shotPhoto = unUploadPhoto[i];
            NSString *imgPath =
            [NSString stringWithFormat:@"/pa/babyShot/%@.jpeg", [ADImageUploader generateImageName]];
            [ADImageUploader uploadWithImage:[UIImage imageWithData:shotPhoto.shotImg] toPath:imgPath
                               progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
                               } completeBlock:^(NSError *error, NSDictionary *result, NSString *imgUrl, BOOL completed) {
                                   if (completed) {
                                       [ADBabyShotDAO updatePhotoWithUrl:shotPhoto.url toNewUrl:imgUrl isUpload:YES];
                                   }else{
                                       [ADBabyShotDAO updatePhotoWithUrl:shotPhoto.url toNewUrl:imgUrl isUpload:NO];
                                   }
                                   if (i == unUploadPhoto.count - 1) {
                                       if (FinshBlock) {
                                           FinshBlock();
                                       }
                                   }
                               }];

        }
    }else{
        if (FinshBlock) {
            FinshBlock();
        }
    }
}

#pragma mark - sync method
+ (void)uploadAllDataOnFinish:(void (^)(NSError *error))aFinishBlock
{
    NSString *addingToken = [[NSUserDefaults standardUserDefaults]addingToken];
    if (addingToken.length > 0) {
        [self uploadAllImageDataOnFinish:^{
            NSString *uid = [[NSUserDefaults standardUserDefaults]addingUid];
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"uid == %@", uid];
            RLMResults *aRes = [ADShotPhoto objectsWithPredicate:pre];
            NSLog(@"skdfklsjdkf: %@",aRes);
            [ADBabyShotSyncManager uploadData:aRes onFinish:^(NSDictionary *res, NSError *error) {
                NSString *serverTime = [NSString stringWithFormat:@"%@", res[@"pregDiarySyncTime"]];
                [ADUserSyncMetaHelper syncServerRecordTime:serverTime andSyncKey:pregDiaryKey];
                NSLog(@"upload all res:%@", res);
                if (aFinishBlock) {
                    aFinishBlock(error);
                }
            }];
        }];
    } else {
        if (aFinishBlock) {
            aFinishBlock([NSError notLoginError]);
        }
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
        [ADUserSyncMetaHelper is_severDataTimeLater_syncKey:@"pregDiarySyncTime"
                                                   onFinish:^(BOOL isLater, NSString *res)
         {
//             [self syncClientRecordTimeWithTimeSp:res];//不明白问什么这里需要记录时间
             needGet = isLater;
             if (aFinishBlock) {
                 aFinishBlock(needGet);
             }
         }];
    }
}

+ (void)uploadOldDataOnFinish:(void (^) (void))aFinishBlock
{
    if ([[NSUserDefaults standardUserDefaults]everUploadBabyShotImg]) {
        if (aFinishBlock) {
            aFinishBlock();
        }
        return;
    }
    
//    RLMResults *aRes = [self readAllData];
    RLMResults *aRes = [ADShotPhoto allObjects];
    NSLog(@"shot res: %@", aRes);
    
    __block NSInteger uploadCnt = 0;
    
    for (ADShotPhoto *aPhoto in aRes) {
        // 老数据 生成 url 并上传
        NSString *imgPath =
        [NSString stringWithFormat:@"/pa/babyShot/%@.jpeg", [ADImageUploader generateImageName]];
        NSLog(@"uploadImg: %@", imgPath);
        uploadCnt ++;
        [ADImageUploader uploadWithImage:[UIImage imageWithData:aPhoto.shotImg]
                                  toPath:imgPath
                           progressBlock:nil
                           completeBlock:
         ^(NSError *error, NSDictionary *result, NSString *imgUrl, BOOL completed) {
             uploadCnt --;
             if (uploadCnt == 0) {
                 if (aFinishBlock) {
                     aFinishBlock();
                 }
             }
         }];
        
        NSString *imgUrl = [NSString stringWithFormat:@"http://addinghome.b0.upaiyun.com%@",imgPath];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        aPhoto.url = imgUrl;
        aPhoto.uid = [[NSUserDefaults standardUserDefaults]addingUid];
        [realm commitWriteTransaction];
    }
    
    if (aRes.count > 0) {
        [self uploadAllDataOnFinish:^(NSError *error) {
            if (error == nil) {
                [[NSUserDefaults standardUserDefaults]setEverUploadBabyShotImg:YES];
            }
        }];
    } else {
        if (aFinishBlock) {
            aFinishBlock();
        }
        [[NSUserDefaults standardUserDefaults]setEverUploadBabyShotImg:YES];
    }
}

+ (void)upDataWithFinishBlock:(void (^)(NSError *error))finishBlock
{
    [self uploadAllDataOnFinish:^(NSError *error) {
        if (finishBlock) {
            finishBlock(error);
        }
        NSLog(@"upload");
    }];

//    if ([self needUploadData]) {
//        // upload data
//        NSLog(@"need up");
//        [self uploadAllDataOnFinish:^(NSError *error) {
//            if (finishBlock) {
//                finishBlock(error);
//            }
//            NSLog(@"upload");
//        }];
//    } else {
//        if (finishBlock) {
//            finishBlock(nil);
//        }
//        
//        NSLog(@"don't upload");
//    }
}

+ (BOOL)isneedDowloadImageWithUrl:(NSString *)url{

    NSPredicate *pre = [NSPredicate predicateWithFormat:@"url == %@", url];
    RLMResults *aRes = [ADShotPhoto objectsWithPredicate:pre];
    if (aRes.count > 0) {
        return NO;
    }
    return YES;
}



+ (void)syncAllDataOnGetData:(void(^)(NSError *error))getDataBlock
             onUploadProcess:(void(^)(NSError *error))processBlock
              onUpdateFinish:(void(^)(NSError *error))finishBlock
{
    if (processBlock) {
        processBlock(nil);
    }
    

    [self needGetDataOnFinish:^(BOOL need) {
        NSLog(@"baby need:%d", need);
        if (need) {
            [ADBabyShotSyncManager getDataOnFinish:^(NSArray *res)
            {
                NSLog(@"cal res:%@", res);
                //合并数据
                if (res.count > 0) {
                    for (int i = 0; i < res.count; i++) {
                        NSString *shotDateStr = res[i][@"time"];
                        NSDate *shotDate = [NSDate dateWithTimeIntervalSince1970:shotDateStr.integerValue];
                        NSString *url = res[i][@"url"];
                        if ([self isneedDowloadImageWithUrl:url]) {
                            [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
                                 if (image) {
                                     [self savePhotoWithImage:image andUrl:url andDate:shotDate isUpload:YES onFinish:nil];
                                     if (getDataBlock) {
                                         getDataBlock(nil);
                                     }
                                     if (i == res.count -1) {
                                         NSLog(@"res cnt:%lu photo save i:%d", (unsigned long)res.count, i);
                                         [self upDataWithFinishBlock:finishBlock];
                                     }
                                 }
                             }];

                        }else{
                            if (i == res.count - 1) {
                                [self upDataWithFinishBlock:finishBlock];
                            }
                        }
                    }

                }else{
                    if (finishBlock) {
                        finishBlock(nil);
                    }
                    [self upDataWithFinishBlock:finishBlock];
                }
            }];
        } else {
            [self upDataWithFinishBlock:finishBlock];
        }
    }];
}

@end
