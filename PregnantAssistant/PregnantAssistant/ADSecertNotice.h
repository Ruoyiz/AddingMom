//
//  ADSecertNotice.h
//  PregnantAssistant
//
//  Created by D on 14/12/8.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADSecertNotice : NSObject

@property (nonatomic, copy)NSString *noticeTitle;
@property (nonatomic, copy)NSString *noticeStoryTitle;
@property (nonatomic, copy)NSString *noticeManTitle;

- (instancetype)initWithNoticeTitle:(NSString *)aTitle
                     andStoryTitle:(NSString *)aStoryTitle
                       andManTitle:(NSString *)aManTitle;

@end
