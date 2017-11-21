//
//  ADMomCellInfo.h
//  PregnantAssistant
//
//  Created by D on 15/3/12.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Realm/Realm.h>

@interface ADMomCellInfo : RLMObject

@property NSString *action;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ADMomCellInfo>
RLM_ARRAY_TYPE(ADMomCellInfo)
