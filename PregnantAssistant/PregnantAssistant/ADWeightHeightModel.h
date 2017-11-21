//
//  ADWeightHeightModel.h
//  PregnantAssistant
//
//  Created by 加丁 on 15/5/29.
//  Copyright (c) 2015年 Adding. All rights reserved.
//
#import <Realm/Realm.h>
#import "RLMObject.h"

@interface ADWeightHeightModel : RLMObject

@property NSString *time;
@property NSString *height;
@property NSString *weight;
@property NSString *uid;

-(ADWeightHeightModel *)initWithDictionary:(NSDictionary *)dic;

+(ADWeightHeightModel *)statusWithDictionary:(NSDictionary *)dic;

@end

RLM_ARRAY_TYPE(ADWHDataManager)
