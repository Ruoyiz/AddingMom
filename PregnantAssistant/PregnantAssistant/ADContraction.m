//
//  ADContraction.m
//  PregnantAssistant
//
//  Created by D on 15/4/20.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADContraction.h"

@implementation ADContraction

- (id)initStartTime:(NSDate *)aStartTime
         andEndTime:(NSDate *)aEndTime
{
    if (self = [super init]) {
        self.startDate = aStartTime;
        self.endDate = aEndTime;
        self.uid = [[NSUserDefaults standardUserDefaults] addingUid];
    }
    return self;

}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
