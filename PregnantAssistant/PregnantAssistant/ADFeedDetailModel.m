//
//  ADFeedDetailModel.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/23.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADFeedDetailModel.h"

@implementation ADFeedDetailModel
+ (ADFeedDetailModel *)getFeedDetailmodelWithDict:(NSDictionary *)dataDict{
    ADFeedDetailModel *model = [[ADFeedDetailModel alloc] init];
    model.mediaId = dataDict[@"mediaId"];
    model.contentId = dataDict[@"contentId"];
    model.title = dataDict[@"title"];
    model.author = dataDict[@"author"];
    model.myDescription = dataDict[@"description"];
    model.publishTime = dataDict[@"publishTime"];
    model.images = dataDict[@"images"];
    model.action = dataDict[@"action"];
    model.mediaName = dataDict[@"mediaName"];
    return model;
}
@end
