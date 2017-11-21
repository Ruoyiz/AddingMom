//
//  ADContractionViewController.h
//  PregnantAssistant
//
//  Created by D on 14-9-30.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADToolRootViewController.h"
#import "ADCustomButton.h"
#import "ADRecordContractView.h"
#import "ADContractionDAO.h"

@interface ADContractionViewController : ADToolRootViewController <
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, retain) UILabel *intervalLabel;
@property (nonatomic, retain) UILabel *lastLabel;

@property (nonatomic, retain) NSTimer *lastTimer;

//@property (nonatomic, retain) ADCustomButton *aStartBtn;

@property (nonatomic, assign) int durationTime;
@property (nonatomic, assign) int intervalTime;

@property (nonatomic, retain) ADRecordContractView *aRecordView;

@property (nonatomic, retain) UITableView *myTableView;

@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;

@property (nonatomic, retain) RLMResults *todayRecords;
@property (nonatomic, retain) RLMResults *allRecords;

@property (nonatomic, retain) UILabel *tipLabel;

@end
