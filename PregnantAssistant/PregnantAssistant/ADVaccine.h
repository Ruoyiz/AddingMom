//
//  ADVaccine.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/8.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Realm/Realm.h>

@interface ADVaccine : RLMObject

@property (nonatomic,strong) NSString *uid;

@property (nonatomic,strong) NSString *isCollected;

@property(nonatomic,strong)NSString *vaccineName;

@property(nonatomic,strong)NSString *vaccineTime;

@property (nonatomic,strong) NSString *vaccineTag;

@property (nonatomic,strong) NSString *vaccineDes;

@property (nonatomic,strong) NSString *vaccineId;

@property (nonatomic,strong) NSString *haveVaccinated;

//接种日期的时间戳
@property (nonatomic,strong) NSString *vaccindateDateStamp;

//默认以及手动设置的接种日期，用来排序列表
@property (nonatomic,strong) NSString *vaccindateDateStr;

//默认的接种日期，用来恢复排序
@property (nonatomic,strong) NSString *orginVaccineDateStr;

//提醒日期的时间戳
@property (nonatomic,strong) NSString *noteDateStamp;

//接种超时日期
@property (nonatomic,strong) NSString *vaccineOverDue;

+ (ADVaccine *)getModelFromDic:(NSDictionary *)dic uid:(NSString *)uid;

//判断是否和五联疫苗冲突
+ (BOOL)isConflictToWuLianVaccine:(NSString *)name;
+ (BOOL)shouldAddVaccine:(ADVaccine *)model;

+ (BOOL)shouldAddWuLianVaccine:(ADVaccine *)model reason:(void (^) (BOOL canAdd,ADVaccine *reModel))reason;

@end
