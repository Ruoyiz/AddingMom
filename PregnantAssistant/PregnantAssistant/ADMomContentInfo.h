//
//  ADMomContentInfo.h
//  PregnantAssistant
//
//  Created by D on 15/3/2.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    contentVideoType = 1,
    contentImageType = 2,
    contentNotifyType = 3,
    contentAdType = 4,
    contentPregType = 5,
    contentToolType = 6
} momLookContentType;

typedef enum {
    contentOnlyTextStyle = 1,
    contentManyImageStyle = 2,
    contentRightImageStyle = 3,
    contentBigImgStyle = 4
} momLookContentStyle;

@interface ADMomContentInfo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSArray *imgUrls;
@property (nonatomic, copy) NSString *aPublishTime;
@property (nonatomic, copy) NSString *aDescription;
//@property (nonatomic, copy) NSString *content; //详情内容str
@property (nonatomic, copy) NSString *mediaSource; //内容来源
@property (nonatomic, copy) NSString *mediaId;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *nUrl;
@property (nonatomic, copy) NSString *wUrl;
@property (nonatomic, copy) NSString *saveDateStr;
@property (nonatomic,strong) NSString *wTitle;

@property (nonatomic, copy) NSString *addingUserLogoUrl;
@property (nonatomic, copy) NSString *timeCost;

@property (nonatomic, assign) momLookContentType aContentType;
@property (nonatomic, assign) momLookContentStyle aContentStyle;

//@property (nonatomic, copy) NSString *pregNoticeWeek;
//@property (nonatomic, copy) NSString *pregNoticeDay;
//@property (nonatomic, copy) NSString *pregLastDay;
//@property (nonatomic, copy) NSString *pregNoticeLength;
//@property (nonatomic, copy) NSString *pregNoticeWeight;

//@property (nonatomic, retain) UIImage *contentImg;

@property (nonatomic, copy) NSString *collectId;
@property (nonatomic, copy) NSString *contentId;

//标签label
@property (nonatomic,strong) NSString *tagLabelStr;

//看看
- (id)initWithModelObject:(id)object;

- (instancetype)initWithTitle:(NSString *)title
                   andImgUrls:(NSArray *)aImgUrl
               andContentType:(NSString *)aContentType
              andContentStyle:(NSString *)aContentStyle
               andPublishTime:(NSString *)aPublishTime
               andMediaSource:(NSString *)aMediaSource
               andDescription:(NSString *)aDes
                    andAction:(NSString *)aAction
                  andSaveDate:(NSDate *)saveDate
                     tagLabel:(NSString *)tagLabel;

@end