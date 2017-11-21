//
//  ADLabourThingListViewController.h
//  PregnantAssistant
//
//  Created by D on 14-9-18.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADInLabourDAO.h"

@interface ADLabourThingListViewController : ADBaseViewController <
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, copy) NSArray *labourThing;
@property (nonatomic, retain) RLMResults *wantLabourThing;

@end
