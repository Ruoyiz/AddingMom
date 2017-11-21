//
//  NSArray+ADSafeCategory.m
//  PregnantAssistant
//
//  Created by D on 15/3/26.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "NSArray+ADSafeCategory.h"

@implementation NSArray (ADSafeCategory)

- (id)TKSafe_objectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self TKSafe_objectAtIndex:index];
    } else {
//#ifdef DEBUG
//        NSAssert(NO, @"index %d > count %d", index, self.count);
//#endif
        return nil;
    }
}

@end
