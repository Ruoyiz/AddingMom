//
//  NSString+Contains.h
//  PregnantAssistant
//
//  Created by D on 14/11/14.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Contains)

- (BOOL)myContainsString:(NSString*)other;
/**
 *  解析Url中某一个参数
 *
 *  @param param 参数
 *
 *  @return 参数内容
 */
- (NSString *)getParamFromUrlWithParam:(NSString *)param;
@end
