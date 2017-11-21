//
//  ADUserInfo.m
//  PregnantAssistant
//
//  Created by yitu on 15/1/25.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADUserInfo.h"

@implementation ADUserInfo

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"babySex":@0, @"nickName":@"", @"height":@"0",
             @"weight":@"0", @"area": @"", @"birthDay":@"0", @"status": @"", @"uid": @"0",@"dueDate":[NSDate date],@"icon":[NSData data],@"babyBirthDay":[NSDate date]};
}

- (ADUserInfo *)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.uid = dic[@"uid"];
        self.nickName = dic[@"nickname"];
        self.height = dic[@"height"];
        self.weight = dic[@"weight"];
        self.area = dic[@"area"];
        NSString *dueDateStr = dic[@"duedate"];
        self.dueDate = [NSDate dateWithTimeIntervalSince1970:dueDateStr.integerValue];
        self.birthDay = dic[@"birthday"];

        NSString *babyBirthdayStr = dic[@"babyBirthday"];
        self.babyBirthDay = [NSDate dateWithTimeIntervalSince1970:babyBirthdayStr.integerValue];

        NSString *sexStr = dic[@"babyGender"];
        self.babySex = sexStr.intValue;
        
//        NSLog(@"status: %@", dic[@"status"]);
        self.status = [NSString stringWithFormat:@"%@", dic[@"status"]];
//        NSLog(@"self status: %@", self.status);
    }
    
    return self;
}

@end
