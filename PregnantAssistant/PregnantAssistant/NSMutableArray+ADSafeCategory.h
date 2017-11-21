//
//  NSMutableArray+ADSafeCategory.h
//  BounceArray
//
//  Created by D on 15/3/30.
//  Copyright (c) 2015年 D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (ADSafeCategory)

- (id)TKSafe_objectAtIndex:(NSUInteger)index;

@end
