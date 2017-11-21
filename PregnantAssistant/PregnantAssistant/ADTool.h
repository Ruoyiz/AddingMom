//
//  ADCollectTool.h
//  PregnantAssistant
//
//  Created by D on 15/4/27.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Realm/Realm.h>
#import "ADIcon.h"

@interface ADTool : RLMObject

@property NSString *uid;
@property NSString *toolId;
@property NSString *title;
@property BOOL isWeb;
@property NSString *myVc;
@property BOOL isMananullyCollect;

@property BOOL isParentTool;


- (NSString *)getToolNameFromToolId:(NSString *)aToolId;

- (id)initWithTitle:(NSString *)aTitle;
- (id)initWithIoolId:(NSString *)aToolId;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ADCollectTool>
RLM_ARRAY_TYPE(ADCollectTool)
