//
//  ADToolModel.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/8/7.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADToolModel : NSObject

@property (nonatomic,strong) NSString *toolId;
@property (nonatomic,strong) NSString *action;
@property (nonatomic,strong) NSString *toolName;

+ (ADToolModel *)getToolModelFromObject:(id)obj;

@end
