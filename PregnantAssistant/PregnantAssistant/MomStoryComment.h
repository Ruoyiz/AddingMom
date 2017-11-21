//
//  MomStoryComment.h
//  PregnantAssistant
//
//  Created by D on 14/12/5.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MomStoryComment : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *time;

- (instancetype)initWithUserName:(NSString *)aUserName
                     withComment:(NSString *)aComment
                        withTime:(NSString *)aTime;

@end
