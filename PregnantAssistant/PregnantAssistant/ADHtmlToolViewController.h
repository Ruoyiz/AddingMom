//
//  ADHtmlToolViewController.h
//  PregnantAssistant
//
//  Created by D on 14-9-17.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADTool.h"

@interface ADHtmlToolViewController : ADBaseViewController <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic, copy) NSDictionary *nameDic;
@property (nonatomic, copy) NSString *vcName;

@property (nonatomic, assign) BOOL isFav;

@property (assign, nonatomic) BOOL isFristPage;

@property (nonatomic, copy) void(^disMissNavBlock)(void);


@end
