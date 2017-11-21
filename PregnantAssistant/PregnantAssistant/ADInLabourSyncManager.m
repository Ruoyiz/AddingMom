//
//  ADInLabourSyncManager.m
//  PregnantAssistant
//
//  Created by D on 15/4/27.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADInLabourSyncManager.h"
#import "AFNetworking.h"
#import "NSArray+SWJSON.h"

@implementation ADInLabourSyncManager

+ (void)getDataOnFinish:(void (^)(NSArray *))aFinishBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *oAuth = [[NSUserDefaults standardUserDefaults]addingToken];
//    oAuth = @"fc69976f06d03508672cb3779cb816c2";
    
    NSDictionary *parameters = @{@"oauth_token":oAuth};
    [manager POST:[NSString stringWithFormat:@"http://%@/pregnantAssistantSync/predeliveryBag/get", baseApiUrl]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"inlabour get JSON: %@", responseObject);
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
//    oAuth = @"fc69976f06d03508672cb3779cb816c2";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"oauth_token": oAuth,
                                 @"data": [self buildWithData:datas]};
    [manager POST:[NSString stringWithFormat:@"http://%@/pregnantAssistantSync/predeliveryBag/put", baseApiUrl]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              if (aFinishBlock) {
                  aFinishBlock(responseObject ,nil);
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
        ADNewLabourThing *aRecord = datas[i];
        
        //here modify
        NSInteger aType = [self judgeType:aRecord.aKindTitle];
        [res addObject:@{@"type": @(aType),
                         @"content":aRecord.name,
                         @"count":aRecord.recommendCnt,
                         @"isChecked": [NSString stringWithFormat:@"%d", aRecord.haveBuy]}];
    }
    
    return [res JSONString];
}

+ (NSInteger)judgeType:(NSString *)aType
{
    NSLog(@"aType:%@",aType);
    NSArray *title = @[
                       @"住院清单", @"产妇卫生用品",
                       @"产妇护理", @"宝宝日用",
                       @"宝宝洗护", @"宝宝喂养",
                       @"宝宝服饰", @"宝宝护肤",
                       @"宝宝床上用品", @"宝宝出行"
                       ];
    for (int i = 0; i < title.count; i++) {
        NSString *aTitle = title[i];
        if ([aTitle isEqualToString:aType]) {
            return 110001 +i;
        }
    }
    return 0;
}

+ (NSString *)getTitleFromType:(NSInteger)aType
{
    NSArray *title = @[
                       @"住院清单", @"产妇卫生用品",
                       @"产妇护理", @"宝宝日用",
                       @"宝宝洗护", @"宝宝喂养",
                       @"宝宝服饰", @"宝宝护肤",
                       @"宝宝床上用品", @"宝宝出行"
                       ];
    
    return title[aType -110001];
}

@end
