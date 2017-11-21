//
//  ADCheckArchivesViewController.h
//  PregnantAssistant
//
//  Created by D on 14/11/27.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADToolRootViewController.h"
#import "CircleDataView.h"
#import "CustomHealthLineGraphView.h"
#import "GraphBackgroundView.h"
#import "ADCheckArchivesDAO.h"
#import "RMPickerViewController.h"
#import "RMDateSelectionViewController.h"

typedef enum {
    weightDataSource = 0,
    bloodPressDataSource,
    heartBeatDataSource,
    palaceHeightDataSource,
    abCircumferenceDataSource
} viewDataSourceType;

@interface ADCheckArchivesViewController : ADToolRootViewController <
CustomHealthLineGraphViewDelegate,
RMPickerViewControllerDelegate,
RMDateSelectionViewControllerDelegate
>

@property (nonatomic, retain) NSMutableArray *buttonsArray;
@property (nonatomic, retain) UIScrollView *myScrollView;


@property (nonatomic, retain) UIImageView *lineView;
@property (nonatomic, retain) UIView *lineView2;
@property (nonatomic, retain) CircleDataView *aCircleDataView;
@property (nonatomic, assign) int circleSize;

@property (nonatomic, retain) CustomHealthLineGraphView *healthLineGraph;

@property (nonatomic, retain) NSDate *currentSelectDay;

@property (nonatomic, assign) viewDataSourceType viewDataSourceType;

@property (nonatomic, retain) RLMResults *allRecordArray;

@property (nonatomic, retain) NSMutableArray *displayRecordArray;

@property (nonatomic, retain) UIImageView *noDataBgView;

@property (nonatomic, retain) GraphBackgroundView *aGraphBgView;

@property (nonatomic, retain) UIImageView *addDataTip;
@property (nonatomic, retain) UIImageView *pressureTip;
@property (nonatomic, retain) UIImageView *heartRateTip;

@property (nonatomic, assign) NSInteger currentSelectInx;

@property (nonatomic, retain) ADCheckData *currentSelectData;

@end
