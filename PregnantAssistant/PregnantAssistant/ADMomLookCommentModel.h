//
//  ADMomLookCommentModel.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/7.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum : NSUInteger {
//    ADMomLookModelStyleHot = 0,
//    ADMomLookModelStyleHotMore,
//    ADMomLookModelStyleAll,
//    ADMomLookModelStyleAllMore,
//} ADMomLookModelStyle;

@interface ADMomLookCommentModel : NSObject

//@property (nonatomic,assign) ADMomLookModelStyle modelStyle;

@property (nonatomic,strong) NSString *commentId;

@property (nonatomic,strong) NSString *face;

@property (nonatomic,strong) NSString *commentBody;

@property (nonatomic,strong) NSString *contentId;

@property (nonatomic,assign) BOOL isComment;

@property (nonatomic,assign) BOOL isPraise;

@property (nonatomic,strong) NSString *replyName;

@property (nonatomic,strong) NSString *commentName;

@property (nonatomic,strong) NSString *praiseCount;

@property (nonatomic,strong) NSMutableArray *subCommentArray;

@property (nonatomic,strong) NSString *replyCount;

@property (nonatomic,strong) NSString *replyCommentId;

@property (nonatomic,strong) NSString *replyContentId;

@property (nonatomic,assign) BOOL isSelf;

@property (nonatomic,strong) NSString *status;

@property (nonatomic,strong) NSString *uid;

@property (nonatomic,strong) NSString *createTime;

@property (nonatomic,strong) NSString *updateTime;

//将网络数据转化为model
+ (NSMutableArray *)conversionResponseObjectToModelArray:(id)responseObject;

@end
