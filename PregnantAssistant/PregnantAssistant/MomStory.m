//
//  MomStory.m
//  CustomCellDemo
//
//  Created by D on 14/12/1.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import "MomStory.h"

@implementation MomStory

-(instancetype)initWithImgData:(NSData *)aData
                    contentStr:(NSString *)aContent
                      placeStr:(NSString *)aPlace
                        dueStr:(NSString *)aDue
                    commentStr:(NSString *)aCommentStr
                       likeStr:(NSString *)aLikeNumStr
{
    if (self = [super init]) {
        _imgData = aData;
        _contentStr = aContent;
        _placeStr = aPlace;
        _dueStr = aDue;
        _commentStr = aCommentStr;
        _likeNumStr = aLikeNumStr;
    }
    
    return self;
}

@end
