//
//  ADFeedDetailModel.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/23.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADFeedDetailModel : NSObject
@property (strong, nonatomic) NSString *mediaId;
@property (strong, nonatomic) NSString *contentId;
@property (strong, nonatomic) NSString *logoUrl;
@property (strong, nonatomic) NSString *publishTime;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *myDescription;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSString *action;
@property (strong ,nonatomic) NSString *mediaName;

+ (ADFeedDetailModel *)getFeedDetailmodelWithDict:(NSDictionary *)dataDict;

@end
