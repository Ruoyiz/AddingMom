//
//  ADShareHelper.h
//  PregnantAssistant
//
//  Created by D on 14/12/2.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    sina_share_type = 0,
    weixin_share_tpye,
    friend_share_type
} ShareType;

@interface ADShareHelper : NSObject

+ (ADShareHelper *)shareInstance;

- (void)sendLinkToWeixinWithShare_Link:(NSString *)share_link
                                 title:(NSString *)title
                           description:(NSString *)description
                             shareType:(ShareType)type
                                 image:(UIImage *)image
                                 isImg:(BOOL)isImg;

- (void)sendWeiboShareWithDes:(NSString *)aDes andImg:(UIImage *)aImg;
- (void)senWeiBoShareWithTitle:(NSString *)title urlString:(NSString *)urlString image:(UIImage *)aImg;

@property (nonatomic, copy) UIImage *thumbImg;
@property (nonatomic, assign) NSInteger currentTryCnt;

@end
