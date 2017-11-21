//
//  ADNewLabourThing.h
//  PregnantAssistant
//
//  Created by D on 15/4/22.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Realm/Realm.h>

@interface ADNewLabourThing : RLMObject

@property NSString *uid;
@property NSString *name;
@property NSString *reason;
@property NSString *recommendCnt; //推荐数量
@property NSString *recommentScore;

@property NSString *aKindTitle;
@property BOOL haveBuy;

- (id)initWithName:(NSString *)aName
            reason:(NSString *)aReason
   recommendCntStr:(NSString *)aRecommandCnt
    recommentScore:(NSString *)recommentScore
         kindTitle:(NSString *)aKindTitle
           haveBuy:(BOOL)haveBuy;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ADNewLabourThing>
RLM_ARRAY_TYPE(ADNewLabourThing)
