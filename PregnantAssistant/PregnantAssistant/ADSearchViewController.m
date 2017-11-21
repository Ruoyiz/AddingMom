//
//  ADSearchViewController.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/8/7.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADSearchViewController.h"
#import "ADSearchNetwork.h"
#import "ADSearchModel.h"
#import "ADFeedRecommendTableViewCell.h"
#import "ADTool.h"
#import "ADMoreContentVC.h"
#import "ADMomLookContentDetailVC.h"
#import "ADPregNotifyViewController.h"
#import "ADHtmlToolViewController.h"
#import "ADFeedNetworkHelper.h"
#import "PregnantAssistant-Swift.h"
#import "ADLoadingView.h"
#import "ADFailLodingView.h"
#import "ADEmptyView.h"
#import "ADLoginControl.h"
#import "ADNavigationController.h"

#define content @"content"
#define media @"media"
#define tool @"tool"

@interface ADSearchViewController ()<ADFeedContentCellDelegate>

@end

@implementation ADSearchViewController{
    UISearchBar *_searchBar;
    ADEmptyView *_noteView;
    UITableView *_myTableView;
    NSMutableArray *_dataArray;
    NSString *_currentKeyword;
    
    ADFailLodingView *_faileLodingView;
    ADLoadingView *_loadingView;
    ADEmptyView *_emptyView;
    
    BOOL _appeared;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    _dataArray = [NSMutableArray array];
    
    UIButton *cancelItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 44)];
    [cancelItemButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelItemButton setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    cancelItemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancelItemButton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [cancelItemButton setTitleColor:[UIColor btn_green_bgColor] forState:UIControlStateNormal];
    
    cancelItemButton.titleLabel.font = [UIFont ADTraditionalFontWithSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelItemButton];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f,0.0f,200.0f,44.0f)];
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [_searchBar setPlaceholder:@"搜索"];
    self.navigationItem.titleView = _searchBar;
    
    [self loadTableView];
    [self loadNoteView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviveRssNoti:) name:updateFeedListNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addingLoginSuccess) name:loginWeiSucessNotify object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddingLoginCancel) name:cancelLogin object:nil];
}

//- (void)addingLoginSuccess
//{
//    if (self.view.superview != nil) {
//        [self.navigationController setNavigationBarHidden:NO animated:NO];
//        [self refreshView];
//    }
//}
//
//- (void)AddingLoginCancel
//{
//    if (self.view.superview != nil) {
//        [self.navigationController setNavigationBarHidden:NO animated:NO];
//    }
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_appeared) {
        [_searchBar becomeFirstResponder];
        _appeared = YES;
    }
}

- (void)addADFaildLoadingVIew{
    if (!_faileLodingView) {
        _faileLodingView = [[ADFailLodingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tapBlock:^{
            [_faileLodingView removeFromSuperview];
            _faileLodingView = nil;
            [self getStartData];
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

- (void)loadTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;

    [self.view addSubview:_myTableView];
}

- (void)loadNoteView
{
    UIView *backView = [self.view viewWithTag:333];
    if (backView == nil) {
        CGFloat startPosY = 123;
        if (SCREEN_HEIGHT == 480) {
            startPosY = 80;
        }
        _noteView = [[ADEmptyView alloc] initWithFrame:CGRectMake(0,startPosY, SCREEN_WIDTH, 200) title:nil image:[UIImage imageNamed:@"searchNote"]];
        _noteView.backgroundColor = [UIColor clearColor];
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backView.backgroundColor = [UIColor clearColor];
        [backView addSubview:_noteView];
        backView.tag = 333;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
        [backView addGestureRecognizer:tap];
    }
    [self.view addSubview:backView];
}

- (void)removeBackView
{
    [_noteView.superview removeFromSuperview];
    _myTableView.backgroundColor = [UIColor cellSharpBackColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)cancelSearch{
    [self leftItemMethod];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self removeBackView];
    _currentKeyword = searchBar.text;
    [self getStartData];
}

- (void)getStartData
{
    [_searchBar resignFirstResponder];
    [self addLoadingViewAndStart];
    [_emptyView removeFromSuperview];
    [_faileLodingView removeFromSuperview];
    _emptyView = nil;
    
    [ADSearchNetwork getSearchListWithEntity:ADSearchEntityAll keyword:_currentKeyword startPos:@"0" length:@"10" firstId:nil success:^(id resObject) {
        [MobClick event:search_load];
        [_myTableView setContentOffset:CGPointMake(0, -64) animated:NO];
        [self analysisResponseObject:resObject];
        [self addLoadingViewStopLoad];
        if(_dataArray.count == 0){
            [self addEmptyViewWithText:_currentKeyword];
        }
    } failure:^(NSError *error) {
        
        [self performSelector:@selector(failuredLoad) withObject:nil afterDelay:1];
    }];
}

- (void)failuredLoad
{
    [self addLoadingViewStopLoad];
    [_dataArray removeAllObjects];
    [_myTableView reloadData];
    [self addADFaildLoadingVIew];
}

- (void)reviveRssNoti:(NSNotification *)noti
{
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
        
        ADSearchModel *searchModel = [_dataArray firstObject];
        if (searchModel.entity != ADSearchResponseEntityMedia) {
            return;
        }
        
        for (ADFeedContentListModel *model in searchModel.dataArray) {
            if ([model.mediaId isEqualToString:mediaId]) {
                model.isRss = isRss;
                [_myTableView reloadData];
                [self refreshView];
                break;
            }
        }
    }
}

- (void)refreshView
{
    [_searchBar resignFirstResponder];
    [ADSearchNetwork getSearchListWithEntity:ADSearchEntityAll keyword:_currentKeyword startPos:@"0" length:@"10" firstId:nil success:^(id resObject) {
        [self analysisResponseObject:resObject];
    } failure:^(NSError *error) {
        
    }];
}

- (void)analysisResponseObject:(id)resObject
{
    [_dataArray removeAllObjects];
    NSDictionary *contentDic = [resObject objectForKey:@"content"];
    NSArray *contentArray = [contentDic objectForKey:@"list"];
    
    NSDictionary *toolDic = [resObject objectForKey:@"tool"];
    NSArray *toolArray = [toolDic objectForKey:@"list"];
    
    NSDictionary *mediaDic =[resObject objectForKey:@"media"];
    NSArray *mediaArray = [mediaDic objectForKey:@"list"];
    
    if (mediaArray && ![mediaArray isEqual:[NSNull null]] && mediaArray.count != 0) {
        NSMutableArray *mediaModelArray = [NSMutableArray array];
        
        for (NSDictionary *obj in mediaArray) {
            ADFeedContentListModel *model = [ADFeedContentListModel getFeedContentListmodelWithDict:obj];
            [mediaModelArray addObject:model];
        }
        
        ADSearchModel *searchModel = [[ADSearchModel alloc] init];
        searchModel.entity = ADSearchResponseEntityMedia;
        searchModel.dataArray = mediaModelArray;
        [_dataArray addObject:searchModel];
    }
    
    if (toolArray && ![toolArray isEqual:[NSNull null]] && toolArray.count != 0) {
        NSMutableArray *toolModelArray = [NSMutableArray array];
        for (NSDictionary *subDic in toolArray) {
            ADToolModel *model = [ADToolModel getToolModelFromObject:subDic];
            [toolModelArray addObject:model];
        }
        
        ADSearchModel *searchModel = [[ADSearchModel alloc] init];
        searchModel.entity = ADSearchResponseEntityTool;
        searchModel.dataArray = toolModelArray;
        [_dataArray addObject:searchModel];
    }
    
    if (contentArray && ![contentArray isEqual:[NSNull null]] && contentArray.count != 0) {
        NSMutableArray *contentModelArray = [NSMutableArray array];
        for (NSDictionary *dic in contentArray) {
            ADMomContentInfo *info = [[ADMomContentInfo alloc] initWithModelObject:dic];
            [contentModelArray addObject:info];
        }
        
        ADSearchModel *searchModel = [[ADSearchModel alloc] init];
        searchModel.entity = ADSearchResponseEntityContent;
        searchModel.dataArray = contentModelArray;
        [_dataArray addObject:searchModel];
    }
    
    [_myTableView reloadData];
}


#pragma mark - tableView代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    
    ADSearchModel *model = [_dataArray objectAtIndex:indexPath.section];
    
    NSArray *array = model.dataArray;
    ADSearchResponseEntity entity = model.entity;
    
    if (entity == ADSearchResponseEntityMedia) {
        
        ADFeedContentListModel *model = [array objectAtIndex:indexPath.row];
        height = [ADFeedRecommendTableViewCell getFeedRecommendWithModel:model];
    }else if (entity == ADSearchResponseEntityTool){
        ADSearchModel *model = [_dataArray objectAtIndex:indexPath.section];
        NSArray *array = model.dataArray;
        
        CGFloat toolWidth = 80;
        NSInteger number = 4;
        if (SCREEN_WIDTH == 320) {
            number = 3;
        }
        
        height = toolWidth * ((array.count - 1) / number + 1) + 15.0 * ((array.count - 1)/ number + 2);
    }else{
 
        height = 34 + 80.0;
    }
    
    return height;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ADSearchModel *model = [_dataArray objectAtIndex:section];
    if (model.entity == ADSearchResponseEntityTool) {
        
        return 1;
    }
    
    NSMutableArray *array = model.dataArray;
    return array.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, SCREEN_WIDTH - 28, 20)];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    
    ADSearchModel *model = [_dataArray objectAtIndex:section];
    if (model.entity == ADSearchResponseEntityMedia) {
        label.text = @"相关加丁号";
    }else if (model.entity == ADSearchResponseEntityTool){
        label.text = @"相关工具";
    }else{
        label.text = @"相关文章";
    }
    
    [view addSubview:label];
    
    if (section != 0) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -0.1, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = [UIColor separator_gray_line_color];
        [view addSubview:lineView];
    }
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 0);
    [button setTitleColor:[UIColor btn_green_bgColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont ADTraditionalFontWithSize:14];
    [button setImage:[UIImage imageNamed:@"greenSearch"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(moreSearchContent:) forControlEvents:UIControlEventTouchUpInside];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor separator_gray_line_color];
    button.backgroundColor = [UIColor whiteColor];
    ADSearchModel *model = [_dataArray objectAtIndex:section];
    if (model.entity == ADSearchResponseEntityMedia) {
        
        [button setTitle:@"  搜索更多相关加丁号" forState:UIControlStateNormal];
        button.tag = 1;
        [view addSubview:button];
        [button addSubview:lineView];

    }else if (model.entity == ADSearchResponseEntityTool){
        
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
        lineView.center = CGPointMake(SCREEN_WIDTH/2.0, 0.2);
    }else{
        [button setTitle:@"  搜索更多相关文章" forState:UIControlStateNormal];
        button.tag = 3;
        [view addSubview:button];
        [button addSubview:lineView];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    ADSearchModel *model = [_dataArray objectAtIndex:section];
    if (model.entity == ADSearchResponseEntityTool) {
        
        return 20;
    }
    
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADSearchModel *model = [_dataArray objectAtIndex:indexPath.section];

    ADSearchResponseEntity entity = model.entity;
    
    if (entity == ADSearchResponseEntityMedia) {
        
        return [self tableView:tableView getMediaCellAtIndexPath:indexPath];
    }else if (entity == ADSearchResponseEntityTool){
        
        return [self tableView:tableView getToolCellAtIndexPath:indexPath];
    }
    
    return [self tableView:tableView getContentCellAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView getMediaCellAtIndexPath:(NSIndexPath *)indexPath
{
    ADSearchModel *model = [_dataArray objectAtIndex:indexPath.section];
    NSArray *array = model.dataArray;
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView getToolCellAtIndexPath:(NSIndexPath *)indexPath
{
    ADSearchModel *model = [_dataArray objectAtIndex:indexPath.section];
    NSArray *array = model.dataArray;
    
    static NSString *cellName = @"ADToolTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat toolWidth = 80;
    NSInteger number = 4;
    if (SCREEN_WIDTH == 320) {
        number = 3;
    }
    CGFloat space = (SCREEN_WIDTH - number * toolWidth - 14 * 2.0) / (number - 1);
    for (int i = 0; i < array.count; i ++) {
        
        CGFloat x = i % number;
        CGFloat y = i / number;
        
        ADToolModel *model = [array objectAtIndex:i];
        UIButton *button = [self getToolViewWithToolModel:model toolWidth:toolWidth];
        button.center = CGPointMake(14 + button.frame.size.width / 2.0 + (button.frame.size.width + space) * x, 15 + toolWidth / 2.0 + (toolWidth+15) * y);
        [cell.contentView addSubview:button];
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView getContentCellAtIndexPath:(NSIndexPath *)indexPath
{
    ADSearchModel *model = [_dataArray objectAtIndex:indexPath.section];
    NSArray *array = model.dataArray;
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
    ADSearchModel *model = [_dataArray objectAtIndex:indexPath.section];
    
    ADSearchResponseEntity entity = model.entity;
    
    if (entity == ADSearchResponseEntityContent) {
        ADMomContentInfo *contentModel = [model.dataArray objectAtIndex:indexPath.row];
        ADMomLookContentDetailVC *aDetialVc = [[ADMomLookContentDetailVC alloc]init];
        aDetialVc.contentId = contentModel.contentId;
        [self.navigationController pushViewController:aDetialVc animated:YES];
    }else if (entity == ADSearchResponseEntityMedia){
        ADFeedContentListModel *mediaModel = [model.dataArray objectAtIndex:indexPath.row];
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

- (UIButton *)getToolViewWithToolModel:(ADToolModel *)model toolWidth:(CGFloat)toolWidth
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, toolWidth, toolWidth)];
    button.backgroundColor = [UIColor clearColor];
    button.tag = [model.toolId integerValue];
    
    CGFloat size = 12;
//    if (SCREEN_WIDTH == 320) {
//        size = 10;
//    }
    NSMutableAttributedString *attStr = [ADHelper getEMAttributeStringFromEmString:model.toolName font:[UIFont ADTraditionalFontWithSize:size] color:[UIColor darkGrayColor] highlightColor:[UIColor btn_green_bgColor]];
    
    CGFloat iconWidth = toolWidth - 25;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconWidth, iconWidth)];
    imageView.center = CGPointMake(toolWidth / 2.0, iconWidth / 2.0);
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@大", attStr.string]];
    imageView.image = image;
    [button addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, toolWidth, 20)];
    label.center = CGPointMake(toolWidth / 2.0, imageView.center.y + iconWidth - 8);
    label.text = model.toolName;
    
    label.attributedText = attStr;
    label.textAlignment = NSTextAlignmentCenter;
    [button addSubview:label];
    
    
    [button addTarget:self action:@selector(toolButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - 订阅代理
- (void)tableViewCell:(ADFeedRecommendTableViewCell *)cell didClickedRssButton:(UIButton *)button
{
    [self resignKeyBoard];
    
    if ([[NSUserDefaults standardUserDefaults] addingToken].length == 0) {
        if ([[NSUserDefaults standardUserDefaults].addingToken isEqualToString:@""]) {
            [self jumpToLoginVcWithCompletion:nil];
            return;
        }
        return;
    }
    button.selected = !button.selected;
    if (button.selected) {
        [[ADFeedNetworkHelper shareManager] subscribeFeedMediaWIthMediaId:cell.refreshModel.mediaId compliteBlock:^(BOOL isSubcribe) {
            if (isSubcribe) {
//                [self refreshView];
                [[NSNotificationCenter defaultCenter] postNotificationName:updateFeedListNotification object:nil];
                //[[NSNotificationCenter defaultCenter] postNotificationName:feedRssChangedNoti object:@"1"];
            }
            else{
                [ADToastHelp showSVProgressToastWithError:@"订阅失败"];
                button.selected = !button.selected;
            }
        }];
        
    }else{
        [[ADFeedNetworkHelper shareManager] desSubscribeFeedMediaWIthMediaId:cell.refreshModel.mediaId compliteBlock:^(BOOL desSubcribe) {
            if (desSubcribe) {
//                [self refreshView];
                [[NSNotificationCenter defaultCenter] postNotificationName:updateFeedListNotification object:nil];
               // [[NSNotificationCenter defaultCenter] postNotificationName:feedRssChangedNoti object:@"1"];
            }else{
                [ADToastHelp showSVProgressToastWithError:@"取消订阅失败"];
                button.selected = !button.selected;
            }
        }];
    }
}

- (void)moreSearchContent:(UIButton *)button
{
    [self resignKeyBoard];
    if (button.tag == 1) {
        ADMoreContentVC *contentVC = [[ADMoreContentVC alloc] init];
        contentVC.isMedia = YES;
        contentVC.currentKeyword = _currentKeyword;
        [self.navigationController pushViewController:contentVC animated:YES];
    }else{
        
        ADMoreContentVC *contentVC = [[ADMoreContentVC alloc] init];
        contentVC.isMedia = NO;
        contentVC.currentKeyword = _currentKeyword;
        [self.navigationController pushViewController:contentVC animated:YES];
    }
}

- (void)toolButtonClicked:(UIButton *)button
{
    [self resignKeyBoard];
    NSString *toolId = [NSString stringWithFormat:@"%ld",(long)button.tag];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self resignKeyBoard];
}

- (void)resignKeyBoard{
    if (_searchBar) {
        [_searchBar resignFirstResponder];
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
