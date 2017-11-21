//
//  ADLoginNetWork.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/7/7.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADLoginControl.h"

@interface ADLoginNetWork : NSObject

+ (void)registerVirifyWithPhone:(NSString *)phone password:(NSString *)password success:(void (^)(id responseObject))successBlock failure:(void(^) (NSString *errorMsg))failureBlock;

+ (void)sendPhoneCodeWithPhone:(NSString *)phone password:(NSString *)password type:(NSString *)type success:(void (^)(id responseObject))successBlock failure:(void(^) (NSString *errorMsg))failureBlock;

+ (void)registerWithPhone:(NSString *)phone password:(NSString *)password codeId:(NSString *)codeId code:(NSString *)code success:(void (^)(id responseObject))successBlock failure:(void(^) (NSString *errorMsg))failureBlock;
+ (void)loginWithPhone:(NSString *)phone password:(NSString *)password success:(void (^)(id responseObject))successBlock failure:(void(^) (NSString *errorMsg))failureBlock;

+ (void)getWeiboUserInfoWithToken:(NSString *)token weiboUid:(NSString *)uid loginControl:(ADLoginControl *)loginContrl;

+ (void)VerifyPhoneCodeWithCode:(NSString *)code phone:(NSString *)phone codeId:(NSString *)codeId success:(void (^)(id responseObject))successBlock failure:(void(^) (NSString *errorMsg))failureBlock;

+ (void)resetPasswordWithPhone:(NSString *)phone password:(NSString *)password codeId:(NSString *)codeId code:(NSString *)code success:(void (^)(id responseObject))successBlock failure:(void(^) (NSString *errorMsg))failureBlock;

@end
