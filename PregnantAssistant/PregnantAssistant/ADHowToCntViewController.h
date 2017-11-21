//
//  ADHowToCntViewController.h
//  PregnantAssistant
//
//  Created by D on 14-10-10.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"

@interface ADHowToCntViewController : ADBaseViewController <
UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (assign, nonatomic) BOOL isFristPage;
@end
