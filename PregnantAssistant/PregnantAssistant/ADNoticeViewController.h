//
//  ADNoticeViewController.h
//  PregnantAssistant
//
//  Created by D on 14/12/6.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADReadNoticeItem.h"
#import "ADFailLodingView.h"
#import "ADNoticeInfo.h"
#import "ADSecertNotice.h"
#import "ADFeedContentListTableViewCell.h"
#import "ADStoryDetailViewController.h"
#import "ADLoadingView.h"
//#import "ADMomLookContentDetailVC.h"
#import "ADLookCommentTableViewCell.h"
#import <AFNetworking.h>
#import "ADEmptyView.h"
#import "SVPullToRefresh.h"
#import "ADLookCommentViewController.h"

@interface ADNoticeViewController : ADBaseViewController <
UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) UIImageView *emptyImg;
@property (nonatomic, retain) RLMResults *allReadNoticeIdArray;
@property (nonatomic, retain) ADFailLodingView *failLoadingView;
@property (nonatomic, retain) NSMutableArray *noticeArray;
@property (nonatomic, assign) NSInteger loadingIndex;
@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic, retain) ADEmptyView *emptyView;
@property (nonatomic, retain) ADLoadingView *customLoadingView;
@property (nonatomic, copy) void(^removeRedDotBlock)(void);
- (void)p_startLoadingAnimation;
- (void)loadContentView;
- (void)loadFailedView;
- (void)addAReadItem:(ADReadNoticeItem *)aItem;
- (void)jumpToSecertVcWithCid:(NSString *)aCid cellIndex:(NSInteger)cellIndex;
- (void)p_stopLoadingAnimation;
@end
