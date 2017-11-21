//
//  ADSearchModel.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/8/7.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADSearchModel.h"
#import "ADFeedContentListModel.h"
#import "ADMomContentInfo.h"
#import "ADToolModel.h"

typedef enum : NSUInteger {
    ADSearchResponseEntityMedia,
    ADSearchResponseEntityContent,
    ADSearchResponseEntityTool,
} ADSearchResponseEntity;

@interface ADSearchModel : NSObject

@property (nonatomic,assign) ADSearchResponseEntity entity;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end
