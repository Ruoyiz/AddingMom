//
//  ADGetTextSize.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/4/14.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADGetTextSize : NSObject

+ (CGFloat)heighForString:(NSString *)text width:(CGFloat)width andFont:(UIFont *)font;

+ (CGFloat)heightForString:(NSString *)text width:(CGFloat)width attributes:(NSDictionary *)attributes;

+ (CGFloat)widthForString:(NSString*)text height:(CGFloat)height andFont:(UIFont *)font;

@end
