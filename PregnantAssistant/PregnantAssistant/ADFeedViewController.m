//
//  ADFeedViewController.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/19.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADFeedViewController.h"
#import "UIFont+ADFont.h"
#import "ADFeedNetworkHelper.h"
#import "ADFeedContentListModel.h"
#import "ADFeedContentListTableViewCell.h"
#import "ADFeedDetailsViewController.h"
#import "ADFeedRecommendViewController.h"
#import "ADLoadingView.h"
#import "SVPullToRefresh.h"
#import "ADFailLodingView.h"
#import "ADEmptyView.h"
#import "ADImageButton.h"
@interface ADFeedViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger _indexY;
    NSMutableArray *_dataArray;
    NSMutableArray *_cellArray;
    UITableView *_tabelView;
    ADEmptyView *_emptyView;
    ADLoadingView *_loadingVIew;
    NSInteger _loaddataIndex;
    UIRefreshControl *_refreshControl;
    ADFailLodingView *_faileLodingView;
    UIView *_headerView;
    UIView *_BGEmptyView;
    BOOL _loading;
    ADImageButton *_feedAddButton;
}

@end

@implementation ADFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSelf];
    [self layoutUI];
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_faileLodingView) {
        [_faileLodingView removeFromSuperview];
        _faileLodingView = nil;
    }
    [MobClick event:media_rss_list_load];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_loadingVIew stopAnimation];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - config
- (void)configSelf{
     _cellArray = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:updateFeedListNotification object:nil];
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(loadData) name:loginWeiSucessNotify object:nil];
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(loadData) name:logoutNotification object:nil];

    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    self.myTitle = @"我的订阅";
    _loaddataIndex = 0;
}

- (void)addrefresh{
    _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [_tabelView addSubview:_refreshControl];
    
    __weak ADFeedViewController *weekSelf = self;
    [_tabelView addInfiniteScrollingWithActionHandler:^{
        [weekSelf insertrowatbottom];
    }];
    _tabelView.showsInfiniteScrolling = YES;
}

#pragma mark - 初始化UI
#define FEEDADDBUTTON_HEIGHT 50
#define FEEDADDBUTTON_IMAGE_HEIGHT 16

- (void)layoutUI{
    NSLog(@"xgDeesjdklfsdk: %@",[[NSUserDefaults standardUserDefaults]xgDeviceToken]);

    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    [self.view addSubview:_tabelView];
    [self addrefresh];
    //隐藏TabViewFootView 多余的线
    UIView *cellsepView = [UIView new];
    cellsepView.backgroundColor = [UIColor clearColor];
    [_tabelView setTableFooterView:cellsepView];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FEEDADDBUTTON_HEIGHT)];
    
    
    _feedAddButton = [[ADImageButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FEEDADDBUTTON_HEIGHT) title:@"  订阅加丁号" titleFont:[UIFont parentToolTitleViewDetailHeiFontWithSize:14] titleTextColor:[UIColor btn_green_bgColor] image:[UIImage imageNamed:@"订阅加"]];
    _feedAddButton.center = CGPointMake(SCREEN_WIDTH/2.0, FEEDADDBUTTON_HEIGHT/2.0);
    [_feedAddButton addTarget:self action:@selector(feedAddButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_feedAddButton];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(14, FEEDADDBUTTON_HEIGHT - 0.5, SCREEN_WIDTH - 28, 0.5)];
    [lineView setBackgroundColor:[UIColor separator_gray_line_color]];
    [_headerView addSubview:lineView];
}

#define IMAVEVIEW_WIDTH 101
#define IMAGEVIEW_HEIGHT 101
#define VIEW_INDEX_Y 114
- (void)addEmptyView{
    if (!_emptyView) {
        _tabelView.showsInfiniteScrolling = NO;
        _BGEmptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _BGEmptyView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:_BGEmptyView];
        _emptyView = [[ADEmptyView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 50 *2 - NAVIBAT_HEIGHT) title:@"还没有任何订阅哦\n请点击订阅" image:[UIImage imageNamed:@"list_loading_06"]];
        [_headerView addSubview:_emptyView];
        _tabelView.tableHeaderView = _headerView;
    }
}

- (void)addADFaildLoadingVIew{
    if (!_faileLodingView) {
        _faileLodingView = [[ADFailLodingView alloc] initWithFrame:CGRectMake(0, VIEW_INDEX_Y, SCREEN_WIDTH, SCREEN_HEIGHT - VIEW_INDEX_Y * 2) tapBlock:^{
            [self loadData];
            [_faileLodingView removeFromSuperview];
            _faileLodingView = nil;
        }];
    }
    [_faileLodingView showInView:self.view];
}

- (void)addloadingView{
    if (!_loadingVIew) {
        _loadingVIew = [[ADLoadingView alloc] initWithFrame:CGRectMake(0, NAVIBAT_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIBAT_HEIGHT - 50)];
        _loadingVIew.userInteractionEnabled = YES;
        [self.view addSubview:_loadingVIew];
    }
}

- (void)removeAllEmptyView{
    [_BGEmptyView removeFromSuperview];
    _BGEmptyView = nil;
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    [_loadingVIew stopAnimation];
    _loadingVIew = nil;
}

#pragma mark - 获取数据
- (void)loadData{
    
    if (_dataArray.count == 0 && !_loading) {
        [self addloadingView];
        [_loadingVIew adLodingViewStartAnimating];
        _loading = YES;
    }
    [ADFeedNetworkHelper getFeedArticlListWithStart:@"0" size:@"20" CompliteBlock:^(NSArray *resArray, BOOL iscomplite) {
        _tabelView.hidden = NO;
        [_dataArray removeAllObjects];
        if (iscomplite) {
            for (NSDictionary *dict in resArray) {
                [_dataArray addObject:[ADFeedContentListModel getFeedContentListmodelWithDict:dict]];
            }
            _loaddataIndex = _dataArray.count;
        }
        if (_dataArray.count == 0) {
            [_feedAddButton setTitle:@"  订阅加丁号" forState:UIControlStateNormal];
            _tabelView.showsInfiniteScrolling = NO;
            [self performSelector:@selector(empthLoad) withObject:nil afterDelay:0.8];
        }else{
            [_feedAddButton setTitle:@"  订阅更多加丁号" forState:UIControlStateNormal];
            [self removeAllEmptyView];
            _tabelView.showsInfiniteScrolling = YES;
            _tabelView.tableHeaderView = _headerView;
         }
        [_tabelView reloadData];
        [_refreshControl endRefreshing];
    } failure:^(NSError *error) {
        [_refreshControl endRefreshing];
        if (_dataArray.count == 0) {
            _tabelView.hidden = YES;
            [self performSelector:@selector(failureLoad) withObject:nil afterDelay:0.8];
        }
    }];
    
}

- (void)empthLoad{
    [_loadingVIew stopAnimation];
    _loadingVIew = nil;
    [self addEmptyView];
}

- (void)failureLoad{
    [_loadingVIew stopAnimation];
    _loadingVIew = nil;
    [self addADFaildLoadingVIew];
}

#pragma mark - buttonClicked
- (void)feedAddButtonClick:(UIButton *)button{
    ADFeedRecommendViewController *vc = [[ADFeedRecommendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    ADFeedContentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ADFeedContentListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.refModel = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ADFeedContentListTableViewCell getCellHeightWithModel:_dataArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ADFeedDetailsViewController *fdVC = [[ADFeedDetailsViewController alloc] init];
    ADFeedContentListModel *model = _dataArray[indexPath.row];
    fdVC.mediaId = model.mediaId;
    [self.navigationController pushViewController:fdVC animated:YES];
}

#pragma mark - 上啦加载更多
- (void)insertrowatbottom{
    [ADFeedNetworkHelper getFeedArticlListWithStart:[NSString stringWithFormat:@"%ld",(long)_loaddataIndex] size:@"20" CompliteBlock:^(NSArray *resArray, BOOL iscomplite) {
        if (iscomplite) {
            for (NSDictionary *dict in resArray) {
                [_dataArray addObject:[ADFeedContentListModel getFeedContentListmodelWithDict:dict]];
            }
        }
        _loaddataIndex = _dataArray.count;
        [_tabelView reloadData];
        [_tabelView.infiniteScrollingView stopAnimating];
    } failure:^(NSError *error) {
        [_tabelView.infiniteScrollingView stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
