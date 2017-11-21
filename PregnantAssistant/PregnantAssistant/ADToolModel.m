//
//  ADToolModel.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/8/7.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADToolModel.h"

@implementation ADToolModel

+ (ADToolModel *)getToolModelFromObject:(id)obj
{
    ADToolModel *model = [[ADToolModel alloc] init];
    model.toolId = [NSString stringWithFormat:@"%@",[obj objectForKey:@"toolId"]];
    model.action = [obj objectForKey:@"action"];
    model.toolName = [obj objectForKey:@"toolName"];
    
    return model;
}

@end
