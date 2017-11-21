//
//  ADInLabourSyncManager.h
//  PregnantAssistant
//
//  Created by D on 15/4/27.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADNewLabourThing.h"

//typedef NS_ENUM(NSInteger, DCB_TYPE) {
//    DCB_TYPE_ZHUYUANQINGDAN = 110001,
//    DCB_TYPE_CFWEISHENGYONGPIN = 110002,
//    DCB_TYPE_CFHULI = 110003,
//    DCB_TYPE_BBRIYONG = 110004,
//    DCB_TYPE_BBXIHU = 110005,
//    DCB_TYPE_BBWEIYANG = 110006,
//    DCB_TYPE_BBFUSHI = 110007,
//    DCB_TYPE_BBHUFU = 110008,
//    DCB_TYPE_BBCHUANGSHANGYONGPIN = 110009,
//    DCB_TYPE_BBCHUXING = 110010
//};
//
@interface ADInLabourSyncManager : NSObject

+ (void)getDataOnFinish:(void (^)(NSArray *))aFinishBlock;
+ (void)uploadData:(RLMResults *)datas
          onFinish:(void (^)(NSDictionary *res, NSError *error))aFinishBlock;

+ (NSString *)getTitleFromType:(NSInteger)aType;

@end
