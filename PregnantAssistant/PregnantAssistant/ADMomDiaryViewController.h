//
//  ADMomDiaryViewController.h
//  PregnantAssistant
//
//  Created by D on 14-9-18.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADToolRootViewController.h"
#import "ADDiaryTableView.h"
#import "ADShadowBgView.h"
#import "ADAddBottomBtn.h"
#import "ADNoteDAO.h"

@interface ADMomDiaryViewController : ADToolRootViewController <
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, retain) ADAddBottomBtn *addNote;
@property (nonatomic, retain) UIImageView *tipImage;
@property (nonatomic, retain) UILabel *tipLabel;
@property (nonatomic, retain) ADShadowBgView *emptyBgView;

@property (nonatomic, retain) ADDiaryTableView *myTableView;
@property (nonatomic, retain) UIView *lineView;

@property (nonatomic, retain) RLMResults *allNoteArray;

@end
