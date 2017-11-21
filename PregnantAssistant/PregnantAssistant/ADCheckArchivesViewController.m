//
//  ADCheckArchivesViewController.m
//  PregnantAssistant
//
//  Created by D on 14/11/27.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADCheckArchivesViewController.h"
#import "CustomDataBtn.h"

#import "UIImage+Rotate.h"

#define BARHEIGHT 47
@interface ADCheckArchivesViewController ()

@end

@implementation ADCheckArchivesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTitle = @"产检档案";
    
    [self showSyncAlert];
    //默认选择体重
    self.viewDataSourceType = weightDataSource;
    [ADCheckArchivesDAO updateOldData];
    self.allRecordArray = [ADCheckArchivesDAO readAllData];
    
    [self setupDisplayDataArray];

    BOOL haveWeightData = NO;
    for (ADCheckData *aCheckData in self.allRecordArray) {
        if (aCheckData.weight.length > 0) {
            haveWeightData = YES;
            break;
        }
    }
    
    int leftEdge = 0;
    int topY = 0;
    if ([ADHelper isIphone4]) {
        _circleSize = 184;
        leftEdge = -40;
        topY = 228;
    } else {
        _circleSize = 210;
        leftEdge = -56;
        topY = 280;
    }
    
    topY += 64;
    
    if (haveWeightData) {
        [self addAllLineView];

        _currentSelectData = self.displayRecordArray[_displayRecordArray.count -1];
        _aCircleDataView = [[CircleDataView alloc]initWithFrame:ACGRectMake(leftEdge, topY, _circleSize, _circleSize)
                                                       withDate:[ADHelper getCircleTitleWithDate:_currentSelectData.aDate]
                                                     withValue1:_currentSelectData.weight
                                                     withValue2:@""
                                                       withUnit:@"(kg)"
                                                        isEmpty:NO
                                                    andParentVC:self];
    } else {
        [self addNoDataBg];
        _aCircleDataView = [[CircleDataView alloc]initWithFrame:ACGRectMake(leftEdge, topY, _circleSize, _circleSize)
                                                       withDate:@""
                                                     withValue1:@""
                                                     withValue2:@""
                                                       withUnit:@""
                                                        isEmpty:YES
                                                    andParentVC:self];
    }

    [self.view addSubview:_aCircleDataView];
    
    [self addLineViewWithIndex:0];
    
    NSArray *buttonNames = @[ @"体重",
                              @"血压",
                              @"胎心率",
                              @"宫高",
                              @"腹围"
                              ];
    self.buttonsArray = [[NSMutableArray alloc]initWithCapacity:5];
    
    for (int i = 0; i < buttonNames.count; i++) {
        NSString *aTitle = buttonNames[i];
        CustomDataBtn *aCustomBtn = nil;
        if ([ADHelper isIphone4]) {
            aCustomBtn = [[CustomDataBtn alloc]initWithFrame:
                          ACGRectMake(SCREEN_WIDTH - 112, topY +4 +i*36, 100, 30)
                                                    andTitle:aTitle];
        } else {
            aCustomBtn = [[CustomDataBtn alloc]initWithFrame:
                          ACGRectMake(320 - 112, topY +8 +i*42, 100, 30)
                                                    andTitle:aTitle];
        }
        
        [aCustomBtn setBackgroundImage:[UIImage imageNamed:@"button"]  forState:UIControlStateSelected];
        [aCustomBtn addTarget:self action:@selector(tapOneBtn:) forControlEvents:UIControlEventTouchUpInside];
        aCustomBtn.tag = 20 +i;
        [self.buttonsArray addObject:aCustomBtn];
        [self.view addSubview:aCustomBtn];
        
        if (i == 0) {
            [aCustomBtn setSelected:YES];
        }
    }
    
    [self addNoDataTip];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self syncAllDataOnFinish:nil];

    self.aCircleDataView.hidden = NO;
    _lineView.hidden = NO;
    _lineView2.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.aCircleDataView.hidden = YES;
    _lineView.hidden = YES;
    _lineView2.hidden = YES;
}

- (void)back
{
    [ADCheckArchivesDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addNoDataBg
{
    if (_noDataBgView.superview == nil) {
        if ([ADHelper isIphone4]) {
            _noDataBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 138)];
            _noDataBgView.image = [UIImage imageNamed:@"noHealthLineData"];
        } else {
            _noDataBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH *0.5875)];
            _noDataBgView.image = [UIImage imageNamed:@"noDatabackground"];
        }
        [self.view addSubview:_noDataBgView];
    }
}

- (void)addNoDataTip
{
    if (self.displayRecordArray.count == 0) {
        if (self.addDataTip.superview == nil) {
            _addDataTip = [[UIImageView alloc]initWithFrame:ACGRectMake(0, 0, 280, 42)];
            if ([ADHelper isIphone4]) {
                _addDataTip.center = CGPointMake(SCREEN_WIDTH /2 +8, 212 +62);
            } else {
//                _addDataTip.center = CGPointMake(SCREEN_WIDTH /2 +8, _noDataBgView.frame.size.height +6 +69);
                _addDataTip.center =
                CGPointMake(SCREEN_WIDTH /2 +8, _aCircleDataView.frame.origin.y - _addDataTip.frame.size.height/2 + 2);
            }
            _addDataTip.image = [UIImage imageNamed:@"pressAddTip"];
            [self.view insertSubview:_addDataTip belowSubview:_aCircleDataView];
        }
    }
}

- (void)addLineBg
{
    NSArray *backValues = nil;
    NSArray *backColors = nil;
    switch (self.viewDataSourceType) {
        case weightDataSource: {
            if ([ADHelper isIphone4]) {
                backValues = @[@"70 ~ 100",
                               @"40 ~  70"];
            } else {
                backValues = @[@"  85  ~  100",
                               @"70  ~  85",
                               @"55  ~  70",
                               @"40  ~  55"];
            }
        } break;
        case bloodPressDataSource: {
            if ([ADHelper isIphone4]) {
                backValues = @[@"110 ~ 180",
                               @" 40  ~ 110"];
            } else {
                backValues = @[@"145 ~ 180",
                               @"110 ~ 145",
                               @" 75  ~ 110",
                               @"40  ~  75"];
            }
        } break;
        case heartBeatDataSource: {
            backValues = @[@"150 ~ 170",
                           @"130 ~ 150",
                           @"110 ~ 130"];
        } break;
        case palaceHeightDataSource: {
            backValues = @[ @"30 ~ 40",
                            @"20 ~ 30",
                            @"10 ~ 20"];

        } break;
        case abCircumferenceDataSource: {
            if ([ADHelper isIphone4]) {
                backValues = @[@"100 ~ 150",
                               @"  50 ~ 100"];
            } else {
                backValues = @[@"125 ~ 150",
                               @"100 ~ 125",
                               @" 75  ~ 100",
                               @"50  ~  75"];
            }
        } break;

        default:
            break;
    }
    
    int barHeight = 0;
    CGRect graphViewFrame = CGRectZero;
    if (self.viewDataSourceType == heartBeatDataSource
        || self.viewDataSourceType == palaceHeightDataSource) {
        
        backColors = @[UIColorFromRGB(0x63ead7),
                       UIColorFromRGB(0x8eefe3),
                       UIColorFromRGB(0xb3f2f4)];
        
        if ([ADHelper isIphone4]) {
            barHeight = 47;
            graphViewFrame = CGRectMake(0, 64, SCREEN_WIDTH, 47*3);
        } else {
            barHeight = 63;
            graphViewFrame = CGRectMake(0, 64, SCREEN_WIDTH, 63*3);
        }
        
    } else {
        if ([ADHelper isIphone4]) {
            backColors = @[UIColorFromRGB(0x63ead7),
                           UIColorFromRGB(0x8eefe3)];
            barHeight = 69;
            graphViewFrame = CGRectMake(0, 64, SCREEN_WIDTH, 69*2);
        } else {
            backColors = @[UIColorFromRGB(0x63ead7),
                           UIColorFromRGB(0x8eefe3),
                           UIColorFromRGB(0xb3f2f4),
                           UIColorFromRGB(0xcffcff)];
            graphViewFrame = CGRectMake(0, 64, SCREEN_WIDTH, BARHEIGHT*4);
            barHeight = BARHEIGHT;
        }
    }
    
    _aGraphBgView = [[GraphBackgroundView alloc]initWithFrame:graphViewFrame
                                         withBackgroundValues:backValues
                                         withBackgroundColors:backColors
                                                withBarHeight:barHeight];
    [self.view addSubview:_aGraphBgView];
}

- (CGRect)getHealthLineGraphFrame
{
    CGRect lineFrame = CGRectZero;
    if ([ADHelper isIphone4]) {
        lineFrame = CGRectMake(0, 64, _allRecordArray.count *36 +20, 69*2 +60);
    } else {
        lineFrame = CGRectMake(0, 64, _allRecordArray.count *36, BARHEIGHT*4 +60);
    }
    return lineFrame;
}

- (void)addHealthLineView
{
    CGRect lineFrame = [self getHealthLineGraphFrame];
    BOOL isTwoLine = NO;
    NSInteger lowValue = 0;
    NSInteger highValue = 0;

    switch (self.viewDataSourceType) {
        case weightDataSource:
            lowValue = 40;
            highValue = 100;

            break;
        case bloodPressDataSource:
            lowValue = 40;
            highValue = 180;
            isTwoLine = YES;
            break;
        case heartBeatDataSource:
            lowValue = 110;
            highValue = 170;

            break;
        case palaceHeightDataSource:
            lowValue = 10;
            highValue = 40;

            break;
        case abCircumferenceDataSource:
            lowValue = 50;
            highValue = 150;

            break;
            
        default:
            break;
    }
    
    _healthLineGraph = [[CustomHealthLineGraphView alloc]initWithFrame:lineFrame
                                                         withLineColor:[UIColor dot_green]
                                                          withLowValue:lowValue
                                                         withHighValue:highValue
                                                             haveLabel:YES
                                                             isTwoLine:isTwoLine];
    _healthLineGraph.delegate = self;
    [self.myScrollView addSubview:_healthLineGraph];
}

- (void)addScrollBg
{
    if ([ADHelper isIphone4]) {
        self.myScrollView = [[UIScrollView alloc]initWithFrame:
                             CGRectMake(0, 0, _aGraphBgView.frame.size.width, _aGraphBgView.frame.size.height +80 +40)];
//        self.myScrollView.backgroundColor = [UIColor yellowColor];
    } else {
        self.myScrollView = [[UIScrollView alloc]initWithFrame:
                             CGRectMake(0, 0, _aGraphBgView.frame.size.width, _aGraphBgView.frame.size.height +80 +40)];
    }

    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.contentSize =
    CGSizeMake(_displayRecordArray.count *36, _aGraphBgView.frame.size.height +40);
//    self.myScrollView.backgroundColor = [UIColor yellowColor];
    
    //滚动到最后
    if (_displayRecordArray.count *36 > self.view.frame.size.width) {
        [self.myScrollView setContentOffset:CGPointMake(_displayRecordArray.count *36 - self.view.frame.size.width, 0)];
    }
    
    [self.view addSubview:self.myScrollView];
}

- (void)addAllLineView
{
    [self addLineBg];
    [self addScrollBg];
    [self addHealthLineView];
}

- (void)removeAllLineView
{
    [_aGraphBgView removeFromSuperview];
    [_myScrollView removeFromSuperview];
    [_healthLineGraph removeFromSuperview];
}

- (void)setupDisplayDataArray
{
    self.displayRecordArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (ADCheckData *aCheckData in self.allRecordArray) {
        switch (self.viewDataSourceType) {
            case weightDataSource:{
                if (aCheckData.weight.length > 0) {
                    [self.displayRecordArray addObject:aCheckData];
                }
            } break;
            case bloodPressDataSource:{
                if (aCheckData.lowBloodPress.length > 0) {
                    [self.displayRecordArray addObject:aCheckData];
                }
            } break;
            case heartBeatDataSource:{
                if (aCheckData.heartBeat.length > 0) {
                    [self.displayRecordArray addObject:aCheckData];
                }
            } break;
            case palaceHeightDataSource:{
                if (aCheckData.palaceHeight.length > 0) {
                    [self.displayRecordArray addObject:aCheckData];
                }
            } break;
            case abCircumferenceDataSource:{
                if (aCheckData.abCircumference.length > 0) {
                    [self.displayRecordArray addObject:aCheckData];
                }
            } break;
                
            default:
                break;
        }
    }
}

- (void)tapOneBtn:(UIButton *)sender
{
    if (sender.selected == YES) {
        return;
    }
    [sender setSelected:YES];
    [self setUnselectWithoutTag:sender.tag];
    
    [self addLineViewWithIndex:sender.tag -20];
    [_noDataBgView removeFromSuperview];
    [_pressureTip removeFromSuperview];
    [_heartRateTip removeFromSuperview];
    
    switch (sender.tag) {
        case 20:
            // 体重
            self.viewDataSourceType = weightDataSource;
            break;
            
        case 21:
            // 血压
            self.viewDataSourceType = bloodPressDataSource;
            break;
            
        case 22:
            // 胎心率
            self.viewDataSourceType = heartBeatDataSource;
            break;
            
        case 23:
            // 宫高
            self.viewDataSourceType = palaceHeightDataSource;
            break;
            
        case 24:
            // 腹围
            self.viewDataSourceType = abCircumferenceDataSource;
            break;
            
        default:
            break;
    }
    
    [self setupDisplayDataArray];

    [self resetLineGraph];
    //Change Circle Btn
    if (self.displayRecordArray.count > 0) {
        ADCheckData *lastData = self.displayRecordArray[self.displayRecordArray.count -1];
        _currentSelectData = lastData;
        [self setCircleDataViewWithData:lastData];
        
        [_addDataTip removeFromSuperview];
        
        if (self.viewDataSourceType == bloodPressDataSource) {
            [self addTipPresure];
        }
        if (self.viewDataSourceType == heartBeatDataSource) {
            [self addTipHeartRate];
        }
    } else {
        [self.aCircleDataView setViewWithDate:nil
                                   withValue1:@""
                                   withValue2:@""
                                     withUnit:@""
                                      isEmpty:YES];
        
        [self addNoDataTip];
    }
}

- (void)resetLineGraph
{
    [_noDataBgView removeFromSuperview];
    [self removeAllLineView];
    
    if (self.displayRecordArray.count > 0) {
        [self addAllLineView];
    } else {
        [self addNoDataBg];
    }
}

- (void)setUnselectWithoutTag:(NSInteger)aTag
{
    for (UIButton *aBtn in self.buttonsArray) {
        if (aBtn.tag != aTag) {
            [aBtn setSelected:NO];
        }
    }
}

- (void)addTipPresure
{
    _pressureTip = [[UIImageView alloc]initWithFrame:ACGRectMake(0, 0, 280, 42)];
    _pressureTip.image = [UIImage imageNamed:@"bloodpresure"];

    if ([ADHelper isIphone4]) {
        _pressureTip.center = CGPointMake(self.view.frame.size.width /2 +8, 188 +24 +62);
    } else {
        _pressureTip.center =
//        CGPointMake(SCREEN_WIDTH /2 +8, 188 +6 +69);
        CGPointMake(SCREEN_WIDTH /2 +8, _aCircleDataView.frame.origin.y - _pressureTip.frame.size.height/2 + 2);
    }

    [self.view insertSubview:_pressureTip belowSubview:_aCircleDataView];
}

- (void)addTipHeartRate
{
    _heartRateTip = [[UIImageView alloc]initWithFrame:ACGRectMake(0, 0, 280, 42)];
    _heartRateTip.image = [UIImage imageNamed:@"babyHeartrate"];
    
    if ([ADHelper isIphone4]) {
        _heartRateTip.center = CGPointMake(self.view.frame.size.width /2 +8, 188 +24 +62);
    } else {
        _heartRateTip.center =
//        CGPointMake(self.view.frame.size.width /2 +8, 188 +6 +69);
        CGPointMake(SCREEN_WIDTH /2 +8, _aCircleDataView.frame.origin.y - _heartRateTip.frame.size.height/2 + 2);
    }

    [self.view insertSubview:_heartRateTip belowSubview:_aCircleDataView];
}

- (void)addLineViewWithIndex:(NSInteger)aInx
{
    [_lineView removeFromSuperview];
    [_lineView2 removeFromSuperview];
    
    int moveTopDistance = 0;
    UIImage *line1Img = nil;
    UIImage *line2Img = nil;
    if ([ADHelper isIphone4]) {
        moveTopDistance = 54;
        line1Img = [UIImage imageNamed:@"line1_4"];
        line2Img = [UIImage imageNamed:@"line2_4"];
    } else {
        line1Img = [UIImage imageNamed:@"line1"];
        line2Img = [UIImage imageNamed:@"line2"];
    }
    moveTopDistance -= 64;
    
    switch (aInx) {
        case 0: {
            if ([ADHelper isIphone4]) {
                _lineView = [[UIImageView alloc]initWithFrame:ACGRectMake(_circleSize/2 -56, 300 -moveTopDistance, 176, 77.5)];
            } else {
                _lineView = [[UIImageView alloc]initWithFrame:ACGRectMake(_circleSize/2 -56, 302 -moveTopDistance, 173, 85)];
            }
            _lineView.image = line1Img;
            
            if (_lineView.superview == nil) {
                [self.view insertSubview:_lineView belowSubview:_aCircleDataView];
            }
        } break;
        case 1: {
            if ([ADHelper isIphone4]) {
                _lineView = [[UIImageView alloc]initWithFrame:ACGRectMake(_circleSize/2 -56, 285 +_circleSize/2 -40 -moveTopDistance, 176, 40)];
            } else {
                _lineView = [[UIImageView alloc]initWithFrame:ACGRectMake(_circleSize/2 -56, 280 +_circleSize/2 -40 -moveTopDistance, 174, 42)];
            }
            _lineView.image = line2Img;
            if (_lineView.superview == nil) {
                [self.view insertSubview:_lineView belowSubview:_aCircleDataView];
            }
        } break;
        case 2: {
            _lineView2 = [[UIView alloc]initWithFrame:ACGRectMake(_circleSize/2 -56, 282 +_circleSize/2 -moveTopDistance, 173, 1.5)];
            _lineView2.backgroundColor = [UIColor btn_green_bgColor];//UIColorFromRGB(0x06F0C7);
            if (_lineView2.superview == nil) {
                [self.view insertSubview:_lineView2 belowSubview:_aCircleDataView];
            }
        } break;
        case 3: {
            if ([ADHelper isIphone4]) {
                _lineView = [[UIImageView alloc]initWithFrame:ACGRectMake(_circleSize/2 -56, 276 +_circleSize/2 +2 -moveTopDistance, 176, 40)];
            } else {
                _lineView = [[UIImageView alloc]initWithFrame:ACGRectMake(_circleSize/2 -56, 282 +_circleSize/2 +2 -moveTopDistance, 174, 42)];
            }
            _lineView.image = [line2Img flipVertical];
            if (_lineView.superview == nil) {
                [self.view insertSubview:_lineView belowSubview:_aCircleDataView];
            }
        } break;
        case 4: {
            if ([ADHelper isIphone4]) {
                _lineView = [[UIImageView alloc]initWithFrame:
                             ACGRectMake(_circleSize/2 -56, 276 +_circleSize/2 +1 -moveTopDistance, 176, 77.5)];
            } else {
                _lineView = [[UIImageView alloc]initWithFrame:
                             ACGRectMake(_circleSize/2 -56, 282 +_circleSize/2 +1 -moveTopDistance, 173, 85)];
            }

            _lineView.image = [line1Img flipVertical];
            if (_lineView.superview == nil) {
                [self.view insertSubview:_lineView belowSubview:_aCircleDataView];
            }
        } break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CustomHealthLineGraphViewDelegate method
- (NSInteger)numberOfPointsInCustomLineGraph:(CustomHealthLineGraphView *)aLineGraph
{
    return _displayRecordArray.count;
}

- (float)customLineGraph:(CustomHealthLineGraphView *)aLineGraph
           valueForIndex:(NSInteger)index
{
    ADCheckData *aData = self.displayRecordArray[index];
    switch (self.viewDataSourceType) {
        case weightDataSource:
            return aData.weight.floatValue;
        case bloodPressDataSource:
            return aData.lowBloodPress.floatValue;
        case heartBeatDataSource:
            return aData.heartBeat.floatValue;
        case palaceHeightDataSource:
            return aData.palaceHeight.floatValue;
        case abCircumferenceDataSource:
            return aData.abCircumference.floatValue;

        default:
            break;
    }
}

- (float)customLineGraph:(CustomHealthLineGraphView *)aLineGraph
          value2ForIndex:(NSInteger)index
{
    ADCheckData *aData = self.displayRecordArray[index];
    return aData.highBloodPress.floatValue;
}

- (NSString *)customLineGraph:(CustomHealthLineGraphView *)aLineGraph
                  tipForIndex:(NSInteger)index
{
    ADCheckData *aData = self.displayRecordArray[index];
    return [ADHelper getHealthLineLabelWithDate:aData.aDate];
}

- (void)customLineGraph:(CustomHealthLineGraphView *)aLineGraph didSelectAtIndex:(NSInteger)aIndex
{
    _currentSelectData = self.displayRecordArray[aIndex];
    _currentSelectDay = _currentSelectData.aDate;
    
    _currentSelectInx = aIndex;
//    NSLog(@"currentDay:%@",aCheckData.aDate);
    //变化Circle data view 数据
    [self setCircleDataViewWithData:_currentSelectData];
}

- (void)setCircleDataViewWithData:(ADCheckData *)aCheckData
{
    NSString *dateStr = [ADHelper getCircleTitleWithDate:aCheckData.aDate];
    NSString *value1 = @"";
    NSString *value2 = @"";
    NSString *unit = @"";
    switch (self.viewDataSourceType) {
        case weightDataSource:
            value1 = aCheckData.weight;
            unit = @"(kg)";
            break;
        case bloodPressDataSource:
            value1 = aCheckData.highBloodPress;
            value2 = aCheckData.lowBloodPress;
            unit = @"(mmhg)";
            break;
        case heartBeatDataSource:
            value1 = aCheckData.heartBeat;
            unit = @"(次/分)";
            break;
        case palaceHeightDataSource:
            value1 = aCheckData.palaceHeight;
            unit = @"(cm)";
            break;
        case abCircumferenceDataSource:
            value1 = aCheckData.abCircumference;
            unit = @"(cm)";
            break;
            
        default:
            break;
    }
    
    [self.aCircleDataView setViewWithDate:dateStr
                               withValue1:value1
                               withValue2:value2
                                 withUnit:unit
                                  isEmpty:NO];
}

- (NSInteger)recommandHighValue
{
    if (self.viewDataSourceType == bloodPressDataSource) {
        return 90;
    } else if (self.viewDataSourceType == heartBeatDataSource) {
        return 160;
    } else {
        //不需要警告值
        return 1000;
    }
}

- (NSInteger)recommandLowValue
{
    if (self.viewDataSourceType == bloodPressDataSource) {
        return 60;
    } else if (self.viewDataSourceType == heartBeatDataSource) {
        return 120;
    } else {
        //不需要警告值
        return 0;
    }
}

- (NSInteger)recommandHighValue2
{
    if (self.viewDataSourceType == bloodPressDataSource) {
        return 140;
    }
    return 1000;
}

- (NSInteger)recommandLowValue2
{
    if (self.viewDataSourceType == bloodPressDataSource) {
        return 90;
    }
    return 0;
}

#pragma mark - plus data method
- (void)plusData:(UIButton *)sender
{
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.delegate = self;
    dateSelectionVC.disableBouncingWhenShowing = YES;
    dateSelectionVC.disableMotionEffects = YES;
    dateSelectionVC.disableBlurEffects = NO;
    dateSelectionVC.hideNowButton = YES;
    
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionVC.datePicker.date = [NSDate date];
    dateSelectionVC.datePicker.maximumDate = [NSDate date];
    
    int daysToSub = -278;
    NSDate *beforeDate = [self.appDelegate.dueDate dateByAddingTimeInterval:60*60*24*daysToSub];
    dateSelectionVC.datePicker.minimumDate = beforeDate;
    
    [dateSelectionVC show];
}

- (void)showInputDataPicker
{
    RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
    pickerVC.delegate = self;
    
    pickerVC.disableBouncingWhenShowing = YES;
    pickerVC.disableMotionEffects = YES;
    pickerVC.disableBlurEffects = NO;
    
    switch (self.viewDataSourceType) {
        case weightDataSource: {
            //设置默认选中值
            pickerVC.titleLabel.text = @"体重";
            if (_currentSelectData.weight.length > 0) {
                NSString *selectValueStr = _currentSelectData.weight;
                NSLog(@"weight:%@", selectValueStr);
                NSRange intRange = [selectValueStr rangeOfString:@"."];
                NSString *intPart = [selectValueStr substringWithRange:NSMakeRange(0, intRange.location)];
                NSString *fracPart = [selectValueStr substringWithRange:
                                      NSMakeRange(intRange.location +1, selectValueStr.length -intRange.location -1)];
                
                [pickerVC.picker selectRow:intPart.intValue -40 inComponent:0 animated:NO];
                [pickerVC.picker selectRow:fracPart.intValue inComponent:1 animated:NO];
            } else {
                [pickerVC.picker selectRow:20 inComponent:0 animated:NO];
            }
        } break;
        case bloodPressDataSource: {
            pickerVC.titleLabel.text = @"舒张压 \t\t\t\t 收缩压";
//            NSLog(@"currentSelectData:%@",_currentSelectData);
            if (_currentSelectData.lowBloodPress.length > 0) {
                NSString *lowPress = _currentSelectData.lowBloodPress;
                NSString *highPress = _currentSelectData.highBloodPress;
                //设置默认选中值
                [pickerVC.picker selectRow:lowPress.intValue -40 inComponent:0 animated:NO];
                [pickerVC.picker selectRow:highPress.intValue -90 inComponent:1 animated:NO];
            } else {
                //设置默认选中值
                [pickerVC.picker selectRow:35 inComponent:0 animated:NO];
                [pickerVC.picker selectRow:35 inComponent:1 animated:NO];
            }
        } break;
        case heartBeatDataSource: {
            
            pickerVC.titleLabel.text = @"胎心率";
            if (_currentSelectData.heartBeat.length > 0) {
                NSString *selectValueStr = _currentSelectData.heartBeat;
                NSLog(@"selectValueStr:%@", selectValueStr);
                [pickerVC.picker selectRow:selectValueStr.intValue -110 inComponent:0 animated:NO];
            } else {
                [pickerVC.picker selectRow:25 inComponent:0 animated:NO];
            }
        } break;
        case palaceHeightDataSource:
            pickerVC.titleLabel.text = @"宫高";
            if (_currentSelectData.palaceHeight.length > 0) {
                NSString *selectValueStr = _currentSelectData.palaceHeight;
                NSRange intRange = [selectValueStr rangeOfString:@"."];
                NSString *intPart = [selectValueStr substringWithRange:NSMakeRange(0, intRange.location)];
                NSString *fracPart = [selectValueStr substringWithRange:
                                      NSMakeRange(intRange.location +1, selectValueStr.length -intRange.location -1)];

                [pickerVC.picker selectRow:intPart.intValue -10 inComponent:0 animated:NO];
                [pickerVC.picker selectRow:fracPart.intValue inComponent:1 animated:NO];
            } else {
                [pickerVC.picker selectRow:10 inComponent:0 animated:NO];
            }
            
            break;
        case abCircumferenceDataSource:
            pickerVC.titleLabel.text = @"腹围";
            if (_currentSelectData.abCircumference.length > 0) {
                NSString *selectValueStr = _currentSelectData.abCircumference;
                NSRange intRange = [selectValueStr rangeOfString:@"."];
                NSString *intPart = [selectValueStr substringWithRange:NSMakeRange(0, intRange.location)];
                NSString *fracPart = [selectValueStr substringWithRange:
                                      NSMakeRange(intRange.location +1, selectValueStr.length -intRange.location -1)];
                
                [pickerVC.picker selectRow:intPart.intValue -50 inComponent:0 animated:NO];
                [pickerVC.picker selectRow:fracPart.intValue inComponent:1 animated:NO];
            } else {
                [pickerVC.picker selectRow:30 inComponent:0 animated:NO];
            }
            
            break;
            
        default:
            break;
    }
    
    [pickerVC show];
}

- (NSNumber *)combineANum:(NSNumber *)aNum withDotNum:(NSNumber *)aDotNum
{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *myNumber = [f numberFromString:[NSString stringWithFormat:@"%@.%@",aNum, aDotNum]];
    
    return myNumber;
}

#pragma mark - RMPickerViewController Delegates
- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray *)selectedRows {
    NSNumber *selectRow1 = selectedRows[0];
    NSNumber *selectRow2;
    if (self.viewDataSourceType == bloodPressDataSource) {
        selectRow2 = selectedRows[1];
    }
    
    NSNumber *finalNum;
    if (self.viewDataSourceType == weightDataSource
        || self.viewDataSourceType == palaceHeightDataSource
        || self.viewDataSourceType == abCircumferenceDataSource) {
        selectRow2 = selectedRows[1];
        finalNum = [self combineANum:selectRow1 withDotNum:selectRow2];
    }
    
    ADCheckData *toAddData = nil;
//    找同一天有没有数据
//    ADCheckData *sameDayData = nil;
//    for (ADCheckData *aCheckData in self.allRecordArray) {
//        if ([aCheckData.aDate isEqualToDateIgnoringTime:_currentSelectDay]) {
//            sameDayData = aCheckData;
//            
//            break;
//        }
//    }
//    
//    NSString *sameDayWeight = sameDayData.weight == nil? @"":sameDayData.weight;
//    NSString *sameDayLowPress = sameDayData.lowBloodPress == nil? @"":sameDayData.lowBloodPress;
//    NSString *sameDayHighPress = sameDayData.highBloodPress == nil? @"":sameDayData.highBloodPress;
//    NSString *sameDayHeartBeat = sameDayData.heartBeat == nil? @"":sameDayData.heartBeat;
//    NSString *sameDayPlaceHeight = sameDayData.palaceHeight == nil? @"":sameDayData.palaceHeight;
//    NSString *sameDayAbCirum = sameDayData.abCircumference == nil? @"":sameDayData.abCircumference;
    
    switch (self.viewDataSourceType) {
        case weightDataSource:
            toAddData = [[ADCheckData alloc] initWithWeight:[NSString stringWithFormat:@"%.1f",
                                                             40 +[finalNum floatValue]]
                                                    andDate:_currentSelectDay];
            break;
            
        case bloodPressDataSource:
            toAddData =
            [[ADCheckData alloc] initWithLowBloodPress:[NSString stringWithFormat:@"%d",40 +[selectRow1 intValue]]
                                     andHighBloodPress:[NSString stringWithFormat:@"%d",90 +[selectRow2 intValue]]
                                               andDate:_currentSelectDay];
            
            break;
            
        case heartBeatDataSource:
            toAddData =
            [[ADCheckData alloc] initWithHeartBeat:[NSString stringWithFormat:@"%d",110 +[selectRow1 intValue]]
                                           andDate:_currentSelectDay];
            
            break;
            
        case palaceHeightDataSource:
            toAddData =
            [[ADCheckData alloc] initWithPalaceHeight:[NSString stringWithFormat:@"%.1f",10 +[finalNum floatValue]]
                                              andDate:_currentSelectDay];
            
            break;
            
        case abCircumferenceDataSource:
            toAddData =
            [[ADCheckData alloc] initWithAbCircumference:[NSString stringWithFormat:@"%.1f",50 +[finalNum floatValue]]
                                                 andDate:_currentSelectDay];
            
            break;
            
        default:
            break;
    }
    
    _currentSelectData = toAddData;
    [ADCheckArchivesDAO createOrUpdateCheckRecordWithData:toAddData];
    
    [self setupDisplayDataArray];
    
    [self refreshView];
    
    if ([_currentSelectDay isEqualToDateIgnoringTime:[NSDate date]]) {
        [self.healthLineGraph reloadGraph];
        
        ADCheckData *lastData = self.displayRecordArray[self.displayRecordArray.count -1];
        NSLog(@"lastData:%@", lastData);
        [self setCircleDataViewWithData:lastData];
        
        //滚动到最后
        if (_displayRecordArray.count *36 > self.view.frame.size.width) {
            [self.myScrollView setContentOffset:
             CGPointMake(_displayRecordArray.count *36 - self.view.frame.size.width, 0)];
        }
    } else {
        [self.healthLineGraph reloadGraphWithSelectInx:_currentSelectInx];
        [self setCircleDataViewWithData:_currentSelectData];
    }
}

// have problem
- (void)refreshView
{
    if (self.healthLineGraph.superview == nil &&
        self.displayRecordArray.count > 0) {
        [self.noDataBgView removeFromSuperview];
        
        [self addAllLineView];
                
        self.myScrollView.contentSize = CGSizeMake(_displayRecordArray.count *36, self.myScrollView.frame.size.height);
        
        [self.healthLineGraph reloadGraph];
        
    }

    //    NSLog(@"day:%@ %@",_currentSelectDay, [NSDate date]);
}

- (void)refreshCircleView
{
    ADCheckData *aData = self.displayRecordArray.lastObject;
    [self setCircleDataViewWithData:aData];
}

- (void)pickerViewControllerDidCancel:(RMPickerViewController *)vc {
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.viewDataSourceType == heartBeatDataSource) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (self.viewDataSourceType) {
        case weightDataSource:
            if (component == 0) {
                return 61;
            } else {
                return 10;
            }

        case bloodPressDataSource:
            if (component == 0) {
                return 101;
            } else {
                return 91;
            }
        case heartBeatDataSource:
            return 61;
        case palaceHeightDataSource:
            if (component == 0) {
                return 31;
            } else {
                return 10;
            }
        case abCircumferenceDataSource:
            if (component == 0) {
                return 101;
            } else {
                return 10;
            }

        default:
            break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (self.viewDataSourceType) {
        case weightDataSource: {
            if (component == 0) {
                return [NSString stringWithFormat:@"%lu", 40 +(long)row];
            } else {
                return [NSString stringWithFormat:@".%lu kg",(long)row];
            }
        } break;
        case bloodPressDataSource: {
            if (component == 0) {
                return [NSString stringWithFormat:@"%lu mmhg", 40 +(long)row];
            } else {
                return [NSString stringWithFormat:@"%lu mmhg", 90 +(long)row];
            }
        } break;
            
        case heartBeatDataSource: {
            return [NSString stringWithFormat:@"%lu 次/分", 110 +(long)row];
        } break;

        case palaceHeightDataSource: {
            if (component == 0) {
                return [NSString stringWithFormat:@"%lu", 10 +(long)row];
            } else {
                return [NSString stringWithFormat:@".%lu cm",(long)row];
            }

        } break;

        case abCircumferenceDataSource: {
            if (component == 0) {
                return [NSString stringWithFormat:@"%lu cm", 50 +(long)row];
            } else {
                return [NSString stringWithFormat:@".%lu cm",(long)row];
            }
        } break;
            
        default:
            break;
    }
    return @"";
}

- (void)editData:(UIButton *)sender
{
    if (_currentSelectDay == nil) {
        ADCheckData *lastData = self.displayRecordArray[self.displayRecordArray.count -1];
        _currentSelectDay = lastData.aDate;
    }
    [self showInputDataPicker];
}

- (void)tapLabel:(UITapGestureRecognizer *)sender
{
    if (_currentSelectDay == nil) {
        ADCheckData *lastData =
        self.displayRecordArray[self.displayRecordArray.count -1];
        _currentSelectDay = lastData.aDate;
    }
    [self showInputDataPicker];
}

CG_INLINE CGRect
ACGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    ADAppDelegate *myDelegate = APP_DELEGATE;
    CGRect rect;
    rect.origin.x = x * myDelegate.autoSizeScaleX; rect.origin.y = y * myDelegate.autoSizeScaleY;
    rect.size.width = width * myDelegate.autoSizeScaleX; rect.size.height = height * myDelegate.autoSizeScaleY;
    return rect;
}

#pragma mark - RMDAteSelectionViewController Delegates
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    _currentSelectDay = aDate;
    _currentSelectData = [ADCheckArchivesDAO findACheckDataWithDate:aDate];
    [self performSelector:@selector(showInputDataPicker) withObject:nil afterDelay:0.38];
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
}

#pragma mark - sync method
- (void)syncAllDataOnFinish:(void(^)(NSError *error))finishBlock
{
    [ADCheckArchivesDAO syncAllDataOnGetData:^(NSError *error) {
        self.allRecordArray = [ADCheckArchivesDAO readAllData];
        [self setupDisplayDataArray];
        
        [self refreshView];
        [self refreshCircleView];
    } onUploadProcess:^(NSError *error) {
        [self rotateSyncBtn];
    } onUpdateFinish:^(NSError *error) {
        if (error != nil) {
            NSLog(@"err:%@", error);
            if (error.code == 100) {
                self.syncBtn.hidden = YES;
            } else {
                [self setNeedUploadBtn];
            }
        } else {
            [self stopRotateSyncBtn];
        }
    }];
}

@end