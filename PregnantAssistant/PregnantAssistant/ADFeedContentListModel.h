//
//  ADFeedContentListModel.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/19.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADFeedContentListModel : NSObject
@property (nonatomic, strong) NSString *mediaId;
@property (nonatomic,strong) NSString *isRss;
@property (nonatomic, strong) NSString *newestContentId;
@property (nonatomic, strong) NSString *newestPublishTime;
@property (nonatomic, strong) NSString *mediaName;
@property (nonatomic, strong) NSString *logoUrl;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *myDescription;
@property (nonatomic, strong) NSString * dotShow;
@property (nonatomic, strong) NSString *uid;
+ (ADFeedContentListModel *)getFeedContentListmodelWithDict:(NSDictionary *)dataDict;
@end
