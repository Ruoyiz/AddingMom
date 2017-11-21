//
//  ADWeightHeightNetManager.h
//  PregnantAssistant
//
//  Created by 加丁 on 15/6/12.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADWeightHeightModel.h"

@interface ADWeightHeightNetManager : NSObject

/*身高体重*/
+ (void)getHeightWidthDataOnFinish:(void(^)(NSArray *responseArray))aFinishBlock failer:(void(^)(NSError *error))failer;
+ (void)uploadHeightWidthData:(RLMResults *)datas
                     onFinish:(void (^)(NSDictionary *res, NSError *error))aFinishBlock failure:(void (^)(NSError *error))failure;
+ (void)getServerTiemDateComplete:(void(^)(NSInteger serverceDate))complete failer:(void(^)(NSError *error))failer;
@end
