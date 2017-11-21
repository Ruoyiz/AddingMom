//
//  ADNetwork.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-11.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>


//新浪账户三种操作方式（获取token）
typedef enum {
    
    SINA_TYPE_LOGIN = 1,
    SINA_TYPE_OATHO = 2,
    SINA_TYPE_SHARE
    
}SINA_TYPE;

typedef enum {
    
    ADACCOUNT_TYPE_UNKNOW = -1,
    ADACCOUNT_TYPE_SINA = 0,
    ADACCOUNT_TYPE_TENCENT,
    ADACCOUNT_TYPE_TENCENTWEIBO,
    ADACCOUNT_TYPE_BAIDU,
    ADACCOUNT_TYPE_WEIXIN
}ADACCOUNT_TYPE;

//网络错误码
typedef enum {
    ADREGISTER_ERROR_INVALID_GRAND = 10003,
    ADREGISTER_ERROR_INVALID_EMAIL = 20001,
    ADREGISTER_ERROR_EXISTED_EMAIL = 20002,
    ADREGISTER_ERROR_INVALID_PHONE,
    ADREGISTER_ERROR_EXISTED_PHONE,
    ADREGISTER_ERROR_INVALID_PASSWORD,
    ADREGISTER_ERROR_INVALID_CODE,
    ADREGISTER_ERROR_EXPIRED_CODE,
    ADREGISTER_ERROR_NOEXISTENT_UID,
    ADREGISTER_ERROR_ALREADY_BINDED,
    ADREGISTER_ERROR_GENCODE_FREQUENT,
    ADOAUTH_QQ_CANCLE,
    ADOAUTH_SINA_CANCLE,
    ADOAUTH_BAIDU_CANCLE,
    ADOAUTH_QQ_FAILURE,
    ADOAUTH_SINA_FAILURE,
    ADOAUTH_BAIDU_FAILURE,
    ADLOGIN_QQ_FAILURE,
    ADLOGIN_SINA_FAILURE,
    ADLOGIN_BAIDU_FAILURE,
    ADLOGIN_WEIXIN_FAILURE
}ADREGISTER_ERROR_CODE;

#define  HTTP_USER_AGENT  ([NSString stringWithFormat:@"%@/%@ iOS/%@",[[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleNameKey],[[NSBundle mainBundle] infoDictionary][(NSString *)@"CFBundleShortVersionString"],[[UIDevice currentDevice] systemVersion]])

#define  HTTP_CID_HEADER ([[[UIDevice currentDevice] identifierForVendor] UUIDString])

#define LOGIN_TEST_HOST @"www.addinghome.com:8080/api_oauth2/token"

#pragma mark - 各种账号

//加丁
#define ACCOUNT_ADDING_UID @"addingUid"
#define ACCOUNT_ADDING_TOKEN @"addingToken"
#define ACCOUNT_ADDING_NICKNAME @"addingNickname"
#define ACCOUNT_ADDING_ISADDING @"isAdding"
#define ACCOUNT_ADDING_ICONURL @"addingIconUrl"

//sina
#define kSinaAppKey         @"556210471"
#define kSinaAppSecret      @"45b53bef55bd758f6296fa174e9aa27a"
#define kSinaRedirectURI    @"http://www.addinghome.com/oauth2/callback"
#define ACCOUNT_SINA_KEY    @"accountSinaKay" //用于userdefault存储
#define ACCOUNT_SINA_TOKEN   @"accountSinaToken" //用于userdefault存储
#define ACCOUNT_SINA_EXPIRES   @"accountSinaExpires" //用于userdefault存储
#define ACCOUNT_SINA_UID   @"accountSinaUid" //用于userdefault存储
#define ACCOUNT_SINA_SHARE_SUCCESSFUL @"sina_share_secceed"
#define ACCOUNT_SINA_SHARE_FAILURE @"sina_share_failure"
//tencent
#define kTencentAppKey         @"801487685"
#define kTencentAppSecret      @"aa392bb7beec56ba92ebff50d8aa3a25"
#define kTencentRedirectURI    @"http://addinghome.com/"
#define ACCOUNT_TENCENT_KEY    @"accountTencentKay" //用于userdefault存储
#define ACCOUNT_TENCENT_TOKEN   @"accountTencentToken" //用于userdefault存储
#define ACCOUNT_TENCENT_EXPIRES   @"accountTencentExpires" //用于userdefault存储
#define ACCOUNT_TENCENT_UID   @"accountTencentUid" //用于userdefault存储

//qq
//#define kQQAppKey         @"101086516"
//#define kQQRedirectURI    @"http://www.addinghome.com/oauth2/callback"
//#define kQQAppSecret      @"b707fcae2d7be964e1dbcda837b599ea"
//#define ACCOUNT_QQ_KEY    @"accountQQKay" //用于userdefault存储
//#define ACCOUNT_QQ_TOKEN   @"accountQQToken" //用于userdefault存储
//#define ACCOUNT_QQ_EXPIRES   @"accountQQExpires" //用于userdefault存储
//#define ACCOUNT_QQ_UID   @"accountQQUid" //用于userdefault存储

//baidu
#define kBaiduAppKey         @"qemBzuVbthD5OkPgl4VobF7t"
#define kBaiduRedirectURI    @"http://www.addinghome.com/oauth2/callback"
#define ACCOUNT_BAIDU_KEY    @"accountBaiduKay" //用于userdefault存储
#define ACCOUNT_BAIDU_TOKEN   @"accountBaiduToken" //用于userdefault存储
#define ACCOUNT_BAIDU_EXPIRES   @"accountBaiduExpires" //用于userdefault存储
#define ACCOUNT_BAIDU_UID   @"accountBaiduUid" //用于userdefault存储

//微信
#define kWeixinAppKey         @"wx9a99a64c9debc82f"
#define kWeixinAppSecret        @"53821ce9d6850fa3f1bfca733cd7f025"
#define kWeixinRedirectURI    @"https://api.weibo.com/oauth2/default.html"
#define ACCOUNT_WEIXIN_KEY    @"accountWeixinKay" //用于userdefault存储
#define ACCOUNT_WEIXIN_TOKEN   @"accountWeixinToken" //用于userdefault存储
#define ACCOUNT_WEIXIN_EXPIRES   @"accountWeixinExpires" //用于userdefault存储
#define ACCOUNT_WEIXIN_UID   @"accountWeixinUid" //用于userdefault存储
#define ACCOUNT_WEIXIN_OPENID   @"accountWeixinOpenid" //用于userdefault存储

//信鸽
#define kXinGeAppId  2200033811
#define kXinGeAppKey @"I4L81RKRF27J"


//友盟统计
#define UMAPP_KEY @"5399540456240b395800a0cb"

//远程推送 devicetoken
#define APP_DEVICETOKEN @"appDeviceToken"
//系统配置key
#define APP_WEIXIN_KEY @"weixinkey"
#define APP_QQ_KEY @"qqkey"
#define APP_BAIDU_KEY @"baidukey"
#define APP_SINA_KEY @"sinakey"


//第三方账号绑定信息key值
#define THIRDPARTY_BIND_KEY  @"thirdPartyBindKey" //用于userdefault存储
#define WEIBO_ENABLED_KEY  @"weibo_enabled" //用于userdefault存储
#define QQ_ENABLED_KEY  @"qq_enabled" //用于userdefault存储
#define BAIDU_ENABLED_KEY  @"baidu_enabled" //用于userdefault存储
/**
 *  预产期key值
 */
#define USER_DUEDATE_KEY @"duedateKey"

/**
 *  用户信息key值
 */
#define USER_USERINFO_KEY @"userInfoKey"


/**
 *  同步数据key值
 */
#define LOCAL_SYNC_TIME @"localSyncTime"//胎动
#define LOCAL_UPDATE_TIME @"localUpdateTime"//胎动

#define LOCAL_SPORT_SYNC_TIME @"localSportSyncTime"//运动量
#define LOCAL_SPORT_UPDATE_TIME @"localSportUpdateTime"//运动量

/**
 *  同步预产期key值
 */
#define LOCAL_DUEDATE_SYNCTIME @"localDuedateSynctime"
#define LOCAL_DUEDATE_UPDATETIME @"localDuedateUpdatetime"
/*
 * 邀请更多妈妈URL获取
 */
#define ACCOUNT_INVITE_MORE_MOM   @"api.addinghome.com/fetalMovement/get_invite_info"

/*
 * 邀请更多妈妈URL获取
 */
#define ENTERPRISE_VERSIN 33017

/*
 * 网络接口 comment path param
 */



