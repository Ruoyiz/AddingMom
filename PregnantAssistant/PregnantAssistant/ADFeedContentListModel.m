//
//  ADFeedContentListModel.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/19.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADFeedContentListModel.h"

@implementation ADFeedContentListModel
+ (ADFeedContentListModel *)getFeedContentListmodelWithDict:(NSDictionary *)dataDict{
    ADFeedContentListModel *model = [[ADFeedContentListModel alloc] init];
    model.mediaId = dataDict[@"mediaId"];
    model.newestContentId = dataDict[@"newestContentId"];
    model.newestPublishTime = dataDict[@"newestPublishTime"];
    model.mediaName = dataDict[@"mediaName"];
    model.logoUrl = dataDict[@"logoUrl"];
    model.type = dataDict[@"type"];
    model.title = dataDict[@"title"];
    model.author = dataDict[@"author"];
    model.myDescription = dataDict[@"description"];
    model.dotShow = dataDict[@"dotShow"];
    model.isRss = [NSString stringWithFormat:@"%@",dataDict[@"isRss"]];
    model.uid = [NSUserDefaults standardUserDefaults].addingUid;
    return model;
}

@end
