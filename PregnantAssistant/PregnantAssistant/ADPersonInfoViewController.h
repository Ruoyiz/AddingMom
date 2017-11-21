//
//  ADPersonInfoViewController.h
//  PregnantAssistant
//
//  Created by D on 14/12/6.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADFailLodingView.h"

@interface ADPersonInfoViewController : ADBaseViewController <
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, retain) NSMutableArray *mySecretArray;
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL haveMoreData;
@property (nonatomic, assign) NSInteger currentPos;

@property (nonatomic, copy) NSString *delPostId;
@property (nonatomic, copy) NSIndexPath *delIndexPath;
@property (nonatomic, retain) ADFailLodingView *failLoadingView;

@end
