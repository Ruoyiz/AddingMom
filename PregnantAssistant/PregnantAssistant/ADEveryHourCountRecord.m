//
//  ADEveryHourCountRecord.m
//  PregnantAssistant
//
//  Created by D on 15/4/23.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADEveryHourCountRecord.h"

@implementation ADEveryHourCountRecord

- (id)initWithRecordTime:(NSDate *)aStartTime
                 andType:(int)aType
              andEndTime:(NSDate *)aEndTime
              andCntTime:(NSString *)aCnt
{
    if (self = [super init]) {
        self.uid = [[NSUserDefaults standardUserDefaults] addingUid];
        self.recordTime = aStartTime;
        self.type = aType;
        if (aType == 1) {
            self.endTime = aEndTime;
            self.cntTimes = aCnt;
        } else {
            self.endTime = aStartTime;
            self.cntTimes = @"1";
        }
    }
    return self;
}

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"uid":@"0",@"cntTimes":@"1"};
}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
