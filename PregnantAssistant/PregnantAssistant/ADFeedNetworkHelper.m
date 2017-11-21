//
//  ADFeedNetworkHelper.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/19.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADFeedNetworkHelper.h"
#import "AFNetworking.h"

@implementation ADFeedNetworkHelper

+ (ADFeedNetworkHelper *)shareManager {
    static ADFeedNetworkHelper *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (manager == nil) {
            manager = [[ADFeedNetworkHelper alloc]init];
        }
    });
    return manager;
}


+ (void)getFeedArticlListWithStart:(NSString *)start size:(NSString *)size CompliteBlock:(void(^)(NSArray *resArray,BOOL iscomplite))complite failure:(void(^)(NSError *error))failure{
    NSString *baseUrl = [NSString stringWithFormat:@"http://api.addinghome.com/adco/mediaRss/getRssList"];
    NSDictionary *dictParm = @{@"oauth_token":[NSUserDefaults standardUserDefaults].addingToken,@"start":start,@"size":size};
    NSLog(@"sldjflksjflks:%@",dictParm);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:baseUrl parameters:dictParm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL isresponse = YES;
//        NSLog(@"arcRespinse: %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (responseObject[@"error"]) {
                isresponse = NO;
            }
        }
        if (complite) {
            complite(responseObject,isresponse);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
     }];
}

+ (void)getFeedContentListWithStart:(NSString *)start size:(NSString *)size mediaID:(NSString *)mediaID compliteBlock:(void(^)(NSArray *resArray,BOOL iscomplite))complite failure:(void(^)(NSError *errer))failure{
    
    NSString *baseUrl = [NSString stringWithFormat:@"http://api.addinghome.com/adco/mediaRss/GetMediaContentList"];
    NSDictionary *dictParm = @{@"mediaId":mediaID,@"start":start,@"size":size,@"oauth_token":[NSUserDefaults standardUserDefaults].addingToken};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:baseUrl parameters:dictParm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL isresponse = YES;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (responseObject[@"error"]) {
                isresponse = NO;
            }
        }
        if (complite) {
            complite(responseObject,isresponse);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)getFeedSearchMediaWithKeyword:(NSString *)keyword start:(NSString *)start size:(NSString *)size compliteBlock:(void(^)(NSArray *resArray,BOOL iscomplite))complite failure:(void (^)(NSError *))failure{
    NSString *baseUrl = [NSString stringWithFormat:@"http://api.addinghome.com/adco/mediaRss/searchMedia"];
    NSDictionary *dictParm = @{@"keyword":keyword,@"start":start,@"size":size};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:baseUrl parameters:dictParm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (complite) {
            complite(responseObject,YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure ) {
            failure(error);
        }
    }];
}
+ (void)getFeedMediaModelWithMediaId:(NSString *)mediaId compliteBlock:(void(^)(NSDictionary *resDict))complite failure:(void (^)(NSError *))failure{
    NSString *baseUrl = [NSString stringWithFormat:@"http://api.addinghome.com/adco/mediaRss/getMedia"];
    NSDictionary *dictParm = @{@"mediaId":mediaId,@"oauth_token":[NSUserDefaults standardUserDefaults].addingToken};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:baseUrl parameters:dictParm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (complite) {
            complite(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)cancelOperationsRequest{
    NSLog(@"canceed:%d",self.httpOperation.cancelled);
    [self.httpOperation cancel];
}

- (void)subscribeFeedMediaWIthMediaId:(NSString *)mediaId compliteBlock:(void(^)(BOOL isSubcribe))complite{
    
    [MobClick event:media_rss_1];
    NSString *baseUrl = [NSString stringWithFormat:@"http://api.addinghome.com/adco/mediaRss/addRss"];
    NSDictionary *dictParm = @{@"mediaId":mediaId,@"oauth_token":[NSUserDefaults standardUserDefaults].addingToken};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    self.httpOperation = [manager POST:baseUrl parameters:dictParm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        BOOL isSubsribe = NO;
        if ([dict[@"result"] integerValue]==1) {
            isSubsribe = YES;
        }
        if (complite) {
            complite(isSubsribe);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (complite) {
            complite(NO);
        }
    }];
}
- (void)desSubscribeFeedMediaWIthMediaId:(NSString *)mediaId compliteBlock:(void(^)(BOOL desSubcribe))complite{
    [MobClick event:media_rss_0];
    NSString *baseUrl = [NSString stringWithFormat:@"http://api.addinghome.com/adco/mediaRss/cancelRss"];
    NSDictionary *dictParm = @{@"mediaId":mediaId,@"oauth_token":[NSUserDefaults standardUserDefaults].addingToken};
    
//    NSLog(@"%@",dictParm);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    self.httpOperation = [manager POST:baseUrl parameters:dictParm success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"取消订阅 %@",responseObject);
        NSDictionary *dict  = responseObject;
        BOOL isSubsribe = NO;
        if ([dict[@"result"] integerValue]==1) {
            isSubsribe = YES;
        }
        if (complite) {
            complite(isSubsribe);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (complite) {
            complite(NO);
        }
    }];
}


@end
