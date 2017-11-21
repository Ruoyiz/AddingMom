//
//  ADCountFetalSyncManager.m
//  PregnantAssistant
//
//  Created by D on 15/4/27.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADCountFetalSyncManager.h"
#import "AFNetworking.h"
#import "NSArray+SWJSON.h"

@implementation ADCountFetalSyncManager

+ (void)getDataOnFinish:(void (^)(NSArray *))aFinishBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *oAuth = [[NSUserDefaults standardUserDefaults]addingToken];
    
    NSDictionary *parameters = @{@"oauth_token":oAuth};
    [manager POST:[NSString stringWithFormat:@"http://%@/pregnantAssistantSync/fetalMovement/get", baseApiUrl]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"get JSON: %@", responseObject);
              if (aFinishBlock) {
                  aFinishBlock(responseObject);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

+ (void)uploadData:(RLMResults *)datas
          onFinish:(void (^)(NSDictionary *res, NSError *error))aFinishBlock
{
    [self buildWithData:datas onFinish:^(NSString * res) {
        NSString *oAuth = [[NSUserDefaults standardUserDefaults]addingToken];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        NSDictionary *parameters = @{@"oauth_token": oAuth, @"data": res};
        [manager POST:[NSString stringWithFormat:@"http://%@/pregnantAssistantSync/fetalMovement/put", baseApiUrl]
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
              }];
    }];
}

+ (void)buildWithData:(RLMResults *)datas
             onFinish:(void (^)(NSString *))aFinishBlock
{
//    DISPATCH_ON_GLOBAL_QUEUE_DEFAULT((^{
    NSMutableArray *res = [[NSMutableArray alloc]initWithCapacity:datas.count];
        for (int i = 0; i < datas.count; i++) {
            ADEveryHourCountRecord *aRecord = datas[i];
            NSString *timeSp = @([aRecord.recordTime timeIntervalSince1970]).stringValue;
            NSString *endTimeSp = @([aRecord.endTime timeIntervalSince1970]).stringValue;
            
//            NSLog(@"type:%d", aRecord.type);
            NSString *typeStr = nil; //20101 普通 20102 专心1小时
            if (aRecord.type == 0) {
                typeStr = @"20101";
            } else {
                typeStr = @"20102";
            }
            
            [res addObject:@{@"time": timeSp, @"type": typeStr, @"startTime": timeSp, @"endTime": endTimeSp,
                             @"value": aRecord.cntTimes}];
//            NSLog(@"res:%@", res);
        }
    
//    NSString *resStr =

//    NSLog(@"dddd res array:%@", [res JSONString]);
//        DISPATCH_ON_MAIN_THREAD(^{
            if (aFinishBlock) {
                aFinishBlock([res JSONString]);
            }
//        });
//    }));
}

@end
