//
//  ADToastHelp.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/13.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADToastHelp : NSObject

+ (void)showSVProgressToastWithTitle:(NSString *)title;

+ (void)dismissSVProgress;
+ (void)showSVProgressWithSuccess:(NSString *)str;

+ (void)showSVProgressToastWithError:(NSString *)str;

@end
