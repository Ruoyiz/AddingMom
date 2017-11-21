//
//  ADNAccountCenter.m
//  
//
//  Created by D on 15/7/16.
//
//

#import "ADNAccountCenter.h"

@implementation ADNAccountCenter

+ (ADNAccountCenter *)defaultCenter
{
    static ADNAccountCenter *sharedADAccountCenter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedADAccountCenter = [[self alloc] init];
    });
    return sharedADAccountCenter;
}

- (void)setupUserInfoByThirdParty:(LXMThirdLoginType)type
                      onReturnApp:(void (^)())onReturnBlock
                         onFinish:(void (^)(NSError *))finishBlock
{
    //第三方登陆
    //登陆后获取token
    //根据token获取账号信息
    [[LXMThirdLoginManager sharedManager]requestLoginWithThirdType:type
                                                     onReturnBlock:^{
                                                         if (onReturnBlock) {
                                                             onReturnBlock();
                                                         }
                                                     } completeBlock:^(LXMThirdLoginResult *thirdPartyRes) {
                                                         if (thirdPartyRes && thirdPartyRes.thirdLoginState == 0) {
                                                             [[ADNAccountCenter defaultCenter]getAddingTokenWithThirdPartyToken:thirdPartyRes.accessToken
                                                                                                                 thirdPartyType:type
                                                                                                                   refreshToken:thirdPartyRes.refresh_token
                                                                                                                   wechatOpenId:thirdPartyRes.unionid
                                                                                                                       onFinish:^(NSError *err) {
                                                                                                                           if (err == nil) {
                                                                                                                               [[ADNAccountCenter defaultCenter]getUserInfoOnFinish:^(NSError *err) {
                                                                                                                                   finishBlock(err);
                                                                                                                               }];
                                                                                                                           } else {
                                                                                                                               finishBlock(err);
                                                                                                                           }
                                                                                                                       }];
                                                         } else {
                                                             NSError *err = [[NSError alloc]initWithDomain:@"com.addinghome" code:404 userInfo:nil];
                                                             finishBlock(err);
                                                         }
                                                 }];
}

- (void)getAddingTokenWithThirdPartyToken:(NSString *)token
                           thirdPartyType:(LXMThirdLoginType)type
                             refreshToken:(NSString *)refreshToken
                             wechatOpenId:(NSString *)wechatOpenId
                                 onFinish:(void(^)(NSError *))finishBlock
{
    NSDictionary *param = nil;
    switch (type) {
        case LXMThirdLoginTypeSinaWeibo:
            param = @{ @"partner":@"weibo",
                       @"partner_token":token,
                       @"client":@"addingMommy"
                       };
            break;
        case LXMThirdLoginTypeWeChat:
            param = @{ @"partner":@"weixin",
                       @"partner_token":token,
                       @"client":@"addingMommy",
                       @"partner_weixin_openid":wechatOpenId,
                       @"refresh_token":refreshToken
                       };
            break;
            
        default:
            break;
    }
    
    ADBaseRequest *aRequest = [ADBaseRequest shareInstance];
    [aRequest GET:@"http://api.addinghome.com/account/partner_login" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        
        NSString *addingToken = resultDic[@"access_token"];
        NSLog(@"addingToken:%@", addingToken);
        [[NSUserDefaults standardUserDefaults]setAddingToken:addingToken];//加丁token.并保存起来

        if (finishBlock) {
            finishBlock(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"err %@", error);
        if (finishBlock) {
            finishBlock(error);
        }
    }];
}

- (void)getUserInfoOnFinish:(void (^)(NSError *))finishBlock
{
    ADBaseRequest *aRequest = [ADBaseRequest shareInstance];
    
    NSDictionary *param = @{@"oauth_token": [[NSUserDefaults standardUserDefaults]addingToken]};

    [aRequest GET:@"http://api.addinghome.com/pregnantAssistant/getFullAccountNUserInfo"
       parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData]
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:nil];
        if (resultDic[@"error"] == nil) {
            [[NSUserDefaults standardUserDefaults]setAddingUid:resultDic[@"uid"]];
            [[NSNotificationCenter defaultCenter]postNotificationName:distrubeDataToUserNotification object:nil];
//            NSString *iconUrl = resultDic[@"face"];
            [ADUserInfoSaveHelper saveWithDic:resultDic];
//            [ADUserInfoSaveHelper saveIconData:resultDic[@"face"] andName:resultDic[@"nickname"]];
            if (finishBlock) {
                finishBlock(nil);
            }
        } else {
//            NSString * errorCode = resultDic[@"error_code"];
//            NSLog(@"login errcode: %@",errorCode);
            
            if (finishBlock) {
                NSError *err = [[NSError alloc]initWithDomain:@"com.addinghome.com" code:500 userInfo:nil];
                finishBlock(err);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (finishBlock) {
            finishBlock(error);
        }
    }];
}

- (void)exitAccount
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    [ADUserInfoSaveHelper copyBasicUserInfoDataFromUid:uid]; //将预产期 宝宝生日保存
    
    [[NSUserDefaults standardUserDefaults] removeAddingUid];//删除uid
    [[NSUserDefaults standardUserDefaults] removeAddingToken];//删除token
    [[NSNotificationCenter defaultCenter]postNotificationName:logoutNotification object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:updateColloctListNotification object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:updateFeedListNotification object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:updateRecommadListNotification object:nil];
}

@end
