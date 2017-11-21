//
//  ADMomSecertNetworkHelper.m
//  PregnantAssistant
//
//  Created by D on 14/12/8.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADMomSecertNetworkHelper.h"
#import "AFNetworking.h"
#import "ADLocationManager.h"

static ADMomSecertNetworkHelper *sharedClient = nil;
@implementation ADMomSecertNetworkHelper

+ (ADMomSecertNetworkHelper *)shareInstance {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedClient = [[ADMomSecertNetworkHelper alloc] init];
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

- (NSString *)getTime{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults lastUpdateBadgeDate]) {
        
        NSLog(@"红点时间 %@",[defaults lastUpdateBadgeDate]);
        NSTimeInterval a = [[defaults lastUpdateBadgeDate] timeIntervalSince1970];
        return [NSString stringWithFormat:@"%.0f", a];
    }else{
        NSDate *date = [defaults valueForKey:firstLaunchTimeKey];
        NSTimeInterval a = [date timeIntervalSince1970];
        return [NSString stringWithFormat:@"%.0f",a];
    }
    
}


//api.addinghome.com/lightforum/regist_device
- (void)regDeviceWithOAuth:(NSString *)aOAuth andDeviceToken:(NSString *)aDeviceToken
{
    _momSecertEngine = [[ADMomSecertEngine alloc] initWithDefaultSettings];
    
    NSDictionary *param = nil;
    if (aOAuth.length > 0 && aDeviceToken.length > 0) {
        param = @{@"oauth_token":aOAuth,
                  @"device_token":aDeviceToken,
                  @"device_type":@"1"};
    }
    
    MKNetworkOperation *op = [_momSecertEngine operationWithPath:@"lightforum/regist_device"
                                                params:param
                                            httpMethod:@"POST"
                                                   ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
    }];
    
    [_momSecertEngine enqueueOperation:op];
}

- (void)getBadgeNumWithResult:(void (^)(int))aFinishBlock
{
    NSString *tStr = [self getToken];
    if (tStr.length > 0) {
        NSDictionary *param = @{@"oauth_token":tStr,@"lastUpdateTime":[self getTime]};
        
        ADBaseRequest *aRequest = [ADBaseRequest shareInstance];

        NSString *urlString = [NSString stringWithFormat:@"http://%@/message/newMessageInfo", baseTestApiUrl];
        
        //NSLog(@"请求秘密小红点%@,%@",urlString,param);
        [aRequest GET:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"秘密小红点 %@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *countStr = [responseObject objectForKey:@"count"];
                if ([countStr isEqual:[NSNull null]]) {
                }else{
                    aFinishBlock((int)countStr.integerValue);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"更新秘密小红点失败%@",error.localizedDescription);
        }];
    }
}

- (void)getSecertBadgeNumwithResult:(void (^)(int result))aFinishBlock{
    NSString *tStr = [self getToken];
    if (tStr.length > 0) {
        NSDictionary *param = @{@"oauth_token":tStr};
        
        ADBaseRequest *aRequest = [ADBaseRequest shareInstance];
        
        NSString *urlString = [NSString stringWithFormat:@"http://%@/lightforum/v2/get_message_count?", baseApiUrl];

        //NSLog(@"请求秘密小红点%@,%@",urlString,param);
        [aRequest GET:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"秘密小红点 %@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *countStr = [responseObject objectForKey:@"count"];
                if ([countStr isEqual:[NSNull null]]) {
                }else{
                    aFinishBlock((int)countStr.integerValue);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"更新秘密小红点失败%@",error.localizedDescription);
        }];
    }
    
}

- (void)updateNotificationTimeComplete:(void (^)(BOOL isremoveSucess))aFinishBlock{

    NSString *tStr = [self getToken];
    if (tStr.length > 0) {
        NSDictionary *param = @{@"oauth_token":tStr,@"notificationTime":[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]]};
        
        
        NSString *urlString = [NSString stringWithFormat:@"http://%@/lightforum/update_notification_time?", baseApiUrl];
        NSLog(@"urlString:%@,param:%@",urlString,param);
        //NSLog(@"请求秘密小红点%@,%@",urlString,param);
        
        ADBaseRequest *aRequest = [ADBaseRequest shareInstance];
        [aRequest POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *countStr = [responseObject objectForKey:@"result"];
                if ([countStr integerValue] == 1) {
                    aFinishBlock(YES);
                }else{
                    aFinishBlock(NO);
                }
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }

}

- (void)getUserPostWithStartInx:(NSString *)startInx
                      andLength:(NSString *)aLength
                      andResult:(void (^)(NSArray *))aFinishBlock
{
    _momSecertEngine = [[ADMomSecertEngine alloc] initWithDefaultSettings];
    
    NSDictionary *param = @{@"oauth_token":[self getToken],
                            @"start":startInx,
                            @"size":aLength};
    
    MKNetworkOperation *op = [_momSecertEngine operationWithPath:@"lightforum/get_post_by_auth"
                                                          params:param
                                                      httpMethod:@"POST"
                                                             ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
        aFinishBlock(resultArray);
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        
    }];
    
    [_momSecertEngine enqueueOperation:op];
}

- (void)getUserPostWithStartInx:(NSString *)startInx
                      andLength:(NSString *)aLength
                      andResult:(void (^)(NSArray *))aFinishBlock failed:(void (^)(void))fail
{
    _momSecertEngine = [[ADMomSecertEngine alloc] initWithDefaultSettings];
    
    NSDictionary *param = @{@"oauth_token":[self getToken],
                            @"start":startInx,
                            @"size":aLength};
    NSString *urlString = [NSString stringWithFormat:@"http://%@/lightforum/get_post_by_auth",baseApiUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arr = responseObject;
        if (aFinishBlock) {
            aFinishBlock(arr);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail();
    }];

}

- (void)deleteSecertWithCommandId:(NSString *)aCommandId PostId:(NSString *)aPostId onFinish:(void (^)(NSDictionary *))aFinishBlock onFailed:(FailRequstBlock)aFailBlock{

    if (aPostId == nil) {
        [ADHelper showToastWithText:@"消息不存在"];
        return;
    }
    _momSecertEngine = [[ADMomSecertEngine alloc] initWithDefaultSettings];
    
    NSDictionary *param;
    NSString *urlString;
    if (aCommandId != nil) {
        param= @{@"oauth_token":[self getToken],
                 @"postId":aPostId,
                 @"commentId":aCommandId};
        urlString = [NSString stringWithFormat:@"http://%@/lightforum/delete_comment",baseApiUrl];


    }else{
        param=  @{@"oauth_token":[self getToken],
                  @"postId":aPostId};
        urlString = [NSString stringWithFormat:@"http://%@/lightforum/delete_post",baseApiUrl];
    }
    
    NSLog(@"删除秘密%@,%@",urlString,param);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"删除结果 %@",responseObject);
        NSDictionary *dic = responseObject;
        if (aFinishBlock) {
            aFinishBlock(dic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        aFailBlock();
    }];

    
}

- (void)getAllNotinfoWithStart:(NSString *)start size:(NSString *)size SecretFinishBlock:(void (^)(NSArray *))aFinishBlock failed:(FailRequstBlock)aFailBlock{

    NSString *stringUrl = [NSString stringWithFormat:@"http://%@/message/getMessageList?", baseApiUrl];
    NSDictionary *param = @{@"oauth_token":[self getToken],@"start":start,@"size":size};
    AFHTTPRequestOperationManager *magager = [AFHTTPRequestOperationManager manager];
    [magager POST:stringUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *dataArray = responseObject;
        if (aFinishBlock) {
            aFinishBlock(dataArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (aFailBlock) {
            aFailBlock();
        }
    }];
}

- (void)getAllSecretNotinfoWithStart:(NSString *)start size:(NSString *)size SecretFinishBlock:(void (^)(NSArray *))aFinishBlock failed:(FailRequstBlock)aFailBlock{
    
    NSString *stringUrl = [NSString stringWithFormat:@"http://%@/lightforum/v2/get_message_line?", baseApiUrl];
    NSDictionary *param = @{@"oauth_token":[self getToken],@"start":start,@"size":size};
    AFHTTPRequestOperationManager *magager = [AFHTTPRequestOperationManager manager];
    [magager POST:stringUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *dataArray = responseObject;
        if (aFinishBlock) {
            aFinishBlock(dataArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (aFailBlock) {
            aFailBlock();
        }
    }];
    
}


- (void)changeAPostWithId:(NSString *)aPostId
                andStatus:(BOOL)aStatus
             complication:(FinishRequstBlock)aRequstBlock
                   failed:(FailRequstBlock)aFailBlock
{
    if (aPostId == nil) {
        [ADHelper showToastWithText:@"消息不存在"];
        return;
    }
    _momSecertEngine = [[ADMomSecertEngine alloc] initWithDefaultSettings];

    NSDictionary *param = @{@"oauth_token":[self getToken],
                            @"postId":aPostId};
    
    NSLog(@"like param:%@", param);
    
    MKNetworkOperation *op = nil;
    if (aStatus == YES) {
        op =[_momSecertEngine operationWithPath:@"lightforum/create_praise"
                                         params:param
                                     httpMethod:@"POST"
                                            ssl:NO];
        
    } else {
        op =[_momSecertEngine operationWithPath:@"lightforum/delete_praise"
                                         params:param
                                     httpMethod:@"POST"
                                            ssl:NO];
    }
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        if (aRequstBlock) {
            aRequstBlock();
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"like err:%@",err);
        if (aFailBlock) {
            aFailBlock();
        }
    }];
    
    [_momSecertEngine enqueueOperation:op];
}

- (void)changeACommentWithId:(NSString *)aCommentId
                   andPostId:(NSString *)aPostId
                   andStatus:(BOOL)aStatus
              andFinishBlock:(FinishRequstBlock)aFinishBlock
                      failed:(FailRequstBlock)aFailBlock
{
    if (aPostId == nil) {
        [ADHelper showToastWithText:@"评论的消息不存在"];
        return;
    }
    _momSecertEngine = [[ADMomSecertEngine alloc] initWithDefaultSettings];
    
    NSDictionary *param = @{@"oauth_token":[self getToken],
                            @"postId":aPostId,
                            @"commentId":aCommentId};

    NSLog(@"comment param:%@", param);
    MKNetworkOperation *op = nil;
    if (aStatus == YES) {
        op =[_momSecertEngine operationWithPath:@"lightforum/create_praise"
                                         params:param
                                     httpMethod:@"POST"
                                            ssl:NO];
        
    } else {
        op =[_momSecertEngine operationWithPath:@"lightforum/delete_praise"
                                         params:param
                                     httpMethod:@"POST"
                                            ssl:NO];
    }
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        if (aFinishBlock) {
            aFinishBlock();
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"like err:%@",err);
        if (aFailBlock) {
            aFailBlock();
        }
    }];
    
    [_momSecertEngine enqueueOperation:op];
}

- (void)reportCommentWithId:(NSString *)aCommentId andPostId:(NSString *)aPostId
{
    if(aPostId == nil){
        //[ADHelper showAlertWithMessage:@"举报的消息不存在"];
        [ADHelper showToastWithText:@"举报的消息不存在"];
        return;
    }
    _momSecertEngine = [[ADMomSecertEngine alloc] initWithDefaultSettings];
    
//    NSString *requstUrl =
//    [NSString stringWithFormat:@"lightforum/report_message?oauth_token=%@&postId=%@&commentId=%@",
//     [self getToken], aPostId, aCommentId];
    NSString *requstUrl = [NSString stringWithFormat:@"lightforum/report_message"];
    
    NSDictionary *param = nil;
    if (aCommentId.length > 0) {
        param = @{@"oauth_token":[self getToken],
                  @"postId":aPostId,
                  @"postId":aCommentId};
    } else {
        param = @{@"oauth_token":[self getToken],
                  @"postId":aPostId};
    }
    NSLog(@"requst:%@", requstUrl);
    MKNetworkOperation *op =[_momSecertEngine operationWithPath:requstUrl
                                                         params:param
                                                     httpMethod:@"POST"
                                                            ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:nil];
        
        NSNumber *resultNum = resultDic[@"result"];
        
        if ([resultNum isEqualToNumber:@1]) {
            [ADHelper showToastWithText:@"举报成功"];
        }
        
        NSLog(@"report rs:%@", [operation responseString]);
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"fail");
    }];
    
    [_momSecertEngine enqueueOperation:op];
}

- (void)createCommentWithPostId:(NSString *)aPostId
                        andBody:(NSString *)aBody
//                 andFinishBlock:(void (^)(NSDictionary *))aFinishBlock
                       onFinish:(FinishRequstBlock)aFinishBlock
                       onFailed:(FailRequstBlock)aFailBlock
{
    _momSecertEngine = [[ADMomSecertEngine alloc] initWithDefaultSettings];
    
    NSDictionary *param = @{@"oauth_token":[self getToken],
                            @"commentbody":aBody,
                            @"postId":aPostId};
    
    MKNetworkOperation *op =[_momSecertEngine operationWithPath:@"lightforum/create_comment"
                                                         params:param
                                                     httpMethod:@"POST"
                                                            ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:nil];
        NSNumber *resultNum = resultDic[@"result"];
        
        if ([resultNum isEqualToNumber:@1]) {
            [ADHelper showToastWithText:@"发表成功"];
            if (aFinishBlock) {
                aFinishBlock();
            }
        } else {
            [ADHelper showToastWithText:@"发表失败"];
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"errOp:%@ err:%@", errorOp, err);
        [ADHelper showToastWithText:@"系统繁忙"];
        
        if (aFailBlock) {
            aFailBlock();
        }
    }];
    
    [_momSecertEngine enqueueOperation:op];
}

- (void)getAllSecertWithStartInx:(NSInteger)aInx
                       andLength:(NSInteger)aLength
                     andViewtype:(viewType)aViewType
                  andFinishBlock:(void (^)(NSArray *))aFinishBlock
                          failed:(FailRequstBlock)aFailBlock
{
    _momSecertEngine = [[ADMomSecertEngine alloc] initWithDefaultSettings];
    
    NSDictionary *param = @{@"oauth_token":[self getToken],
                            @"start":[NSString stringWithFormat:@"%ld",(long)aInx],
                            @"size":[NSString stringWithFormat:@"%ld",(long)aLength]};
    
    MKNetworkOperation *op = nil;
    
    if (aViewType == allStoryType) {
        op = [_momSecertEngine operationWithPath:@"lightforum/v2/timeline_all"
                                          params:param
                                      httpMethod:@"POST"
                                             ssl:NO];
    } else {
        op = [_momSecertEngine operationWithPath:@"lightforum/v2/timeline_hot"
                                          params:param
                                      httpMethod:@"POST"
                                             ssl:NO];
    }
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
        if (aFinishBlock) {
            aFinishBlock(resultArray);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"err:%@",err);
        if (aFailBlock) {
            aFailBlock();
        }
    }];
    
    [_momSecertEngine enqueueOperation:op];
}

- (void)getAllSecertWithStartInx:(NSInteger)aInx
                       andLength:(NSInteger)aLength
                   andLastPostId:(NSInteger)aLostPostId
                     andViewtype:(viewType)aViewType
                  andFinishBlock:(void (^)(NSArray *))aFinishBlock
                          failed:(FailRequstBlock)aFailBlock
                    oAuthTimeOut:(OAuthTimeOutBlock)aOAuthBlock
{
    
    NSDictionary *param1 = @{@"oauth_token":[self getToken],
                                   @"start":[NSString stringWithFormat:@"%ld",(long)aInx],
                                   @"size":[NSString stringWithFormat:@"%ld",(long)aLength]};
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:param1];

    if (aInx != 0) {
        [param setObject:[NSString stringWithFormat:@"%ld",(long)aLostPostId] forKey:@"postId"];
    }
    
    NSString *urlString;
    if (aViewType == allStoryType) {
        urlString = [NSString stringWithFormat:@"http://%@/lightforum/v2/timeline_all",baseApiUrl];
    }else{
        urlString = [NSString stringWithFormat:@"http://%@/lightforum/v2/timeline_hot",baseApiUrl];
    }
    
    ADBaseRequest *aRequest = [ADBaseRequest shareInstance];
    [aRequest POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id resultArray = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
        if ([resultArray isKindOfClass:[NSDictionary class]]) {
            if ([resultArray[@"error_code"] isEqualToNumber:@10001] ||
                [resultArray[@"error_code"] isEqualToNumber:@10002]) {
                NSLog(@"err:%@", resultArray[@"error"]);
                if (aOAuthBlock) {
                    aOAuthBlock();
                }
            }
        }else if(aFinishBlock){
            aFinishBlock(resultArray);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (aFailBlock) {
            aFailBlock();
        }
    }];
    
    
}

- (void)postSecerrWithBody:(NSString *)body
                 andImgUrl:(NSString *)imageUrl
            andFinishBlock:(FinishRequstBlock)aFinishBlock
                    failed:(FailRequstBlock)aFailBlock
{
    _momSecertEngine = [[ADMomSecertEngine alloc] initWithDefaultSettings];
    
    ADAppDelegate *appDelegate = APP_DELEGATE;
    
    NSTimeInterval time=[appDelegate.dueDate timeIntervalSinceDate:[NSDate date]];
    int days=((int)time)/(3600*24);
    if (days < 0) {
        days = 0;
    }
    int passDay = 280 -days -1;
    
    int week = passDay /7;
    
    if ([self getToken].length > 0) {
        NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithCapacity:0];
        [param setObject:[self getToken] forKey:@"oauth_token"];
        [param setObject:body forKey:@"postbody"];
        [param setObject:[NSString stringWithFormat:@"%d", week] forKey:@"pregWeek"];
        
        NSString *longtitude =
        [ADLocationManager shareLocationManager].location.longitude == nil? @"":[ADLocationManager shareLocationManager].location.longitude;
        NSString *latitude =
        [ADLocationManager shareLocationManager].location.latitude == nil? @"":[ADLocationManager shareLocationManager].location.latitude;

        [param setObject:longtitude forKey:@"longitude"];
        [param setObject:latitude forKey:@"latitude"];
        
        if (imageUrl.length > 0) {
            [param setObject:imageUrl forKey:@"imageUrl"];
        }
        
        MKNetworkOperation *op = [_momSecertEngine operationWithPath:@"lightforum/create_post"
                                                              params:param
                                                          httpMethod:@"POST"
                                                                 ssl:NO];
        
        [op addCompletionHandler:^(MKNetworkOperation *operation) {
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                                      options:NSJSONReadingAllowFragments
                                                                        error:nil];
            
            NSNumber *resultNum = resultDic[@"result"];
            
            NSLog(@"resultDic:%@", resultDic);
            if ([resultNum isEqualToNumber:@1]) {
                [ADHelper showToastWithText:@"发布成功"];
                
                if (aFinishBlock) {
                    aFinishBlock();
                }
            } else {
                [ADHelper showToastWithText:@"发布失败"];
                if (aFailBlock) {
                    aFailBlock();
                }
            }
        }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
            [ADHelper showToastWithText:ConnectError];
            NSLog(@"post err:%@", err);
            if (aFailBlock) {
                aFailBlock();
            }
        }];
        
        [_momSecertEngine enqueueOperation:op];
    }
}

- (void)getASecretWithId:(NSInteger)aSecretId
          andFinishBlock:(void (^)(NSArray *))aFinishBlock
                  failed:(FailRequstBlock)aFailBlock
{
    _momSecertEngine = [[ADMomSecertEngine alloc] initWithDefaultSettings];

    NSDictionary *param = @{@"postId":[NSString stringWithFormat:@"%ld",(long)aSecretId],
                            @"oauth_token":[self getToken]};
    
    NSLog(@"param:%@", param);
//    NSString *urlString = [NSString stringWithFormat:@"%@/lightforum/get_post",baseApiUrl];
//
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//      
//        NSArray *resultArray = responseObject;
//        NSLog(@"responseObject ==== %@",responseObject);
//        if (aFinishBlock) {
//            aFinishBlock(resultArray);
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error  == %@",error);
//        if (aFailBlock) {
//            aFailBlock();
//        }
//    }];
    
    
    MKNetworkOperation *op =[_momSecertEngine operationWithPath:@"lightforum/get_post"
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
    
    [_momSecertEngine enqueueOperation:op];
}

- (void)replayCommentWithId:(NSString *)aCommentId
                    andBody:(NSString *)aBody
                  andPostId:(NSString *)aPostId
             andFinishBlock:(FinishRequstBlock)aFinishBlock
{
    if (aPostId == nil) {
        [ADHelper showToastWithText:@"消息不存在"];
        return;
    }
    _momSecertEngine = [[ADMomSecertEngine alloc] initWithDefaultSettings];
    
    NSDictionary *param = @{@"oauth_token":[self getToken],
                            @"postId":aPostId,
                            @"commentbody":aBody,
                            @"commentId":aCommentId};
    
    MKNetworkOperation *op = [_momSecertEngine operationWithPath:@"lightforum/create_comment"
                                                          params:param
                                                      httpMethod:@"POST"
                                                             ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:nil];

        NSNumber *resultNum = resultDic[@"result"];
        NSLog(@"replay res:%@", resultDic);
        
        if ([resultNum isEqualToNumber:@1]) {
            [ADHelper showToastWithText:@"回复成功"];
        } else {
            [ADHelper showToastWithText:@"回复失败"];
        }

        if (aFinishBlock) {
            aFinishBlock();
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        [ADHelper showToastWithText:@"系统繁忙"];
    }];
    
    [_momSecertEngine enqueueOperation:op];
}

- (void)getCommentWithPostId:(NSString *)aPostId
                 andStartInx:(NSString *)aStart
                     andSize:(NSString *)aSize
              andFinishBlock:(void (^)(NSArray *))aFinishBlock failed:(void (^) (void))failed
{
    if (aPostId == nil) {
        [ADHelper showToastWithText:@"消息不存在"];
        return;
    }
    
    NSDictionary *param = @{@"postId":aPostId,
                            @"start":aStart,
                            @"size":aSize,
                            @"oauth_token":[self getToken]};
    NSString *urlString = [NSString stringWithFormat:@"http://%@/lightforum/get_comment",baseApiUrl];
    
    ADBaseRequest *aRequest = [ADBaseRequest shareInstance];
    [aRequest POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *resultArray = responseObject;
        if (aFinishBlock) {
            aFinishBlock(resultArray);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failed) {
            failed();
        }
    }];
}

- (void)updateNoticeRequestTime
{
    _momSecertEngine = [[ADMomSecertEngine alloc] initWithDefaultSettings];
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    
    NSLog(@"token:%@", [self getToken]);
    NSDictionary *param = @{@"oauth_token":[self getToken],
                            @"notificationTime":timeString};
    
    MKNetworkOperation *op = nil;
    
    op = [_momSecertEngine operationWithPath:@"lightforum/update_notification_time"
                                      params:param
                                  httpMethod:@"POST"
                                         ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
    }];
    
    [_momSecertEngine enqueueOperation:op];
}

- (void)getNewsListWithFinishBlock:(void (^)(NSArray *))aFinishBlock
{
    _momSecertEngine = [[ADMomSecertEngine alloc] initWithDefaultSettings];

    NSDictionary *param = @{@"oauth_token":[self getToken]};
    
    NSLog(@"param:%@", param);
    MKNetworkOperation *op = nil;
    
    op =[_momSecertEngine operationWithPath:@"lightforum/v2/get_message_line"
                                     params:param
                                 httpMethod:@"POST"
                                        ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
        NSLog(@"message array:%@", resultArray);
        if (aFinishBlock) {
            aFinishBlock(resultArray);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
    }];
    
    [_momSecertEngine enqueueOperation:op];
}

- (void)getNewsListWithFinishBlock:(void (^)(NSArray *))aFinishBlock failed:(void (^) (void))failed
{
    _momSecertEngine = [[ADMomSecertEngine alloc] initWithDefaultSettings];
    
    NSDictionary *param = @{@"oauth_token":[self getToken]};
    
    NSLog(@"param:%@", param);
    MKNetworkOperation *op = nil;
    
    op =[_momSecertEngine operationWithPath:@"lightforum/v2/get_message_line"
                                     params:param
                                 httpMethod:@"POST"
                                        ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
        NSLog(@"message array:%@", resultArray);
        if (aFinishBlock) {
            aFinishBlock(resultArray);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        failed();
    }];
    
    [_momSecertEngine enqueueOperation:op];
}

- (void)postWeiXinInfoWithAccessToken:(NSString *)accessToken
                      andRefreshToken:(NSString *)refreshToken
                            andOpenid:(NSString *)openId
{
    _momSecertEngine = [[ADMomSecertEngine alloc] initWithDefaultSettings];
    
    NSDictionary *param = @{ @"partner":@"weixin",
                             @"partner_token":accessToken,
                             @"client":@"addingMommy",
                             @"partner_weixin_openid":openId,
                             @"refresh_token":refreshToken
                             };
    MKNetworkOperation *op = [_momSecertEngine operationWithPath:[NSString stringWithFormat:@"account/partner_login"]
                                                          params:param
                                                      httpMethod:@"POST"
                                                             ssl:NO];
    
    NSLog(@"WX Param:%@", param);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:nil];
        
        NSString *addingToken = resultDic[@"access_token"];
        NSLog(@"addingToken:%@", addingToken);
        
        [[NSUserDefaults standardUserDefaults]setAddingToken:addingToken];
        
        self.appDelegate.addingToken = addingToken;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:getAddingTokenNotification
                                                            object:nil
                                                          userInfo:nil];
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
    }];
    
    [_momSecertEngine enqueueOperation:op];
}

@end