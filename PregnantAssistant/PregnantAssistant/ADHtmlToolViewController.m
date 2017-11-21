//
//  ADHtmlToolViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-17.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADHtmlToolViewController.h"
//#import "ADNoticeView.h"
#import "ADToastCollectView.h"
#import "ADCollectToolDAO.h"

@interface ADHtmlToolViewController ()

@end

@implementation ADHtmlToolViewController

-(void)dealloc
{
    _webView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameDic = @{
                     @"胎儿发育评测":@"evaluation",
                     @"预产期计算器":@"expect",
                     @"胎儿体重计算":@"foetusweight",
                     @"生男生女表":@"foretab",
                     @"孕期体重标准":@"gestweight",
                     @"HCG参考值":@"hcg",
                     @"孕酮参考值":@"prog",
                     @"唐筛查看男女":@"sods",
                     @"B超单解读":@"typeblist"
                     };
    
    self.myTitle = [NSString stringWithFormat:@"%@", _vcName];
    [self addMyWebView];
    [self loadLocalHtmlFile];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [MobClick beginLogPageView:_vcName];
    [MobClick event:_vcName];
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    _isFav = [ADCollectToolDAO hasCollectAToolWithTitle:_vcName];
    
    //默认收藏
    if (_isFav) {
        [self setRightItemWithImgFav];
    } else {
        [self setRightItemWithImgCollect];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

//    _isFav = NO;
//    NSLog(@"title: %@ vcName: %@", self.aTool.title, _vcName);
    //已收藏
    NSLog(@"isFav: %d", _isFav);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:_vcName];
    
    if (self.disMissNavBlock) {
        self.disMissNavBlock();
    }
}

- (void)addMyWebView
{
    CGRect webRect = [[UIScreen mainScreen] bounds];
//    webRect.size.height -= [ADHelper getNavigationBarHeight];
    
    _webView = [[UIWebView alloc] initWithFrame:webRect];
    _webView.backgroundColor = [UIColor bg_lightYellow];
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.delegate = self;

    [self.view addSubview:_webView];
}

- (void)rightItemMethod:(UIButton *)sender
{
//    NSLog(@"collect:%@", self.aTool.title);
    ADToastCollectView *aToastView = [[ADToastCollectView alloc]initWithFrame:CGRectMake(0, 64, 0, 0)
                                                                     andTitle:_vcName
                                                                 andParenView:self.view];

    if (_isFav == YES) {
        //取消收藏
        [ADCollectToolDAO unCollectAToolWithTitle:_vcName onFinish:^(NSError *err) {
            if (err.code == ERRCODE_LESS_TOOL) {
                [ADHelper showToastWithText:atLeastIconNumTip];
            } else {
                _isFav = NO;
                [self setRightItemWithImgCollect];
                [aToastView showUnCollectToast];
            }
        }];
    } else {
        _isFav = YES;
        [self setRightItemWithImgFav];
        
        [ADCollectToolDAO collectAToolWithTitle:_vcName recordTime:YES];
        
        [aToastView showCollectToast];
    }
}

- (void)loadLocalHtmlFile
{
    NSString *htmlName = self.nameDic[self.vcName];
    NSLog(@"htmlName:%@", htmlName);
    //取得欲读取档案的位置与文件名
        NSURL *url =
        [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:htmlName
                                                               ofType:@"html"
                                                          inDirectory:@"Html"]];
        
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Disable user selection
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{

    NSString *currentURL = request.URL.absoluteString;
    NSString *currentName = [currentURL lastPathComponent];
    
    NSRange titleRange = [currentName rangeOfString:@"."];
    currentName = [currentName substringWithRange:NSMakeRange(0, titleRange.location)];
    
    if ([self.vcName isEqualToString:@"B超单解读"]) {
        if ([currentName isEqualToString:@"typeblist"]) {
            _isFristPage = YES;
        } else {
            _isFristPage = NO;
        }
        NSLog(@"url:%@", currentName);
    }
    
    return YES;
}

- (void)back
{
    if ([self.vcName isEqualToString:@"B超单解读"]) {
        if (_isFristPage) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self loadLocalHtmlFile];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
