//
//  ADCheckArichivesSyncManager.m
//  PregnantAssistant
//
//  Created by D on 15/4/27.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADCheckArichivesSyncManager.h"
#import "AFNetworking.h"
#import "NSArray+SWJSON.h"

@implementation ADCheckArichivesSyncManager

+ (void)getDataOnFinish:(void (^)(NSArray *))aFinishBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *oAuth = [[NSUserDefaults standardUserDefaults]addingToken];
//    oAuth = @"fc69976f06d03508672cb3779cb816c2";
    
    NSDictionary *parameters = @{@"oauth_token":oAuth};
    [manager POST:[NSString stringWithFormat:@"http://%@/pregnantAssistantSync/antenatalCareRecord/get", baseApiUrl]
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
//    oAuth = @"fc69976f06d03508672cb3779cb816c2";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"oauth_token": oAuth,
                                 @"data": [self buildWithData:datas]};
    [manager POST:[NSString stringWithFormat:@"http://%@/pregnantAssistantSync/antenatalCareRecord/put", baseApiUrl]
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
        ADCheckData *aRecord = datas[i];
        NSString *dataDate = @([aRecord.aDate timeIntervalSince1970]).stringValue;
//        [NSString stringWithFormat:@"%ld", (long)[aRecord.aDate timeIntervalSince1970]];
        
        //every record change many time... fuck
        if (aRecord.weight.length > 0) {
            [res addObject:@{@"type": @"802611", @"time": dataDate,
                             @"value": aRecord.weight, @"value1": @"0"}];
        }
        if (aRecord.lowBloodPress.length > 0) {
            [res addObject:@{@"type": @"802612", @"time": dataDate,
                             @"value": aRecord.lowBloodPress, @"value1": aRecord.highBloodPress}];
        }
        if (aRecord.heartBeat.length > 0) {
            [res addObject:@{@"type": @"802613", @"time": dataDate,
                             @"value": aRecord.heartBeat, @"value1": @"0"}];
        }
        if (aRecord.palaceHeight.length > 0) {
            [res addObject:@{@"type": @"802614", @"time": dataDate,
                             @"value": aRecord.palaceHeight, @"value1": @"0"}];
        }
        if (aRecord.abCircumference.length > 0) {
            [res addObject:@{@"type": @"802615", @"time": dataDate,
                             @"value": aRecord.abCircumference, @"value1": @"0"}];
        }
    }
    
    return [res JSONString];
}

//    public static final int CJDA_TYPE_WEIGHT = 802611; 体重
//    public static final int CJDA_TYPE_BP = 802612;  血压
//    public static final int CJDA_TYPE_FHR = 802613; 胎心率
//    public static final int CJDA_TYPE_FUH = 802614; 宫高
//    public static final int CJDA_TYPE_AC = 802615; 腹围
@end
