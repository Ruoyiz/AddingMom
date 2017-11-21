//
//  ADNoticeViewController.m
//  PregnantAssistant
//
//  Created by D on 14/12/6.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADNoticeViewController.h"

@implementation ADNoticeViewController{
}

-(void)dealloc
{
    self.myTableView.dataSource = nil;
    self.myTableView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets  = NO;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _loadingIndex = 0;
    [self readNoticeRow];
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    _noticeArray = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] addingToken].length > 0) {
        self.myTitle = @"我的消息";
        [self getData];
    } else {
        self.myTitle = @"登录";
        [self addLoginBtnIsSecert:NO];
    }
}

- (void)loadContentView
{
    [self p_stopLoadingAnimation];
    
    if (_noticeArray.count == 0) {
        [self addEmptyView];
    } else {
        [self addTableView];
    }
}

#pragma mark - 网络请求获取数据
- (void)getData
{
    if (_noticeArray.count == 0) {
        [self p_startLoadingAnimation];
    }
    [[ADMomSecertNetworkHelper shareInstance] getAllNotinfoWithStart:@"0" size:@"10" SecretFinishBlock:^(NSArray *resultArray) {
        [_noticeArray removeAllObjects];
        if (self.removeRedDotBlock) {
            self.removeRedDotBlock();
        }
        [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_noticeArray addObject:[ADNoticeInfo noticeinfoWithDictionary:obj]];
        }];
        _loadingIndex = _noticeArray.count;
        if (_noticeArray.count) {
            [_emptyView removeFromSuperview];
            _emptyView = nil;
        }
        [_refreshControl endRefreshing];
        [self performSelector:@selector(loadContentView) withObject:nil afterDelay:0.6];

    } failed:^{
        [_refreshControl endRefreshing];
        [self p_stopLoadingAnimation];
        if (0 == _noticeArray.count) {
            [self performSelector:@selector(loadFailedView) withObject:nil afterDelay:0.6];
        }
    }];
}

#pragma mark 本地存储
- (void)addAReadItem:(ADReadNoticeItem *)aItem
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:aItem];
    [realm commitWriteTransaction];
}

#pragma mark 获取本地数据
- (void)readNoticeRow
{
    self.allReadNoticeIdArray =
    [[ADReadNoticeItem allObjects]sortedResultsUsingProperty:@"messageId" ascending:NO];
}

#pragma mark - InitUI
- (void)addEmptyView
{
    if (!_emptyView) {
        _emptyView = [[ADEmptyView alloc] initWithFrame:CGRectMake(0,  64, SCREEN_WIDTH, SCREEN_HEIGHT - 64*2) title:@"还没有任何消息哦" image:[UIImage imageNamed:@"list_loading_06"]];
        [self.view addSubview:_emptyView];
    }
}

- (void)addTableView
{
    self.myTableView = [[UITableView alloc]initWithFrame:
                        CGRectMake(0, NAVIBAT_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIBAT_HEIGHT)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.myTableView];
    __weak ADNoticeViewController *weekSelf = self;
    [_myTableView addInfiniteScrollingWithActionHandler:^{
        [weekSelf insertrowatbottom];
    }];
    _myTableView.showsInfiniteScrolling = YES;
    _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_refreshControl addTarget:self action:@selector(getData) forControlEvents:UIControlEventValueChanged];
    [_myTableView addSubview:_refreshControl];

}

#pragma mark - uitableView method
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Remove seperator inset
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    // Prevent the cell from inheriting the Table View's margin settings
//    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
//    
//    // Explictly set your cell's layout margins
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _noticeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    ADFeedContentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ADFeedContentListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ADNoticeInfo *info = _noticeArray[indexPath.row];
    cell.isSeen = NO;
    for (ADReadNoticeItem *aItem in self.allReadNoticeIdArray) {
        if ([aItem.messageId isEqualToString:info.messageId]) {
            cell.isSeen = YES;
        }
    }
    cell.refNoticeModel = info;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ADFeedContentListTableViewCell getNoticeCellHeightWithModel:_noticeArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ADFeedContentListTableViewCell *cell = (ADFeedContentListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.isSeen = YES;
    cell.refNoticeModel = _noticeArray[indexPath.row];
    ADNoticeInfo *noticeInfo = _noticeArray[indexPath.row];
    ADReadNoticeItem *aItem = [[ADReadNoticeItem alloc]init];
    aItem.messageId = noticeInfo.messageId;
    [self addAReadItem:aItem];

    NSString *countId =noticeInfo.contentId;
    NSLog(@"type == %@",noticeInfo.type);
    if ([noticeInfo.type intValue] > 4) {
        [self jumpToContentVcWithCid:countId];
    }else{
        [self jumpToSecertVcWithCid:noticeInfo.postId cellIndex:indexPath.row];
    }

}
- (void)jumpToSecertVcWithCid:(NSString *)aCid cellIndex:(NSInteger)cellIndex
{
    ADStoryDetailViewController *aStoryVc = [[ADStoryDetailViewController alloc]init];
    
    aStoryVc.postId = [aCid integerValue];
    aStoryVc.cellIndex = cellIndex;
    [aStoryVc isDeleteReturnBackBlock:^(BOOL isDelete, NSInteger rowIndex) {
        if (isDelete) {
            [ADHelper showToastWithText:@"删除成功，请继续。。。" frame:CGRectMake(0, 64, SCREEN_WIDTH, 50)];
            [self getData];
            [self.myTableView reloadData];
        }
    }];
    [self.navigationController pushViewController:aStoryVc animated:YES];
}

- (void)jumpToContentVcWithCid:(NSString *)aCid
{
    ADLookCommentViewController *aDetialVc = [[ADLookCommentViewController alloc]init];
    aDetialVc.contentId = aCid;
    [self.navigationController pushViewController:aDetialVc animated:YES];
}

#pragma mark - loading
- (void)p_startLoadingAnimation
{
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    
    if (!_customLoadingView) {
        _customLoadingView =[[ADLoadingView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64*2)];
        [self.view addSubview:_customLoadingView];
    }
    
    [_customLoadingView adLodingViewStartAnimating];
}

- (void)p_stopLoadingAnimation
{
    if (_customLoadingView) {
        [_customLoadingView adLodingViewStartAnimating];
        [_customLoadingView removeFromSuperview];
        _customLoadingView = nil;
    }
}

- (void)loadFailedView
{
    if (_failLoadingView.superview == nil) {
        _failLoadingView = [[ADFailLodingView alloc]initWithFrame:
                            CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -40) tapBlock:^{
                                [self getData];
                                _failLoadingView = nil;
                            }];
    }
    
    [_failLoadingView showInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)loginWechatAccount
//{
//    [[ADAccountCenter sharedADAccountCenter] oAuthWeiXinWithTarget:self oauthType:ADLogin
//                                                           success:@selector(loginOAuthSuccessful:)
//                                                           failure:nil];
//}
- (void)insertrowatbottom{
    [[ADMomSecertNetworkHelper shareInstance] getAllNotinfoWithStart:[NSString stringWithFormat:@"%ld",(long)_loadingIndex] size:@"10" SecretFinishBlock:^(NSArray *resultArray) {
        [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_noticeArray addObject:[ADNoticeInfo noticeinfoWithDictionary:obj]];
        }];
        [_myTableView reloadData];
        [_myTableView.infiniteScrollingView stopAnimating];
        _loadingIndex = _noticeArray.count;
    } failed:^{
        [_myTableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)loginOAuthSuccessful:(NSString *)iconUrl
{
    [[NSNotificationCenter defaultCenter] postNotificationName:loginWeiSucessNotify object:nil];
    [self.loginView removeFromSuperview];
    
    [ADToastHelp dismissSVProgress];
    [self getData];
}

@end