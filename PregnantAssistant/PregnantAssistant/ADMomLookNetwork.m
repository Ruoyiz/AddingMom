//
//  ADMomLookNetwork.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/15.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADMomLookNetwork.h"
#import "AFNetworking.h"

//判断是否为测试环境
#define commentTest 0

#define ChannelListUrlString @"http://%@/adco/v2.1/getChannelList"
#define MomLookContentList @"http://%@/adco/v2/getContentList"
#define LookBadgeUrlString @"http://%@/adco/v2.1/getNewContentInfo"

@implementation ADMomLookNetwork
+ (NSString *)getHost
{
    if (commentTest) {
        return baseTestApiUrl;
    }
    
    return baseApiUrl;
}

+ (NSMutableDictionary *)getUserParamas
{
    NSMutableDictionary *paramas = [NSMutableDictionary dictionary];
    
//    ADAppDelegate *myAppDelegate = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSString *pr = myAppDelegate.userLocation.province;
//    NSString *ci = myAppDelegate.userLocation.city;
    
    ADLocationManager *manager = [ADLocationManager shareLocationManager];
    NSString *pr = manager.location.province;
    NSString *ci = manager.location.city;

    if (pr) {
        [paramas setObject:pr forKey:@"pr"]; // province
    }
    
    if (ci) {
        [paramas setObject:ci forKey:@"ci"]; // province
    }
    
    if ([[ADUserInfoSaveHelper readUserStatus]isEqualToString:@"1"]) {
        NSTimeInterval interval = [[ADHelper getDueDate] timeIntervalSince1970];
        [paramas setObject:@"1" forKey:@"userStatus"];
        [paramas setObject:[NSString stringWithFormat:@"%ld",(long)interval] forKey:@"duedate"];
    } else {
        NSTimeInterval interval = [[ADHelper getBirthDate] timeIntervalSince1970];
        [paramas setObject:@"2" forKey:@"userStatus"];
        [paramas setObject:[NSString stringWithFormat:@"%ld",(long)interval] forKey:@"birthdate"];
    }
    return paramas;
}

+ (NSMutableDictionary *)getContentListHttpParmas
{
    NSMutableDictionary *paramas = [NSMutableDictionary dictionary];
    
    ADLocationManager *manager = [ADLocationManager shareLocationManager];
    NSString *pr = manager.location.province;
    NSString *ci = manager.location.city;

    if (pr) {
        [paramas setObject:pr forKey:@"pr"]; // province
    }
    
    if (ci) {
        [paramas setObject:ci forKey:@"ci"]; // province
    }
    
    if ([[ADUserInfoSaveHelper readUserStatus]isEqualToString:@"1"]) {
        NSTimeInterval interval = [[ADHelper getDueDate] timeIntervalSince1970];
        [paramas setObject:@"1" forKey:@"userStatus"];
        [paramas setObject:[NSString stringWithFormat:@"%ld",(long)interval] forKey:@"duedate"];
    } else {
        NSTimeInterval interval = [[ADHelper getBirthDate] timeIntervalSince1970];
        [paramas setObject:@"2" forKey:@"userStatus"];
        [paramas setObject:[NSString stringWithFormat:@"%ld",(long)interval] forKey:@"birthdate"];
    }
    return paramas;
}

//获取频道列表
+ (void)getChannelListSuccess:(void (^) (id responseObject))success failure:(void (^) (NSString * errorMessage))failure
{
    NSString *urlString = [NSString stringWithFormat:ChannelListUrlString,[self getHost]];

    ADBaseRequest *aRequst = [ADBaseRequest shareInstance];
    
    //NSLog(@"headers ... %@",manager.requestSerializer.HTTPRequestHeaders);
    [aRequst GET:urlString parameters:[self getContentListHttpParmas] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

//获取feed列表
+ (void)getFeedListWithChannelId:(NSInteger)channelId startPos:(NSInteger)startPos length:(NSInteger)length contentId:(NSString *)contentId succsee:(void (^) (id responseObject) )success failure:(void (^)(NSString *errorMessage))failure
{
    NSString *urlString = [NSString stringWithFormat:MomLookContentList,[self getHost]];
    
    NSMutableDictionary *paramas = [self getContentListHttpParmas];
    
    [paramas setObject:[NSString stringWithFormat:@"%ld",(long)startPos] forKey:@"start"];
    [paramas setObject:[NSString stringWithFormat:@"%ld",(long)length] forKey:@"size"];
    [paramas setObject:contentId forKey:@"contentId"];
    [paramas setObject:[NSString stringWithFormat:@"%ld",(long)channelId] forKey:@"channelId"];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] addingToken];
    if (token.length > 0) {
        [paramas setValue:token forKey:@"oauth_token"];
    }
    
    if ([ADLocationManager shareLocationManager].location.longitude != nil) {
        [paramas setValue:[ADLocationManager shareLocationManager].location.longitude forKey:@"longitude"];
        [paramas setValue:[ADLocationManager shareLocationManager].location.latitude forKey:@"latitude"];
    }
    
    ADBaseRequest *aRequst = [ADBaseRequest shareInstance];
    [aRequst GET:urlString parameters:paramas success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            success(responseObject);
        }else{
            failure(@"");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

//获取看看红点 fuck
//+ (void)getMomLookBadgeNumWithChannels:(NSArray *)channelIds
+ (void)getMomLookBadgeNumWithChannels:(NSArray *)channelIds
                          channelTimes:(NSArray *)channelTimes
                              onFinish:(void (^)(NSMutableArray *))aFininshBlock
{
    NSMutableDictionary *param = [self getUserParamas];//[NSMutableDictionary dictionaryWithCapacity:1];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] addingToken];
    if (token.length > 0) {
        [param setValue:token forKey:@"oauth_token"];
    }
    
//    NSDate *timeSp = [[NSUserDefaults standardUserDefaults] momLookListRequestTime];
//    NSString *timeSpStr = [NSString stringWithFormat:@"%ld", (long)[timeSp timeIntervalSince1970]];
    
    //NSLog(@"icon timeSp:%@",timeSpStr);
    NSDate *firstDate = channelTimes[0];
    NSString *firstDataStr = [NSString stringWithFormat:@"%ld", (long)[firstDate timeIntervalSince1970]];
    
    NSMutableString *allChannelIdStr = [NSMutableString stringWithFormat:@"%@",channelIds[0]];
    NSMutableString *allChannelTimeStr = [NSMutableString stringWithFormat:@"%@",firstDataStr];
    
    for (int i = 1; i < channelIds.count; i++) {
        [allChannelIdStr appendString:[NSString stringWithFormat:@",%@",channelIds[i]]];
        
        NSDate *aDate = channelTimes[i];
        NSString *aDataStr = [NSString stringWithFormat:@"%ld", (long)[aDate timeIntervalSince1970]];
        [allChannelTimeStr appendString:[NSString stringWithFormat:@",%@", aDataStr]];
    }
    
    //NSLog(@"get channels:%@", channels);
    [param setValue:allChannelIdStr forKey:@"channelList"];
    [param setValue:allChannelTimeStr forKey:@"lastUpdateTime"];
    
    NSString *urlString = [NSString stringWithFormat:LookBadgeUrlString,[self getHost]];
    
    //NSLog(@"获取看看小红点%@,%@",urlString,param);
    
    ADBaseRequest *aRequst = [ADBaseRequest shareInstance];
    
    [aRequst POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *allBadgeNumber = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSString *key in channelIds) {
            NSString *keyStr = [NSString stringWithFormat:@"%@",key];
//            allBadgeNumber += [responseObject[keyStr] integerValue];
            [allBadgeNumber addObject:responseObject[keyStr]];
        }
        
        aFininshBlock(allBadgeNumber);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
@end
