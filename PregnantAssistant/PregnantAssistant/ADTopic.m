//
//  ADTopic.m
//  PregnantAssistant
//
//  Created by D on 15/1/7.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADTopic.h"

@implementation ADTopic

- (instancetype)initWithTopicTitle:(NSString *)aTitle
                          btnTitle:(NSString *)aBtnTitle
                            imgUrl:(NSString *)aUrl
                              type:(NSString *)aType
{
    if (self = [super init]) {
        _btnTitle = aBtnTitle;
        _topicTitle = aTitle;
        _imgUrl = aUrl;
        _type = aType;
    }
    return self;
}

@end
