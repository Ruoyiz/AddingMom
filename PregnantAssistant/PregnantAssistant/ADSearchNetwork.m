//
//  ADSearchNetwork.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/8/6.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADSearchNetwork.h"

@implementation ADSearchNetwork

+ (void)getSearchListWithEntity:(ADSearchEntity)entity keyword:(NSString *)keyword startPos:(NSString *)startPos length:(NSString *)length firstId:(NSString *)firstId success:(void (^) (id resObject))successBlock failure:(void (^) (NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *entityString = @"*";
    if (entity == ADSearchEntityMedia) {
        entityString = @"media";
    }else if (entity == ADSearchEntityTool){
        entityString = @"tool";
    }else if (entity == ADSearchEntityContent){
        entityString = @"content";
    }
    [parameters setObject:[[NSUserDefaults standardUserDefaults] addingToken] forKey:@"oauth_token"];
    [parameters setObject:entityString forKey:@"entity"];
    [parameters setObject:keyword forKey:@"q"];
    [parameters setObject:startPos forKey:@"start"];
    [parameters setObject:length forKey:@"size"];
    
    if (entity == ADSearchEntityContent) {
        [parameters setObject:firstId forKey:@"contentId"];
    }else if (entity == ADSearchEntityMedia){
        [parameters setObject:firstId forKey:@"mediaId"];

    }
    
//    NSLog(@"..... %@",parameters);
    
    ADBaseRequest *aRequest = [ADBaseRequest shareInstance];
    [aRequest POST:@"http://api.addinghome.com/adsearch/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *errorStr = [responseObject objectForKey:@"error"];
        if (![errorStr isEqual:[NSNull null]] && errorStr != nil) {
            failureBlock(nil);
        }else{
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
}

@end
