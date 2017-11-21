//
//  ADMomLookContentDetailVC.m
//  PregnantAssistant
//
//  Created by yitu on 15/3/4.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADMomLookContentDetailVC.h"
#import "ADMomLookNetworkHelper.h"
#import "ADShareView.h"
#import "ADShareHelper.h"
#import "ADMomLookDAO.h"
#import "ADAdStatHelper.h"
#import "ADAdWebVC.h"
#import "ADLookCommentNetwork.h"
#import "ADUserInfoSaveHelper.h"
#import "PregnantAssistant-Swift.h"
#import "ADLookCommentViewController.h"
#import "ADFeedDetailsViewController.h"
#import "ADLoginControl.h"
#import "ADNavigationController.h"
#import "ADGetTextSize.h"
#import "ADFeedNetworkHelper.h"
#import "ADTool.h"
#import "ADHtmlToolViewController.h"
#import "ADToolRootViewController.h"
#import "ADPregNotifyViewController.h"

#define ITEM_EDGE 8
#define leftMargin 24/2
#define yMargin 24/2
#define kMargin 24/2
#define NavItemTag 3000
#define MAXLENGTH 600
#define BARHEIGHT 48
#define TEXTLANGTH 300

@interface ADMomLookContentDetailVC ()<UIWebViewDelegate>
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *sourceLabel;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UIWebView *contentWebview;


@property (nonatomic, strong) ADShareView *aShareView;
@property (nonatomic, strong) UIView *bgView;
//@property (nonatomic, assign) BOOL isCollected;
@end

@implementation ADMomLookContentDetailVC{
    
    //判断是否完成数据配置，完成才可以评论收藏等。。。
    BOOL _finishLoad;
 
    UIView *_customNavBar;
    
    NSString *_newContentId;
    
    NSString *_commentName;
    NSString *_setRss;
    NSInteger _continueToDo;
    NSString *_mediaId;
    BOOL _canFav;
    NSDate *_beginDate;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ADToastHelp dismissSVProgress];
    if (self.disMissNavBlock) {
        self.disMissNavBlock();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configNavigaionView];
    [MobClick event:adco_content_normal_view];
    
    //webview
    self.contentWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 50-20)];
    _contentWebview.scrollView.showsVerticalScrollIndicator = YES;
    _contentWebview.delegate = self;
    _contentWebview.opaque = NO;
    _contentWebview.scrollView.showsHorizontalScrollIndicator = NO;
    _contentWebview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentWebview];
    
    [self.view bringSubviewToFront:_customNavBar];
    [self startRequest];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveCountFromNoti:) name:ChangeCommentCountNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveRssFormNoti:) name:updateFeedListNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addingLoginSuccess) name:loginWeiSucessNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddingLoginCancel) name:cancelLogin object:nil];
}

- (void)addingLoginSuccess
{
    if(_continueToDo == 1){
        [self refreshData];
    }
    _continueToDo = 0;
}

- (void)AddingLoginCancel
{
    if (_continueToDo == 1) {
        if ([_setRss isEqualToString:@"1"]) {
            NSString *jsRss = [NSString stringWithFormat:@"setRss(%@)",@"0"];
            [_contentWebview stringByEvaluatingJavaScriptFromString:jsRss];
        }else{
            NSString *jsRss = [NSString stringWithFormat:@"setRss(%@)",@"1"];
            [_contentWebview stringByEvaluatingJavaScriptFromString:jsRss];
        }
    }
    _continueToDo = 0;
}

#pragma mark - 获取网络数据
- (void)startRequest
{
    //进行网络请求
    _newContentId = [[_contentModel.action componentsSeparatedByString:@"="] objectAtIndex:1];

    if (_newContentId.length == 0) {
        _newContentId = _contentId;
    }
    
    [self p_startLoadingAnimation];
    [self.view bringSubviewToFront:_customNavBar];

    _finishLoad = NO;
    [ADLookCommentNetwork getLookContentWithContentId:_newContentId success:^(id responseObject) {
        NSString *errorStr = [responseObject objectForKey:@"error"];
        if ([errorStr isKindOfClass:[NSString class]]) {
            [self performSelector:@selector(failedLoad) withObject:nil afterDelay:0.8];
            return ;
        }
        NSString *rss = [responseObject objectForKey:@"isRss"];
        if ([rss isEqual:[NSNull null]] || rss == nil) {
            _setRss = @"0";
        }else{
            _setRss = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"isRss"]];
        }
        _contentModel = [[ADMomContentInfo alloc] initWithModelObject:responseObject];
        [self loadWebContentWithUrl:_contentModel.nUrl];
        [self updateUserInterfaceWithModel:_contentModel];

    } failure:^(NSError *error) {
        [self analysisNetworkError:error];
    }];
}

- (void)refreshData{
    [self.view bringSubviewToFront:_customNavBar];
    
    [ADLookCommentNetwork getLookContentWithContentId:_newContentId success:^(id responseObject) {
        NSString *rss = [responseObject objectForKey:@"isRss"];
        if ([rss isEqual:[NSNull null]] || rss == nil) {
            _setRss = @"0";
        }else{
            _setRss = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"isRss"]];
        }
        
        if ([_setRss isEqualToString:@"0"]) {
            [self setRssWithRss:@"1"];
        }else{
            NSString *jsRss = [NSString stringWithFormat:@"setRss(%@)",@"1"];
            [_contentWebview stringByEvaluatingJavaScriptFromString:jsRss];
        }
        _contentModel = [[ADMomContentInfo alloc] initWithModelObject:responseObject];
        [self updateUserInterfaceWithModel:_contentModel];
        
    } failure:^ (NSError *error){
        [self setRssWithRss:@"1"];
    }];
}

- (void)analysisNetworkError:(NSError *)error
{
    if (error.code == -1011) {
        NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *url = [dic objectForKey:@"nurl"];
            if (url != nil && ![url isEqual:[NSNull null]]) {
                _contentModel = [[ADMomContentInfo alloc] initWithModelObject:dic];
                [self loadWebContentWithUrl:url];
                _canFav = YES;
                [self updateUserInterfaceWithModel:_contentModel];
                _finishLoad = NO;
            }else{
                [self performSelector:@selector(failedLoad) withObject:nil afterDelay:0.8];
            }
        }
    }else{
        [self performSelector:@selector(failedLoad) withObject:nil afterDelay:0.8];
    }
}

- (void)configNavigaionView
{
    _customNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    _customNavBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_customNavBar];
    
    UIView *sharpLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    sharpLineView.backgroundColor = [UIColor separator_line_color];
    [_customNavBar addSubview:sharpLineView];
    
    NSArray *imageArray = [NSArray arrayWithObjects:@"bottomBack", @"ArticleCollect" ,@"ArticleShare", @"comment", nil];
    CGFloat space = 5;
    CGFloat width = (SCREEN_WIDTH - space * 5) / 4.0;
    CGFloat posX = space;
    CGFloat buttonWidth = width;
    int i = 0;
    for (NSString *imageName in imageArray) {
        
        UIButton *contentButton = [[UIButton alloc] initWithFrame:CGRectMake(posX, 0, buttonWidth, 50)];
        [contentButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        contentButton.titleLabel.font = [UIFont systemFontOfSize:16];
        contentButton.tag = NavItemTag + i;
        [contentButton addTarget:self action:@selector(navItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_customNavBar addSubview:contentButton];

        //显示评论数
        if (i == imageArray.count - 1) {
//            [contentButton setTitle:str forState:UIControlStateNormal];
            [contentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            if (_contentModel != nil) {
                if ([_contentModel.commentCount isEqual:[NSNull null]] || _contentModel.commentCount == nil || [_contentModel.commentCount integerValue] == 0) {
                }else{
                    NSString *commentCount = [NSString stringWithFormat:@"%@",_contentModel.commentCount];
                    [self setCommentCountWithCount:commentCount];
                }
            }
        }
        
        //判断是否收藏过
        if (i==1) {
            [contentButton setImage:[UIImage imageNamed:@"ArticleCollected"] forState:UIControlStateSelected];
            [contentButton setImage:[UIImage imageNamed:@"ArticleCollect"] forState:UIControlStateNormal];
            
            [self hasCollectContentWithAction:_contentModel.action];
        }
        
        posX += buttonWidth + space;
        
        i++;
    }
}

#pragma mark - button -event
- (void)navItemClicked:(UIButton *)button
{
    if (!_finishLoad && button.tag > NavItemTag + 1) {
        return;
    }else if (button.tag == NavItemTag + 1){
        
        if (_finishLoad || _canFav) {
        }else{
            return;
        }
    }
    if (button.tag == NavItemTag) {
        
        //go back to momLook
        [self.navigationController popViewControllerAnimated:YES];
    }else if (button.tag == NavItemTag + 1){
        NSString *addingToken = [[NSUserDefaults standardUserDefaults] addingToken];
        if (addingToken.length == 0) {
            [self jumpToLoginVcWithCompletion:nil];
            return;
        }
        if (button.selected) {
            [[ADAdStatHelper shareInstance] sendContentCancelCollectingWithCid:_aChannelId andPositionIndex:_aIndex andContentId:_newContentId];
        }else{
            [[ADAdStatHelper shareInstance] sendContentCollectWithCid:_aChannelId andPositionIndex:_aIndex andContentId:_newContentId];
        }
        
        [self favAVideo:button];
    }else if (button.tag == NavItemTag + 2){
        
        //分享
        [self shareMethod:button];
    }else if (button.tag == NavItemTag + 3){
        
        //评论
        [self jumpToCommentVCWithContentId:_newContentId];
    }
}

//分享
- (void)shareMethod:(id)sender
{
    [self resignFirstResponder];
    
    [self showBgview];
    
    _aShareView =
    [[ADShareView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180)
                          andParentVC:self
                            showTitle:YES];
    [_bgView addSubview:_aShareView];
    
    UITapGestureRecognizer *disMissTap2 =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissExBgView)];
    
    [_aShareView addGestureRecognizer:disMissTap2];
    [self.appDelegate.window addSubview:_aShareView];
}

- (void)dismissActionSheet
{
    
    [self dismissExBgView];
}

- (void)showBgview
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgView.backgroundColor = [UIColor darkGrayColor];
    _bgView.alpha = 0.1;
    [self.appDelegate.window addSubview:_bgView];
    
    [UIView animateWithDuration:0.2 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _bgView.alpha = 0.4;
                    } completion:^(BOOL finished) {
                     }];

    
    _bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *disMissTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissExBgView)];
    [_bgView addGestureRecognizer:disMissTap];
}

- (void)dismissExBgView
{
    [UIView animateWithDuration:0.3 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _bgView.alpha = 0;
                         _aShareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _aShareView.frame.size.height);
                     } completion:^(BOOL finished) {
                         [_bgView removeFromSuperview];
                         [_aShareView removeFromSuperview];
                         _aShareView = nil;
                     }];
}

#pragma mark -share method
- (void)shareContent:(UIButton *)sender
{
    ADAppDelegate *myApp = APP_DELEGATE;
    myApp.isSharing = YES;
    NSInteger index = sender.tag;
    
    if (index == 1) {
        [[ADAdStatHelper shareInstance] sendContentShareWithCid:_aChannelId andPositionIndex:_aIndex andContentId:_newContentId shareTo:@"weibo"];

    }else if (index == 2){
        
        [[ADAdStatHelper shareInstance] sendContentShareWithCid:_aChannelId andPositionIndex:_aIndex andContentId:_newContentId shareTo:@"weixinMessage"];

    }else if (index == 3){
        [[ADAdStatHelper shareInstance] sendContentShareWithCid:_aChannelId andPositionIndex:_aIndex andContentId:_newContentId shareTo:@"weixinTimeline"];
    }
    
    else{
        sender.tag = index - 10;
    }
    
    [self dismissExBgView];
    
    NSString *des = _contentModel.aDescription;
    NSString *title = _contentModel.wTitle;
    __block UIImage *shareImage = [UIImage imageNamed:@"AppIcon60x60"];

    _shareUrl = [_contentModel.wUrl copy];
    if ([_contentModel.imgUrls count] > 0) {
        //得到图片 并将图片进行裁剪 存入coredata
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:[_contentModel.imgUrls objectAtIndex:0]]
                                                            options:0
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // progression tracking code
         }
                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             if (image && finished)
             {
                 shareImage = image;
             }
             
             //要放在主线程里
             NSDictionary *param = @{@"tag" : @(sender.tag), @"title" :title, @"des" :des, @"shareImage" : shareImage};
            [self performSelector:@selector(sendShareInfoWithParam:) onThread:[NSThread mainThread] withObject:param waitUntilDone:NO];
            
         }];
    }else{
        //要放在主线程里
        NSDictionary *param = @{@"tag": @(sender.tag), @"title": title, @"des": des, @"shareImage" :shareImage};
        [self performSelector:@selector(sendShareInfoWithParam:) onThread:[NSThread mainThread] withObject:param waitUntilDone:NO];
    }
}

- (void)sendShareInfoWithParam:(NSDictionary *)param
{
//    NSLog(@"分享");
    [MobClick event:adco_content_video_share];
    NSInteger tag = [[param objectForKey:@"tag"] integerValue];
    NSString *title = [param objectForKey:@"title"];
    NSString *des = [param objectForKey:@"des"];
    UIImage *shareImage = [param objectForKey:@"shareImage"];
    if (tag == 1) {
        //微博
        if(des.length > 100){
            des = [des substringToIndex:99];
        }
        
        des = [NSString stringWithFormat:@"%@ %@", des, _shareUrl];
        [[ADShareHelper shareInstance] sendWeiboShareWithDes:des andImg:shareImage];

    } else if (tag == 2) {
        
        //微信
        [[ADShareHelper shareInstance] sendLinkToWeixinWithShare_Link:_contentModel.wUrl
                                                                title:title
                                                          description:des
                                                            shareType:weixin_share_tpye
                                                                image:shareImage
                                                                isImg:NO];
    } else if (tag == 3) {
        //朋友圈
        [[ADShareHelper shareInstance] sendLinkToWeixinWithShare_Link:_contentModel.wUrl
                                                                title:title
                                                          description:des
                                                            shareType:friend_share_type
                                                                image:shareImage
                                                                isImg:NO];
    }
}

//收藏
- (void)favAVideo:(UIButton *)sender{
    
    NSLog(@"收藏");
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [MobClick event:adco_content_normal_cancel_collecting];
        
        if (_collectId.length == 0) {
            [ADToastHelp showSVProgressToastWithError:@"取消收藏失败"];
            sender.selected = !sender.selected;
            return;
        }
        
        [MomLookCollectSyncHelper unCollect:_collectId finish:^(NSError * err) {
            if (err) {
                NSLog(@"取消收藏成功");
                [ADToastHelp showSVProgressToastWithError:@"取消收藏失败"];
                sender.selected = !sender.selected;
            } else {
//                [ADMomLookDAO deleteCollectedContent:_contentModel.action];
                [[NSNotificationCenter defaultCenter]postNotificationName:updateColloctListNotification object:nil];
                sender.selected = NO;
            }
        }];
    } else {
        [MobClick event:adco_content_normal_collect];
        [MomLookCollectSyncHelper collect:_contentModel.action finish:^(NSString * collectId, NSError * err) {
            if (err || collectId.length == 0) {
                [ADToastHelp showSVProgressToastWithError:@"收藏失败"];
                sender.selected = !sender.selected;
            } else {
                NSLog(@"收藏成功");
                sender.selected = YES;
                _contentModel.collectId = collectId;
                _collectId = collectId;
                [[NSNotificationCenter defaultCenter]postNotificationName:updateColloctListNotification object:nil];
            }
        }];
    }
}

- (void)jumpToLoginVcWithCompletion:(void (^)(void))aFinishBlock
{
    ADLoginControl *loginVc = [[ADLoginControl alloc] init];
    loginVc.subTitle = @"永久保存你的收藏";
    ADNavigationController *nc = [[ADNavigationController alloc] initWithRootViewController:loginVc];
    [ADHelper presentVc:nc atVc:self hiddenNavi:YES loginControl:loginVc];
}

- (void)loadWebContentWithUrl:(NSString *)url
{
    NSMutableURLRequest *aReq = [ADHelper getCookieRequestWithUrl:[NSURL URLWithString:url]];
    _contentWebview.delegate = self;
    [_contentWebview loadRequest:aReq];
}

//根据获取的model 更新UI
- (void)updateUserInterfaceWithModel:(ADMomContentInfo *)model
{
    [self hasCollectContentWithAction:model.action];
    
    if ([_contentModel.commentCount isEqual:[NSNull null]] || _contentModel.commentCount == nil || [_contentModel.commentCount integerValue] == 0) {
    }else{
        NSString *commentCount = [NSString stringWithFormat:@"%@",_contentModel.commentCount];
        [self setCommentCountWithCount:commentCount];
    }
    
    _finishLoad = YES;
}

- (void)hasCollectContentWithAction:(NSString *)action
{
    UIButton *favBtn = (UIButton *)[_customNavBar viewWithTag:NavItemTag + 1];    
    if (action) {
        if ([AFNetworkReachabilityManager sharedManager].reachable == YES && [[NSUserDefaults standardUserDefaults]addingToken].length > 0) {
            [MomLookCollectSyncHelper isCollect:action finish:^(BOOL isCollect, NSString *collectId) {
                favBtn.selected = isCollect;
                _collectId = collectId;
            }];
        }
    }
}

- (void)setCommentCountWithCount:(NSString *)commentCount
{
    NSString *commetStr = commentCount;
    if (commentCount.integerValue >
        99) {
        commetStr = @"99+";
    }
    
    CGFloat labelHeight = 15;
    CGFloat labelWidth = [ADGetTextSize widthForString:commetStr height:15 andFont:[UIFont boldSystemFontOfSize:10]] + 10;
    UIButton *commentButton = (UIButton *)[_customNavBar viewWithTag:NavItemTag + 3];
    UIButton *label = (UIButton *)[commentButton viewWithTag:1000];
    if(label == nil && commentCount.integerValue != 0){
        if (labelWidth < labelHeight) {
            labelWidth = labelHeight;
        }
        label = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
        label.center = CGPointMake( commentButton.frame.size.width / 2.0 + 10, commentButton.frame.size.height / 2.0 - 10);
        
        label.backgroundColor = [UIColor btn_green_bgColor];
        [label setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        label.layer.cornerRadius = labelHeight / 2.0;
        if (iPhone6Plus) {
            label.contentEdgeInsets = UIEdgeInsetsMake(-0.5, 0, 1, 0.5);
        }
        label.userInteractionEnabled = NO;
        label.layer.masksToBounds = YES;
        label.tag = 1000;
        label.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        [commentButton addSubview:label];
    }else if(commentCount.integerValue == 0){
        [label removeFromSuperview];
    }
    
    
    [label setTitle:commentCount forState:UIControlStateNormal];
    if (_contentWebview) {
      
        NSString *jsCommentCount = [NSString stringWithFormat:@"setCommentCount(%@)",commentCount];
        [_contentWebview stringByEvaluatingJavaScriptFromString:jsCommentCount];
    }
}

- (void)reciveCountFromNoti:(NSNotification *)noti
{
    NSString *notiStr = noti.object;
    [self setCommentCountWithCount:notiStr];
}

- (void)reciveRssFormNoti:(NSNotification *)noti
{
    if (_contentWebview) {
        NSString *str = noti.object;
        if (![str isKindOfClass:[NSString class]]) {
            return;
        }
        
        NSString *jsRss = [NSString stringWithFormat:@"setRss(%@)",[[str componentsSeparatedByString:@" "] lastObject]];
        [_contentWebview stringByEvaluatingJavaScriptFromString:jsRss];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)p_startLoadingAnimation
{
    self.customLoadingView =[[ADLoadingView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50)];
    [self.view addSubview:_customLoadingView];
    
    [_customLoadingView adLodingViewStartAnimating];
}

- (void)p_stopLoadingAnimation
{
        [UIView animateWithDuration:0.2 delay:0.05
             usingSpringWithDamping:1 initialSpringVelocity:5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _customLoadingView.alpha = 0;
                         } completion:^(BOOL finished) {
                             [_customLoadingView removeFromSuperview];
                             _customLoadingView = nil;
                         }];
}

#pragma mark -- webview delegate
- (void)loadReq:(NSURLRequest *)request
{
    [_contentWebview loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [NSString stringWithFormat:@"%@",request.URL];
    if ([urlString rangeOfString:@"dding://adco/contentCollect"].location != NSNotFound) {
        
        NSString *addingToken = [[NSUserDefaults standardUserDefaults] addingToken];
        if (addingToken.length == 0) {
            [self jumpToLoginVcWithCompletion:nil];
            return NO;
        }
        [self favAVideo:nil];
        return NO;
    }else if ([urlString rangeOfString:@"adding://adco/contentShare"].location != NSNotFound){
        [self shareMethod:nil];
        return NO;
    }else if ([urlString rangeOfString:@"adding://adco/contentShare/weixinMessage"].location != NSNotFound){
        UIButton *button = [[UIButton alloc] init];
        button.tag = 2 + 10;
        [self shareContent:button];
        return NO;
    }else if ([urlString rangeOfString:@"dding://adco/contentShare/weixinTimeline"].location != NSNotFound){
        UIButton *button = [[UIButton alloc] init];
        button.tag = 3 + 10;
        [self shareContent:button];
        return NO;
    }else if ([urlString rangeOfString:@"adding://adco/contentShare/weibo"].location != NSNotFound){
        UIButton *button = [[UIButton alloc] init];
        button.tag = 1 + 10;
        [self shareContent:button];
        return NO;
    }else if([urlString rangeOfString:@"adding://adco/mediaOpen?mediaId="].location != NSNotFound){
        
        NSString *mediaId = [[urlString componentsSeparatedByString:@"adding://adco/mediaOpen?mediaId="] lastObject];
        
        ADFeedDetailsViewController *dvc = [[ADFeedDetailsViewController alloc] init];
        dvc.mediaId = mediaId;
        [self.navigationController pushViewController:dvc animated:YES];
        
        return NO;
    }else if ([urlString rangeOfString:@"adding://adco/contentComment?contentId="].location != NSNotFound){
        
        NSString *contentId = [[urlString componentsSeparatedByString:@"adding://adco/contentComment?contentId="] lastObject];
        [self jumpToCommentVCWithContentId:contentId];
        return NO;
    }else if ([urlString rangeOfString:@"adding://adco/mediaRss?mediaId"].location != NSNotFound){
        
        [self setRssWithUrl:urlString];
        return NO;
    }else if([urlString myContainsString:@"adding://adco/content?contentId="]){
        
        [self openArticleWithUrl:urlString];
        return NO;
    }else if ([urlString myContainsString:@"adding://adco/adTool?toolId="]){
        
        [self openToolWithUrlString:urlString];
        return NO;
    }
    
    
    if (navigationType != UIWebViewNavigationTypeLinkClicked) {
        _beginDate = [NSDate date];
//        [MobClick beginEvent:adco_content_normal_load];
        return YES;
    }
    

    ADAdWebVC *webVc = [[ADAdWebVC alloc] init];
    webVc.adUrl = [NSString stringWithFormat:@"%@",request.URL];
    [self.navigationController pushViewController:webVc animated:YES];
    return NO;
}

- (void)openToolWithUrlString:(NSString *)urlString
{
    NSString *toolId = [[urlString componentsSeparatedByString:@"adding://adco/adTool?toolId="] lastObject];
    if([toolId isEqualToString:@"100099"]){
        ADPregNotifyViewController *aNotifyVc = [[ADPregNotifyViewController alloc]init];
        [self.navigationController pushViewController:aNotifyVc animated:YES];
        return;
    }
    ADTool *aTool = [[ADTool alloc] initWithIoolId:toolId];
    if (aTool.isWeb == YES) {
        ADHtmlToolViewController *aHtmlToolVc = [[ADHtmlToolViewController alloc]init];
        aHtmlToolVc.vcName = aTool.title;
        [self.navigationController pushViewController:aHtmlToolVc animated:YES];
    } else {
        ADToolRootViewController *aVc = [[NSClassFromString(aTool.myVc) alloc] init];
        aVc.vcName = aTool.title;
        [self.navigationController pushViewController:aVc animated:YES];
    }
}

- (void)openArticleWithUrl:(NSString *)url
{
    NSString *contentId = [[url componentsSeparatedByString:@"adding://adco/content?contentId="] lastObject];
    if(contentId.length != 0){
        ADMomLookContentDetailVC *dvc = [[ADMomLookContentDetailVC alloc] init];
        dvc.contentId = contentId;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

- (void)setRssWithUrl:(NSString *)urlString
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue cancelAllOperations];
    
    NSString *rss = [[[[urlString componentsSeparatedByString:@"&setRss="] lastObject] componentsSeparatedByString:@"/"] firstObject];
    _setRss = rss;
    
    NSString *addingToken = [[NSUserDefaults standardUserDefaults] addingToken];
    _mediaId = [[[[urlString componentsSeparatedByString:@"mediaId="] lastObject] componentsSeparatedByString:@"&"] firstObject];
    if (addingToken.length == 0) {
        
        ADLoginControl *loginControl = [[ADLoginControl alloc] init];
        loginControl.subTitle = @"订阅喜欢的加丁号，看到最新的文章";
        ADNavigationController *nc = [[ADNavigationController alloc] initWithRootViewController:loginControl];
        _continueToDo = 1;
        [ADHelper presentVc:nc atVc:self hiddenNavi:YES loginControl:loginControl];
        return;
    }
    
    [self setRssWithRss:rss];
}

- (void)setRssWithRss:(NSString *)rss
{
    NSString *jsRss = [NSString stringWithFormat:@"setRss(%@)",rss];
    [_contentWebview stringByEvaluatingJavaScriptFromString:jsRss];
    
    if ([rss isEqualToString:@"0"]) {
        [[ADFeedNetworkHelper shareManager] desSubscribeFeedMediaWIthMediaId:_mediaId compliteBlock:^(BOOL desSubcribe) {
            if(desSubcribe){
                [[NSNotificationCenter defaultCenter]postNotificationName:updateFeedListNotification object:nil];
            }else{
                NSString *jsRssCancel = [NSString stringWithFormat:@"setRss(%@)",@"1"];
                [_contentWebview stringByEvaluatingJavaScriptFromString:jsRssCancel];
                [ADToastHelp showSVProgressToastWithError:@"取消订阅失败"];
            }
        }];
    }else{
        [[ADFeedNetworkHelper shareManager] subscribeFeedMediaWIthMediaId:_mediaId compliteBlock:^(BOOL isSubcribe) {
            
            if(isSubcribe){
                [[NSNotificationCenter defaultCenter]postNotificationName:updateFeedListNotification object:nil];
            }else{
                NSString *jsRssCancel = [NSString stringWithFormat:@"setRss(%@)",@"0"];
                [_contentWebview stringByEvaluatingJavaScriptFromString:jsRssCancel];
                [ADToastHelp showSVProgressToastWithError:@"订阅失败"];
            }
        }];
    }

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"加载失败 :%@",error.localizedDescription);
    if (error.code != -999) {
        [_contentWebview loadHTMLString:@" " baseURL:nil];
    }
    [self performSelector:@selector(failedLoad) withObject:nil afterDelay:0.8];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"done ");
//    [MobClick endEvent:adco_content_normal_load];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:_beginDate];
    
    int time = timeInterval * 1000;
    
//    NSLog(@"打开页面需要时间%d",time);
    [MobClick event:adco_content_normal_load attributes:nil counter:time];
    [self p_stopLoadingAnimation];
    
    if (_aChannelId.length == 0) {
        _aChannelId = @"0";

    }
    
    [[ADAdStatHelper shareInstance] sendContentReadWithCid:_aChannelId
                                          andPositionIndex:_aIndex
                                              andContentId:[_contentModel.action getParamFromUrlWithParam:@"contentId"]];
    
    
    NSString *jsRss = [NSString stringWithFormat:@"setRss(%@)",_setRss];
    [webView stringByEvaluatingJavaScriptFromString:jsRss];
    
    NSString *commentCount = [NSString stringWithFormat:@"%@",_contentModel.commentCount];
    NSString *jsCommentCount = [NSString stringWithFormat:@"setCommentCount(%@)",commentCount];
    [webView stringByEvaluatingJavaScriptFromString:jsCommentCount];
    
    //[self loadTableView];
}

#pragma mark -load fail

- (void)failedLoad
{
    [self p_stopLoadingAnimation];
    [self performSelector:@selector(addErrorView) withObject:nil afterDelay:0.2];
}

- (void)addErrorView
{
    if (!_failLoadingView) {
        _failLoadingView = [[ADFailLodingView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) tapBlock:^{
            [self startRequest];
            _failLoadingView = nil;
        }];
    }
    
    [_failLoadingView showInView:self.view];
    
    [self.view bringSubviewToFront:_customNavBar];
}

- (void)jumpToCommentVCWithContentId:(NSString *)contentId
{
    ADLookCommentViewController *tvc = [[ADLookCommentViewController alloc] init];
    tvc.contentId = contentId;
    tvc.commentCount = _contentModel.commentCount;
    [self.navigationController pushViewController:tvc animated:YES];
}


@end
