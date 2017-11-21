//
//  ADTopic.h
//  PregnantAssistant
//
//  Created by D on 15/1/7.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADTopic : NSObject

@property (nonatomic, copy) NSString *topicTitle;
@property (nonatomic, copy) NSString *btnTitle;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *type;

- (instancetype)initWithTopicTitle:(NSString *)aTitle
                          btnTitle:(NSString *)aBtnTitle
                            imgUrl:(NSString *)aUrl
                              type:(NSString *)aType;

@end
