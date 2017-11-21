//
//  NSMutableArray+ADSafeCategory.m
//  BounceArray
//
//  Created by D on 15/3/30.
//  Copyright (c) 2015年 D. All rights reserved.
//

#import "NSMutableArray+ADSafeCategory.h"

@implementation NSMutableArray (ADSafeCategory)

- (id)TKSafe_objectAtIndex:(NSUInteger)index
{
    @autoreleasepool {
        if (index < self.count) {
            return [self TKSafe_objectAtIndex:index];
        } else {
            return nil;
        }
    }
}

@end
