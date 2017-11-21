//
//  ADPersonInfoViewController.m
//  PregnantAssistant
//
//  Created by D on 14/12/6.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADPersonInfoViewController.h"
#import "CustomStoryTableViewCell.h"
#import "ADStoryDetailViewController.h"
#import "SVPullToRefresh.h"
#import "ADLoadingView.h"
#import "ADAlertView.h"
#import "ADEmptyView.h"

@interface ADPersonInfoViewController ()


@end

@implementation ADPersonInfoViewController{
    ADLoadingView *_customLoadingView;
}


-(void)dealloc
{
    self.myTableView.dataSource = nil;
    self.myTableView.delegate = nil;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    self.myTitle = @"我的秘密";
    self.view.backgroundColor = [UIColor bg_lightYellow];
    
    [self setLeftBackItemWithImage:nil
                    andSelectImage:nil];
    
    self.mySecretArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self addTableView];
    [self p_startLoadingAnimation];
    
    [self getStartData];

    //[self addRefreshAndInfi];
}

- (void)getStartData
{
    [self getDataBeginWith:@"0"
                 andLength:@"10"
              complication:^(void){
                  [self p_stopLoadingAnimation];
                  if (self.mySecretArray.count == 0) {
                      [self addEmptyView];
                  } else {
                      //[self.myTableView reloadData];
                      [self reloadData];
                  }
              }];
}

- (void)reloadData
{
    if (self.mySecretArray.count == 0) {
        [self addEmptyView];
    }else{
        [self.myTableView reloadData];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

//- (void)addRefreshAndInfi
//{
//    self.refreshControl = [[UIRefreshControl alloc]init];
//    [self.refreshControl addTarget:self
//                            action:@selector(refreshView:)
//                  forControlEvents:UIControlEventValueChanged];
//    [self.myTableView addSubview:self.refreshControl];
//    
//    __weak ADPersonInfoViewController *weakSelf = self;
//    // setup infinite scrolling
//    [self.myTableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf loadMore];
//    }];
//}

- (void)refreshView:(UIRefreshControl *)refresh
{
    NSLog(@"currentPos:%ld",(long)_currentPos);
    [self replaceDataBeginWith:@"0"
                     andLength:[NSString stringWithFormat:@"%ld",(long)_currentPos]
                  complication:^{
        [refresh endRefreshing];
    }];
}

- (void)loadMore
{
    if (_currentPos == 0 && _mySecretArray.count == 0) {
        [self p_startLoadingAnimation];
    }
    [self getDataBeginWith:[NSString stringWithFormat:@"%ld", (long)_currentPos]
                 andLength:@"10"
              complication:^(void){
                  
                  if (_haveMoreData) {
                      //[self.myTableView reloadData];
                      [self reloadData];
                  } else {
                      [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.1];
                  }
                  [self.myTableView.infiniteScrollingView stopAnimating];
              }];
}

- (void)scrollToBottom
{
    [self.myTableView setContentOffset:
     CGPointMake(0, self.myTableView.contentSize.height -self.myTableView.bounds.size.height) animated:YES];
}

- (void)replaceDataBeginWith:(NSString *)startInx
                   andLength:(NSString *)aLength
                complication:(FinishRequstBlock)aRequstBlock
{
    [[ADMomSecertNetworkHelper shareInstance]getUserPostWithStartInx:startInx
                                                           andLength:aLength
                                                           andResult:
     ^(NSArray * resultArray) {
         
         [self.mySecretArray removeAllObjects];
         [self.mySecretArray addObjectsFromArray:resultArray];
         
         if (resultArray.count > 0) {
             _haveMoreData = YES;
         } else {
             _haveMoreData = NO;
         }
         
         [self reloadData];
         //[self.myTableView reloadData];
         aRequstBlock();
     }];
}

- (void)getDataBeginWith:(NSString *)startInx
               andLength:(NSString *)aLength
            complication:(FinishRequstBlock)aRequstBlock
{
    [[ADMomSecertNetworkHelper shareInstance] getUserPostWithStartInx:startInx
                                                           andLength:aLength
                                                           andResult:
     ^(NSArray * resultArray) {
         
         [self.mySecretArray addObjectsFromArray:resultArray];
         
         if (resultArray.count > 0) {
             _haveMoreData = YES;
         } else {
             _haveMoreData = NO;
         }
         
         _currentPos += resultArray.count;
         
         [self.myTableView.infiniteScrollingView stopAnimating];
         [self p_stopLoadingAnimation];
         aRequstBlock();
     } failed:^{
         [self performSelector:@selector(loadFailedViewWithStart:) withObject:startInx afterDelay:1];
     }];
}

- (void)addTableView
{
    self.myTableView = [[UITableView alloc]initWithFrame:
                        CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -64)
                                                   style:UITableViewStylePlain];
    self.myTableView.backgroundColor = [UIColor bg_lightYellow];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.myTableView];
}

- (void)addEmptyView
{
    ADEmptyView *emptyView = [[ADEmptyView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIBAT_HEIGHT) title:@"还没有发布过秘密" image:[UIImage imageNamed:@"list_loading_06"]];
    [self.view addSubview:emptyView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableview method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mySecretArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *aSecert = self.mySecretArray[indexPath.row];
    
    NSString *reuseStr = @"customCell";
    CustomStoryTableViewCell *customCell = [[CustomStoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                          reuseIdentifier:reuseStr];
    customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    customCell.passThoughTouch = YES;
    
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
    
    NSString *imageUrls = aSecert[@"imageUrl"];
    NSData* xmlData = [imageUrls dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *imageUrlArray = nil;
    if (xmlData != nil) {
        imageUrlArray = [NSJSONSerialization JSONObjectWithData:xmlData
                                                        options:NSJSONReadingAllowFragments
                                                          error:nil];
    }
    
    customCell.imageUrlArray = imageUrlArray;
    
    customCell.showDelBtn = YES;
    [customCell.delBtn addTarget:self action:@selector(delSecert:) forControlEvents:UIControlEventTouchUpInside];
    
    return customCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADStoryDetailViewController *aStoryVc = [[ADStoryDetailViewController alloc]init];
    
    aStoryVc.aSecret = self.mySecretArray[indexPath.row];
    [aStoryVc isDeleteReturnBackBlock:^(BOOL isDelete, NSInteger rowIndex) {
        if (isDelete) {
            [ADToastHelp showSVProgressWithSuccess:@"删除成功"];
            [_mySecretArray removeAllObjects];
            [self getStartData];
            [_myTableView reloadData];
        }
    }];

    [self.navigationController pushViewController:aStoryVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *aSecert = self.mySecretArray[indexPath.row];

    NSString *body = aSecert[@"body"];
    CGRect textRect = [body boundingRectWithSize:CGSizeMake(self.view.frame.size.width -18, 1000)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}
                                         context:nil];
    float height = textRect.size.height +100;
    
    // add image height
    NSString *imageUrls = aSecert[@"imageUrl"];
    
    NSData* xmlData = [imageUrls dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *imageUrlArray = nil;
    if (xmlData != nil) {
        imageUrlArray  = [NSJSONSerialization JSONObjectWithData:xmlData
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
        
    }
    float perImgRowHeight = (self.view.frame.size.width - 8*4) /3;
    if (imageUrlArray.count > 0) {
        NSInteger rowNum = (imageUrlArray.count -1) /3 +1;
        height += perImgRowHeight *rowNum;
    }
    
    return height;
}

- (void)changeLikeStatus:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    CustomStoryTableViewCell *aStoryCell =
    (CustomStoryTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
    
    NSString *likeStr = aStoryCell.likeLabel.text;
    if (sender.selected == NO) {
        sender.selected = YES;
        [self changeASecret:sender withStatus:YES];
        aStoryCell.likeLabel.text = [NSString stringWithFormat:@"%d",likeStr.intValue +1];
    } else {
        sender.selected = NO;
        [self changeASecret:sender withStatus:NO];
        aStoryCell.likeLabel.text = [NSString stringWithFormat:@"%d",likeStr.intValue -1];
    }
}

- (void)changeASecret:(UIButton *)sender withStatus:(BOOL)likeStatus
{
    int likeTag = (int)sender.tag;
    NSString *aPostId = self.mySecretArray[likeTag][@"postId"];

    [[ADMomSecertNetworkHelper shareInstance]changeAPostWithId:aPostId
                                                     andStatus:likeStatus
                                                  complication:
     ^{
         [self replaceDataBeginWith:@"0"
                          andLength:[NSString stringWithFormat:@"%ld", (long)_currentPos]
                       complication:^{}];
     } failed:^{
         if (sender.selected == NO) {
             sender.selected = YES;
         } else {
             sender.selected = NO;
         }
     }];
}

- (void)delSecert:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    _delIndexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    _delPostId = self.mySecretArray[_delIndexPath.row][@"postId"];
    
    ADAlertView *alert = [[ADAlertView alloc] initWithTitle:@"确定删除？" cancelTitle:@"取消" confirmTitle:@"确定"];
    [alert showWithConfirm:^{
        [[ADMomSecertNetworkHelper shareInstance] deleteSecertWithCommandId:nil PostId:_delPostId onFinish:^(NSDictionary *resultDic) {
            [ADToastHelp showSVProgressWithSuccess:@"删除成功"];
            [self.mySecretArray removeObjectAtIndex:_delIndexPath.row];
            [self.myTableView reloadData];
            if (self.mySecretArray.count == 0) {
                [self addEmptyView];
            }
        } onFailed:^{
            [ADToastHelp showSVProgressToastWithError:@"删除失败"];
        }];
    }];
}

#pragma mark - loading
- (void)p_startLoadingAnimation
{
    if (!_customLoadingView) {
        _customLoadingView =[[ADLoadingView alloc]initWithFrame:self.view.bounds];
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

- (void)loadFailedViewWithStart:(NSString *)startInx
{
    [self p_stopLoadingAnimation];
//    [self finishReloadingData];
    
    if ([startInx isEqualToString:@"0"]) {
        if (_failLoadingView.superview == nil) {
            _failLoadingView = [[ADFailLodingView alloc]initWithFrame:
                                CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 49) tapBlock:^{
                                    [self p_startLoadingAnimation];
                                    [self getStartData];
                                    _failLoadingView = nil;
                                }];
            
        }
        [_failLoadingView showInView:self.view];
    }
}

@end