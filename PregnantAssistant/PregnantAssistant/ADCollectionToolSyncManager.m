//
//  ADCollectionToolSyncManager.m
//  PregnantAssistant
//
//  Created by D on 15/5/14.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADCollectionToolSyncManager.h"
#import "AFNetworking.h"
#import "NSArray+SWJSON.h"

@implementation ADCollectionToolSyncManager

+ (void)getDataOnFinish:(void (^)(NSArray *))aFinishBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *oAuth = [[NSUserDefaults standardUserDefaults]addingToken];
    
    NSLog(@"token:%@", oAuth);
    NSDictionary *parameters = @{@"oauth_token":oAuth};
    [manager POST:[NSString stringWithFormat:@"http://%@/pregnantAssistantSync/toolsCollection/get", baseApiUrl]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"tool rex: %@", responseObject);
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
    NSLog(@"tool collect need up %lu",(unsigned long)datas.count);
    NSString *oAuth = [[NSUserDefaults standardUserDefaults]addingToken];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"oauth_token": oAuth,
                                 @"data": [self buildWithData:datas]};
    [manager POST:[NSString stringWithFormat:@"http://%@/pregnantAssistantSync/toolsCollection/put", baseApiUrl]
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
    if (datas.count == 0) {
        return @"[]";
    }

//    NSPredicate *type1ToolPre = [NSPredicate predicateWithFormat:@"isParentTool == 0"];
//    NSPredicate *type2ToolPre = [NSPredicate predicateWithFormat:@"isParentTool == 1"];
//    
//    RLMResults *type1Tool = [datas objectsWithPredicate:type1ToolPre];
//    NSLog(@"type1Tool: %@", type1Tool);
//    RLMResults *type2Tool = [datas objectsWithPredicate:type2ToolPre];
//    NSLog(@"type2Tool: %@", type2Tool);
    
    NSMutableArray *res = [[NSMutableArray alloc]initWithCapacity:datas.count];
    
    for (int i = 0; i < datas.count; i++) {
        ADTool *aTool = datas[i];
        [res addObject:
         @{@"toolId": aTool.toolId, @"toolIndex": @(i), @"type": @"1"}];
    }
    
//    for (int i = 0; i < type2Tool.count; i++) {
//        ADTool *aTool = type2Tool[i];
//
//        [res addObject:
//         @{@"toolId": aTool.toolId, @"toolIndex": @(i), @"type": @"2"}];
//    }
    NSLog(@"build data:%@", res);

    return [res JSONString];
}

@end
