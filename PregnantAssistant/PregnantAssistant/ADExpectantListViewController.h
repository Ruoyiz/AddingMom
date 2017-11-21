//
//  ADExpectantListViewController.h
//  PregnantAssistant
//
//  Created by D on 14-9-18.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"

@interface ADExpectantListViewController : ADBaseViewController <
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *allKindThingArray;
//@property (nonatomic, retain) NSMutableArray *haveBuyArray;

@property (nonatomic, copy) NSArray *headerTitles;
@property (nonatomic, retain) NSMutableArray *displayHeaderTitles;

@end