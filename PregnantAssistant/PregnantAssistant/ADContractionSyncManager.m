//
//  ADContractionSyncManager.m
//  PregnantAssistant
//
//  Created by D on 15/4/27.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADContractionSyncManager.h"
#import "AFNetworking.h"
#import "NSArray+SWJSON.h"

@implementation ADContractionSyncManager

+ (void)getDataOnFinish:(void (^)(NSArray *))aFinishBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *oAuth = [[NSUserDefaults standardUserDefaults]addingToken];
    
    NSDictionary *parameters = @{@"oauth_token":oAuth};
    [manager POST:[NSString stringWithFormat:@"http://%@/pregnantAssistantSync/uterineContraction/get", baseApiUrl]
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
    
    NSString *oAuth = [[NSUserDefaults standardUserDefaults]addingToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"oauth_token": oAuth,
                                 @"data": [self buildWithData:datas]};
    [manager POST:[NSString stringWithFormat:@"http://%@/pregnantAssistantSync/uterineContraction/put", baseApiUrl]
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
}

+ (NSString *)buildWithData:(RLMResults *)datas
{
    NSMutableArray *res = [[NSMutableArray alloc]initWithCapacity:1];

    for (int i = 0; i < datas.count; i++) {
        ADContraction *aRecord = datas[i];
        NSString *timeSp = @([aRecord.startDate timeIntervalSince1970]).stringValue;
        NSString *endTimeSp = @([aRecord.endDate timeIntervalSince1970]).stringValue;
        
        [res addObject:@{@"startTime": timeSp, @"endTime": endTimeSp}];
    }

    return [res JSONString];
}

@end
