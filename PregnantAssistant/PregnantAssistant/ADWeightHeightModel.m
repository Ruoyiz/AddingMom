//
//  ADWeightHeightModel.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/5/29.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADWeightHeightModel.h"

@implementation ADWeightHeightModel
-(ADWeightHeightModel *)initWithDictionary:(NSDictionary *)dic{
    if(self=[super init]){
        self.time=dic[@"time"];
        self.height=dic[@"height"] ;
        self.weight=dic[@"weight"];
        self.uid = [[NSUserDefaults standardUserDefaults] addingUid];
        
    }
    return self;
}

+(ADWeightHeightModel *)statusWithDictionary:(NSDictionary *)dic{
    ADWeightHeightModel *model=[[ADWeightHeightModel alloc]initWithDictionary:dic];
    return model;
}

@end
