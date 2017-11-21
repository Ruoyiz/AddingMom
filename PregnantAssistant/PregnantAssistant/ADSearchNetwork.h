//
//  ADSearchNetwork.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/8/6.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ADSearchEntityAll,
    ADSearchEntityMedia,
    ADSearchEntityTool,
    ADSearchEntityContent,
} ADSearchEntity;

@interface ADSearchNetwork : NSObject

+ (void)getSearchListWithEntity:(ADSearchEntity)entity keyword:(NSString *)keyword startPos:(NSString *)startPos length:(NSString *)length firstId:(NSString *)firstId success:(void (^) (id resObject))successBlock failure:(void (^) (NSError *error))failureBlock;


@end
