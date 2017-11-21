//
//  ADUserInfoSaveHelper.h
//  PregnantAssistant
//
//  Created by D on 15/4/14.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADUserInfo.h"

//传BasicInfo 的 key
#define userStatusKey @"userStatusKey"
#define userDueDateKey @"userDueDateKey"
#define babyBirthDayKey @"babyBirthDayKey"
#define babySexKey @"babySexKey"
//static NSString *babyBirthDayKey = @"babyBirthDayKey";

@interface ADUserInfoSaveHelper : NSObject

+ (void)saveWithDic:(NSDictionary *)aDic;
+ (void)saveIconData:(NSString *)image andName:(NSString *)aName;
+ (void)saveImageDataWithImage:(UIImage *)image aName:(NSString *)aName;
+ (UIImage *)readIconData;

+ (void)saveUserName:(NSString *)aName;
+ (NSString *)readUserName;

+ (void)saveUserArea:(NSString *)area;
+ (NSString *)readUserArea;

+ (void)saveUserHeight:(NSString *)aHeight;
+ (NSString *)readUserHeight;

+ (void)saveUserWeight:(NSString *)aWeight;
+ (NSString *)readUserWeight;

+ (void)saveBirthDay:(NSString *)aBirthDay;
+ (NSString *)readBirthDay;

+ (void)copyBasicUserInfoDataFromUid:(NSString *)uid;
//+ (void)deleteUserInfoWithUid:(NSString *)uid;

+ (void)saveBabayBirthday:(NSDate *)babyBirdthday;
+ (NSDate *)readBabyBirthday;

+ (void)saveDueDate:(NSDate *)dueDate;
+ (NSDate *)readDueDate;

+ (void)saveBabaySex:(NSInteger)babySex;
+ (NSInteger)readBabySex;

+ (void)saveUserStatus:(NSString *)aStatus;
+ (NSString *)readUserStatus;

+ (void)saveBasicUserInfo:(NSDictionary *)aInfo;
+ (NSDictionary *)readBasicUserInfo;

+ (void)syncAllDataOnGetData:(void(^)(NSError *error))getDataBlock
             onUploadProcess:(void(^)(NSError *error))processBlock
              onUpdateFinish:(void(^)(NSError *error))finishBlock;


@end
