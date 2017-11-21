//
//  ADCheckCalTime.m
//  PregnantAssistant
//
//  Created by D on 15/4/21.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADCheckCalTime.h"

@implementation ADCheckCalTime

- (id)initWithDate:(NSDate *)aDate
{
    if (self = [super init]) {
        self.aDate = aDate;
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
