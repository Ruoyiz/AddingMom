//
//  ADMomLookReadInfoManager.h
//  PregnantAssistant
//
//  Created by D on 15/3/12.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADMomCellInfo.h"

@interface ADMomLookReadInfoManager : NSObject

+ (void)addCellInfoWithAction:(NSString *)aAction;
+ (void)delCellInfoWithAction:(NSString *)aAction;
+ (BOOL)isClickedWithAction:(NSString *)aAction;

+ (RLMResults *)readAllFavVideo;

@end
