//
//  ADMomLookNetworkHelper.m
//  PregnantAssistant
//
//  Created by D on 15/1/24.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADMomLookNetworkHelper.h"
#import "XGPush.h"

static ADMomLookNetworkHelper *sharedClient = nil;
@implementation ADMomLookNetworkHelper

+ (ADMomLookNetworkHelper *)shareInstance {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedClient = [[ADMomLookNetworkHelper alloc] init];
    });
    
    return sharedClient;
}

- (NSString *)getToken
{
    NSString *tStr = [[NSUserDefaults standardUserDefaults] addingToken];
    
    if (tStr.length == 0) {
        tStr = @"";
    }
    
    return tStr;
}

- (void)getAllVideoWithStartInx:(NSInteger)aInx
                      andLength:(NSInteger)aLength
            andVideoCatalogType:(NSString *)aType
                  andParentType:(NSString *)aParentType
                 andFinishBlock:(void (^)(NSArray *))aFinishBlock
                         failed:(FailRequstBlock)aFailBlock
{
    self.momLookEngine = [[ADMomLookNetworkEngine alloc] initWithDefaultSettings];
    
    NSDictionary *param = nil;
    if (aType.length > 0) {
        param = @{@"oauth_token":[self getToken],
                  @"start":[NSString stringWithFormat:@"%ld",(long)aInx],
                  @"size":[NSString stringWithFormat:@"%ld",(long)aLength],
                  @"parentType":aParentType,
                  @"type":aType};
    } else {
        param = @{@"oauth_token":[self getToken],
                  @"start":[NSString stringWithFormat:@"%ld",(long)aInx],
                  @"size":[NSString stringWithFormat:@"%ld",(long)aLength]};
    }
    
    MKNetworkOperation *op = [self.momLookEngine operationWithPath:@"pregnantAssistant/read/get_reads"
                                                            params:param
                                                        httpMethod:@"POST"
                                                               ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
        if (aFinishBlock) {
            aFinishBlock(resultArray);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        //NSLog(@"video err:%@",err);
        if (aFailBlock) {
            aFailBlock();
        }
    }];
    
    [self.momLookEngine enqueueOperation:op];
}

//Deprecated
- (void)getAllVideoWithStartInx:(NSInteger)aInx
                      andLength:(NSInteger)aLength
                        dueDate:(NSString *)dueDate
                      channelId:(NSInteger)aChannelId
                      contentId:(NSInteger)aContentId
                      longitude:(NSString *)aLongitude
                       latitude:(NSString *)aLatitude
                       onFinish:(void (^)(NSArray *))aFinishBlock
                         failed:(FailRequstBlock)aFailBlock
{
    self.momLookEngine = [[ADMomLookNetworkEngine alloc] initWithDefaultSettings];

    NSMutableDictionary *paramas = [self getHttpParmas];
    [paramas setObject:[NSString stringWithFormat:@"%ld",(long)aInx] forKey:@"start"];
    [paramas setObject:[NSString stringWithFormat:@"%ld",(long)aLength] forKey:@"size"];
    [paramas setObject:[NSString stringWithFormat:@"%ld",(long)aContentId] forKey:@"contentId"];
    [paramas setObject:[NSString stringWithFormat:@"%ld",(long)aChannelId] forKey:@"channelId"];
    
    NSString *token = [self getToken];
    if (token.length > 0) {
        [paramas setValue:token forKey:@"oauth_token"];
    }
    
    if (aLongitude != nil) {
        [paramas setValue:aLongitude forKey:@"longitude"];
        [paramas setValue:aLatitude forKey:@"latitude"];
    }
    
    //NSLog(@"video content param:%@", paramas);
    
    MKNetworkOperation *op = [self.momLookEngine operationWithPath:@"adco/v2/getContentList"
                                                            params:paramas
                                                        httpMethod:@"POST"
                                                               ssl:NO];
    
    __weak MKNetworkOperation *weakOp = op;
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
        
        NSDictionary *headers = weakOp.readonlyResponse.allHeaderFields;
        NSDate *lastPushDate = [[NSUserDefaults standardUserDefaults] pushDate];
        NSDate *now = [NSDate date];
        NSInteger days = [lastPushDate daysBeforeDate:now];
//        
        //NSLog(@"+++++++++++++++++++\n%@\n+++++++++++++",headers);
//        NSLog(@"%@",[headers objectForKey:@"X-AD-PushTagAdd"]);
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);

        //return [src cStringUsingEncoding:enc];
        NSString *tagStr = [headers objectForKey:@"X-AD-PushTagAdd"];
        NSString *pushTag = [NSString stringWithFormat:@"%s",[tagStr cStringUsingEncoding:enc]];
        
        NSLog(@"%@",pushTag);
        //添加和删除信鸽推送tag
        if ((lastPushDate && days >= 1) || !lastPushDate) {
            [XGPush setTag:pushTag];
            NSString *delStr = [headers objectForKey:@"X-AD-PushTagDelete"];
            NSArray *delArray = [delStr componentsSeparatedByString:@","];
            for (NSString *str in delArray) {
                NSString *delTag = [NSString stringWithFormat:@"%s",[str cStringUsingEncoding:enc]];
                [XGPush delTag:delTag];
            }
        }
        
        if (aFinishBlock) {
            aFinishBlock(resultArray);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        if (aFailBlock) {
            aFailBlock();
        }
    }];
    
    [self.momLookEngine enqueueOperation:op];
}

- (void)getVideoListOnFinish:(void (^)(NSArray *))aFinishBlock
                      onFail:(FailRequstBlock)aFailBlock
{
    self.momLookEngine = [[ADMomLookNetworkEngine alloc] initWithDefaultSettings];
    
    NSDictionary *param = @{@"oauth_token":[self getToken]};
    
    MKNetworkOperation *op = [self.momLookEngine operationWithPath:@"pregnantAssistant/read/get_types"
                                                            params:param
                                                        httpMethod:@"POST"
                                                               ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
        
        if (aFinishBlock) {
            aFinishBlock(resultArray);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {

        NSLog(@"video 2 err:%@",err);
        if (aFailBlock) {
            aFailBlock();
        }
    }];
    
    [self.momLookEngine enqueueOperation:op];
}

- (void)recordPlayVideoOnceWithWid:(NSString *)aWid
                          onFinish:(void (^)(NSArray *))aFinishBlock
                            onFail:(FailRequstBlock)aFailBlock
{
    self.momLookEngine = [[ADMomLookNetworkEngine alloc] initWithDefaultSettings];
    
    MKNetworkOperation *op =
    [_momLookEngine operationWithPath:[NSString stringWithFormat:@"pregnantAssistant/read/play?wid=%@",aWid]
                               params:nil
                           httpMethod:@"POST"
                                  ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
        if (aFinishBlock) {
            aFinishBlock(resultArray);
        }
        //NSLog(@"resultArray:%@", resultArray);
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
//        NSLog(@"err:%@",err);
        if (aFailBlock) {
            aFailBlock();
        }
    }];
    
    [_momLookEngine enqueueOperation:op];
}

/**
 *  获取某一项咨询的详细内容
 *
 *  @param aContentId   咨询id
 *  @param aFinishBlock 成功的block
 *  @param aFailBlock   失败的block
 */
//- (void)getDetailContentWithContentId:(NSInteger)aContentId
//                             onFinish:(void (^)(NSArray *))aFinishBlock
//                               failed:(FailRequstBlock)aFailBlock
//{
//    self.momLookEngine = [[ADMomLookNetworkEngine alloc] initWithDefaultSettings];
//    
//    NSMutableDictionary *param = [@{@"contentId":[NSString stringWithFormat:@"%ld",(long)aContentId],}mutableCopy];
//    
//    NSString *token = [self getToken];
//    if (token.length > 0) {
//        [param setValue:token forKey:@"oauth_token"];
//    }
//    
//    MKNetworkOperation *op = [_momLookEngine operationWithPath:@"adco/getContent"
//                                                        params:param
//                                                    httpMethod:@"POST"
//                                                           ssl:NO];
//    [op addCompletionHandler:^(MKNetworkOperation *operation) {
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData]
//                                                               options:NSJSONReadingAllowFragments
//                                                                    error:nil];
//        //NSLog(@"请求结果是%@",resultDic);
//        if (!resultDic) {
//            if (aFailBlock) {
//                aFailBlock();
//            }
//            return;
//        }
//        //NSLog(@"fffff%@",resultDic);
//        
//        //创建model
//        ADMomContentInfo *info = [[ADMomContentInfo alloc]initWithTitle:[resultDic objectForKey:@"title"]
//                                                             andImgUrls:[resultDic objectForKey:@"images"]
//                                                         andContentType:[resultDic objectForKey:@"type"]
//                                                        andContentStyle:[resultDic objectForKey:@"style"]
//                                                         andPublishTime:[resultDic objectForKey:@"publishTime"]
//                                                            andDuration:@""
//                                                             andContent:[resultDic objectForKey:@"content"]
//                                                         andMediaSource:[resultDic objectForKey:@"mediaName"]
//                                                         andDescription:[resultDic objectForKey:@"description"]
//                                                           andContentId:[resultDic objectForKey:@"contentId"]
//                                                              andAction:[resultDic objectForKey:@"action"]
//                                                                andNUrl:[resultDic objectForKey:@"nurl"]
//                                                                andWUrl:[resultDic objectForKey:@"wurl"] tagLabel:[resultDic objectForKey:@"label"]];
//
//        NSArray *resultArray = [NSArray arrayWithObject:info];
//        if (aFinishBlock) {
//            aFinishBlock(resultArray);
//        }
//    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
//        if (aFailBlock) {
//            aFailBlock();
//        }
//    }];
//   
//    [_momLookEngine enqueueOperation:op];
//
//}

/**
 *  取消获取某一项咨询的详细内容的网络请求
 */
- (void)cancelGetDetailContentRequest
{
    
//    [_detailContentEngine]
}
/**
 *  获取频道
 *
 *  @param aFinishBlock 成功的block
 *  @param aFailBlock   失败的block
 */
- (void)getChannelListOnFinish:(void (^)(NSArray *))aFinishBlock
                        failed:(FailRequstBlock)aFailBlock
{
    _momLookEngine = [[ADMomLookNetworkEngine alloc]initWithDefaultSettings];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSString *token = [self getToken];
    if (token.length > 0) {
        [param setValue:token forKey:@"oauth_token"];
    }
    
    MKNetworkOperation *op = [_momLookEngine operationWithPath:@"adco/getChannelList"
                                                        params:param
                                                    httpMethod:@"POST"
                                                           ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:nil];
        if (aFinishBlock) {
            aFinishBlock(resultArray);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        if (aFailBlock) {
            aFailBlock();
        }
    }];
    
    [_momLookEngine enqueueOperation:op];
}

//- (void)getMomLookBadgeNumWithChannels:(NSArray *)channels
//                              onFinish:(void (^)(NSInteger))aFinishBlock
//{
//    _momLookEngine = [[ADMomLookNetworkEngine alloc]initWithDefaultSettings];
//    
//    NSMutableDictionary *param = [self getHttpParmas];//[NSMutableDictionary dictionaryWithCapacity:1];
//    
//    NSString *token = [self getToken];
//    if (token.length > 0) {
//        [param setValue:token forKey:@"oauth_token"];
//        
//    }
//    
//    NSDate *timeSp = [[NSUserDefaults standardUserDefaults] momLookListRequestTime];
//    NSString *timeSpStr = [NSString stringWithFormat:@"%ld", (long)[timeSp timeIntervalSince1970]];
//    
//    //NSLog(@"icon timeSp:%@",timeSpStr);
//    
//    NSMutableString *channelsId = [NSMutableString stringWithFormat:@"%@",channels[0]];
//
//    NSMutableString *channelsTime = [NSMutableString stringWithFormat:@"%@",timeSpStr];
//    for (int i = 1; i < channels.count; i++) {
//        [channelsId appendString:[NSString stringWithFormat:@",%@",channels[i]]];
//        [channelsTime appendString:[NSString stringWithFormat:@",%@",timeSpStr]];
//    }
//    
//    //NSLog(@"get channels:%@", channels);
//    [param setValue:channelsId forKey:@"channelList"];
//    [param setValue:channelsTime forKey:@"lastUpdateTime"];
//    
//    _appDelegate = APP_DELEGATE;
////    NSString *dueDateSp =
////    [NSString stringWithFormat:@"%ld", (long)[_appDelegate.dueDate timeIntervalSince1970]];
////    [param setValue:dueDateSp forKey:@"duedate"];
//    
//    __block NSInteger allBadgeNum = 0;
//    
//    MKNetworkOperation *op = [_momLookEngine operationWithPath:@"adco/getNewContentInfo"
//                                                            params:param
//                                                        httpMethod:@"POST"
//                                                               ssl:NO];
//    //NSLog(@"param:%@", param);
//    [op addCompletionHandler:^(MKNetworkOperation *operation) {
//        NSArray *resDic = [NSJSONSerialization JSONObjectWithData:[operation responseData]
//                                                          options:NSJSONReadingAllowFragments
//                                                            error:nil];
//        
//        NSLog(@"mk 获取红点的 %@",resDic);
//        //NSLog(@"resDic:%@", resDic);
//        for (int i = 0; i < resDic.count; i++) {
//            allBadgeNum += [resDic[i] integerValue];
//        }
//        
//        if (aFinishBlock) {
//            aFinishBlock(allBadgeNum);
//        }
//    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
//    }];
//    
//    [_momLookEngine enqueueOperation:op];
//}

//获取孕期和育儿状态下的http参数
- (NSMutableDictionary *)getHttpParmas
{
    NSMutableDictionary *paramas = [NSMutableDictionary dictionary];
    
    ADLocationManager *manager = [ADLocationManager shareLocationManager];
    NSString *pr = manager.location.province;
    NSString *ci = manager.location.city;
    if (pr.length > 0) {
        [paramas setObject:pr forKey:@"pr"]; // province
    }
    
    if (ci.length > 0) {
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

@end
