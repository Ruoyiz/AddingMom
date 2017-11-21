//
//  ADVaccineDAO.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/8.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADVaccine.h"

@interface ADVaccineDAO : NSObject

//添加疫苗
//+ (void)addVaccine:(ADVaccine *)model;
+ (void)addAllVaccineFromVaccineArray:(NSArray *)array;

//修改一个疫苗
+ (void)modifyVaccine:(ADVaccine *)model collect:(NSString *)collect success:(void (^) (ADVaccine *newModel))success;

+ (void)modifyVaccine:(ADVaccine *)model vaccindate:(NSString *)vaccindate;
+ (void)modifyVaccine:(ADVaccine *)model noteDate:(NSString *)noteDate;
+ (void)modifyVaccine:(ADVaccine *)model vaccindeStamp:(NSString *)vaccindateStamp;

//获取指定类型的疫苗 collect 为 @“0” 时表示获取未添加的自费疫苗 @“1” 获取必打和添加的自费疫苗
+ (NSMutableArray *)readAllVaccineCollected:(NSString *)collect;

//获取自费疫苗
+ (NSMutableArray *)readAllExpenseVaccine;

+ (ADVaccine *)getBaiBaiPoVaccine;
+ (ADVaccine *)getHibVaccine;
+ (ADVaccine *)getJiHuiVaccine;
+ (ADVaccine *)getWuLianVaccine;
+ (ADVaccine *)getVaccineFromName:(NSString *)name;

//注册和移除疫苗提醒
+ (void)removeNotificationWithName:(NSString *)name;
+ (void)addANotificationWithName:(NSString *)name noteDate:(NSDate *)noteDate noteTitle:(NSString *)noteStr;
+ (void)resetAllConflictVaccine;

+ (void)distrubuteData;

+ (void)syncVaccineDataSuccess:(void (^) (void))success failure:(void (^)(void))failure;

@end
