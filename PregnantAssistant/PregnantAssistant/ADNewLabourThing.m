//
//  ADNewLabourThing.m
//  PregnantAssistant
//
//  Created by D on 15/4/22.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADNewLabourThing.h"

@implementation ADNewLabourThing

- (id)initWithName:(NSString *)aName
            reason:(NSString *)aReason
   recommendCntStr:(NSString *)aRecommandCnt
    recommentScore:(NSString *)recommentScore
         kindTitle:(NSString *)aKindTitle
           haveBuy:(BOOL)haveBuy
{
    if (self = [super init]) {
        self.uid = [[NSUserDefaults standardUserDefaults] addingUid];
        self.name = aName;
        self.reason = aReason;
        self.recommendCnt = aRecommandCnt;
        self.recommentScore = recommentScore;
        self.haveBuy = haveBuy;
        self.aKindTitle = aKindTitle;
    }
    return self;
}

// Specify default values for properties
+ (NSDictionary *)defaultPropertyValues
{
    return @{@"uid":@"0",@"haveBuy":@NO,@"aKindTitle":@""};
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
