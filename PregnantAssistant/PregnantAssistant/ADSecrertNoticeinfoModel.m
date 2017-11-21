//
//  ADSecrertNoticeinfoModel.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/7/16.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADSecrertNoticeinfoModel.h"

@implementation ADSecrertNoticeinfoModel
+ (ADSecrertNoticeinfoModel *)getSecrertNoticeinfoModelWithDict:(NSDictionary *)dict{
    ADSecrertNoticeinfoModel *model = [[ADSecrertNoticeinfoModel alloc] init];
    model.commentCount = dict[@"commentCount"];
    model.creatTime = dict[@"createTime"];
    model.messageListId = dict[@"messageListId"];
    model.postId = dict[@"postId"];
    model.praiseCount = dict[@"praiseCount"];
    model.type = dict[@"type"];
    model.uid = dict[@"uid"];
    model.postbody = dict[@"postbody"];
    return model;
}
@end
