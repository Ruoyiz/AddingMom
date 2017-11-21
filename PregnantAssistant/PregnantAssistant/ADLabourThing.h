//
//  ADLabourThing.h
//  PregnantAssistant
//
//  Created by D on 14-9-18.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADLabourThing : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *recommendCnt; //推荐数量
@property (nonatomic, assign) float recommentScore;

@end
