//
//  ADMomLookContentDetailVC.h
//  PregnantAssistant
//
//  Created by yitu on 15/3/4.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADLoadingView.h"
#import "ADFailLodingView.h"
#import "ADActionSheetView.h"

@interface ADMomLookContentDetailVC : ADBaseViewController 

@property(nonatomic,strong)ADMomContentInfo *contentModel;
@property(nonatomic,copy) NSString *contentId;
@property(nonatomic,copy) NSString *aChannelId;
@property(nonatomic,copy) NSString *aIndex;
@property(nonatomic,copy) NSString *aAdId;

@property(nonatomic,copy) NSString *shareUrl;
@property(nonatomic,retain) ADLoadingView *customLoadingView;
@property(nonatomic,retain) ADFailLodingView *failLoadingView;

@property(nonatomic,copy) NSString *collectId;

@property (nonatomic, copy) void(^disMissNavBlock)(void);


//微信登录回来继续做未完成的动作
//- (void)contuneComment;

@end
