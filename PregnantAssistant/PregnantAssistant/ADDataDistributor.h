//
//  ADDataDistributor.h
//  PregnantAssistant
//
//  Created by D on 15/4/21.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADDataDistributor : NSObject

+ (ADDataDistributor *)shareInstance;

- (void)distributeDataToLoginUser;

@end
