//
//  NSString+Contains.m
//  PregnantAssistant
//
//  Created by D on 14/11/14.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "NSString+Contains.h"

@implementation NSString (Contains)

- (BOOL)myContainsString:(NSString*)other {
    NSRange range = [self rangeOfString:other];
    return range.location != NSNotFound;
}
/**
 *  解析Url中某一个参数
 *
 *  @param param 参数
 *
 *  @return 参数内容
 */
- (NSString *)getParamFromUrlWithParam:(NSString *)param
{
    //获取问号的位置，问号后是参数列表
    NSRange range = [self rangeOfString:@"?"];
//    NSLog(@"参数列表开始的位置：%d", (int)range.location);
    
    //获取参数列表
    NSString *propertys = [self substringFromIndex:(int)(range.location+1)];
//    NSLog(@"截取的参数列表：%@", propertys);
    
    //进行字符串的拆分，通过&来拆分，把每个参数分开
    NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
//    NSLog(@"把每个参数列表进行拆分，返回为数组：\n%@", subArray);
    
    for (int j = 0 ; j < subArray.count; j++)
    {
        //在通过=拆分键和值
        NSArray *dicArray = [subArray[j] componentsSeparatedByString:@"="];
//        NSLog(@"再把每个参数通过=号进行拆分：\n%@", dicArray);
        //给字典加入元素
        if ([dicArray count] > 1) {
            if([dicArray[0] isEqualToString:param]){
//                NSLog(@"参数是…%@",dicArray[1]);
                return dicArray[1];
                break;
            }

        }
    }
    return nil;
}

@end
