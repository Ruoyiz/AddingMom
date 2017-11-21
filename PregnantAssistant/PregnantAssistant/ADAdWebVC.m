//
//  ADAdWebVC.m
//  PregnantAssistant
//
//  Created by yitu on 15/3/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADAdWebVC.h"
#import "ADAdStatHelper.h"
#import "SDWebImageManager.h"
#import "ADShareHelper.h"

#define ITEM_EDGE 8
@interface ADAdWebVC ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *contentWebview;
@property(nonatomic,strong)UIButton *closeButton;
//@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)NSString *currentUrlString;
@end

@implementation ADAdWebVC{
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    
    //判断是否统计过广告
    BOOL _adActioned;
    
    UIImage *_remoteShareImage;
    
    NSString *_shareTitle;
    
    NSURLRequest *_request;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
    if (self.disMissNavBlock) {
        self.disMissNavBlock();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationView];
    //webview
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _contentWebview.opaque = NO;
    _contentWebview.backgroundColor = [UIColor clearColor];
    _contentWebview.scrollView.showsVerticalScrollIndicator = NO;
    _contentWebview.scalesPageToFit = YES;
    [self.view addSubview:_contentWebview];
    
    [self loadProgressView];
    
    if (self.webTitle) {
        self.myTitle = self.webTitle;
    }
    [self loadRequest];
    
    [MobClick event:adco_content_normal_view];
}

-(void)loadRequest
{
    if (_action.length > 0) {
        _adUrl = [_action getParamFromUrlWithParam:@"url"];
    }
    
    NSString *dataGBK = [_adUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:dataGBK];
    _currentUrlString = [NSString stringWithFormat:@"%@",url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];//[ADHelper getCookieRequestWithUrl:url];
    _request = request;
    [_contentWebview loadRequest:request];
}

- (void)configNavigationView
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backTopVC:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 24, 24)];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"webClose"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeWebView:) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setFrame:CGRectMake(0, 0, 15, 15)];
    
    UIBarButtonItem *firstItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *secondItem = [[UIBarButtonItem alloc] initWithCustomView:_closeButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, firstItem, secondItem];
    _closeButton.hidden = YES;
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setImage:[UIImage imageNamed:@"举报"] forState:UIControlStateNormal];
    //    [closeButton setImage:[UIImage imageNamed:@"工具后退1"] forState:UIControlStateHighlighted];
    [moreButton addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    [moreButton setFrame:CGRectMake(0, 0, 24, 45)];
//    [moreButton setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 10, 0)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];

//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
//    _titleLabel.backgroundColor = [UIColor clearColor];
//    _titleLabel.font = [UIFont systemFontOfSize:28/2];
//    _titleLabel.textAlignment = NSTextAlignmentCenter;
////    _titleLabel.textColor = [UIColor buttonSelectedGreenColor];//[UIColor colorWithWhite:1.0 alpha:0.5];
//    self.navigationItem.titleView = _titleLabel;
    
}
- (void)backTopVC:(id)sender
{
    if ([_contentWebview canGoBack]) {
        [_contentWebview goBack];
        _closeButton.hidden = NO;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)closeWebView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)moreClick:(id)sender
{
    //弹出action sheet
    ADWebActionSheetView *actionSheet = [[ADWebActionSheetView alloc] init];
    actionSheet.delegate = self;
    [actionSheet show];
}
#pragma mark - ActionSheetDelegate
- (void)clickItemAtIndex:(NSInteger)index
{
    switch (index) {
        case 1://复制链接
        {
            NSLog(@"分享微博");
            [self shareContentAtIndex:1];
        }
            break;
        case 2:
        {
            NSLog(@"分享好友");
            [self shareContentAtIndex:2];
            
        }
            break;
        case 3://用Safari打开
        {
            NSLog(@"分享朋友圈");
            [self shareContentAtIndex:3];
        }
            break;
            
        case 10://复制链接
        {
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = self.currentUrlString;
            
        }
            break;
        case 12://刷新页面
        {
            if ([_contentWebview isLoading]) {
                [_contentWebview stopLoading];
            }
            [_contentWebview loadRequest:_request];
            
        }
            break;
        case 11://用Safari打开
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _currentUrlString]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -share method
- (void)shareContentAtIndex:(NSInteger)index
{
    if (_shareTitle == nil || [_shareTitle isEqual:[NSNull null]]) {
        [ADToastHelp showSVProgressToastWithError:@"网页信息获取不完整，请稍候再试"];
        return;
    }
    NSString *des = @"";
    NSString *title = _shareTitle;//_titleLabel.text;
    __block UIImage *shareImage;// = [UIImage imageNamed:@"AppIcon60x60"];
    if (_remoteShareImage) {
        shareImage = _remoteShareImage;
        NSDictionary *param = @{@"tag" : @(index), @"title" :title, @"des" :des, @"shareImage" : shareImage};
        [self performSelector:@selector(sendShareInfoWithParam:) onThread:[NSThread mainThread] withObject:param waitUntilDone:NO];
    }else{
        NSDictionary *param = @{@"tag" : @(index), @"title" :title, @"des" :des};
        [self performSelector:@selector(sendShareInfoWithParam:) onThread:[NSThread mainThread] withObject:param waitUntilDone:NO];
    }
}

- (void)sendShareInfoWithParam:(NSDictionary *)param
{
    [MobClick event:adco_content_video_share];
    
    NSInteger tag = [[param objectForKey:@"tag"] integerValue];
    NSString *title = [param objectForKey:@"title"];
    NSString *des = [param objectForKey:@"des"];
    UIImage *shareImage = [param objectForKey:@"shareImage"];
    if (tag == 1) {
        //微博
        if(_shareTitle.length > 100){
            des = [_shareTitle substringToIndex:99];
        }else{
            des = _shareTitle;
        }
        
        des = [NSString stringWithFormat:@"%@ %@", des,_adUrl];
        NSLog(@"fen xiang wei bo %@",des);
        [[ADShareHelper shareInstance] sendWeiboShareWithDes:des andImg:shareImage];
//        if (des.length < 140) {
//        }else{
//            NSLog(@"..... %@",des);
//            [[ADShareHelper shareInstance] senWeiBoShareWithTitle:_shareTitle urlString:_adUrl image:shareImage];
//        }
    } else if (tag == 2) {
        
        //微信
        [[ADShareHelper shareInstance] sendLinkToWeixinWithShare_Link:_adUrl
                                                                title:title
                                                          description:des
                                                            shareType:weixin_share_tpye
                                                                image:shareImage
                                                                isImg:NO];
    } else if (tag == 3) {
        //朋友圈
        [[ADShareHelper shareInstance] sendLinkToWeixinWithShare_Link:_adUrl
                                                                title:title
                                                          description:des
                                                            shareType:friend_share_type
                                                                image:shareImage
                                                                isImg:NO];
    }
}

#pragma mark - webview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (request.URL != nil && ![request.URL isEqual:[NSNull null]] && navigationType == UIWebViewNavigationTypeLinkClicked) {
        _request = request;
        NSLog(@"start %@",request.URL);
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (![theTitle isEqualToString:_shareTitle]) {
        _shareTitle = theTitle;
    }
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (![theTitle isEqualToString:_shareTitle]) {
        _shareTitle = theTitle;
        if (!self.webTitle) {
            UILabel *label;
            if ([self.navigationItem.titleView isKindOfClass:[UILabel class]]) {
                [self addTitle:theTitle];
            }else{
                label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 140, 42)];
                [label setFont:[UIFont ADTraditionalFontWithSize:15]];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setTextColor:UIColorFromRGB(0x333333)];
                [label setTextAlignment:NSTextAlignmentCenter];
                self.navigationItem.titleView = label;
                [self performSelector:@selector(addTitle:) withObject:theTitle afterDelay:0.3];
            }
        }
    }
    
    //获取网页图片
    [self getShareImageAtindex:0];
    
//    if (_isAd && !_adActioned && _cId) {
//        _adActioned = YES;
//        [[ADAdStatHelper shareInstance] sendAdReadWithCid:_cId andPositionIndex:_positionInx andAdId:_adId];
//    }
}

//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    [_contentWebview loadHTMLString:@" " baseURL:nil];
//    
//    _failLoadingView = [[ADFailLodingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tapBlock:^{
//        [webView loadRequest:_request];
//        [_failLoadingView removeFromSuperview];
//        _failLoadingView = nil;
//    }];
//    [self.view addSubview:_failLoadingView];
//}

- (void)addTitle:(NSString *)title
{
    UILabel *label = (UILabel *)self.navigationItem.titleView;
    label.text = title;
}

//获取webView中的图片
- (void)getShareImageAtindex:(int)index
{
    NSString * str = [NSString stringWithFormat:@"document.getElementsByTagName(\"img\")[%d].src",index];//@"";
    NSString *imageUrl = [_contentWebview stringByEvaluatingJavaScriptFromString:str];
    
    //NSLog(@"下载图片 %d, url  %@",index,imageUrl);
    
    if ([imageUrl rangeOfString:@"://"].location != NSNotFound) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             //处理下载进度
         } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
             if (error) {
                 NSLog(@"error is %@",error.localizedDescription);
             }
             if (image) {
                 //图片下载完成  在这里进行相关操作，如加到数组里 或者显示在imageView上
                 if (image.size.width > 100 && image.size.height > 100 && !_remoteShareImage) {
                     _remoteShareImage = image;
                     //NSLog(@"图片下载完成 %@",imageUrl);
                     return ;
                 }
             }
             
             if (!_remoteShareImage && index < 10) {
                 [self getShareImageAtindex:index + 1];
             }
             
         }];
    }else{
        if (!_remoteShareImage && index < 10) {
            [self getShareImageAtindex:index + 1];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadProgressView
{
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _contentWebview.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 1.5f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [_contentWebview stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)loadFailedView
{
    if (!_failLoadingView) {
        _failLoadingView = [[ADFailLodingView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) tapBlock:^{
            [self loadRequest];
            _failLoadingView = nil;
        }];
    }
    
    [_failLoadingView showInView:self.view];
}

//- (void)loadBlankPage {
////    if (!errorRequest) {
////        
////    }
//    NSURL *errorUrl = [NSURL URLWithString:@""];
//    NSURLRequest *errorRequest = [NSURLRequest requestWithURL:errorUrl];
//    [self.contentWebview loadRequest:errorRequest];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
