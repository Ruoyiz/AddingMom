//
//  ADLoginNetWork.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/7/7.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADLoginNetWork.h"
#import "AFNetWorking.h"
#import "ADUserInfoSaveHelper.h"
#import "ADNetwork.h"

//判断是否注册过
#define IsRegisteredUrlString @"http://api.addinghome.com/account/is_registered"

//注册
#define RegisterUrlString @"http://api.addinghome.com/account/register"

//验证验证吗
#define VerifyPhoneCode @"http://api.addinghome.com/account/phone_verify_code"

//发送验证码
#define SendPhoneCode @"http://api.addinghome.com/account/phone_send_code"

//短信验证
#define VerifyUrlString @"http://api.addinghome.com/account/register_verify"

//登录
#define LoginUrlString @"http://api.addinghome.com/oauth2/token"

//修改密码
#define UpdatePasswordUrlString @"http://api.addinghome.com/account/update_password"

//获取用户信息
#define GetFullAccountUrlString @"http://api.addinghome.com/account/get_full_account"

@implementation ADLoginNetWork

+ (void)registerVirifyWithPhone:(NSString *)phone password:(NSString *)password success:(void (^)(id responseObject))successBlock failure:(void(^) (NSString *errorMsg))failureBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *string = @"+86";
    [param setObject:[string stringByAppendingString:phone] forKey:@"phone"];
    [param setObject:password forKey:@"password"];
    [param setObject:[ADHelper getIdfv] forKey:@"stat_cid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:VerifyUrlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"%@,%@",responseObject,param);
        NSString *result = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"result"]];
        if ([result isEqualToString:@"1"]) {
            successBlock(responseObject);
        }else{
            NSString *errorStr = [responseObject objectForKey:@"error"];
            failureBlock(errorStr);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error.localizedDescription);
        failureBlock(ConnectError);
    }];
}

+ (void)sendPhoneCodeWithPhone:(NSString *)phone password:(NSString *)password type:(NSString *)type success:(void (^)(id responseObject))successBlock failure:(void(^) (NSString *errorMsg))failureBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *string = @"+86";
    [param setObject:[string stringByAppendingString:phone] forKey:@"phone"];
    if (password != nil) {
        [param setObject:password forKey:@"password"];
    }
    [param setObject:[ADHelper getIdfv] forKey:@"stat_cid"];
    [param setObject:type forKey:@"type"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:SendPhoneCode parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"发送验证码 %@",responseObject);
        
        NSString *error = [responseObject objectForKey:@"error"];
        if (error == nil || [error isEqual:[NSNull null]]) {
            successBlock(responseObject);
        }else{
            if ([error isEqualToString:@"gen code too frequent"] ) {
                NSLog(@"cdcccc"); 
                failureBlock(@"验证码发送太频繁");
            }else{
                failureBlock(@"重置密码失败，请重试");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(ConnectError);

    }];
}

+ (void)VerifyPhoneCodeWithCode:(NSString *)code phone:(NSString *)phone codeId:(NSString *)codeId success:(void (^)(id responseObject))successBlock failure:(void(^) (NSString *errorMsg))failureBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *string = @"+86";
    [param setObject:[string stringByAppendingString:phone] forKey:@"phone"];
    [param setObject:codeId forKey:@"codeId"];
    [param setObject:code forKey:@"code"];

    [param setObject:[ADHelper getIdfv] forKey:@"stat_cid"];
//    [param setObject:type forKey:@"type"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:VerifyPhoneCode parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"result"]];
        if ([result isEqualToString:@"1"]) {
            successBlock(responseObject);
        }else{
            failureBlock(@"验证码错误");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(ConnectError);
    }];
}

+ (void)registerWithPhone:(NSString *)phone password:(NSString *)password codeId:(NSString *)codeId code:(NSString *)code success:(void (^)(id responseObject))successBlock failure:(void(^) (NSString *errorMsg))failureBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *string = @"+86";
    [param setObject:[string stringByAppendingString:phone] forKey:@"phone"];
    [param setObject:password forKey:@"password"];
    [param setObject:[ADHelper getIdfv] forKey:@"stat_cid"];
    [param setObject:codeId forKey:@"codeId"];
    [param setObject:code forKey:@"code"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:RegisterUrlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"%@,%@",responseObject,param);
        NSString *errorMsg = [responseObject objectForKey:@"error"];
        if ([errorMsg isEqual:[NSNull null]] || errorMsg == nil) {
            successBlock(responseObject);
        }else{
            failureBlock(errorMsg);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error.localizedDescription);
        failureBlock(ConnectError);

    }];
}

+ (void)loginWithPhone:(NSString *)phone password:(NSString *)password success:(void (^)(id responseObject))successBlock failure:(void(^) (NSString *errorMsg))failureBlock
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
   
    NSString *stat_token = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN]==nil?@"":[[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN];
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [dic setValue:stat_token forKey:@"stat_token"];
    [dic setValue:idfv forKey:@"stat_cid"];
    
    [dic setValue:@"add3ing5add7ing" forKey:@"client_secret"];
    
    [dic setValue:@"100" forKey:@"client_id"];
    [dic setValue:@"add3ing5add7ing" forKey:@"client_secret"];
    [dic setValue:@"password" forKey:@"grant_type"];
    
    NSString *string = @"+86";
    [dic setValue:[string stringByAppendingString:phone] forKey:@"username"];
    [dic setValue:password forKey:@"password"];
    NSLog(@"登录参数 %@",dic);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:LoginUrlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"登录成功%@",responseObject);

        NSString *token = [responseObject objectForKey:@"access_token"];
        if ([token isEqual:[NSNull null]] || token == nil) {
            failureBlock(@"");
        }else{
            [[NSUserDefaults standardUserDefaults] setAddingToken:[NSString stringWithFormat:@"%@",token]];
            //[[ADAccountCenter sharedADAccountCenter] getUserInfoWithToken:token withTarget:self success:@selector(loginSuccess) failure:@selector(loginFailure)];
            [self getUserInfoWithToken:token success:^(id responseObject) {
                NSLog(@"获取个人信息 %@",responseObject);
                successBlock(responseObject);
            } failure:^(NSString *errorMsg) {
                NSLog(@"获取个人数据失败");
                failureBlock(ConnectError);
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code != -10009) {
            failureBlock(@"用户名或密码错误");
        }else{
            failureBlock(ConnectError);
        }
    }];
}

+ (void)getUserInfoWithToken:(NSString*)token success:(void (^)(id responseObject))successBlock failure:(void(^) (NSString *errorMsg))failureBlock
{
    NSString *usrToken;
    if (token == nil) {
        usrToken = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ADDING_TOKEN];
    }else{
        usrToken = token;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:usrToken forKey:@"oauth_token"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url = @"http://api.addinghome.com/pregnantAssistant/getFullAccountNUserInfo";
    [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject objectForKey:@"error"] ==nil) {
                NSString *uid = [responseObject objectForKey:@"uid"];
                [[NSUserDefaults standardUserDefaults] setAddingUid:uid];
                [[NSNotificationCenter defaultCenter]postNotificationName:distrubeDataToUserNotification object:nil];
            
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:nil];
                [ADUserInfoSaveHelper saveWithDic:resultDic];
//                [ADUserInfoSaveHelper saveIconData:responseObject[@"face"] andName:responseObject[@"nickname"]];
                successBlock(responseObject);
            }else{
                
                [ADToastHelp dismissSVProgress];
                NSString * errorCode = [responseObject objectForKey:@"error_code"];
                failureBlock(errorCode);
            }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(ConnectError);
    }];
}

+ (void)getWeiboUserInfoWithToken:(NSString *)token weiboUid:(NSString *)uid loginControl:(ADLoginControl *)loginContrl
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:token forKey:@"partner_token"];
    [param setObject:[ADHelper getIdfv] forKey:@"stat_cid"];
    [param setObject:@"weibo" forKey:@"partner"];
    [param setObject:@"addingMommy" forKey:@"client"];

    //[ADToastHelp showSVProgressToastWithTitle:@"正在登录"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:@"http://api.addinghome.com/account/partner_login" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"。。。。成功");

        NSString *token = [responseObject objectForKey:@"access_token"];
        if ([token isEqual:[NSNull null]] || token == nil) {
            [loginContrl addingLoginFailure];
        }else{
            [[NSUserDefaults standardUserDefaults] setAddingToken:[NSString stringWithFormat:@"%@",token]];
            [self getUserInfoWithToken:token success:^(id responseObject) {
                [loginContrl addingLoginSuccessfull];
            } failure:^(NSString *errorMsg) {
                //failureBlock(errorMsg);
                [loginContrl addingLoginFailure];

            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ADToastHelp showSVProgressToastWithError:@"微博授权失败"];
        [loginContrl addingLoginSuccessfull];
        NSLog(@"%@",error.localizedDescription);
    }];
}

+ (void)resetPasswordWithPhone:(NSString *)phone password:(NSString *)password codeId:(NSString *)codeId code:(NSString *)code success:(void (^)(id responseObject))successBlock failure:(void(^) (NSString *errorMsg))failureBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *string = @"+86";
    [param setObject:[string stringByAppendingString:phone] forKey:@"phone"];
    [param setObject:password forKey:@"password"];
    [param setObject:[ADHelper getIdfv] forKey:@"stat_cid"];
    [param setObject:codeId forKey:@"codeId"];
    [param setObject:code forKey:@"code"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:UpdatePasswordUrlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@,%@",responseObject,param);
        NSString *result = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"result"]];
        if ([result isEqualToString:@"1"]) {
            successBlock(responseObject);
        }else{
            NSString *error = [responseObject objectForKey:@"error"];
            if ([error isEqualToString:@"none existent uid"]) {
                failureBlock(@"手机号未注册");
            }else{
                failureBlock(@"重置密码失败");
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(ConnectError);
    }];
}

@end
