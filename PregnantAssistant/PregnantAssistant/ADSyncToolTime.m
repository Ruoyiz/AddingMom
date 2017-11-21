//
//  ADSyncToolTime.m
//  PregnantAssistant
//
//  Created by D on 15/4/24.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADSyncToolTime.h"

@implementation ADSyncToolTime

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"uid":@"0",
             @"c_userInfo_MTime":@"0",
             @"c_antenatalCareCalendar_MTime":@"0",
             @"c_antenatalCareRecord_MTime":@"0",
             @"c_motherDiary_MTime":@"0",
             @"c_pregDiary_MTime":@"0",
             @"c_predeliveryBag_MTime":@"0",
             @"c_fetalMovement_MTime":@"0",
             @"c_uterineContraction_MTime":@"0",
             @"c_toolsCollection_MTime":@"0",
             @"c_heightWeight_MTime":@"0",
             @"c_vaccineSync_MTime":@"0",
             
             @"s_userInfo_MTime":@"0",
             @"s_antenatalCareCalendar_MTime":@"0",
             @"s_antenatalCareRecord_MTime":@"0",
             @"s_motherDiary_MTime":@"0",
             @"s_pregDiary_MTime":@"0",
             @"s_predeliveryBag_MTime":@"0",
             @"s_fetalMovement_MTime":@"0",
             @"s_uterineContraction_MTime":@"0",
             @"s_toolsCollection_MTime":@"0",
             @"s_vaccineSync_MTime":@"0",
             @"s_heightWeightSync_MTime":@"0"
             };
}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
