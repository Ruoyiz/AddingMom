//
//  ADContraction.h
//  PregnantAssistant
//
//  Created by D on 15/4/20.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Realm/Realm.h>

@interface ADContraction : RLMObject

@property NSString *uid;
@property NSDate *startDate;
@property NSDate *endDate;

- (id)initStartTime:(NSDate *)aStartTime
         andEndTime:(NSDate *)aEndTime;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ADContraction>
RLM_ARRAY_TYPE(ADContraction)
