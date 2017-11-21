//
//  ADHowToCntViewController.m
//  PregnantAssistant
//
//  Created by D on 14-10-10.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADHowToCntViewController.h"

@interface ADHowToCntViewController ()

@end

@implementation ADHowToCntViewController

-(void)dealloc
{
    _webView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myTitle = @"胎动小知识";
    
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    _isFristPage = YES;
    [self.view addSubview:self.webView];
    [self loadLocalHtmlFile];
}

- (UIWebView *)webView
{
    if (_webView == nil) {
        CGRect webRect = [[UIScreen mainScreen] bounds];
//        webRect.size.height -= [ADHelper getNavigationBarHeight];
        
        _webView = [[UIWebView alloc] initWithFrame:webRect];
        _webView.backgroundColor = [UIColor bg_lightYellow];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.delegate = self;
    }
    return _webView;
}

- (void)loadLocalHtmlFile
{
    NSURL *localUrl =
    [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index"
                                                           ofType:@"html"
                                                      inDirectory:@"Html"]];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:localUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)back
{
    if (_isFristPage) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self loadLocalHtmlFile];
    }
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
    
    NSLog(@"currentUrl:%@ currentName:%@", request.URL.relativePath, currentName);
    
    if ([currentName isEqualToString:@"index.html"]) {
        _isFristPage = YES;
    } else {
        _isFristPage = NO;
    }
    
    return YES;
}

@end
