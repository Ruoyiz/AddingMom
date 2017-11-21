//
//  ADFeedRecommendViewController.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/23.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADFeedRecommendViewController.h"
#import "ADFeedNetworkHelper.h"
#import "ADFeedRecommendTableViewCell.h"
#import "ADFeedContentListModel.h"
#import "ADFeedDetailsViewController.h"
#import "ADFeedDetailsViewController.h"
#import "ADLoadingView.h"
#import "ADNavigationController.h"
#import "SVPullToRefresh.h"
#import "ADEmptyView.h"
#import "UIFont+ADFont.h"
#import "AMBlurView.h"
#import "ADMoreContentVC.h"
#import "ADFailLodingView.h"

#define ACTION_MEDIASEARCH @"adding://adco/mediaSearch"
#define ACTION_MEDIACLICK @"adding://adco/mediaOpen?mediaId="

@interface ADFeedRecommendViewController ()<UIWebViewDelegate,UITextFieldDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{

    CGFloat _indexY;
    UITableView *_tabelView;
    NSMutableArray *_dataArray;
    UISearchBar *_searchBar;
    UIButton *_cancelButton;
    ADLoadingView *_loadingView;
    NSInteger _currentIndex;
    NSString *_searchBarText;
    UIWebView *_webView;
    AMBlurView *_titleView;
    BOOL _isweb;
    ADEmptyView *_emptyView;
    ADFailLodingView *_faileLodingView;
    BOOL _isNavHide;
}
@end

@implementation ADFeedRecommendViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isNavHide) {
        self.navigationController.navigationBarHidden = YES;
    }else{
        self.navigationController.navigationBarHidden = NO;
    }
    self.navigationController.navigationBar.translucent = YES;
    [MobClick event:media_add];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    self.myTitle = @"加丁号";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self layoutUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self addRetuanBackButtonItem];
    [SVProgressHUD dismiss];
}

#pragma mark - LayoutUI
#define TOP_DISTANCE 13
#define LEFT_DISTANCE 14
- (void)layoutUI{
    self.navigationItem.hidesBackButton = YES;
    [self addRetuanBackButtonItem];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_webView setBackgroundColor:[UIColor whiteColor]];
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self getMediaUrlString]]]];
    [self.view addSubview:_webView];
}

- (NSString *)getMediaUrlString
{
    NSString *urlString = @"http://www.addinghome.com/adcoweb/media";
    NSString *token = [[NSUserDefaults standardUserDefaults] addingToken];
    NSString *userStatus = [ADUserInfoSaveHelper readUserStatus];
    if ([userStatus isEqualToString:@"2"]) {
        NSString *birdthDay = [NSString stringWithFormat:@"%ld",(long)[[ADUserInfoSaveHelper readBabyBirthday] timeIntervalSince1970]];

        NSString *fileString = [NSString stringWithFormat:@"%@?oauth_token=%@&userStatus=%@&duedate=%@&birthdate=%@", urlString, token, userStatus,@"", birdthDay];
        return fileString;
    }
    
    NSString *dueDate = [NSString stringWithFormat:@"%ld",(long)[[ADUserInfoSaveHelper readDueDate] timeIntervalSince1970]];

    NSString *fileString = [NSString stringWithFormat:@"%@?oauth_token=%@&userStatus=%@&duedate=%@&birthdate=%@", urlString, token, userStatus, dueDate, @""];
    return fileString;
}

- (void)addLoadingView{
    if (!_loadingView) {
        _loadingView = [[ADLoadingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_loadingView];
    }
}
- (void)addtabelView{
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 9, SCREEN_WIDTH, SCREEN_HEIGHT - 44 -9) style:UITableViewStylePlain];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tabelView];
    [self addRefresh];
}
- (void)addEmptyViewWithText:(NSString *)text{
    if (!_emptyView&&![text isEqualToString:@""]) {
        _emptyView = [[ADEmptyView alloc] initWithFrame:CGRectMake(0, 74+9 , SCREEN_WIDTH, SCREEN_HEIGHT - 83) title:[NSString stringWithFormat:@"没有找到“”相关结果"] image:[UIImage imageNamed:@"addingSearch"]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"没有找到“%@”相关结果",text]];
        [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x00DDBA) range:NSMakeRange(5, text.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont parentToolTitleViewDetailHeiFontWithSize:15] range:NSMakeRange(0, str.length)];
        [_emptyView setAttributeString:str];
        [self.view addSubview:_emptyView];
    }
}

- (void)addADFaildLoadingVIew{
    
    if (!_faileLodingView) {
        _faileLodingView = [[ADFailLodingView alloc] initWithFrame:CGRectMake(0, NAVIBAT_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIBAT_HEIGHT*2) tapBlock:^{
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self getMediaUrlString]]]];
            [_faileLodingView removeFromSuperview];
            _faileLodingView = nil;
        }];
    }
    [_faileLodingView showInView:self.view];
}

- (void)addRefresh{
    __weak ADFeedRecommendViewController *weekSelf = self;
    [_tabelView addInfiniteScrollingWithActionHandler:^{
        [weekSelf insertrowatbottom];
    }];
}

- (void)addRetuanBackButtonItem{
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
}
- (void)addSearchbar{
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _isNavHide = YES;
    _titleView = [[AMBlurView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 74)];
    [self.view addSubview:_titleView];
    //仿NavBar下面分割线
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 73.5, SCREEN_WIDTH, 0.1)];
    [lineView setBackgroundColor:UIColorFromRGB(0x9c9c9d)];
    [_titleView addSubview:lineView];

    _cancelButton= [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(SCREEN_WIDTH -50, 32, 50, 30);
    _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _cancelButton.titleLabel.font = [UIFont parentToolTitleViewDetailHeiFontWithSize:14];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:UIColorFromRGB(0x00DDBA) forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
   [_titleView addSubview:_cancelButton];

    _searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(7, 32, SCREEN_WIDTH - 50, 30)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索";
    UITextField *searchField = nil;
    for (UIView *subview in [[_searchBar.subviews objectAtIndex:0] subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            searchField = (UITextField *)subview;
        }else{
            [subview removeFromSuperview];
        }
    }
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    // 设置搜索栏输入框边框颜色
    searchField.layer.cornerRadius = 4.0f;
    searchField.layer.masksToBounds = YES;
    searchField.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    searchField.layer.borderWidth = 1.0f;
    [_searchBar becomeFirstResponder];
    [_titleView addSubview:_searchBar];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        _searchBar.frame = CGRectMake(7, 32, SCREEN_WIDTH - 50, 30);
    } completion:nil];
}

#pragma mark - ButtonClick
- (void)returnbackClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cancelButtonClick:(UIButton *)button{
    [self addRetuanBackButtonItem];
    [_dataArray removeAllObjects];
    [UIView animateWithDuration:0.3 animations:^{
        _titleView.alpha = 0;
    } completion:^(BOOL finished) {
        _webView.hidden = NO;
        [_titleView removeFromSuperview];
        _titleView = nil;
        [_tabelView removeFromSuperview];
        _tabelView = nil;
        if (_emptyView) {
            [_emptyView removeFromSuperview];
            _emptyView = nil;
        }
        self.navigationController.navigationBarHidden = NO;
        _isNavHide = NO;
    }];
}

#pragma mark - tabelviewDelegete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ADFeedRecommendTableViewCell getFeedRecommendWithModel:_dataArray[indexPath.row]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    ADFeedRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ADFeedRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    cell.refreshModel = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_searchBar resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ADFeedDetailsViewController *dvc = [[ADFeedDetailsViewController alloc] init];
    ADFeedContentListModel *model = _dataArray[indexPath.row];
    dvc.mediaId = model.mediaId;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - webviewDelegate
- (void)loadingFailed{
    [_loadingView stopAnimation];
    _loadingView = nil;
    _webView.hidden = NO;
    [self addADFaildLoadingVIew];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self addLoadingView];
    [_loadingView adLodingViewStartAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    _webView.hidden = YES;
    [self performSelector:@selector(loadingFailed) withObject:nil afterDelay:0.8];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_loadingView stopAnimation];
    _loadingView = nil;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlString = [NSString stringWithFormat:@"%@",request.URL];
    
    NSLog(@"加丁号请求的URL %@",urlString);
    if ([urlString isEqualToString:ACTION_MEDIASEARCH]) {
//        _isNavHide = YES;
//        _webView.hidden = YES;
//        [self addtabelView];
//        [self addSearchbar];
        ADMoreContentVC *moreVc = [[ADMoreContentVC alloc] init];
        moreVc.isMedia = YES;
        [self.navigationController pushViewController:moreVc animated:YES];
        return  NO;
    }
    if ([urlString myContainsString:ACTION_MEDIACLICK]) {
        NSString *mediaid = [[urlString componentsSeparatedByString:ACTION_MEDIACLICK ]lastObject];
        ADFeedDetailsViewController *dvc = [[ADFeedDetailsViewController alloc] init];
        dvc.mediaId = mediaid;
        [self.navigationController pushViewController:dvc animated:YES];
        return NO;
    }
    return YES;
}

#pragma mark - seachBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    [MobClick event:media_search];
    [ADFeedNetworkHelper getFeedSearchMediaWithKeyword:searchBar.text start:@"0" size:@"10" compliteBlock:^(NSArray *resArray, BOOL iscomplite) {
        if (iscomplite) {
            [_dataArray removeAllObjects];
            for (NSDictionary *dict in resArray) {
                [_dataArray addObject:[ADFeedContentListModel getFeedContentListmodelWithDict:dict]];
            }
            _currentIndex = _dataArray.count;
        }
        if (_dataArray.count) {
            _tabelView.showsInfiniteScrolling = YES;
            if (_emptyView) {
                [_emptyView removeFromSuperview];
                _emptyView = nil;
            }
            [_tabelView reloadData];
        }else{
            _tabelView.showsInfiniteScrolling = NO;
            if (_emptyView) {
                [_emptyView removeFromSuperview];
                _emptyView = nil;
            }
            [self addEmptyViewWithText:searchBar.text];
        }
    }failure:^(NSError *error) {
        
    }];
}

//- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
//{
//    CGRect rect = CGRectMake(0, 0, size.width, size.height);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}
#pragma mark - 下拉加载更多
- (void)insertrowatbottom{
     [ADFeedNetworkHelper getFeedSearchMediaWithKeyword:_searchBar.text start:[NSString stringWithFormat:@"%ld",(long)_currentIndex] size:@"10" compliteBlock:^(NSArray *resArray, BOOL iscomplite) {
        if (iscomplite) {
            for (NSDictionary *dict in resArray) {
                [_dataArray addObject:[ADFeedContentListModel getFeedContentListmodelWithDict:dict]];
            }
            _currentIndex = _dataArray.count;
            [_tabelView reloadData];
            [_tabelView.infiniteScrollingView stopAnimating];
        }
    }failure:^(NSError *error) {
        [_tabelView.infiniteScrollingView stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
