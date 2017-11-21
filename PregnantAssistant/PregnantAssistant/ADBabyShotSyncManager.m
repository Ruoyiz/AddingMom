//
//  ADBabyShotSyncManager.m
//  PregnantAssistant
//
//  Created by D on 15/4/28.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBabyShotSyncManager.h"
#import "ADBabyShotDAO.h"
#import "AFNetworking.h"
#import "NSArray+SWJSON.h"

@implementation ADBabyShotSyncManager

+ (void)getDataOnFinish:(void (^)(NSArray *))aFinishBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *oAuth = [[NSUserDefaults standardUserDefaults]addingToken];
    
    NSDictionary *parameters = @{@"oauth_token":oAuth};
    [manager POST:[NSString stringWithFormat:@"http://%@/pregnantAssistantSync/pregDiary/get", baseApiUrl]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [manager POST:[NSString stringWithFormat:@"http://%@/pregnantAssistantSync/pregDiary/put", baseApiUrl]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"nskljdksdJSON: %@", responseObject);
              if (aFinishBlock) {
                  aFinishBlock(responseObject,nil);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if (aFinishBlock) {
                  aFinishBlock(nil,error);
              }
          }];
}

+ (NSString *)buildWithData:(RLMResults *)datas
{
//    NSMutableString *resStr = [[NSMutableString alloc]init];
    NSMutableArray *res = [[NSMutableArray alloc]initWithCapacity:1];

    for (int i = 0; i < datas.count; i++) {
        ADShotPhoto *aRecord = datas[i];
        NSString *dataDate = @([aRecord.shotDate timeIntervalSince1970]).stringValue;
        
        [res addObject:@{@"time": dataDate, @"url": aRecord.url}];
    }
    
    return [res JSONString];
}

@end
