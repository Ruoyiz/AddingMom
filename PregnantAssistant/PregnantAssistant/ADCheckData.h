//
//  ADCheckData.h
//  PregnantAssistant
//
//  Created by D on 14/11/27.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <Realm/Realm.h>

@interface ADCheckData : RLMObject

@property NSString *uid;

@property NSString *weight; // 体重
@property NSString *lowBloodPress; // 血压
@property NSString *highBloodPress; // 血压
@property NSString *heartBeat;// 胎心率
@property NSString *palaceHeight;// 宫高
@property NSString *abCircumference;// 腹围
@property NSDate *aDate;// 时间

- (id)initWithWeight:(NSString *)aWeight
    andLowBloodPress:(NSString *)aLowBloodPress
   andHighBloodPress:(NSString *)aHighBloodPress
        andHeartBeat:(NSString *)aHeartBeat
     andPalaceHeight:(NSString *)aPalaceHeight
  andAbCircumference:(NSString *)aAbCircumference
             andDate:(NSDate *)aDate;

- (id)initWithWeight:(NSString *)aWeight
             andDate:(NSDate *)aDate;

- (id)initWithLowBloodPress:(NSString *)aLowBloodPress
          andHighBloodPress:(NSString *)aHighBloodPress
                    andDate:(NSDate *)aDate;

- (id)initWithHeartBeat:(NSString *)aHeartBeat
                andDate:(NSDate *)aDate;

- (id)initWithPalaceHeight:(NSString *)aPalaceHeight
                   andDate:(NSDate *)aDate;

- (id)initWithAbCircumference:(NSString *)aAbCircumference
                      andDate:(NSDate *)aDate;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ADCheckData>
RLM_ARRAY_TYPE(ADCheckData)
