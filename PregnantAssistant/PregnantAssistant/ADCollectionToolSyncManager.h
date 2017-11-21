//
//  ADCollectionToolSyncManager.h
//  PregnantAssistant
//
//  Created by D on 15/5/14.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADTool.h"

@interface ADCollectionToolSyncManager : NSObject

+ (void)getDataOnFinish:(void (^)(NSArray *))aFinishBlock;
+ (void)uploadData:(RLMResults *)datas
          onFinish:(void (^)(NSDictionary *res, NSError *error))aFinishBlock;

@end
