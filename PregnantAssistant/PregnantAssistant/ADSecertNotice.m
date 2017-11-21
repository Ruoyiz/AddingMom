//
//  ADSecertNotice.m
//  PregnantAssistant
//
//  Created by D on 14/12/8.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADSecertNotice.h"

@implementation ADSecertNotice

- (instancetype)initWithNoticeTitle:(NSString *)aTitle
                      andStoryTitle:(NSString *)aStoryTitle
                        andManTitle:(NSString *)aManTitle
{
    if (self = [super init]) {
        _noticeTitle = aTitle;
        _noticeStoryTitle = aStoryTitle;
        _noticeManTitle = aManTitle;
    }
    return self;
}

@end