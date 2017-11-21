//
//  ADHIstoryContractViewController.h
//  PregnantAssistant
//
//  Created by D on 14/10/20.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADContractionDAO.h"

@interface ADHistoryContractViewController : ADBaseViewController <
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, retain) UITableView *myTableView;

@property (nonatomic, retain) NSMutableArray *titleArray;
//@property (nonatomic, retain) NSMutableArray *isTitleOpenArray;
@property (nonatomic, retain) RLMResults *allRecords;
@property (nonatomic, retain) NSMutableArray *finalAllRecords;
@property (nonatomic, retain) UIImageView *imgView;

@end
