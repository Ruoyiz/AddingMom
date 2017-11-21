//
//  MomStory.h
//  CustomCellDemo
//
//  Created by D on 14/12/1.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MomStory : NSObject

@property (nonatomic, copy) NSData *imgData;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *placeStr;
@property (nonatomic, copy) NSString *dueStr;
@property (nonatomic, copy) NSString *commentStr;
@property (nonatomic, copy) NSString *likeNumStr;

- (instancetype)initWithImgData:(NSData *)aData
                     contentStr:(NSString *)aContent
                       placeStr:(NSString *)aPlace
                         dueStr:(NSString *)aDue
                     commentStr:(NSString *)aCommentStr
                        likeStr:(NSString *)aLikeNumStr;

@end
