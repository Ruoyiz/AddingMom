//
//  ADMomSecretViewController.m
//  PregnantAssistant
//
//  Created by D on 14/12/1.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADMomSecretViewController.h"
#import "CustomStoryTableViewCell.h"
#import "ADTopicTableViewCell.h"
#import "MomStory.h"
#import "ADWriteSecretViewController.h"
#import "ADNoticeViewController.h"
#import "ADPersonInfoViewController.h"
#import "SVPullToRefresh.h"
#import "ADRecommendTipView.h"
#import "ADTopic.h"
#import "AFNetworking.h"
#import "ADLoadingView.h"
//#import "ADLoginViewController.h"
#import "ADUserInfoListVC.h"
#import "ADSecretNoticeViewController.h"

#define ADDBTNHEIGHT 48
#define ITEM_EDGE 4

#define MACCELLHEIGHT 200

@interface ADMomSecretViewController (){
    UIImageView *_redDotImageView;
    UIImageView *_popViewRedDotImageVIew;

}

@property(nonatomic,strong)ADLoadingView *customLoadingView;

@end

@implementation ADMomSecretViewController{
    NSInteger _currentAllPos;
    NSInteger _currentHotPos;
    NSString *_lastPostAllId;
    NSString *_lastPostHotId;
    NSInteger _selectIndex;
}

#pragma mark - view circle life
-(void)dealloc
{
    self.myTableView.showsInfiniteScrolling = NO;
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
    [self.myTableView removeFromSuperview];
    self.myTableView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor bg_lightYellow];
    
    _tStr = [[NSUserDefaults standardUserDefaults]addingToken];
    
    _popView = [self buildPopView];

    self.aViewType = allStoryType;
    
    _haveMoreData = YES;
    _reloading = NO;
    
    if (_tStr.length > 0) {
        [self setupAllUI];
    } else {
        [self setLeftBackItemWithImage:nil andSelectImage:nil];
        self.myTitle = @"登录";
        [self addLoginBtnIsSecert:YES];
    }
}

- (void)reachabilityChanged:(NSNotification*)note
{
    Reachability* reach = [note object];

    if ([reach isReachable]) {
        _reachable = YES;
    } else {
        _reachable = NO;
        [_refreshControl endRefreshing];
        [self.myTableView.infiniteScrollingView stopAnimating];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSecertRedDot) name:removeSecretNumChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(reachabilityChanged:)
                                                name:kReachabilityChangedNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(loginWeiSucess:)
                                                name:loginWeiSucessNotify
                                              object:nil];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    _tStr = [[NSUserDefaults standardUserDefaults]addingToken];
    
    [MobClick event:lightforum_display];
    
    if (_tStr.length > 0 && self.appDelegate.deviceToken.length > 0) {
        [[ADMomSecertNetworkHelper shareInstance]regDeviceWithOAuth:_tStr
                                                     andDeviceToken:self.appDelegate.deviceToken];
    }
    
    //get data
    [self.myTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (void)setupAllUI
{
    self.allSecretDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.hotSecretDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    _currentAllPos = 0;
    _currentHotPos = 0;
    _lastPostHotId = @"";
    _lastPostAllId = @"";
    
    [self setupUI];
    
    //加载等待
    [self p_startLoadingAnimation];

    [self getDataBeginWith:@"0" andLength:@"50" andType:self.aViewType complication:^{
        [self.myTableView reloadData];
        self.myTableView.showsInfiniteScrolling = YES;
    }];
//
    [self createHeaderView];
    [self addRefreshAndInfi];
    
    [self addWriteBtn];
}

- (void)setRightItem
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"moreSet"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(showPopMenu) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 21, 21 +4)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 4, 0, -4)];
    _redDotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 5, 5, 5)];
    _redDotImageView.layer.cornerRadius = 2.5;
    _redDotImageView.layer.masksToBounds = YES;
    _redDotImageView.backgroundColor = [UIColor red_Dot_color];
    if (!_secertnotiShow) {
        _redDotImageView.hidden = YES;
    }
    [backButton addSubview:_redDotImageView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)showPopMenu
{
    if (_popView.superview == nil) {
        [self.appDelegate.window addSubview:_popView];
    } else {
        [_popView removeFromSuperview];
    }
}

- (void)removeSecertRedDot{
    [_popViewRedDotImageVIew removeFromSuperview];
    _popViewRedDotImageVIew = nil;
    [_redDotImageView removeFromSuperview];
    _redDotImageView = nil;
}

- (UIView *)buildPopView
{
    UIImageView *aPopView = [[UIImageView alloc]initWithFrame:
                             CGRectMake(self.view.frame.size.width -104, 64+2, 100, 96)];
    aPopView.image = [UIImage imageNamed:@"bubble"];
    aPopView.userInteractionEnabled = YES;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(2, 52, 96, 0.5)];
    line.backgroundColor = [UIColor whiteColor];
    [aPopView addSubview:line];
    
    UIButton *noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noticeBtn.frame = CGRectMake(0, 16, 100, 32);
    [noticeBtn setTitle:@"我的秘密" forState:UIControlStateNormal];
    noticeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    noticeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [noticeBtn addTarget:self action:@selector(jumpToMySecert) forControlEvents:UIControlEventTouchUpInside];
    [aPopView addSubview:noticeBtn];
    
    UIButton *personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    personBtn.frame = CGRectMake(0, 56, 100, 32);
    [personBtn setTitle:@"我的消息" forState:UIControlStateNormal];
    personBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    personBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [personBtn addTarget:self action:@selector(jumpToMyNotice) forControlEvents:UIControlEventTouchUpInside];
    _popViewRedDotImageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(82, 7, 5, 5)];
    _popViewRedDotImageVIew.layer.cornerRadius = 2.5;
    _popViewRedDotImageVIew.layer.masksToBounds = YES;
    _popViewRedDotImageVIew.backgroundColor = [UIColor red_Dot_color];
    if (!_secertnotiShow) {
        _popViewRedDotImageVIew.hidden = YES;
    }
    [personBtn addSubview:_popViewRedDotImageVIew];
    [aPopView addSubview:personBtn];
    
    return aPopView;
}

- (void)baseClickEvent
{
    [_popView removeFromSuperview];
}

- (void)jumpToMySecert
{
    [self baseClickEvent];
    NSString *tStr = [[NSUserDefaults standardUserDefaults] addingToken];
    if (tStr.length > 0) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        ADPersonInfoViewController *aVc = [[ADPersonInfoViewController alloc]init];
        [self.navigationController pushViewController:aVc animated:YES];
//    } else {
//        [self jumpToLoginVcWithCompletion:nil];
    }
}

- (void)jumpToMyNotice
{
    [self baseClickEvent];
    NSString *tStr = [[NSUserDefaults standardUserDefaults] addingToken];
    if (tStr.length > 0) {
        [self.navigationController pushViewController:[[ADSecretNoticeViewController alloc]init] animated:YES];
    } else {
//        [self jumpToLoginVcWithCompletion:nil];
    }
}

//- (void)jumpToLoginVcWithCompletion:(void (^)(void))aFinishBlock
//{
//    ADLoginViewController *aVc = [[ADLoginViewController alloc]init];
//    UINavigationController *aNavi = [[UINavigationController alloc]initWithRootViewController:aVc];
//    aNavi.navigationBar.translucent = NO;
//    [self presentViewController:aNavi animated:YES completion:aFinishBlock];
//}

- (void)addWriteBtn
{
    if (_writeBtn.superview == nil) {
        _writeBtn = [[ADAddBottomBtn alloc]initWithFrame:
                        CGRectMake(0, SCREEN_HEIGHT -ADDBTNHEIGHT, SCREEN_WIDTH, ADDBTNHEIGHT)];
        
        [_writeBtn addTarget:self action:@selector(pushWriteSecretVc) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_writeBtn];
        [self.view bringSubviewToFront:_writeBtn];
    }
}

- (void)addRefreshAndInfi
{
    __weak ADMomSecretViewController *weakSelf = self;
//    [self.myTableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf loadMore];
//    }];
    self.myTableView.showsInfiniteScrolling = NO;
    
    UIView *loadMoreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 10, SCREEN_WIDTH -4, 20)];
    tipLabel.text = @"加载更多";
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.textColor = [UIColor font_IconGray];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [loadMoreView addSubview:tipLabel];
    
    UIActivityIndicatorView *testActivityIndicator =
    [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = CGPointMake(SCREEN_WIDTH /3 +12, 20.0f);
    [testActivityIndicator startAnimating];
    [loadMoreView addSubview:testActivityIndicator];
    
    [self.myTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    
    [self.myTableView.infiniteScrollingView setCustomView:loadMoreView forState:SVInfiniteScrollingStateAll];
}

#pragma mark - login successsful callback
- (void)loginSuccessful
{
    [_aLoginVc.view removeFromSuperview];
    //get all list data
    self.allSecretDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.hotSecretDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    _currentAllPos = 0;
    _lastPostAllId = @"";
    
    _currentHotPos = 0;
    _lastPostHotId = @"";
    
    [self setupUI];
    
    [self getDataBeginWith:@"0" andLength:@"50" andType:self.aViewType complication:^{
        [self.myTableView reloadData];
    }];
    
//    [self getLocation];
    
    [self addRefreshAndInfi];
    
//    _tStr = [[NSUserDefaults standardUserDefaults]addingToken];
//    [[ADMomSecertNetworkHelper shareInstance]regDeviceWithOAuth:_tStr
//                                                 andDeviceToken:self.appDelegate.deviceToken];
}

- (void)loadMore
{
//    NSLog(@"pos:%d",_currentPos);
    long currentPos = [self getStartPos];
    [self getDataBeginWith:[NSString stringWithFormat:@"%ld", currentPos]
                 andLength:@"50"
                   andType:self.aViewType
              complication:^(void){
                  
                  if (_haveMoreData) {
                      [self.myTableView reloadData];
                  } else {
                      [ADHelper showToastWithText:@"没有了" frame:CGRectMake(0, SCREEN_HEIGHT- 100, SCREEN_WIDTH, 50)];
                      [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.1];
                  }
                  
                  [self.myTableView.infiniteScrollingView stopAnimating];
                  [self finishReloadingData];
    }];
}

- (void)scrollToBottom
{
    if (self.myTableView.contentSize.height >self.myTableView.bounds.size.height) {
        [self.myTableView setContentOffset:CGPointMake(0, self.myTableView.contentSize.height -self.myTableView.bounds.size.height) animated:YES];
    }
}

- (void)replaceDataBeginWith:(NSString *)startInx
                   andLength:(NSString *)aLength
                     andType:(viewType)aViewType
                complication:(FinishRequstBlock)aRequstBlock
{
    long lastPostId = _lastPostHotId.integerValue;
    if (self.aViewType == allStoryType) {
        lastPostId = _lastPostAllId.integerValue;
    }
    
    [[ADMomSecertNetworkHelper shareInstance]getAllSecertWithStartInx:startInx.integerValue
                                                            andLength:aLength.integerValue
                                                        andLastPostId:lastPostId
                                                          andViewtype:aViewType
                                                       andFinishBlock:
     ^(NSArray *resultArray) {
         if (aViewType == allStoryType) {
             if (resultArray.count > 0) {
                 [self.allSecretDataArray removeAllObjects];
                 [self.allSecretDataArray addObjectsFromArray:resultArray];
             }
         } else {
             if (resultArray.count > 0) {
                 [self.hotSecretDataArray removeAllObjects];
                 [self.hotSecretDataArray addObjectsFromArray:resultArray];
             }
         }
         
         if (resultArray.count > 0) {
             _haveMoreData = YES;
         } else {
             _haveMoreData = NO;
         }
         
         aRequstBlock();
     }failed:^{
         _aTitleView.userInteractionEnabled = YES;
         [self p_stopLoadingAnimation];
         [self finishReloadingData];
         [ADHelper showToastWithText:ConnectError];
     }oAuthTimeOut:^{
         [self p_stopLoadingAnimation];
         [self finishReloadingData];
         [ADHelper showToastWithText:@"网络连接较慢 请耐心等待"];
         _aTitleView.userInteractionEnabled = YES;
     }];
}

- (void)getDataBeginWith:(NSString *)startInx
               andLength:(NSString *)aLength
                 andType:(viewType)aViewType
            complication:(FinishRequstBlock)aRequstBlock
{
    
    [[ADMomSecertNetworkHelper shareInstance]getAllSecertWithStartInx:startInx.integerValue
                                                            andLength:aLength.integerValue
                                                        andLastPostId:[self getLastPostId]
                                                          andViewtype:aViewType
                                                       andFinishBlock:
     ^(NSArray *resultArray) {
         
         //NSLog(@"....%@",resultArray);
         if (aViewType == allStoryType) {
             if ([startInx isEqualToString:@"0"]) {
                 [_allSecretDataArray removeAllObjects];
             }
             [self.allSecretDataArray addObjectsFromArray:resultArray];
             [MobClick event:lightforum_all_display];
         } else {
             if ([startInx isEqualToString:@"0"]) {
                 [_hotSecretDataArray removeAllObjects];
             }
             [self.hotSecretDataArray addObjectsFromArray:resultArray];
            [MobClick event:lightforum_hot_display];
         }
         
         if (resultArray.count > 0) {
             _haveMoreData = YES;
         } else {
             _haveMoreData = NO;
         }
         
         if (resultArray.count > 0) {
             NSDictionary *aSecret = resultArray[resultArray.count -1];
             if (aViewType == allStoryType) {
                 _lastPostAllId = aSecret[@"postId"];
                 _currentAllPos += resultArray.count;
             }else{
                 _lastPostHotId = aSecret[@"postId"];
                 _currentHotPos += resultArray.count;
             }
         }
         
         aRequstBlock();
     }failed:^{
         [self performSelector:@selector(loadFailedViewWithStart:) withObject:startInx afterDelay:1];

         [self showToast];
     }oAuthTimeOut:^{
         [self.myTableView.infiniteScrollingView stopAnimating];
         [self finishReloadingData];
         
         NSString *tStr = [[NSUserDefaults standardUserDefaults] addingToken];
         if (tStr.length == 0) {
             [self pushLoginVc];
             return;
         }
     }];
}

- (void)setupUI
{
    [self setNaviTitleView];
    [self addTableView];
    
    //add badge
    [self addBadgeView];
}

- (void)addTableView
{
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 48)
                                                   style:UITableViewStylePlain];
    
    self.myTableView.backgroundColor = [UIColor bg_lightYellow];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.myTableView];
}

- (void)setNaviTitleView
{
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    [self setRightItem];
    [self setDisplayCustomTitleView];
}

//设置导航的自定义titleView居中
- (void)setDisplayCustomTitleView
{
    _aTitleView = [[ADSecertTitleView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) andParentVC:self];
    
    CGRect leftViewbounds = self.navigationItem.leftBarButtonItem.customView.bounds;
    CGRect rightViewbounds = self.navigationItem.rightBarButtonItem.customView.bounds;
    CGRect frame;
    
    CGFloat maxWidth = leftViewbounds.size.width > rightViewbounds.size.width ? leftViewbounds.size.width : rightViewbounds.size.width;
    maxWidth += 20;
//    frame = _aTitleView.frame;
    CGFloat width = SCREEN_WIDTH - maxWidth * 2;
    
    frame = CGRectMake(0, 0, width, 44);
    _aTitleView.frame = frame;

    self.navigationItem.titleView = _aTitleView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushWriteSecretVc
{
    [self baseClickEvent];
    //判断是否登陆
    NSString *tStr = [[NSUserDefaults standardUserDefaults] addingToken];
    if (tStr.length == 0) {
        ADUserInfoListVC *listVC = [[ADUserInfoListVC alloc] init];
        listVC.fromMonSecret = YES;
        [self.navigationController pushViewController:listVC animated:YES];
        return;
    }
    ADWriteSecretViewController *aWriteVc = [[ADWriteSecretViewController alloc]init];
    aWriteVc.aMomVc = self;
    
    [self.navigationController pushViewController:aWriteVc animated:YES];
}

- (void)pushWriteSecretVcWithTopic:(NSString *)topicStr
{
    [self baseClickEvent];
    ADWriteSecretViewController *aWriteVc = [[ADWriteSecretViewController alloc]init];
    aWriteVc.aMomVc = self;
    if (topicStr.length > 0) {
        aWriteVc.topicString = topicStr;
    }
    
    [self.navigationController pushViewController:aWriteVc animated:YES];
}

- (void)addBadgeView
{
    [[ADMomSecertNetworkHelper shareInstance]getBadgeNumWithResult:^(int resultNum) {
//        NSString *cntStr = resDic[@"count"];
        _aBadgeNum = resultNum;
        if (_aBadgeNum > 0) {
            _aBadgeView = [[ADBadgeView alloc]initWithFrame:CGRectMake(0, 0, 16, 16)
                                                     andNum:_aBadgeNum
                                                 andBgColor:UIColorFromRGB(0xDB2E57)];
            [_threeLineBtn addSubview:_aBadgeView];
            _aBadgeView.center = CGPointMake(_threeLineBtn.frame.size.width +5, 8);
            
            _aBadgeViewOnPop = [[ADBadgeView alloc]initWithFrame:CGRectMake(22, 14, 16, 16)
                                                          andNum:_aBadgeNum
                                                      andBgColor:[UIColor defaultTintColor]];
//            [_popView addSubview:_aBadgeViewOnPop];
        }
    }];
}

#pragma mark - tableview method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.aViewType == allStoryType) {
        if (_allSecretDataArray.count > 0) {
            [self p_stopLoadingAnimation];
            
        }
        return self.allSecretDataArray.count;
    } else {
        if (_hotSecretDataArray.count > 0) {
            [self p_stopLoadingAnimation];
        }
        return self.hotSecretDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *aSecert = nil;
    if (self.aViewType == allStoryType) {
        if (indexPath.row < self.allSecretDataArray.count) {
            aSecert = self.allSecretDataArray[indexPath.row];
        }
    } else {
        if (indexPath.row < self.hotSecretDataArray.count) {
            aSecert = self.hotSecretDataArray[indexPath.row];
        }
    }
    
    NSString *type = aSecert[@"type"];
    
    if ([type isEqualToString:@"1"] || [type isEqualToString:@"2"]) {
        return [self tableView:tableView topicCellForRowAtIndexPath:indexPath aSecert:aSecert];
    } else {
        return [self tableView:tableView storyCellForRowAtIndexPath:indexPath aSecert:aSecert];
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[CustomStoryTableViewCell class]]) {
        CustomStoryTableViewCell *storyCell = (CustomStoryTableViewCell *)cell;
        storyCell.imageUrlArray = nil;
        
        for (UIImageView *aImgView in storyCell.imageViewArray) {
            [aImgView removeFromSuperview];
        }
        storyCell.imageViewArray = nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //判断是否登陆
    NSString *tStr = [[NSUserDefaults standardUserDefaults] addingToken];
    if (tStr.length == 0) {
        [self pushLoginVc];
        return;
    }
    
    [self baseClickEvent];
    _selectIndex = indexPath.row;
    ADStoryDetailViewController *aStoryVc = [[ADStoryDetailViewController alloc]init];
    aStoryVc.comefromMomSec = YES;
    if (self.aViewType == hotStoryType) {
        aStoryVc.aSecret = self.hotSecretDataArray[indexPath.row];
    } else {
        aStoryVc.aSecret = self.allSecretDataArray[indexPath.row];
    }
    
    NSNumber *type = aStoryVc.aSecret[@"type"];
    if (type.intValue == 1 || type.intValue == 2) {
        ADTopicTableViewCell *aTopicCell = (ADTopicTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
        
        if (type.intValue == 1) {
            //官方秘密
            [self pushToDetailVcWithPostId:aTopicCell.postId andUid:aTopicCell.uId andTopic:aTopicCell.aTopic];
        } else {
            //引导话题
            [self pushWriteSecretVcWithTopic:aTopicCell.topic];
        }
    } else {
        
        aStoryVc.delegate = self;
        aStoryVc.fromRow = _selectIndex;
        [aStoryVc isDeleteReturnBackBlock:^(BOOL isDelete, NSInteger rowIndex) {
            if (isDelete) {
                [ADHelper showToastWithText:@"删除成功，请继续。。。" frame:CGRectMake(0, 64, SCREEN_WIDTH, 50)];
                [self getStartData];
                [_myTableView reloadData];
            }
        }];

        [self.navigationController pushViewController:aStoryVc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *aSecert = nil;
    if (self.aViewType == allStoryType) {
        if (indexPath.row < self.allSecretDataArray.count) {
            aSecert = self.allSecretDataArray[indexPath.row];
        }
    } else {
        if (indexPath.row < self.hotSecretDataArray.count) {
            aSecert = self.hotSecretDataArray[indexPath.row];
        }
    }
    
    NSString *type = aSecert[@"type"];
    if ([type isEqualToString:@"1"]) {
        float height = self.view.frame.size.width * (1012 /1080.0) +12 +44;
        return height;
    } else if ([type isEqualToString:@"2"]) {
        float height = self.view.frame.size.width * (1012 /1080.0) +12;
        return height;
    } else {
        NSString *body = aSecert[@"body"];
        CGRect textRect = [body boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 36, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont momSecretCell_title_font]} context:nil];

        float height = textRect.size.height;
        
        // add image height
        NSString *imageUrls = aSecert[@"imageUrl"];
        
        NSData* xmlData = [imageUrls dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *imageUrlArray = nil;
        if (xmlData != nil) {
            imageUrlArray = [NSJSONSerialization JSONObjectWithData:xmlData
                                                            options:NSJSONReadingAllowFragments
                                                              error:nil];
        }
        
        float perImgRowHeight = (self.view.frame.size.width - 8*4) /3;
        if (imageUrlArray.count > 0) {
            NSInteger rowNum = (imageUrlArray.count -1) /3 +1;
            height += perImgRowHeight *rowNum;
            
            height += 21 +6 +40+12;
        } else {
            height += 42 +40;
        }
        
        return height;
    }
}

#pragma mark - 分别加载story和topic的cell
//加载storyCell
- (UITableViewCell *)tableView:(UITableView *)tableView storyCellForRowAtIndexPath:(NSIndexPath *)indexPath aSecert:(NSDictionary *)aSecert
{
    NSString *reuseStr = @"customStoryCell";
    CustomStoryTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:reuseStr];
    if (customCell == nil) {
        customCell = [[CustomStoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseStr];
        customCell.selectionStyle = UITableViewCellSelectionStyleNone;
        customCell.passThoughTouch = YES;
    }
    
    customCell.summaryStory.text = aSecert[@"body"];
    customCell.placeAndDueLabel.text = aSecert[@"cityName"];
    
    NSString *commentStr = aSecert[@"commentCount"];
    NSString *likeStr = aSecert[@"praiseCount"];
    if (commentStr.intValue > 999) {
        commentStr = [NSString stringWithFormat:@"%dK",commentStr.intValue/1000];
    }
    customCell.commentLabel.text = commentStr;
    
    if (likeStr.intValue > 999) {
        likeStr = [NSString stringWithFormat:@"%dK",likeStr.intValue/1000];
    }
    customCell.likeLabel.text = likeStr;
    
    NSString *isHot = aSecert[@"isHot"];
    customCell.isHot = isHot.boolValue;
    
    NSString *isComment = aSecert[@"isComment"];
    customCell.isComment = isComment.boolValue;
    customCell.isLike = aSecert[@"isPraise"];
    
    customCell.likeBtn.tag = indexPath.row;
    
    [customCell.likeBtn addTarget:self action:@selector(changeLikeStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    NSData* xmlData = [aSecert[@"imageUrl"] dataUsingEncoding:NSUTF8StringEncoding];
    if (xmlData != nil) {
        customCell.imageUrlArray = [NSJSONSerialization JSONObjectWithData:xmlData
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:nil];
    }
    
    NSString *isRecommend = aSecert[@"isRecommend"];
    customCell.isRecommand = isRecommend.boolValue;
    
    return customCell;
}

//加载topicCell
- (UITableViewCell *)tableView:(UITableView *)tableView topicCellForRowAtIndexPath:(NSIndexPath *)indexPath aSecert:(NSDictionary *)aSecert
{
    NSString *type = aSecert[@"type"];
    
    NSString *reuseTopicCellId = @"topicCell";
    NSString *aImgUrl = nil;
    if ([type isEqualToString:@"1"]) {
        NSString *imageUrls = aSecert[@"imageUrl"];
        NSData* xmlData = [imageUrls dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *imageUrlArray = nil;
        if(xmlData != nil) {
            imageUrlArray = [NSJSONSerialization JSONObjectWithData:xmlData
                                                            options:NSJSONReadingAllowFragments
                                                              error:nil];
        }
        //只有1个图片地址
        aImgUrl = imageUrlArray[0];
    } else {
        aImgUrl = aSecert[@"image_url"];
    }
    
    ADTopic *aTopic = nil;
    //shit
    if ([type isEqualToString:@"1"]) {
        NSString *aTopicTitle = aSecert[@"body"];
        
        aTopic = [[ADTopic alloc]initWithTopicTitle:aTopicTitle btnTitle:@"" imgUrl:aImgUrl type:type];
        
    } else if ([type isEqualToString:@"2"]) {
        NSString *aTopicTitle = aSecert[@"body"];
        NSString *aBtnTitle = aSecert[@"buttonName"];
        
        aTopic = [[ADTopic alloc]initWithTopicTitle:aBtnTitle btnTitle:aTopicTitle imgUrl:aImgUrl type:type];
    }
    
    ADTopicTableViewCell *topicCell = nil;
    if ([type isEqualToString:@"1"]) {
        topicCell = [[ADTopicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:reuseTopicCellId
                                                         topic:aTopic
                                                    showDetail:YES];
    } else {
        topicCell = [[ADTopicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:reuseTopicCellId
                                                         topic:aTopic
                                                    showDetail:NO];
    }
    
    topicCell.parentVC = self;
    topicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([type isEqualToString:@"1"]) {
        NSString *postId = aSecert[@"postId"];
        topicCell.postId = postId.intValue;
        NSString *uId = aSecert[@"uid"];
        topicCell.uId = uId.intValue;
        
        NSString *commentStr = aSecert[@"commentCount"];
        NSString *likeStr = aSecert[@"praiseCount"];
        if (commentStr.intValue > 999) {
            commentStr = [NSString stringWithFormat:@"%dK",commentStr.intValue/1000];
        }
        topicCell.commentLabel.text = commentStr;
        
        if (likeStr.intValue > 999) {
            likeStr = [NSString stringWithFormat:@"%dK",likeStr.intValue/1000];
        }
        topicCell.likeLabel.text = likeStr;
        
        NSString *isComment = aSecert[@"isComment"];
        topicCell.isComment = isComment.boolValue;
        topicCell.isLike = aSecert[@"isPraise"];
        
        topicCell.likeBtn.tag = indexPath.row;
        [topicCell.likeBtn
         addTarget:self action:@selector(changeTopicLikeStatus:) forControlEvents:UIControlEventTouchUpInside];
        topicCell.placeAndDueLabel.text = @"来自加丁妈妈";
        
    } else if ([type isEqualToString:@"2"]) {
        topicCell.topic = aSecert[@"body"];
    }
    
    return topicCell;
}

#pragma mark - 修改UI状态
- (void)changeLikeStatus:(UIButton *)sender
{
    //判断是否登陆
    NSString *tStr = [[NSUserDefaults standardUserDefaults] addingToken];
    if (tStr.length == 0) {
        //[self.navigationController pushViewController:aVc animated:YES];
        [self pushLoginVc];
        return;
    }
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    CustomStoryTableViewCell *aStoryCell =
    (CustomStoryTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
    
    NSString *likeStr = aStoryCell.likeLabel.text;
    
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.4)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    
    [sender.layer addAnimation:k forKey:@"SHOW"];

    NSMutableDictionary *aSecert = nil;
    NSMutableArray *muArray = nil;
    if (self.aViewType == allStoryType) {
        muArray = self.allSecretDataArray;
    } else {
        muArray = self.hotSecretDataArray;
    }
    
    if (indexPath.row < muArray.count) {
        
        aSecert = [NSMutableDictionary dictionaryWithDictionary:muArray[indexPath.row]];
    }
    else{
        return;
    }
    //NSString *type = aSecert[@"type"];
    
//    if ([type isEqualToString:@"1"] || [type isEqualToString:@"2"]) {
//        
//    } else {
//
//    }

    //NSLog(@"+++++++%@",aSecert);
    if (sender.selected == NO) {
        NSInteger praiseCount = [aStoryCell.likeLabel.text integerValue];
        praiseCount ++;
        [aSecert setObject:[NSString stringWithFormat:@"%ld",(long)praiseCount] forKey:@"praiseCount"];
        [aSecert setObject:[NSNumber numberWithBool:YES] forKey:@"isPraise"];
        
        //改变model状态
        [muArray replaceObjectAtIndex:indexPath.row withObject:aSecert];
        
        //NSLog(@"%@",muArray[indexPath.row]);
        sender.selected = YES;
        aStoryCell.likeLabel.text = [NSString stringWithFormat:@"%ld",(long)praiseCount];
        [self changeASecret:sender withStatus:YES finish:^(){
            //[aSecert setValue:[NSNumber numberWithBool:YES] forKey:@"isPraise"];
        }failed:^{
            [aSecert setObject:[NSNumber numberWithBool:NO] forKey:@"isPraise"];
            //改变model状态
            NSInteger praiseCount = [[aSecert objectForKey:@"praiseCount"] integerValue];
            praiseCount --;
            [aSecert setObject:[NSString stringWithFormat:@"%ld",(long)praiseCount] forKey:@"praiseCount"];
            [muArray replaceObjectAtIndex:indexPath.row withObject:aSecert];
            sender.selected = NO;
            [ADHelper showToastWithText:ConnectError];
            //aStoryCell.likeLabel.text = [NSString stringWithFormat:@"%d",likeStr.intValue];
        }];
    } else {
        [aSecert setObject:[NSNumber numberWithBool:NO] forKey:@"isPraise"];
        //改变model状态
        NSInteger commentCount = [aStoryCell.likeLabel.text integerValue];
        commentCount --;
        [aSecert setObject:[NSString stringWithFormat:@"%ld",(long)commentCount] forKey:@"praiseCount"];
        [muArray replaceObjectAtIndex:indexPath.row withObject:aSecert];
        sender.selected = NO;
        aStoryCell.likeLabel.text = [NSString stringWithFormat:@"%ld",(long)commentCount];
        [self changeASecret:sender withStatus:NO finish:^(){
//            [self replaceDataBeginWith:@"0"
//                             andLength:[NSString stringWithFormat:@"%ld",[self getStartPos]]
//                               andType:self.aViewType
//                          complication:^{}];
            
        }failed:^{
            sender.selected = YES;
            
            [ADHelper showToastWithText:ConnectError];
            aStoryCell.likeLabel.text = [NSString stringWithFormat:@"%d",likeStr.intValue];
            [aSecert setObject:[NSNumber numberWithBool:YES] forKey:@"isPraise"];
            NSInteger commentCount = [[aSecert objectForKey:@"praiseCount"] integerValue];
            commentCount ++;
            [aSecert setObject:[NSString stringWithFormat:@"%ld",(long)commentCount] forKey:@"praiseCount"];
            aStoryCell.likeLabel.text = [NSString stringWithFormat:@"%ld",(long)commentCount];

            [muArray replaceObjectAtIndex:indexPath.row withObject:aSecert];

        }];
    }
}

- (void)changeTopicLikeStatus:(UIButton *)sender
{
    //判断是否登陆
    NSString *tStr = [[NSUserDefaults standardUserDefaults] addingToken];
    if (tStr.length == 0) {
        //[self.navigationController pushViewController:aVc animated:YES];
        [self pushLoginVc];
        return;
    }
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    CustomStoryTableViewCell *aStoryCell =
    (CustomStoryTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
    
    NSString *likeStr = aStoryCell.likeLabel.text;
    
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.4)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    
    [sender.layer addAnimation:k forKey:@"SHOW"];
    
    if (sender.selected == NO) {
        sender.selected = YES;
        aStoryCell.likeLabel.text = [NSString stringWithFormat:@"%d",likeStr.intValue +1];
        [self changeASecret:sender withStatus:YES finish:^(){
            [self replaceDataBeginWith:@"0"
                             andLength:[NSString stringWithFormat:@"%ld",[self getStartPos]]
                               andType:self.aViewType
                          complication:^{}];
            
        }failed:^{
            sender.selected = NO;
            [ADHelper showToastWithText:ConnectError];
            aStoryCell.likeLabel.text = [NSString stringWithFormat:@"%d",likeStr.intValue];

        }];
    } else {
        sender.selected = NO;
        aStoryCell.likeLabel.text = [NSString stringWithFormat:@"%d",likeStr.intValue -1];
        [self changeASecret:sender withStatus:NO finish:^(){
            [self replaceDataBeginWith:@"0"
                             andLength:[NSString stringWithFormat:@"%ld",[self getStartPos]]
                               andType:self.aViewType
                          complication:^{}];
        }failed:^{
            sender.selected = YES;
            [ADHelper showToastWithText:ConnectError];
            aStoryCell.likeLabel.text = [NSString stringWithFormat:@"%d",likeStr.intValue];
        }];
    }
}

- (void)changeASecret:(UIButton *)sender withStatus:(BOOL)likeStatus finish:(FinishRequstBlock)aRequstBlock failed:(void (^) (void))failed
{
    int likeTag = (int)sender.tag;
    
    NSString *aPostId = nil;
    
    if (self.aViewType == allStoryType) {
        aPostId = self.allSecretDataArray[likeTag][@"postId"];
    } else {
        aPostId = self.hotSecretDataArray[likeTag][@"postId"];
    }
    
    [[ADMomSecertNetworkHelper shareInstance] changeAPostWithId:aPostId
                                                     andStatus:likeStatus
                                                  complication:^{
                                                      if (aRequstBlock) {
                                                          aRequstBlock();
                                                      }
                                                  }
                                                        failed:^{
                                                            failed();
                                                        }];
}

- (void)changeStatusAtIndex:(NSInteger)index withObjc:(NSDictionary *)aSecret
{
    NSString *type = [NSString stringWithFormat:@"%@",[aSecret objectForKey:@"type"]];
    
    if ([type isEqualToString:@"1"] || [type isEqualToString:@"2"]) {
        //return [self tableView:tableView topicCellForRowAtIndexPath:indexPath aSecert:aSecert];
    } else {
        //return [self tableView:tableView storyCellForRowAtIndexPath:indexPath aSecert:aSecert];
    }
    
    if ([type integerValue] == 1 || [type integerValue] == 2) {
        ADTopicTableViewCell *topicCell = nil;
        for (UIView *view in  self.myTableView.visibleCells) {
            if ([view isKindOfClass:[ADTopicTableViewCell class]]) {
                topicCell = (ADTopicTableViewCell *)view;
                NSString *likeCount = [NSString stringWithFormat:@"%@",[aSecret objectForKey:@"praiseCount"]];
                BOOL isPrise = [[aSecret objectForKey:@"isPraise"] boolValue];
                topicCell.likeBtn.selected = isPrise;
                topicCell.likeLabel.text = likeCount;
                
                NSMutableArray *muArray = nil;
                if (self.aViewType == allStoryType) {
                    muArray = self.allSecretDataArray;
                } else {
                    muArray = self.hotSecretDataArray;
                }
                
                [muArray replaceObjectAtIndex:index withObject:aSecret];
                return;
            }
        }
    }else{
        CustomStoryTableViewCell *storyCell = nil;
        
        for (UIView *view in self.myTableView.visibleCells) {
            if ([view isKindOfClass:[CustomStoryTableViewCell class]]) {
                storyCell = (CustomStoryTableViewCell *)view;
                if (storyCell.likeBtn.tag == index) {
                    
                    
                    NSString *likeCount = [NSString stringWithFormat:@"%@",[aSecret objectForKey:@"praiseCount"]];
                    BOOL isPrise = [[aSecret objectForKey:@"isPraise"] boolValue];
                    //NSLog(@"++++++++++++++可以改变状态++++++++++++%d,%@",isPrise,likeCount);
                    storyCell.likeBtn.selected = isPrise;
                    storyCell.likeLabel.text = likeCount;
                    
                    NSMutableArray *muArray = nil;
                    if (self.aViewType == allStoryType) {
                        muArray = self.allSecretDataArray;
                    } else {
                        muArray = self.hotSecretDataArray;
                    }
                    
                    [muArray replaceObjectAtIndex:index withObject:aSecret];
                    
                    return;
                }
            }
        }
    }
    
}

- (void)pushToDetailVcWithPostId:(NSInteger)aId andUid:(NSInteger)aUid andTopic:(ADTopic *)aTopic
{
    ADStoryDetailViewController *aStoryVc = [[ADStoryDetailViewController alloc]init];
    aStoryVc.postId = aId;
    aStoryVc.isTopic = YES;
    aStoryVc.topic = aTopic;
    aStoryVc.delegate = self;
    aStoryVc.fromRow = _selectIndex;
    aStoryVc.uid = [NSString stringWithFormat:@"%ld", (long)aUid];
    
    [self.navigationController pushViewController:aStoryVc animated:YES];
}

#pragma mark - title点击后响应
- (void)reloadViewData
{
    [_failLoadingView removeFromSuperview];

    if (_aTitleView.selectInx == 1) {
        self.aViewType = allStoryType;
        if (_allSecretDataArray.count != 0) {
            //[self showRefreshView];
        }
    } else {
        
        self.aViewType = hotStoryType;
        if (_hotSecretDataArray.count != 0) {
            //[self showRefreshView];
        }
    }
    
    [self.myTableView reloadData];
    
    if (self.aViewType == allStoryType) {
        if (_allSecretDataArray.count == 0) {
            [self p_startLoadingAnimation];
            [self getStartData];
        }
        
    } else {
        if (_hotSecretDataArray.count == 0) {
            [self p_startLoadingAnimation];
            [self getStartData];
        }
    }
}

- (void)getStartData
{
    [self getDataBeginWith:@"0" andLength:@"50" andType:self.aViewType complication:^{
        [self.myTableView reloadData];
        [self finishReloadingData];
    }];
}

- (void)tableViewScrollToTop
{
    //NSLog(@"滑动到顶");
    [self.myTableView scrollRectToVisible:CGRectMake(0, -60, SCREEN_WIDTH, self.myTableView.frame.size.height) animated:YES];
}

#pragma mark - loading
- (void)p_startLoadingAnimation
{
    if (!_customLoadingView) {
        self.customLoadingView =[[ADLoadingView alloc]initWithFrame:self.myTableView.frame];
        [self.view addSubview:_customLoadingView];
    }
    
    [_customLoadingView adLodingViewStartAnimating];
}

- (void)p_stopLoadingAnimation
{
    if (_customLoadingView) {
        [_customLoadingView adLodingViewStartAnimating];
        [_customLoadingView removeFromSuperview];
        self.customLoadingView = nil;
    }
}

#pragma mark - methods for creating and removing the header view
-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _refreshHeaderView.delegate = self;
    
    [self.myTableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)removeHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark force to show the refresh headerView
-(void)showRefreshHeader:(BOOL)animated{
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        // scroll the table view to the top region
        [self.myTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:YES];
        [UIView commitAnimations];
    }
    else
    {
        [self.myTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:YES];
    }
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
}

//刷新delegate
#pragma mark data reloading methods that must be overide by the subclass
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    //  should be calling your tableviews data source model to reload
//    _reloading = YES;
//
    _aTitleView.userInteractionEnabled = NO;
    
    if (_reloading == YES) {
        return;
    }
    _reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:1.0];
    }
}

#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
    }
}

#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    [_popView removeFromSuperview];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

#pragma mark EGORefreshTableDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
    return _reloading; // should return if data source model is reloading
}

#pragma mark - 刷新结束后需要实现的方法
- (void)refreshView
{
    [self replaceDataBeginWith:@"0"
                     andLength:[NSString stringWithFormat:@"%ld",[self getStartPos]]
                       andType:self.aViewType
                  complication:^{
                      [self finishReloadingData];
                      _aTitleView.userInteractionEnabled = YES;
                      [self.myTableView reloadData];
                  }];
}

#pragma mark - ADFailedLoading 代理
//- (void)tapReloadAction
//{
//    [self p_startLoadingAnimation];
//    
//    //加载数据
//    [self getDataBeginWith:@"0" andLength:@"50" andType:self.aViewType complication:^{
//        [self.myTableView reloadData];
//        self.myTableView.showsInfiniteScrolling = YES;
//    }];
//}

- (void)loadFailedViewWithStart:(NSString *)startInx
{
    [self p_stopLoadingAnimation];
    [self finishReloadingData];
    
    if (self.aViewType == allStoryType) {
        if (self.allSecretDataArray.count != 0) {
            return;
        }
    } else if (self.hotSecretDataArray.count != 0) {
        return;
    }
    
    if ([startInx isEqualToString:@"0"]) {
        if (_failLoadingView.superview == nil) {
            _failLoadingView = [[ADFailLodingView alloc]initWithFrame:
                                CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) tapBlock:^{
                                    [self p_startLoadingAnimation];
                                    
                                    //加载数据
                                    [self getDataBeginWith:@"0" andLength:@"50" andType:self.aViewType complication:^{
                                        [self.myTableView reloadData];
                                        self.myTableView.showsInfiniteScrolling = YES;
                                    }];
                                    _failLoadingView = nil;
                                }];            
        }
        
        [_failLoadingView showInView:self.view];
    }
}

- (void)pushLoginVc
{
    ADUserInfoListVC *listVC = [[ADUserInfoListVC alloc] init];
    listVC.fromMonSecret = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)showToast
{
    if (self.aViewType == allStoryType) {
        if (_allSecretDataArray.count > 0) {
            [ADHelper showToastWithText:ConnectError];
        }
    } else {
        if (_hotSecretDataArray.count > 0) {
            [ADHelper showToastWithText:ConnectError];
        }
    }
}

- (void)showRefreshView
{
    if(self.aViewType == allStoryType && _allSecretDataArray.count == 0){
        
        if (_failLoadingView) {
            [_failLoadingView reloadAction];
        }
        return;
    }
    if (self.aViewType == hotStoryType && _hotSecretDataArray.count == 0) {
        
        if (_failLoadingView) {
            [_failLoadingView reloadAction];
        }
        return;
    }
    _reloading = YES;
    [_refreshHeaderView startRotate];
    [UIView animateWithDuration:0.3 animations:^{
        self.myTableView.contentOffset = CGPointMake(0, -48);
    } completion:^(BOOL finished) {
        [self getStartData];
    }];
}

- (long)getLastPostId
{
    long lastPostId = _lastPostHotId.integerValue;
    if (self.aViewType == allStoryType) {
        lastPostId = _lastPostAllId.integerValue;
    }
    return lastPostId;
}

- (long)getStartPos
{
    long currentPos = _currentHotPos;
    if (self.aViewType == allStoryType) {
        currentPos = _currentAllPos;
    }
    return currentPos;
}

- (void)setupPos
{
    if (self.aViewType == allStoryType) {
        _currentAllPos = 0;
        _lastPostAllId = @"";
    }else{
        _currentHotPos = 0;
        _lastPostHotId = @"";
    }
}

#pragma mark - login method
- (void)loginWechatAccount
{
//    [[ADAccountCenter sharedADAccountCenter] oAuthWeiXinWithTarget:self oauthType:ADLogin
//                                                           success:@selector(loginOAuthSuccessful:)
//                                                           failure:nil];
}

- (void)loginOAuthSuccessful:(NSString *)iconUrl
{
    [[NSNotificationCenter defaultCenter] postNotificationName:loginWeiSucessNotify object:nil];
    [self.loginView removeFromSuperview];
    
    [ADToastHelp dismissSVProgress];
    _tStr = [[NSUserDefaults standardUserDefaults]addingUid];
    [self setupAllUI];
}

- (void)loginWeiSucess:(NSNotification *)notification
{
}

@end