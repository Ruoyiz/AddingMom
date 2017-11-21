//
//  ADBabyShotSyncManager.h
//  PregnantAssistant
//
//  Created by D on 15/4/28.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADShotPhoto.h"

@interface ADBabyShotSyncManager : NSObject

+ (void)getDataOnFinish:(void (^)(NSArray *))aFinishBlock;
+ (void)uploadData:(RLMResults *)datas
          onFinish:(void (^)(NSDictionary *res, NSError *error))aFinishBlock;

@end
