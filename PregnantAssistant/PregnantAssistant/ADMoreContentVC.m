//
//  ADMoreContentVC.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/8/10.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADMoreContentVC.h"
#import "ADSearchNetwork.h"
#import "ADFeedRecommendTableViewCell.h"
#import "ADSearchModel.h"
#import "SVPullToRefresh.h"
#import "ADFeedNetworkHelper.h"
#import "PregnantAssistant-Swift.h"
#import "ADLoadingView.h"
#import "ADFailLodingView.h"
#import "ADEmptyView.h"
#import "ADLoginControl.h"
#import "ADNavigationController.h"

@interface ADMoreContentVC ()<ADFeedContentCellDelegate>

@end

@implementation ADMoreContentVC
{
    UISearchBar *_searchBar;
    UITableView *_myTableView;
    NSMutableArray *_dataArray;
//    NSString *_currentKeyword;
    
    ADFailLodingView *_faileLodingView;
    ADLoadingView *_loadingView;
    ADEmptyView *_emptyView;
    BOOL _appeared;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    _dataArray = [NSMutableArray array];
    
    UIButton *cancelItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 44)];
    [cancelItemButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelItemButton setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    cancelItemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancelItemButton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [cancelItemButton setTitleColor:[UIColor btn_green_bgColor] forState:UIControlStateNormal];
    
    CGFloat size = 14;
    if (SCREEN_WIDTH == 320) {
        size = 12;
    }
    
    cancelItemButton.titleLabel.font = [UIFont ADTraditionalFontWithSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelItemButton];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f,0.0f,200.0f,44.0f)];
    _searchBar.delegate = self;
    _searchBar.text = _currentKeyword;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [_searchBar setPlaceholder:@"搜索"];
    
    self.navigationItem.titleView = _searchBar;

    [self loadTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviveRssNoti:) name:updateFeedListNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addingLoginSuccess) name:loginWeiSucessNotify object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddingLoginCancel) name:cancelLogin object:nil];
    
    if (self.isMedia) {
        [MobClick event:search_media_load];
    }else{
        [MobClick event:search_content_normal_load];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_appeared) {
        _appeared = YES;
        if (!_currentKeyword) {
            [_searchBar becomeFirstResponder];
        }
    }
}

- (void)reviveRssNoti:(NSNotification *)noti
{
    if (!self.isMedia) {
        return;
    }
    NSString *contentStr = noti.object;
    if (![contentStr isKindOfClass:[NSString class]]) {
        return;
    }
    
    NSArray *contentArray = [contentStr componentsSeparatedByString:@" "];
    NSString *mediaId = [contentArray firstObject];
    NSString *isRss = [contentArray lastObject];
    
    if ([mediaId isKindOfClass:[NSString class]]) {
        if (_dataArray.count == 0) {
            return;
        }
        
        for (ADFeedContentListModel *model in _dataArray) {
            if ([model.mediaId isEqualToString:mediaId]) {
                model.isRss = isRss;
                [_myTableView reloadData];
                [self refreshView];
                break;
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    __weak ADMoreContentVC *weakSelf = self;
    [_myTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    if (_currentKeyword == nil) {
        _myTableView.showsInfiniteScrolling = NO;
    }else{
        _myTableView.showsInfiniteScrolling = YES;
        [self getFirstData];

    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _myTableView.showsInfiniteScrolling = YES;

    [searchBar resignFirstResponder];
    _currentKeyword = searchBar.text;
   
    [self getFirstData];
}

- (void)getFirstData
{
    if (_myTableView.tableHeaderView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, SCREEN_WIDTH - 28, 20)];
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:16];
        
        if (self.isMedia) {
            label.text = @"相关加丁号";
        }else{
            label.text = @"相关文章";
        }
        
        [view addSubview:label];
        _myTableView.tableHeaderView = view;
    }
    
    [self addLoadingViewAndStart];
    [_myTableView setContentOffset:CGPointMake(0, -64) animated:NO];

    [self getDataFromStartPos:@"0" length:@"20" success:^{
        [_dataArray removeAllObjects];
    } failure:^{
        [_dataArray removeAllObjects];
    }];
}

- (void)getDataFromStartPos:(NSString *)startPos length:(NSString *)length success:(void (^) (void))successBlock failure:(void (^) (void))failureBlock
{
    [_searchBar resignFirstResponder];
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    [_faileLodingView removeFromSuperview];
    
    
    ADSearchEntity entity = ADSearchEntityContent;
    if (self.isMedia) {
        entity = ADSearchEntityMedia;
    }
    NSString *firstId = @"";
    if ([startPos isEqualToString:@"0"]) {

    }else if (self.isMedia) {
        ADFeedContentListModel *model = [_dataArray firstObject];
        firstId = model.mediaId;
    }else{
        ADMomContentInfo *model = [_dataArray firstObject];
        firstId = model.contentId;
    }
    [ADSearchNetwork getSearchListWithEntity:entity keyword:_currentKeyword startPos:startPos length:length firstId:firstId success:^(id resObject) {
        if (successBlock) {
            successBlock();
        }
        [self analysisResponseObject:resObject];
        
        [self addLoadingViewStopLoad];
        
        if(_dataArray.count == 0){
            [self addEmptyViewWithText:_currentKeyword];
        }
    } failure:^(NSError *error) {
        if (failureBlock) {
            failureBlock();
        }
        
        if ([startPos isEqualToString:@"0"] && _dataArray.count == 0) {
            [self addADFaildLoadingVIew];
        }
    }];
}

- (void)refreshView
{
    [self getDataFromStartPos:@"0" length:[NSString stringWithFormat:@"%ld",(long)_dataArray.count] success:^{
        [_dataArray removeAllObjects];
    } failure:^{
        
    }];
}

- (void)loadMore
{
    [self getDataFromStartPos:[NSString stringWithFormat:@"%ld",(long)_dataArray.count] length:@"20" success:^{
        [_myTableView.infiniteScrollingView stopAnimating];
    } failure:^{
        [_myTableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)analysisResponseObject:(id)resObject
{
    NSDictionary *contentDic = [resObject objectForKey:@"content"];
    NSArray *contentArray = [contentDic objectForKey:@"list"];
    NSDictionary *mediaDic =[resObject objectForKey:@"media"];
    NSArray *mediaArray = [mediaDic objectForKey:@"list"];
    
    if (self.isMedia && mediaArray && ![mediaArray isEqual:[NSNull null]] && mediaArray.count != 0) {
        
        for (NSDictionary *obj in mediaArray) {
            ADFeedContentListModel *model = [ADFeedContentListModel getFeedContentListmodelWithDict:obj];
            [_dataArray addObject:model];
        }
    }
    
    if (!self.isMedia && contentArray && ![contentArray isEqual:[NSNull null]] && contentArray.count != 0) {
        for (NSDictionary *dic in contentArray) {
            ADMomContentInfo *info = [[ADMomContentInfo alloc] initWithModelObject:dic];
            [_dataArray addObject:info];
        }
    }

    [_myTableView reloadData];
}

- (void)cancelSearch{
    [self leftItemMethod];
}

#pragma mark - tableView代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    NSArray *array = _dataArray;
    if (self.isMedia) {
        
        ADFeedContentListModel *model = [array objectAtIndex:indexPath.row];
        height = [ADFeedRecommendTableViewCell getFeedRecommendWithModel:model];
    }
    else{
        
        height = 34 + 80.0;
    }
    
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isMedia) {
        
        return [self tableView:tableView getMediaCellAtIndexPath:indexPath];
    }
    
    return [self tableView:tableView getContentCellAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView getMediaCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = _dataArray;
    
    static NSString *cellName = @"ADFeedRecommendTableViewCell";
    ADFeedRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ADFeedRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        cell.delegate = self;
    }
    
    ADFeedContentListModel *mediaModel = [array objectAtIndex:indexPath.row];
    cell.refreshModel = mediaModel;
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView getContentCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = _dataArray;
    ADMomContentInfo *contentModel = [array objectAtIndex:indexPath.row];
    static NSString *cellName = @"ADMomLookContentTableViewCell";
    ADMomLookContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ADMomLookContentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        cell.fromSearch = YES;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(14, 34 + 80.0 - 0.6, SCREEN_WIDTH - 28, 0.5)];
        lineView.backgroundColor = [UIColor separator_gray_line_color];
        [cell addSubview:lineView];
    }
    
    cell.aMomLookInfo = contentModel;
    if (contentModel.imgUrls.count > 0) {
        NSString *urlString = [contentModel.imgUrls objectAtIndex:0];
        [cell.thumbImgView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil];
    }else{
        cell.thumbImgView.image = [UIImage imageNamed:@"加丁号文章默认"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self resignKeyBoard];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.isMedia) {
        ADMomContentInfo *contentModel = [_dataArray objectAtIndex:indexPath.row];
        ADMomLookContentDetailVC *aDetialVc = [[ADMomLookContentDetailVC alloc]init];
        aDetialVc.contentId = contentModel.contentId;
        [self.navigationController pushViewController:aDetialVc animated:YES];
    }else {
        ADFeedContentListModel *mediaModel = [_dataArray objectAtIndex:indexPath.row];
        ADFeedDetailsViewController *dvc = [[ADFeedDetailsViewController alloc] init];
        dvc.mediaId = mediaModel.mediaId;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}
- (void)leftItemMethod
{
    [_searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 订阅代理
- (void)tableViewCell:(ADFeedRecommendTableViewCell *)cell didClickedRssButton:(UIButton *)button
{
    [self resignKeyBoard];
    
    if ([[NSUserDefaults standardUserDefaults]addingToken].length == 0) {
        [self jumpToLoginVcWithCompletion:nil];
        return;
    }
    
    button.selected = !button.selected;
    if (button.selected) {
        [[ADFeedNetworkHelper shareManager] subscribeFeedMediaWIthMediaId:cell.refreshModel.mediaId compliteBlock:^(BOOL isSubcribe) {
            if (isSubcribe) {
                NSString *contentStr = [NSString stringWithFormat:@"%@ %@",cell.refreshModel.mediaId,@"1"];
                [[NSNotificationCenter defaultCenter] postNotificationName:updateFeedListNotification object:contentStr];
            }
            else{
                [ADToastHelp showSVProgressToastWithError:@"订阅失败"];
                button.selected = !button.selected;
            }
            
        }];
        
    }else{
        [[ADFeedNetworkHelper shareManager] desSubscribeFeedMediaWIthMediaId:cell.refreshModel.mediaId compliteBlock:^(BOOL desSubcribe) {
            if (desSubcribe) {
                NSString *contentStr = [NSString stringWithFormat:@"%@ %@",cell.refreshModel.mediaId,@"0"];
                [[NSNotificationCenter defaultCenter] postNotificationName:updateFeedListNotification object:contentStr];
            }else{
                [ADToastHelp showSVProgressToastWithError:@"取消订阅失败"];
                button.selected = !button.selected;
            }
           
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self resignKeyBoard];
}

- (void)resignKeyBoard{
    if (_searchBar) {
        [_searchBar resignFirstResponder];
    }
}

- (void)addADFaildLoadingVIew{
    if (!_faileLodingView) {
        _faileLodingView = [[ADFailLodingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tapBlock:^{
            [_faileLodingView removeFromSuperview];
            _faileLodingView = nil;
            [self getFirstData];
        }];
    }
    [_faileLodingView showInView:self.view];
}

- (void)addLoadingViewAndStart{
    if (!_loadingView) {
        _loadingView = [[ADLoadingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_loadingView];
        [_loadingView adLodingViewStartAnimating];
    }
}

- (void)addLoadingViewStopLoad
{
    [_loadingView adLodingViewStopAnimating];
    [_loadingView removeFromSuperview];
    _loadingView = nil;
}

- (void)addEmptyViewWithText:(NSString *)text{
    if (!_emptyView&&![text isEqualToString:@""]) {
        _emptyView = [[ADEmptyView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, SCREEN_HEIGHT) title:[NSString stringWithFormat:@"没有找到“”相关结果"] image:[UIImage imageNamed:@"addingSearch"]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"没有找到“%@”相关结果",text]];
        [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x00DDBA) range:NSMakeRange(5, text.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont parentToolTitleViewDetailHeiFontWithSize:15] range:NSMakeRange(0, str.length)];
        [_emptyView setAttributeString:str];
        [self.view addSubview:_emptyView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
        [_emptyView addGestureRecognizer:tap];
    }
}

- (void)jumpToLoginVcWithCompletion:(void (^)(void))aFinishBlock
{
    ADLoginControl *loginVc = [[ADLoginControl alloc] init];
    loginVc.subTitle = @"订阅喜欢的加丁号，看到最新的文章";
    ADNavigationController *nc = [[ADNavigationController alloc] initWithRootViewController:loginVc];
    [ADHelper presentVc:nc atVc:self hiddenNavi:YES loginControl:loginVc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
