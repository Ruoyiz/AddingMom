//
//  UIView+ADClone.m
//  PregnantAssistant
//
//  Created by D on 15/3/27.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "UIView+ADClone.h"

@implementation UIView (ADClone)

- (id) clone {
    NSData *archivedViewData = [NSKeyedArchiver archivedDataWithRootObject: self];
    id clone = [NSKeyedUnarchiver unarchiveObjectWithData:archivedViewData];
    return clone;
}

@end
