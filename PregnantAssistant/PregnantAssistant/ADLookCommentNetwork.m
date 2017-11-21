//
//  ADLookCommentNetwork.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/12.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADLookCommentNetwork.h"
#import "AFNetworking.h"

//判断是否为测试环境
#define commentTest 0
#define LookContentUrlString @"http://%@/adco/v2.1/getContent"
//评论列表
#define CommentListUrlString @"http://%@/adcomment/v2/getCommentList"

//创建评论
#define CreateCommentUrlString @"http://%@/adcomment/createComment"

// 获取热门评论
#define HotCommentListUrlString @"http://%@/adcomment/getCommentListHot"

//点赞接口
#define CreatePrasieUrlString @"http://%@/adcomment/createPraise"

//取消赞
#define DeletePraiseUrlString @"http://%@/adcomment/deletePraise"

//举报
#define ReportCommentUrlString @"http://%@/adcomment/reportComment"

//删除自己的评论
#define deleteCommentUrlString @"http://%@/adcomment/deleteComment"

@implementation ADLookCommentNetwork

+ (NSString *)getHost
{
    if (commentTest) {
        return baseTestApiUrl;
    }
    
    return baseApiUrl;
}

+ (NSError *)getErrorFromDic:(NSDictionary *)dic
{
    NSError *error = [NSError errorWithDomain:[dic objectForKey:@"error"] code:[[dic objectForKey:@"error_code"] integerValue] userInfo:[dic objectForKey:@"error_params"]];
    return error;
}

+ (void)getLookContentWithContentId:(NSString *)contentId success:(void (^) (id responseObject)) success failure :(void (^) (NSError *error)) failure
{
    NSString *urlString = [NSString stringWithFormat:LookContentUrlString,[self getHost]];
    
    NSString *oAuth = [[NSUserDefaults standardUserDefaults]addingToken];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:oAuth forKey:@"oauth_token"];
    [parameters setObject:contentId forKey:@"contentId"];
    
    //NSLog(@"获取文章 %@,%@",parameters,urlString);

    ADBaseRequest *aRequest = [ADBaseRequest shareInstance];
    
    [aRequest GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"....%@,%@",operation.response.allHeaderFields,responseObject);
//        NSLog(@"%@",operation.response.allHeaderFields);
        //NSLog(@"%@",responseObject);
        if (success) {
            success (responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//- (void)GET:(NSString *)URLString
//                     parameters:(id)parameters
//                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
//{
//    
//}

//获取评论列表
+ (void)getCommentListFromStartPos:(NSInteger)startPos size:(NSInteger)size contentId:(NSString *)contentId commentId:(NSString *)commentId success:(void (^) (id responseObject, NSInteger commentCount))success failure:(void (^) (NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:CommentListUrlString,[self getHost]];
    
    
    NSString *oAuth = [[NSUserDefaults standardUserDefaults]addingToken];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:oAuth forKey:@"oauth_token"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)startPos] forKey:@"start"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)size] forKey:@"size"];
    [parameters setObject:contentId forKey:@"contentId"];
    
    if (commentId != nil) {
        [parameters setObject:commentId forKey:@"commentId"];
    }
    
    ADBaseRequest *aRequest = [ADBaseRequest shareInstance];
    
    [aRequest GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *error = [responseObject objectForKey:@"error"];
            if ([error isEqual:[NSNull null]] || error == nil) {
                
            }else{
                if (failure) {
                    failure([self getErrorFromDic:responseObject]);
                }
            }
        }else{
            
            NSString *countStr = [operation.response.allHeaderFields objectForKey:@"X-AD-CommentCount"];
            NSInteger count = 0;// = [ integerValue];

            if ([countStr isEqual:[NSNull null]]) {
                
            }else{
                count = [countStr integerValue];
            }
            if (success) {
                success(responseObject,count);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//获取热门评论列表
+ (void)getHotCommentListFromStartPos:(NSInteger)startPos size:(CGFloat)size contentId:(NSString *)contentId commentId:(NSString *)commentId success:(void (^) (id responseObject, NSInteger commentCount))success failure:(void (^) (NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:HotCommentListUrlString,[self getHost]];
    
    NSString *oAuth = [[NSUserDefaults standardUserDefaults]addingToken];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:oAuth forKey:@"oauth_token"];
//    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)startPos] forKey:@"start"];
//    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)size] forKey:@"size"];
    [parameters setObject:contentId forKey:@"contentId"];
    
    ADBaseRequest *aRequest = [ADBaseRequest shareInstance];
    
    [aRequest GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            failure([self getErrorFromDic:responseObject]);
        }else{
            NSString *countStr = [operation.response.allHeaderFields objectForKey:@"X-AD-CommentCount"];
            NSInteger count = 0;// = [ integerValue];
            
            if ([countStr isEqual:[NSNull null]]) {
                
            }else{
                count = [countStr integerValue];
            }
            if (success) {
                success(responseObject,count);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取热门评论失败%@",error.localizedDescription);
        if (failure) {
            failure(error);
        }
    }];
}

//创建评论
+ (void)createCommentForContentId:(NSString *)contentId replyCommentId:(NSString *)replyCommentId commentbody:(NSString *)commentbody success:(void (^) (id responseObject))success failure:(void (^) (NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:CreateCommentUrlString,[self getHost]];
    NSString *oAuth = [[NSUserDefaults standardUserDefaults] addingToken];
    
    if (oAuth.length == 0 || contentId == nil || [contentId isEqual:[NSNull null]]) {
        failure([[NSError alloc] init]);
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:oAuth forKey:@"oauth_token"];
    [parameters setObject:contentId forKey:@"contentId"];
    
    if (contentId) {
        [parameters setObject:contentId forKey:@"contentId"];
    }
    if(replyCommentId != nil){
        [parameters setObject:replyCommentId forKey:@"replyCommentId"];
    }
    [parameters setObject:commentbody forKey:@"commentBody"];
    
    //NSLog(@"创建评论%@,%@",parameters,urlString);
    ADBaseRequest *aRequest = [ADBaseRequest shareInstance];
    
    [aRequest GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *error = [responseObject objectForKey:@"error"];
        if ([error isEqual:[NSNull null]] || error == nil) {
            if (success) {
                success(responseObject);
            }
        }else{
            if (failure) {
                failure([self getErrorFromDic:responseObject]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"创建热门评论失败%@",error.localizedDescription);
        if (failure) {
            failure(error);
        }
    }];
}

//点赞
+ (void)createPraiseForContentId:(NSString *)contentId commentId:(NSString *)commentId success:(void (^) (id responseObject))success failure:(void (^) (NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:CreatePrasieUrlString,[self getHost]];
    NSString *oAuth = [[NSUserDefaults standardUserDefaults] addingToken];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:oAuth forKey:@"oauth_token"];
//    [parameters setObject:contentId forKey:@"contentId"];
//    [parameters setObject:commentId forKey:@"commentId"];
    if (commentId) {
        [parameters setObject:commentId forKey:@"commentId"];
    }
    
    if (contentId) {
        [parameters setObject:contentId forKey:@"contentId"];
    }
    
    ADBaseRequest *aRequest = [ADBaseRequest shareInstance];
    
    [aRequest GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *error = [responseObject objectForKey:@"error"];
        if ([error isEqual:[NSNull null]] || error == nil) {
            if (success) {
                success(responseObject);
            }
        }else{
            if (failure) {
                failure([self getErrorFromDic:responseObject]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"点赞失败 %@",error.localizedDescription);
        if (failure) {
            failure(error);
        }
    }];
}

//取消赞
+ (void)deletePraiseForContentId:(NSString *)contentId commentId:(NSString *)commentId success:(void (^) (id responseObject))success failure:(void (^) (NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:DeletePraiseUrlString,[self getHost]];
    NSString *oAuth = [[NSUserDefaults standardUserDefaults] addingToken];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:oAuth forKey:@"oauth_token"];
    if (commentId) {
        [parameters setObject:commentId forKey:@"commentId"];
    }
    
    if (contentId) {
        [parameters setObject:contentId forKey:@"contentId"];
    }
    
    ADBaseRequest *aRequest = [ADBaseRequest shareInstance];
    
    [aRequest GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"取消点赞 %@",responseObject);

        NSString *error = [responseObject objectForKey:@"error"];
        if ([error isEqual:[NSNull null]] || error == nil) {
            if (success) {
                success(responseObject);
            }
        }else{
            if (failure) {
                failure([self getErrorFromDic:responseObject]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"点赞失败 %@",error.localizedDescription);
        if (failure) {
            failure(error);
        }
    }];
}

//举报
+ (void)reportCommentForContentId:(NSString *)contentId commentId:(NSString *)commentId success:(void (^) (id responseObject))success failure:(void (^) (NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:ReportCommentUrlString,[self getHost]];
    NSString *oAuth = [[NSUserDefaults standardUserDefaults] addingToken];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:oAuth forKey:@"oauth_token"];
//    [parameters setObject:contentId forKey:@"contentId"];
//    [parameters setObject:commentId forKey:@"commentId"];
    
    if (commentId) {
        [parameters setObject:commentId forKey:@"commentId"];
    }
    
    if (contentId) {
        [parameters setObject:contentId forKey:@"contentId"];
    }
    
    ADBaseRequest *aRequest = [ADBaseRequest shareInstance];
    
    [aRequest GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"举报 %@",responseObject);

        NSString *error = [responseObject objectForKey:@"error"];
        if ([error isEqual:[NSNull null]] || error == nil) {
            if (success) {
                success(responseObject);
            }
        }else{
            if (failure) {
                failure([self getErrorFromDic:responseObject]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"举报失败 %@",error.localizedDescription);
        if (failure) {
            failure(error);
        }
    }];
}

//删除自己的评论
+ (void)deleteCommentForContentId:(NSString *)contentId commentId:(NSString *)commentId success:(void (^) (id responseObject))success failure:(void (^) (NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:deleteCommentUrlString,[self getHost]];
    NSString *oAuth = [[NSUserDefaults standardUserDefaults] addingToken];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:oAuth forKey:@"oauth_token"];
//    [parameters setObject:contentId forKey:@"contentId"];
//    [parameters setObject:commentId forKey:@"commentId"];
    
    if (commentId) {
        [parameters setObject:commentId forKey:@"commentId"];
    }
    
    if (contentId) {
        [parameters setObject:contentId forKey:@"contentId"];
    }
    
    //NSLog(@"%@,%@",urlString,parameters);
    ADBaseRequest *aRequest = [ADBaseRequest shareInstance];
    
    [aRequest GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"删除 %@",responseObject);
        NSString *error = [responseObject objectForKey:@"error"];
        if ([error isEqual:[NSNull null]] || error == nil) {
            if (success) {
                success(responseObject);
            }
        }else{
            if (failure) {
                failure([self getErrorFromDic:responseObject]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"删除失败 %@",error.localizedDescription);
        if (failure) {
            failure(error);
        }
    }];
}

@end
