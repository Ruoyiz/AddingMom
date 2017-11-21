//
//  ADNAccountCenter.h
//  
//
//  Created by D on 15/7/16.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//#import <LXMThirdLoginManager.h>
//#import <LXMThirdLoginResult.h>
#import "LXMThirdLoginManager.h"
#import "LXMThirdLoginResult.h"

typedef NS_ENUM(NSInteger, ThirdPartyType) {
    WeiboType,
    WechatType
};

@interface ADNAccountCenter : NSObject

+ (ADNAccountCenter *)defaultCenter;

- (void)setupUserInfoByThirdParty:(LXMThirdLoginType)type
                      onReturnApp:(void (^)())onReturnBlock
                         onFinish:(void (^)(NSError *))finishBlock;

- (void)getAddingTokenWithThirdPartyToken:(NSString *)token
                           thirdPartyType:(LXMThirdLoginType)type
                             refreshToken:(NSString *)refreshToken
                             wechatOpenId:(NSString *)wechatOpenId
                                 onFinish:(void(^)(NSError *))finishBlock;
- (void)getUserInfoOnFinish:(void (^)(NSError *))finishBlock;
- (void)exitAccount;

@end
