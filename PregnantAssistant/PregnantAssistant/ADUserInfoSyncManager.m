//
//  ADUserInfoSyncManager.m
//  PregnantAssistant
//
//  Created by D on 15/5/28.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADUserInfoSyncManager.h"
#import "AFNetworking.h"
#import "NSArray+SWJSON.h"

@implementation ADUserInfoSyncManager

+ (void)getDataOnFinish:(void (^)(NSArray *))aFinishBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *oAuth = [[NSUserDefaults standardUserDefaults]addingToken];
    
    NSDictionary *parameters = @{@"oauth_token":oAuth};
    [manager POST:[NSString stringWithFormat:@"http://%@/pregnantAssistantSync/UserInfo/get", baseApiUrl]
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
    [manager POST:[NSString stringWithFormat:@"http://%@/pregnantAssistantSync/UserInfo/put", baseApiUrl]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (aFinishBlock) {
                  aFinishBlock(responseObject, nil);
              }
              //NSLog(@"JSON: %@", responseObject);
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
        ADUserInfo *aData = datas[i];
        NSString *sexStr = [NSString stringWithFormat:@"%ld",(long)aData.babySex];
        //problem
        NSString *dueDateStr = [NSString stringWithFormat:@"%ld", (long)[aData.dueDate timeIntervalSince1970]];
        NSString *babyBirthDayStr =
        [NSString stringWithFormat:@"%ld", (long)[aData.babyBirthDay timeIntervalSince1970]];
        [res addObject:@{@"duedate":dueDateStr,@"area": aData.area, @"birthday": aData.birthDay,
                         @"weight":aData.weight, @"height": aData.height, @"nickname": aData.nickName,
                         @"status":aData.status,@"babyBirthday":babyBirthDayStr,@"babyGender":sexStr}];
    }
    
    return [res JSONString];
}

@end
