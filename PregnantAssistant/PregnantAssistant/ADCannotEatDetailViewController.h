//
//  ADCannotEatDetailViewController.h
//  PregnantAssistant
//
//  Created by D on 14-9-29.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"

@interface ADCannotEatDetailViewController : ADBaseViewController <
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *selectedIndexes;

@end
