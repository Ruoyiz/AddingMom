//
//  ADFeedMediaModel.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/24.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADFeedMediaModel : NSObject
@property (nonatomic, strong) NSString *mediaId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *logoUrl;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *myDescription;
@property (nonatomic, strong) NSString *isRss;
@property (nonatomic, strong) NSString *wtitle;
@property (nonatomic, strong) NSString *wurl;
+ (ADFeedMediaModel *)getFeedMediaModelWithDict:(NSDictionary *)dict;
@end
