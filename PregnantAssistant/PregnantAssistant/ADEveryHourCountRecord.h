//
//  ADEveryHourCountRecord.h
//  PregnantAssistant
//
//  Created by D on 15/4/23.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Realm/Realm.h>

@interface ADEveryHourCountRecord : RLMObject

@property NSString *uid;
@property NSDate *recordTime;

@property int type; // 0 每小时胎动 1 专心1小时

@property NSDate *endTime;
@property NSString *cntTimes;

- (id)initWithRecordTime:(NSDate *)aStartTime
                 andType:(int)aType
              andEndTime:(NSDate *)aEndTime
              andCntTime:(NSString *)aCnt;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ADEveryHourCountRecord>
RLM_ARRAY_TYPE(ADEveryHourCountRecord)
