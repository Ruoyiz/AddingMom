//
//  ADReadNoticeItem.h
//  PregnantAssistant
//
//  Created by D on 14/12/12.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <Realm/Realm.h>

@interface ADReadNoticeItem : RLMObject
@property NSString *messageId;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<ADReadNoticeItem>
RLM_ARRAY_TYPE(ADReadNoticeItem)
