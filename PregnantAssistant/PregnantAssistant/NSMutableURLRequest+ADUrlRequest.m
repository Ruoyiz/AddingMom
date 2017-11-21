//
//  NSMutableURLRequest+ADUrlRequest.m
//  PregnantAssistant
//
//  Created by D on 15/4/8.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "NSMutableURLRequest+ADUrlRequest.h"
#import "JRSwizzle.h"

@implementation NSMutableURLRequest (ADUrlRequest)

- (void)newSetValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    if ([field isEqualToString:@"User-Agent"]) {
        value = [NSString stringWithFormat:@"PregnantAssistant/%@ iOS/%@", [ADHelper getVersion],[ADHelper getIOSVersion]];
    }
    [self newSetValue:value forHTTPHeaderField:field];
}

+ (void)setupUserAgentOverwrite
{
    [[self class] jr_swizzleMethod:@selector(setValue:forHTTPHeaderField:)
                        withMethod:@selector(newSetValue:forHTTPHeaderField:)
                             error:nil];
}

@end
