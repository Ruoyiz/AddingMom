//
//  ADCTableViewController.h
//  PregnantAssistant
//
//  Created by D on 14-9-26.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"

@interface ADCTableViewController : ADBaseViewController <
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, copy) NSArray *dataArray;

@end
