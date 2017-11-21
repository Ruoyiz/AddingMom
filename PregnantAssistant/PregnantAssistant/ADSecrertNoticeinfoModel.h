//
//  ADSecrertNoticeinfoModel.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/7/16.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADSecrertNoticeinfoModel : NSObject
@property (nonatomic, strong) NSString *commentCount;
@property (nonatomic, strong) NSString *creatTime;
@property (nonatomic, strong) NSString *messageListId;
@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSString *postbody;
@property (nonatomic, strong) NSString *praiseCount;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *uid;
+ (ADSecrertNoticeinfoModel *)getSecrertNoticeinfoModelWithDict:(NSDictionary *)dict;
@end
