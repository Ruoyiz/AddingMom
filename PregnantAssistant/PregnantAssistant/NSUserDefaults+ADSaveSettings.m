//
//  NSUserDefaults+ADSaveSettings.m
//  PregnantAssistant
//
//  Created by D on 15/1/8.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "NSUserDefaults+ADSaveSettings.h"
#import "ADUserInfoSaveHelper.h"

@implementation NSUserDefaults (ADSaveSettings)

-(void)setDate:(NSData *)date
{
    [self setObject:date forKey:dateKey];
    [self synchronize];
}

-(NSData *)date
{
   return [self objectForKey:dateKey];
}

-(void)setFirstUseAppDate:(NSDate *)firstUseAppDate
{
    [self setObject:firstUseAppDate forKey:firstLaunchTimeKey];
    [self synchronize];
}

-(NSDate *)firstUseAppDate
{
    return [self objectForKey:firstLaunchTimeKey];
}

-(void)setFirstLauch:(BOOL)firstLauch
{
    [self setBool:firstLauch forKey:firstLaunchKey];
    [self synchronize];
}

- (void)setLaunchType:(NSInteger)type
{
    if (type == ADLaunchTypeDuringPregnancy) {
        [ADUserInfoSaveHelper saveUserStatus:@"1"];
    } else {
        [ADUserInfoSaveHelper saveUserStatus:@"2"];
    }

    [self setInteger:type forKey:appLaunchType];
    [self synchronize];
}

- (NSInteger)launchType
{
//    if ([self objectForKey:appLaunchType]) {
//        NSLog(@"存在key值");
//    }else
//        NSLog(@"不存在");
//    if ([[ADUserInfoSaveHelper readUserStatus] isEqualToString:@"1"]) {
//        return ADLaunchTypeDuringPregnancy;
//    }else if ([[ADUserInfoSaveHelper readUserStatus] isEqualToString:@"2"]){
//        return ADLaunchTypeDuringParenting;
//    }
//    if ([[ADUserInfoSaveHelper readUserStatus] isEqualToString:@"1"]) {
//        return 1;
//    } else {
//        return 2;
//    }
    return [self integerForKey:appLaunchType];
}

-(BOOL)firstLauch
{
    return [self boolForKey:firstLaunchKey];
}

-(void)setMomSecretCommentDraft:(NSString *)momSecretCommentDraft
{
    [self setObject:momSecretCommentDraft forKey:momSecretCommentDraftKey];
    [self synchronize];
}

-(NSString *)momSecretCommentDraft
{
    return [self objectForKey:momSecretCommentDraftKey];
}

-(void)setAllContractionRecords:(NSArray *)allContractionRecords
{
    [self setObject:allContractionRecords forKey:allContractionRecordKey];
    [self synchronize];
}

-(NSArray *)allContractionRecords
{
    return [self objectForKey:allContractionRecordKey];
}

-(void)setHasShowNoticeTip:(BOOL)hasShowNoticeTip
{
    [self setBool:hasShowNoticeTip forKey:hasShowNoticeTipKey];
    [self synchronize];
}

-(BOOL)hasShowNoticeTip
{
    return [self boolForKey:hasShowNoticeTipKey];
}

-(void)setAddingToken:(NSString *)addingToken
{
    if (addingToken == nil || [addingToken isEqual:[NSNull null]]) {
        addingToken = @"";
    }
    
    [self setObject:addingToken forKey:addingTokenKey];
    [self synchronize];
}

-(NSString *)addingToken
{
    NSString *token = [self objectForKey:addingTokenKey];
    if ([token isEqual:[NSNull null]] || token == nil) {
        token = @"";
    }
    return token;
}

- (void)removeAddingToken
{
    [self removeObjectForKey:addingTokenKey];
    [self synchronize];
}

#pragma mark - uid
-(void)setAddingUid:(NSString *)addingUid
{
    [self setObject:addingUid forKey:addingUidKey];
    [self synchronize];
}

-(NSString *)addingUid
{
    NSString *uid = [self objectForKey:addingUidKey];
    if (uid.length == 0) {
        uid = @"0";
    }
    return uid;
}

- (void)removeAddingUid
{
    [self removeObjectForKey:addingUidKey];
    [self synchronize];
}

-(void)setTouchWarmTime:(NSString *)touchWarmTime
{
    [self setObject:touchWarmTime forKey:touchWarmTimeKey];
    [self synchronize];
}

-(NSString *)touchWarmTime
{
    return [self objectForKey:touchWarmTimeKey];
}

-(void)setFavToolArray:(NSData *)favToolArray
{
    [self setObject:favToolArray forKey:favToolIconKey];
    [self synchronize];
}

-(NSData *)favToolArray
{
    return [self objectForKey:favToolIconKey];
}

-(void)setAddingMomSecret:(NSString *)addingMomSecret
{
    [self setObject:addingMomSecret forKey:addingMomSecretKey];
    [self synchronize];
}

-(NSString *)addingMomSecret
{
    return [self objectForKey:addingMomSecretKey];
}

-(void)setDueDate:(NSData *)dueDate
{
    [self setObject:dueDate forKey:dueDateKey];
    [self synchronize];
}

-(NSData *)dueDate
{
    return [self objectForKey:dueDateKey];
}

- (void)setBirthDate:(NSDate *)birthDate
{
    [self setObject:birthDate forKey:birthdateKey];
    [self synchronize];
}

- (void)setBabySex:(ADBabySex)babySex
{
    [self setInteger:babySex forKey:babaySexKey];
    [self synchronize];
}

- (ADBabySex)babySex
{
    return (ADBabySex)[self integerForKey:babaySexKey];
}

- (NSDate *)birthDate
{
    return [self objectForKey:birthdateKey];
}

- (void)setPushDate:(NSDate *)date
{
    [self setObject:date forKey:@"PUSHDATE"];
    [self synchronize];
}

- (NSDate *)pushDate
{
    return [self objectForKey:@"PUSHDATE"];
}

-(void)setEverLaunched:(BOOL)everLaunched
{
    [self setBool:everLaunched forKey:everLaunchedKey];
    [self synchronize];
}

-(BOOL)everLaunched
{
    return [self boolForKey:everLaunchedKey];
}

-(void)setWxAccessToken:(NSString *)wxAccessToken
{
    [self setObject:wxAccessToken forKey:wxAccessTokenKey];
    [self synchronize];
}

-(NSString *)wxAccessToken
{
    return [self objectForKey:wxAccessTokenKey];
}

-(void)setWxRefreshToken:(NSString *)wxRefreshToken
{
    [self setObject:wxRefreshToken forKey:wxRefreshToken];
    [self synchronize];
}

-(NSString *)wxRefreshToken
{
    return [self objectForKey:wxRefreshTokenKey];
}

-(void)setWxOpenId:(NSString *)wxOpenId
{
    [self setObject:wxOpenId forKey:wxOpenIdKey];
    [self synchronize];
}

-(NSString *)wxOpenId
{
    return [self objectForKey:wxOpenIdKey];
}

-(void)setMomLookListRequestTime:(NSDate *)momLookListRequestTime
{
    [self setObject:momLookListRequestTime forKey:momLookListRequstTimeKey];
    [self synchronize];
}

-(NSDate *)momLookListRequestTime
{
    NSDate * res = [self objectForKey:momLookListRequstTimeKey];
    if (res == nil) {
        res = [NSDate date];
        [self setMomLookListRequestTime:res];
    }
    return res;
}

-(void)setMomLookFeedListRequestTime:(NSDate *)momLookFeedListRequestTime
{
    [self setObject:momLookFeedListRequestTime forKey:momLookFeedListRequestTimeKey];
    [self synchronize];
}

-(NSDate *)momLookFeedListRequestTime
{
    NSDate * res = [self objectForKey:momLookFeedListRequestTimeKey];
    if (res == nil) {
        res = [NSDate date];
        [self setMomLookFeedListRequestTime:res];
    }
    return res;
}

-(void)setEverRecIcon:(BOOL)everRecIcon
{
    [self setBool:everRecIcon forKey:everRecKey];
    [self synchronize];
}

-(BOOL)everRecIcon
{
    return [self boolForKey:everRecKey];
}


-(void)setHaveLauchToolTab:(BOOL)haveLauchToolTab
{
    [self setBool:haveLauchToolTab forKey:haveLauchToolTabKey];
    [self synchronize];
}

-(BOOL)haveLauchToolTab
{
    return [self boolForKey:haveLauchToolTabKey];
}

-(void)setHavetUpdateCountFetalToolData:(BOOL)havetUpdateCountFetalToolData
{
    [self setBool:havetUpdateCountFetalToolData forKey:countFetal_HaveUpdate];
    [self synchronize];
}

-(BOOL)havetUpdateCountFetalToolData
{
    return [self boolForKey:countFetal_HaveUpdate];
}

- (BOOL)everChangedLaunchType
{
    return [self boolForKey:ever_ChangedLaunchType];
}

- (void)setEverChangedLaunchType:(BOOL)everChangedLaunchType
{
    [self setBool:everChangedLaunchType forKey:ever_ChangedLaunchType];
    [self synchronize];
}

- (BOOL)everUploadBabyShotImg
{
    return [self boolForKey:everUploadBabyImgKey];
}

- (void)setEverUploadBabyShotImg:(BOOL)everUploadBabyShotImg
{
    [self setBool:everUploadBabyShotImg forKey:everUploadBabyImgKey];
    [self synchronize];
}

- (BOOL)everUploadCheckCal
{
    return [self boolForKey:everUploadCheckCalKey];
}

- (void)setEverUploadCheckCal:(BOOL)everUploadCheckCal
{
    [self setBool:everUploadCheckCal forKey:everUploadCheckCalKey];
    [self synchronize];
}

-(BOOL)everUploadContraction
{
    return [self boolForKey:everUploadContractionKey];
}

- (void)setEverUploadContraction:(BOOL)everUploadContraction
{
    [self setBool:everUploadContraction forKey:everUploadContractionKey];
    [self synchronize];
}

- (BOOL)everUploadCountFetail
{
    return [self boolForKey:everUploadCountFetailKey];
}

- (void)setEverUploadCountFetail:(BOOL)everUploadCountFetail
{
    [self setBool:everUploadCountFetail forKey:everUploadContractionKey];
    [self synchronize];
}

- (void)setCheckSyncDate:(NSDate *)checkSyncDate
{
    [self setObject:checkSyncDate forKey:checkSyncDateKey];
    [self synchronize];
}

- (NSDate *)checkSyncDate
{
    return [self objectForKey:checkSyncDateKey];
}

-(void)setEverUploadCollectTool:(BOOL)everUploadCollectTool
{
    [self setBool:everUploadCollectTool forKey:everUploadCollectToolKey];
    [self synchronize];
}

-(BOOL)everUploadCollectTool
{
    return [self boolForKey:everUploadCollectToolKey];
}

- (BOOL)everUploadMomNote
{
    return [self boolForKey:everUploadMomNoteKey];
}

- (void)setEverUploadMomNote:(BOOL)everUploadMomNote
{
    [self setBool:everUploadMomNote forKey:everUploadMomNoteKey];
    [self synchronize];
}

- (void)setChannelNameArray:(NSArray *)channelNameArray
{
    [self setObject:channelNameArray forKey:kMomLookChannelNames];
    [self synchronize];
}

- (NSArray *)channelNameArray
{
    return [self objectForKey:kMomLookChannelNames];
}

- (void)setChannelIdArray:(NSString *)channelIdArray
{
    [self setObject:channelIdArray forKey:kMomLookChannelIds];
    [self synchronize];
}

- (NSArray *)channelIdArray
{
    return [self objectForKey:kMomLookChannelIds];
}

- (void)setLongitude:(NSString *)longitude
{
    [self setObject:longitude forKey:longitudeKey];
    [self synchronize];
}

- (void)setLatitude:(NSString *)latitude
{
    [self setObject:latitude forKey:latitudeKey];
    [self synchronize];
}

- (NSString *)longitude
{
    return [self objectForKey:longitudeKey];
}

- (NSString *)latitude
{
    return [self objectForKey:latitudeKey];
}

- (void)setHasShowSyncAlert:(BOOL)hasShowSyncAlert
{
    [self setBool:hasShowSyncAlert forKey:hasShowSyncKey];
    [self synchronize];
}

- (BOOL)hasShowSyncAlert
{
    return [self boolForKey:hasShowSyncKey];
}

- (BOOL)haveEverRecommandParentTool
{
    return [self boolForKey:haveEverRecommandParentToolKey];
}

- (void)setHaveEverRecommandParentTool:(BOOL)haveEverRecommandParentTool
{
    [self setBool:haveEverRecommandParentTool forKey:haveEverRecommandParentToolKey];
    [self synchronize];
}

- (void)setLastUpdateBadgeDate:(NSDate *)lastUpdateBadgeDate
{
    [self setObject:lastUpdateBadgeDate forKey:lastUpdateDateKey];
    [self synchronize];
}

- (NSDate *)lastUpdateBadgeDate
{
    return [self objectForKey:lastUpdateDateKey];
}

- (void)setEverUpdateCheckArchive:(BOOL)everUpdateCheckArchive
{
    [self setBool:everUpdateCheckArchive forKey:everUpdateCheckArchiveKey];
    [self synchronize];
}

- (BOOL)everUpdateCheckArchive
{
    return [self boolForKey:everUpdateCheckArchiveKey];
}

- (void)setXgDeviceToken:(NSString *)xgDeviceToken
{
    [self setObject:xgDeviceToken forKey:xgDeviceTokenKey];
    [self synchronize];
}

- (NSString *)xgDeviceToken
{
    return [self objectForKey:xgDeviceTokenKey];
}

@end
