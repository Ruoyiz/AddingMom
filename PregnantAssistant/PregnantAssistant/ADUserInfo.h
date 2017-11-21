//
//  ADUserInfo.h
//  PregnantAssistant
//
//  Created by yitu on 15/1/25.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Realm/Realm.h>

@interface ADUserInfo : RLMObject

@property NSData *icon;
@property NSString *nickName;
@property NSString *uid;
@property NSString *height;
@property NSString *weight;
@property NSString *area;
@property NSDate *dueDate;
@property NSString *birthDay;
@property NSDate *babyBirthDay;

@property NSInteger babySex;
@property NSString *status; //准妈妈 1    妈妈 2

- (ADUserInfo *)initWithDic:(NSDictionary *)dic;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ADUserInfo>
RLM_ARRAY_TYPE(ADUserInfo)
