//
//  ADCheckCalTime.h
//  PregnantAssistant
//
//  Created by D on 15/4/21.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Realm/Realm.h>

@interface ADCheckCalTime : RLMObject

@property NSString *uid;
@property NSDate *aDate;

- (id)initWithDate:(NSDate *)aDate;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ADCheckCalTime>
RLM_ARRAY_TYPE(ADCheckCalTime)
