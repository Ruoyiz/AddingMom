//
//  ADStringObject.h
//  PregnantAssistant
//
//  Created by D on 15/4/21.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Realm/Realm.h>
#import "RLMObject.h"

@interface ADStringObject : RLMObject

@property NSString *value;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<ADStringObject>
RLM_ARRAY_TYPE(ADStringObject)
