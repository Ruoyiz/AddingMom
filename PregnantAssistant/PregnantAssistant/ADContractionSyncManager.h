//
//  ADContractionSyncManager.h
//  PregnantAssistant
//
//  Created by D on 15/4/27.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADContraction.h"

@interface ADContractionSyncManager : NSObject

+ (void)getDataOnFinish:(void (^)(NSArray *))aFinishBlock;
+ (void)uploadData:(RLMResults *)datas
          onFinish:(void (^)(NSDictionary *res, NSError *error))aFinishBlock;

@end
