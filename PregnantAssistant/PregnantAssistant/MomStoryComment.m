//
//  MomStoryComment.m
//  PregnantAssistant
//
//  Created by D on 14/12/5.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "MomStoryComment.h"

@implementation MomStoryComment

- (instancetype)initWithUserName:(NSString *)aUserName
                     withComment:(NSString *)aComment
                        withTime:(NSString *)aTime
{
    if (self = [super init]) {
        _userName = aUserName;
        _comment = aComment;
        _time = aTime;
    }
    return self;
}

@end
