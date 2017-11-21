//
//  ADMomSecretViewController.h
//  PregnantAssistant
//
//  Created by D on 14/12/1.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADAddBottomBtn.h"
#import "ADLoginMomViewController.h"
#import "ADBadgeView.h"
#import "ADSecertTitleView.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "ADFailLodingView.h"
#import "ADStoryDetailViewController.h"
#import "ADAddBottomBtn.h"

@interface ADMomSecretViewController : ADBaseViewController
<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,ChangeLikeStatusWhenBack>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    ADFailLodingView *_failLoadingView;
}

@property (nonatomic, assign) viewType aViewType;
@property (nonatomic, retain) UITableView *myTableView;

@property (nonatomic, retain) ADAddBottomBtn *addBottomBtn;

@property (nonatomic, retain) UIButton *threeLineBtn;
@property (nonatomic, copy) NSString *tStr;
@property (nonatomic, retain) ADLoginMomViewController *aLoginVc;

@property (nonatomic, retain) NSMutableArray *allSecretDataArray;
@property (nonatomic, retain) NSMutableArray *hotSecretDataArray;
@property (nonatomic, retain) UIRefreshControl *refreshControl;

@property (nonatomic, assign) BOOL haveMoreData;

@property (nonatomic, assign) BOOL reachable;

@property (nonatomic, assign) int localLikeNum;

@property (nonatomic, retain) ADBadgeView *aBadgeView;
@property (nonatomic, retain) ADBadgeView *aBadgeViewOnPop;
@property (nonatomic, assign) int aBadgeNum;

@property (nonatomic, assign) BOOL isWriteVCBack;

@property (nonatomic, retain) UIView *maskView;
@property (nonatomic, retain) UIScrollView *scrollImgBg;

@property (nonatomic, retain) ADSecertTitleView *aTitleView;
@property (nonatomic, retain) ADAddBottomBtn *writeBtn;

@property (nonatomic, retain) UIView *popView;
@property (nonatomic, assign) BOOL secertnotiShow;

- (void)reloadViewData;

@end