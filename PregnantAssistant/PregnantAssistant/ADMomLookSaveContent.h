//
//  ADMomLookSaveContent.h
//  PregnantAssistant
//
//  Created by D on 15/3/6.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Realm/Realm.h>
#import "ADStringObject.h"
#import "ADMomContentInfo.h"

@interface ADMomLookImage : RLMObject

@property NSString *imageUrl;

- (instancetype)initWithUrl:(NSString *)aUrl;

@end

RLM_ARRAY_TYPE(ADMomLookImage)

@interface ADMomLookSaveContent : RLMObject

@property RLMArray <ADMomLookImage> *images;
@property NSString *title;
@property NSString *aPublishTime;
@property NSString *aDescription;
//@property NSString *content; //详情内容str
@property NSString *mediaSource; //内容来源
@property NSString *action;
@property NSString *nUrl;
@property NSString *wUrl; //分享 url

@property NSDate *saveDate;

@property NSString *addingUserLogoUrl;
@property NSString *timeCost;

@property NSString *uid;
@property NSInteger collectId;

@property (nonatomic, assign) momLookContentType aContentType;
@property (nonatomic, assign) momLookContentStyle aContentStyle;

-(instancetype)initWithInfo:(ADMomContentInfo *)aInfo;

@end

RLM_ARRAY_TYPE(ADMomLookSaveContent)