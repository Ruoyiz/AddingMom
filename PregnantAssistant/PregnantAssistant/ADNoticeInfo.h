//
//  ADNoticeInfo.h
//  PregnantAssistant
//
//  Created by 加丁 on 15/5/7.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADNoticeInfo : NSObject

@property (nonatomic, strong) NSString *contentCommentId;
@property (nonatomic, strong) NSString *contentId;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *postCommentId;
@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSString *quote;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *lastReactionUid;
- (ADNoticeInfo *)initWithDictionary:(NSDictionary *)dic;
+ (ADNoticeInfo *)noticeinfoWithDictionary:(NSDictionary *)dic;

@end
