//
//  ADFeedMediaModel.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/24.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADFeedMediaModel.h"

@implementation ADFeedMediaModel
+ (ADFeedMediaModel *)getFeedMediaModelWithDict:(NSDictionary *)dict{

    ADFeedMediaModel *model = [[ADFeedMediaModel alloc] init];
    model.mediaId = dict[@"mediaId"];
    model.name = dict[@"mediaName"];
    model.logoUrl = dict[@"logoUrl"];
    model.type = dict[@"type"];
    model.myDescription = dict[@"description"];
    model.isRss = dict[@"isRss"];
    model.wtitle = dict[@"wtitle"];
    model.wurl = dict[@"wurl"];
    return model;
}
@end
