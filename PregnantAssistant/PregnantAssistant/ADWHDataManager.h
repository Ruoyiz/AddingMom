//
//  ADWHDataManager.h
//  PregnantAssistant
//
//  Created by 加丁 on 15/5/27.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADWeightHeightModel.h"
@interface ADWHDataManager : NSObject

+ (void)saveWhDataWithDic:(NSDictionary *)dic;//保存
+ (void)deleteModelWithCreatDate:(NSDate *)date;//删除
+ (ADWeightHeightModel *)readFirstModel;//读取最新的一个
+ (ADWeightHeightModel *)readSecendModel;//读取第二个
+ (RLMResults *)readAllModel;//读取全部数据
+ (void)sortModelData;//本地数据排序

+ (void)distrubuteData;
//+ (void)saveLocalTimeWithTimeString:(NSString *)localTimeString;
//+ (NSString *)readTheLastLocalTimeDate;

+ (void)syncAllDataOnGetData:(void(^)(BOOL iscomplete))getDataBlock
              getDataFailure:(void(^)(NSError *error))getDateFailure
             onUploadProcess:(void(^)(BOOL iscomplete))processBlock
               uploadFailure:(void(^)(NSError *error))failure
                      noNeed:(void(^)(bool netWork))noNeed;

@end
