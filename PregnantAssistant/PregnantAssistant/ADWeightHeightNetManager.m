//
//  ADWeightHeightNetManager.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/6/12.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADWeightHeightNetManager.h"
#import "AFNetworking.h"
#import "NSArray+SWJSON.h"

@implementation ADWeightHeightNetManager

+ (void)getHeightWidthDataOnFinish:(void(^)(NSArray *responseArray))aFinishBlock failer:(void (^)(NSError *))failer{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *adToken = [NSUserDefaults standardUserDefaults].addingToken;
    NSString *downLoadString = [NSString stringWithFormat:@"http://%@/pregnantAssistantSync/heightWeight/get?oauth_token=%@",baseApiUrl,adToken];
    NSLog(@"downloadString == %@",downLoadString);
    [manager POST:downLoadString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (aFinishBlock) {
            aFinishBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failer) {
            failer(error);
        }
    }];
    
}
+ (void)uploadHeightWidthData:(RLMResults *)datas
                     onFinish:(void (^)(NSDictionary *res, NSError *error))aFinishBlock failure:(void (^)(NSError *))failure{
    
    NSString *oAuth = [[NSUserDefaults standardUserDefaults]addingToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"oauth_token": oAuth,
                                 @"data": [self buildWeightHeightModelData:datas]};
    [manager POST:[NSString stringWithFormat:@"http://%@/pregnantAssistantSync/heightWeight/put", baseApiUrl]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              if (aFinishBlock) {
                  aFinishBlock(responseObject, nil);
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if (aFinishBlock) {
                  aFinishBlock(nil, error);
              }
              if (failure) {
                  failure(error);
              }
          }];
    
    
}

+ (void)getServerTiemDateComplete:(void(^)(NSInteger serverceDate))complete failer:(void (^)(NSError *))failer{
    NSString *serverUrl  = [NSString stringWithFormat:@"http://%@/pregnantAssistantSync/getSyncMeta?",baseApiUrl];
    NSDictionary *dic = @{@"oauth_token":[NSUserDefaults standardUserDefaults].addingToken};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:serverUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dict = responseObject;
        NSInteger tim = [dict[@"heightWeightSyncTime"] intValue];
        if (complete) {
            complete(tim);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failer(error);
    }];
}


+ (NSString *)buildWeightHeightModelData:(RLMResults *)datas{
    
    if (!datas.count) {
        return @"[]";
    }
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (ADWeightHeightModel *model in datas) {
        [mArray addObject:@{@"uid":model.uid, @"height":model.height, @"weight":model.weight, @"time": [NSString stringWithFormat:@"%f",[model.time doubleValue]]}];
    }
    NSLog(@"marray == %@",mArray);
    
    
    return [mArray JSONString];
}


@end
