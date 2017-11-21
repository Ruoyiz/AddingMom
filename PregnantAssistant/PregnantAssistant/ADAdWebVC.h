//
//  ADAdWebVC.h
//  PregnantAssistant
//
//  Created by yitu on 15/3/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "ADFailLodingView.h"
#import "ADWebActionSheetView.h"

@interface ADAdWebVC : ADBaseViewController<NJKWebViewProgressDelegate,ADWebActionSheetDelegate>{
    ADFailLodingView *_failLoadingView;
}

//@property (nonatomic,strong) NSURL *url;
@property(nonatomic,strong)NSString *webTitle;
@property(nonatomic,assign)UIImage *shareImage;
@property(nonatomic,assign)BOOL isAd;
@property(nonatomic,strong)NSString *adUrl;
@property(nonatomic, copy)NSString *action;

@property(nonatomic,strong)NSString *adId;
@property(nonatomic,strong)NSString *cId;
@property(nonatomic,strong)NSString *positionInx;

@property (nonatomic, copy) void(^disMissNavBlock)(void);


@end
