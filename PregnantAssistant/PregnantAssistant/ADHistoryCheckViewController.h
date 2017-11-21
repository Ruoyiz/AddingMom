//
//  ADHistoryCheckViewController.h
//  PregnantAssistant
//
//  Created by D on 14-9-19.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADCustomPicker.h"
#import "ADAddBottomBtn.h"
#import "ADBackgroundView.h"
#import "ADCheckCalDAO.h"

@interface ADHistoryCheckViewController : ADBaseViewController <
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, retain) UITableView *myTableView;
//@property (nonatomic, retain) NSMutableArray *warnDateArray;
@property (nonatomic, retain) RLMResults *warnDateArray;
@property (nonatomic, retain) ADAddBottomBtn *addNote;
@property (nonatomic, retain) ADCustomPicker *datePicker;
@property (nonatomic, retain) ADBackgroundView *aBgView;
@property (nonatomic, retain) UIImageView *emptyTipView;

@end
