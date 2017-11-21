//
//  ADStringObject.m
//  PregnantAssistant
//
//  Created by D on 15/4/21.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADStringObject.h"

@implementation ADStringObject

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
+ (NSDictionary *)defaultPropertyValues
{
    return @{@"value":@"", @"photoData":@"",@"isUpload":@YES};
}

@end
