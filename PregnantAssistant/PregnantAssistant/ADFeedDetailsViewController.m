//
//  ADFeedDetailsViewController.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/23.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADFeedDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "ADFeedDetailModel.h"
#import "ADFeedDetailsTableViewCell.h"
#import "UIImage+Tint.h"
#import "ADFeedMediaModel.h"
#import "ADFeedContentListModel.h"
#import "ADFeedNetworkHelper.h"
#import "ADLoadingView.h"
#import "ADMomLookContentDetailVC.h"
#import "SVPullToRefresh.h"
#import "ADNavigationController.h"
#import "ADLable.h"
#import "ADFailLodingView.h"
#import "ADEmptyView.h"
#import "ADWebActionSheetView.h"
#import "ADShareHelper.h"
#import "ADLoginControl.h"

typedef void(^myblock)(BOOL isempty);
@interface ADFeedDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,ADWebActionSheetDelegate>{
    CGFloat _indexY;
    UITableView *_tabelView;
    NSMutableArray *_dataArray;
    ADFeedMediaModel *_mediaModel;
    BOOL _isFeedRss;
    ADLoadingView *_loadingView;
    NSInteger _currentIndex;
    ADFailLodingView *_faileLodingView;
    ADEmptyView *_emptyView;
    UIView *_listEmptyView;
    UIButton *_feedButton;
    UIImage *_remoteShareImage;
    BOOL _duringLogn;
}
@end

@implementation ADFeedDetailsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_duringLogn) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [MobClick event:media_load];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_loadingView stopAnimation];
    if (self.disMissNavBlock) {
        self.disMissNavBlock();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelLogin) name:cancelLogin object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(feedRssChange) name:loginSucessNotification object:nil];
    
    [self layoutUI];
    [self loadData];
}

- (void)feedRssChange
{
    _duringLogn = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [ADFeedNetworkHelper getFeedMediaModelWithMediaId:_mediaId compliteBlock:^(NSDictionary *resDict) {
        BOOL isfeedrss = NO;
        if ([resDict[@"isRss"] integerValue] != 0) {
            isfeedrss = YES;
        }
        
        [self updateButtonColor:_feedButton isFeedRss:isfeedrss];
    }failure:^(NSError *error) {
        [self performSelector:@selector(failureLoad) withObject:nil afterDelay:0.8];
    }];
}

- (void)addRefresh{
    __weak ADFeedDetailsViewController *weekSelf = self;
    [_tabelView addInfiniteScrollingWithActionHandler:^{
        [weekSelf insertrowatbottom];
    }];
    _tabelView.showsInfiniteScrolling = YES;
}

#pragma mark - layoutUI
#define NAV_HEIGHT 64
#define TITLE_IMAGE_HEIGHT 89
#define TOP_DISTANCE 25
- (void)layoutUI{
    self.myTitle = @"加丁号";
    [self setLeftBackItemWithImage:nil andSelectImage:nil ];
    [self setRightItemWithImage:[[UIImage imageNamed:@"举报"] imageWithTintColor:UIColorFromRGB(0x333333)] andSelectImage:nil];
    [self addtabelView];
}
- (void)addtabelView{
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tabelView];
    [self addRefresh];
}

- (void)addloadingView{
    if (!_loadingView) {
        _loadingView = [[ADLoadingView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT*2)];
        [self.view addSubview:_loadingView];
    }
    
}

- (void)addADFaildLoadingVIew{
    if (!_faileLodingView) {
        _faileLodingView = [[ADFailLodingView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT*2) tapBlock:^{
            [self loadData];
            [_faileLodingView removeFromSuperview];
            _faileLodingView = nil;
        }];
    }
    [_faileLodingView showInView:self.view];
}

- (void)addListEmptyView{
    _tabelView.scrollEnabled = NO;
    CGFloat indexY = _indexY + 64;
    UIView *weekView = [[UIView alloc] initWithFrame:CGRectMake(0, indexY, SCREEN_WIDTH, SCREEN_HEIGHT - indexY)];
    [self.view addSubview:weekView];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 28, 0.5)];
    lineView.backgroundColor = [UIColor separator_gray_line_color];
    [weekView addSubview:lineView];
    ADLable *label = [[ADLable alloc] initWithFrame:CGRectMake(0,  19, SCREEN_WIDTH, 28) titleText:@"还没有文章哦" textColor:UIColorFromRGB(0x737373) textFont:[UIFont parentToolTitleViewDetailHeiFontWithSize:12] lineSpace:2];
    label.textAlignment = NSTextAlignmentCenter;
    [weekView addSubview:label];
}
- (void)finishLoad
{
    UIView *_bgScrollView = [[UIView alloc] init];
    [_bgScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bgScrollView];
    _indexY = TOP_DISTANCE;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - TITLE_IMAGE_HEIGHT)/2, _indexY, TITLE_IMAGE_HEIGHT, TITLE_IMAGE_HEIGHT)];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:_mediaModel.logoUrl] placeholderImage:[UIImage imageNamed:@"feedTitle"]];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_mediaModel.logoUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            imageView.image = image;
            _remoteShareImage = image;
        }else{
            [imageView setImage:[UIImage imageNamed:@"feedTitle"]];
        }
    }];
    imageView.layer.cornerRadius = TITLE_IMAGE_HEIGHT/2.0;
    imageView.layer.masksToBounds = YES;
    [_bgScrollView addSubview:imageView];
    _indexY += TITLE_IMAGE_HEIGHT;
    _indexY += 21;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _indexY, SCREEN_WIDTH, 20)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.attributedText = [[NSAttributedString alloc] initWithString:_mediaModel.name attributes:@{NSFontAttributeName:[UIFont parentToolTitleViewDetailHeiFontWithSize:20],NSForegroundColorAttributeName:UIColorFromRGB(0x333333)}];
    [_bgScrollView addSubview:nameLabel];
    _indexY += 20;
    _indexY += 15;
    ADLable *desLabel = [[ADLable alloc] initWithFrame:CGRectMake(14, _indexY, SCREEN_WIDTH - 28, 0) titleText:_mediaModel.myDescription textColor:UIColorFromRGB(0x737373) textFont:[UIFont parentToolTitleViewDetailHeiFontWithSize:14] lineSpace:6];
    [_bgScrollView addSubview:desLabel];
    _indexY += desLabel.frame.size.height;
    _indexY += 22;
    _feedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([_mediaModel.isRss integerValue] != 0) {
        _isFeedRss = YES;
    }
    CGFloat rateOfCornius = 55/148.0;
    CGFloat feedButtonWidth = 95.0*(SCREEN_WIDTH/320.0);
    _feedButton.frame = CGRectMake(0, _indexY, feedButtonWidth, feedButtonWidth * rateOfCornius);
    _feedButton.center = CGPointMake(SCREEN_WIDTH/2.0, _indexY + 15);
    
    [self updateButtonColor:_feedButton isFeedRss:_isFeedRss];
    [_feedButton addTarget: self action:@selector(feedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollView addSubview:_feedButton];
    _indexY += 58;
    _bgScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _indexY);
    _tabelView.tableHeaderView = _bgScrollView;
    [_tabelView reloadData];
}


- (void)feedButtonClick:(UIButton *)button{
    if ([[NSUserDefaults standardUserDefaults].addingToken isEqualToString:@""]) {
        [self pushLoginVc];
        return;
    }
    
    [self updateButtonColor:button isFeedRss:!_isFeedRss];
    if (_isFeedRss) {
        _isFeedRss = NO;
        [[ADFeedNetworkHelper shareManager] desSubscribeFeedMediaWIthMediaId:_mediaId compliteBlock:^(BOOL desSubcribe) {
            if (desSubcribe) {
                _isFeedRss = NO;
                NSString *contentStr = [NSString stringWithFormat:@"%@ %@",_mediaId,@"0"];
                [[NSNotificationCenter defaultCenter] postNotificationName:updateFeedListNotification object:contentStr];
            }else{
                _isFeedRss = YES;
                [ADToastHelp showSVProgressToastWithError:@"取消订阅失败"];
                [self updateButtonColor:button isFeedRss:_isFeedRss];
            }
            
        }];
    }else{
        _isFeedRss = YES;
        [[ADFeedNetworkHelper shareManager] subscribeFeedMediaWIthMediaId:_mediaId compliteBlock:^(BOOL isSubcribe) {
            if (isSubcribe) {
                _isFeedRss = YES;
                NSString *contentStr = [NSString stringWithFormat:@"%@ %@",_mediaId,@"1"];
                [[NSNotificationCenter defaultCenter] postNotificationName:updateFeedListNotification object:contentStr];
            }
            else{
                _isFeedRss = NO;
                [ADToastHelp showSVProgressToastWithError:@"订阅失败"];
                [self updateButtonColor:button isFeedRss:_isFeedRss];
            }
            
        }];
    }
}

- (void)rightItemMethod:(UIButton *)button{
    ADWebActionSheetView *actionSheet = [[ADWebActionSheetView alloc] initWithShareTitleArray:@[@"新浪微博", @"微信好友", @"朋友圈"] shareImageArray:@[@"微博分享", @"微信", @"朋友圈分享"] titleArray:@[@"拷贝链接"] titleImageArray:@[@"拷贝链接"]];
    actionSheet.delegate = self;
    [actionSheet show];

}

#pragma mark - ButtonClickDelegate
- (void)clickItemAtIndex:(NSInteger)index{
    index == 10 ?[UIPasteboard generalPasteboard].string = _mediaModel.wurl :[self shareContentAtIndex:index];
}

- (void)returnbackClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - LoadData
- (void)loadData{
    if (_dataArray.count == 0) {
        [self addloadingView];
        [_loadingView adLodingViewStartAnimating];
    }
    [ADFeedNetworkHelper getFeedMediaModelWithMediaId:_mediaId compliteBlock:^(NSDictionary *resDict) {
        NSLog(@"resDict: %@",resDict);
        if (resDict.count) {
            _mediaModel = [ADFeedMediaModel getFeedMediaModelWithDict:resDict];
        }
        [self finishLoad];
        [ADFeedNetworkHelper getFeedContentListWithStart:@"0" size:@"10" mediaID:_mediaId compliteBlock:^(NSArray *resArray, BOOL iscomplite) {
            for (NSDictionary *dict in resArray) {
                [_dataArray addObject:[ADFeedDetailModel getFeedDetailmodelWithDict:dict]];
            }
            if (_dataArray.count) {
                _tabelView.showsInfiniteScrolling = YES;
                _currentIndex = _dataArray.count;
                [_tabelView reloadData];
            }else{
                _tabelView.showsInfiniteScrolling = NO;
                [self addListEmptyView];
            }
            [_loadingView stopAnimation];
            _loadingView = nil;
        }failure:^(NSError *errer) {
            [self performSelector:@selector(failureLoad) withObject:nil afterDelay:0.8];
        }];
    }failure:^(NSError *error) {
        [self performSelector:@selector(failureLoad) withObject:nil afterDelay:0.8];
    }];
}

- (void)failureLoad{
    [_loadingView stopAnimation];
    _loadingView = nil;
    [self addADFaildLoadingVIew];
}

#pragma mark - TabelViewDelete

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    ADFeedDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ADFeedDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.refreshModel = _dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ADMomLookContentDetailVC *aDetialVc = [[ADMomLookContentDetailVC alloc]init];
    ADFeedDetailModel *model = _dataArray[indexPath.row];
    aDetialVc.contentId = [self getContentIdWithAction:model.action];
    [self.navigationController pushViewController:aDetialVc animated:YES];
}
#pragma mark - 上拉加载更多
- (void)insertrowatbottom{
    [ADFeedNetworkHelper getFeedContentListWithStart:[NSString stringWithFormat:@"%ld",(long)_currentIndex] size:@"10" mediaID:_mediaId compliteBlock:^(NSArray *resArray, BOOL iscomplite) {
        for (NSDictionary *dict in resArray) {
            [_dataArray addObject:[ADFeedDetailModel getFeedDetailmodelWithDict:dict]];
        }
        _currentIndex = _dataArray.count;
        [_tabelView reloadData];
        [_tabelView.infiniteScrollingView stopAnimating];
    }failure:^(NSError *errer) {
        [_tabelView.infiniteScrollingView stopAnimating];
    }];
}

- (void)shareContentAtIndex:(NSInteger)index{
    [MobClick event:media_share];
    NSString *title = _mediaModel.wtitle.length==0?@"":_mediaModel.wtitle;
    NSString *description = _mediaModel.myDescription.length==0 ? @"":_mediaModel.myDescription;
    __block UIImage *shareImage;//r = [UIImage imageNamed:@"AppIcon60x60"];
    if (_remoteShareImage) {
        shareImage = _remoteShareImage;
        NSDictionary *param = @{@"tag" : @(index), @"title" :title, @"des" :description, @"shareImage" : shareImage};
        [self performSelector:@selector(sendShareInfoWithParam:) onThread:[NSThread mainThread] withObject:param waitUntilDone:NO];
    }else{
        NSDictionary *param = @{@"tag" : @(index), @"title" :title, @"des" :description};
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
        if(des.length > 100){
            des = [des substringToIndex:99];
        }
        
        des = [NSString stringWithFormat:@"%@ %@", des,_mediaModel.wurl];
        [[ADShareHelper shareInstance] sendWeiboShareWithDes:des andImg:shareImage];
        
    } else if (tag == 2) {
        //微信
        [[ADShareHelper shareInstance] sendLinkToWeixinWithShare_Link:_mediaModel.wurl
                                                                title:title
                                                          description:des
                                                            shareType:weixin_share_tpye
                                                                image:shareImage
                                                                isImg:NO];
    } else if (tag == 3) {
        //朋友圈
        [[ADShareHelper shareInstance] sendLinkToWeixinWithShare_Link:_mediaModel.wurl
                                                                title:title
                                                          description:des
                                                            shareType:friend_share_type
                                                                image:shareImage
                                                                isImg:NO];
    }
}

- (void)updateButtonColor:(UIButton *)button isFeedRss:(BOOL)isfeedRss{
    if (isfeedRss) {
        [button setImage:[UIImage imageNamed:@"取消订阅"] forState:UIControlStateNormal];
    }else{
        [button setImage:[UIImage imageNamed:@"加订阅"] forState:UIControlStateNormal];
    }
}

- (NSString *)getContentIdWithAction:(NSString *)action{
    NSString *contentId = [[action componentsSeparatedByString:@"contentId="] lastObject];
    return contentId;
}

- (void)pushLoginVc
{
    _duringLogn = YES;
    ADLoginControl *loginVc = [[ADLoginControl alloc] init];
    loginVc.subTitle = @"订阅喜欢的加丁号，看到最新的文章";
    ADNavigationController *nc = [[ADNavigationController alloc] initWithRootViewController:loginVc];
    [ADHelper presentVc:nc atVc:self hiddenNavi:YES loginControl:loginVc];
}

- (void)cancelLogin
{
    _duringLogn = NO;
//    if (self.view.superview != nil) {
//        [self.navigationController setNavigationBarHidden:NO animated:NO];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
