//
//  ADNoticeInfo.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/5/7.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADNoticeInfo.h"

@implementation ADNoticeInfo


- (ADNoticeInfo *)initWithDictionary:(NSDictionary *)dic{

    if (self = [super init]) {
        self.contentCommentId = dic[@"contentCommentId"];
        self.contentId = dic[@"contentId"];
        self.count = dic[@"count"];
        self.createTime = dic[@"createTime"];
        self.messageId = dic[@"messageId"];
        self.postCommentId = dic[@"postCommentId"];
        self.postId = dic[@"postId"];
        self.quote = dic[@"quote"];
        self.status = dic[@"status"];
        self.type = dic[@"type"];
        self.uid = dic[@"uid"];
        self.updateTime = dic[@"updateTime"];
        self.message = dic[@"message"];
        self.lastReactionUid = dic[@"lastReactionUid"];
    }
    
    return self;
}


+ (ADNoticeInfo *)noticeinfoWithDictionary:(NSDictionary *)dic{

    ADNoticeInfo *info = [[ADNoticeInfo alloc] initWithDictionary:dic];
    return info;
}


@end
