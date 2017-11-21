//
//  ADCountFetalViewController.m
//  PregnantAssistant
//
//  Created by D on 14-10-10.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADCountFetalViewController.h"
#import "ADHowToCntViewController.h"
#import "ADOneHourDataView.h"
#import "NSTimer+Pausing.h"

#define SHOW_ONEVIEW_KEY @"showOneViewkey"
#define TOP_BAR_HEIGHT 48

static NSString *minTip = @"5分钟连续记录算一次";
static NSString *howCntTip = @"怎样数胎动?";
static NSString *validKey = @"LASTVALIDKEY";


@interface ADCountFetalViewController ()
@end

@implementation ADCountFetalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTitle = @"数胎动";
    self.view.backgroundColor = [UIColor bg_lightYellow];
    
    [self showSyncAlert];
    
    [ADCountFetalDAO updateDataBaseOnfinish:^{
    
        self.todayFirstClickDate = [ADCountFetalDAO getTodayFirstAddOneDate];
        
        NSLog(@"today first:%@", self.todayFirstClickDate);
        [self updateDataWithDate:[NSDate date]];
        NSLog(@"load dateArray:%@",_allHourArray);

        [self addCal];
        if (_allHourArray.count == 0) {
            [self addZeroDataView];
        } else {
            [self addScrollView];
            [self addLineDataView];
            [self setDotScrollView];
            [self addTodayNum];
            [self addReadTipImage];
            
            [self addCalcCntView];
            //专心一小时
            if (_todayOneHourArray.count > 0) {
                [self addAHourView];
            }
            
            [self setScrollView];
        }

        [self addBottomCount];
    }];
    
    //启动计时器 1h 后显示分析界面
    _showDataTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(showCalcData)
                                                    userInfo:nil
                                                     repeats:YES];
    [self syncAllDataOnFinish:^(NSError *error) {
    }];
}

- (void)back
{
    [self syncAllDataOnFinish:^(NSError *error) {
    }];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cntDayChanged)
                                                 name:NOTIFICATION_CNT_DAY_CHANGED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cntDayChanged)
                                                 name:NOTIFICATION_CHANGE_CNT_TODAY
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)cntDayChanged
{
    //获取某天每个小时胎动数据
    [self updateDataWithDate:self.appDelegate.cntDisplayDate];
    
    //remove
    [self removeDataView];
    [self removeOperationAndEmpty];
    
    //没有数据 变成空页面
    if (_allHourArray.count == 0) {
        [self addZeroDataView];
        NSLog(@"zero view");
    } else {
        NSLog(@"data view");
        [self addScrollView];
        [self addLineDataView];
        [self addTodayNum];
        [self addReadTipImage];
        
        [self addCalcCntView];
        
        //算出每个小时胎动几次，添加到perHourValuesArray
        [self.lineGraph reloadGraph];
        
        [self setDotScrollView];
        
        //更新今日记录胎动总数
        _todayView.cnt = _allHourArray.count;

        //更新推算最多一小时
        _calcCntView.mostHourLabel.text = [ADHelper getMostHourWithDate:_mostHour];

        _calcCntView.mostHourTimeLabel.text = [NSString stringWithFormat:@"%@ 次", _mostHourNum];
        //更新平均胎动 推算胎动总数
        _calcCntView.perHour = _avgHourNum;

        //查找这一天 是否有专心一小时数据
        
        //删除oneHourDataView
        for (ADOneHourDataView *aView in self.perOneHourViewArray) {
            [aView removeFromSuperview];
        }
        [self.perOneHourViewArray removeAllObjects];
       
        //有专心一小时数据 显示
        if (_todayOneHourArray.count > 0) {
            [self addAHourView];
        }
        
        if (_todayOneHourArray.count > 0) {
            self.myScrollView.contentSize =
            CGSizeMake(SCREEN_WIDTH, _todayOneHourArray.count *36 +
                       _calcCntView.frame.size.height +_calcCntView.frame.origin.y +4);
        } else {
            //没有专心1小时数据
            self.myScrollView.contentSize =
            CGSizeMake(SCREEN_WIDTH, 90 +_tipImgView.frame.size.height +_tipImgView.frame.origin.y +28);
        }
    }
}

- (void)removeDataView
{
    [_myScrollView removeFromSuperview];
}

- (void)becomeActive
{
    if (_oneView.superview != nil) {
        NSLog(@"right");
        [_oneView.durationTimer setFireDate:[NSDate date]];

        //更新倒计时
        NSDate *now = [NSDate date];
        _showOneViewDate = [[NSUserDefaults standardUserDefaults]objectForKey:SHOW_ONEVIEW_KEY];
        NSLog(@"now:%@ show:%@",now, _showOneViewDate);
        NSTimeInterval durationTime = [now timeIntervalSinceDate:_showOneViewDate];
        NSLog(@"time:%f",durationTime);
        int remSec = 3600 - durationTime;
        
        int min = remSec /60 %60;
        int sec = remSec %60;
        _oneView.durationTime = durationTime;
        if (sec >= 0) {
            _oneView.reminTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", min, sec];
        }
        
        // 改变按钮 为完成
        if (remSec <= 0) {
            _oneView.reminTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", 0, 0];
            [_aCntView changeFinishButton];
            //停止计时
            [_oneView.durationTimer pause];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //阻止锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self addObservers];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //允许锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_showDataTimer invalidate];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (void)addTodayNum
{
    _todayView = [[ADTodayRecordNumView alloc]initWithFrame:
     CGRectMake(0, _graphBackgroundScrollView.frame.size.height + _graphBackgroundScrollView.frame.origin.y,
                SCREEN_WIDTH, 188/2)];
    
//    NSLog(@"today allHourArray:%@",_allHourArray);
    //设置今日胎动总数
    _todayView.cnt = _allHourArray.count;
    [self.myScrollView addSubview:_todayView];
}

- (void)addScrollView
{
    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64 + TOP_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT -64 -90 -48)];

    if (self.myScrollView.superview == nil) {
        [self.view addSubview:self.myScrollView];
    }
}

- (void)setScrollView
{
    //没有专心一小时数据
    if (_todayOneHourArray.count == 0) {
        self.myScrollView.contentSize =
        CGSizeMake(SCREEN_WIDTH, 90 +_tipImgView.frame.size.height +_tipImgView.frame.origin.y +28);
    } else {
        self.myScrollView.contentSize =
        CGSizeMake(SCREEN_WIDTH, _todayOneHourArray.count *36 +_calcCntView.frame.size.height +_calcCntView.frame.origin.y +4);
    }
}

- (void)addReadTipImage
{
    _tipImgView =
    [[UIImageView alloc]initWithFrame:
     CGRectMake(30, _todayView.frame.origin.y + _todayView.frame.size.height +9, 129, 43)];
    _tipImgView.image = [UIImage imageNamed:@"智能解读"];
    [self.myScrollView addSubview:_tipImgView];
    UIView *lineView = [[UIView alloc]initWithFrame:
                        CGRectMake(15, _tipImgView.frame.origin.y +_tipImgView.frame.size.height, SCREEN_WIDTH -30, 1)];
    lineView.backgroundColor = [UIColor light_green_Btn];
    [self.myScrollView addSubview:lineView];
}

- (void)addCalcCntView
{
    _calcCntView = [[ADCalcFetalView alloc]initWithFrame:
                    CGRectMake(0, _tipImgView.frame.origin.y + _tipImgView.frame.size.height +2, SCREEN_WIDTH, 116)];

    _calcCntView.perHour = _avgHourNum;
    _calcCntView.mostHourLabel.text = [ADHelper getMostHourWithDate:_mostHour];

    _calcCntView.mostHourTimeLabel.text = [NSString stringWithFormat:@"%@ 次", _mostHourNum];
    
    [self.myScrollView addSubview:_calcCntView];
    //记录今天第一次点击+1 时间 for 1h 后 显示分析界面
    if (![self.appDelegate.cntDisplayDate isEqualToDateIgnoringTime:[NSDate date]]) {
        [_calcCntView showDataWithAnimation:NO];
    } else if (self.todayFirstClickDate == nil) {
        //do noting
        NSLog(@"no date");
    } else if ([ADHelper isDurationBigger1Hour:[NSDate date] date2:self.todayFirstClickDate]) {
        NSLog(@"show here");
        [_calcCntView showDataWithAnimation:NO];
    } else if (![self.todayFirstClickDate isEqualToDateIgnoringTime:self.appDelegate.cntDisplayDate]) {
        NSLog(@"show here 2");
        [_calcCntView showDataWithAnimation:NO];
    } else {
        //同一天 间隔时间小于5min
        NSLog(@"!! aDate:%@ display:%@", _todayFirstClickDate, self.appDelegate.cntDisplayDate);
    }
}

- (void)addCal
{
    _aCalendarView = [[ADCalendarView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, TOP_BAR_HEIGHT)
                                            withIsCntView:YES];
    
    [self.view addSubview:_aCalendarView];
}

- (void)addLineDataView
{
    _cloadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 316/2)];
    _cloadImageView.image = [UIImage imageNamed:@"redCload_bg"];
    _cloadImageView.userInteractionEnabled = YES;
    [self.myScrollView addSubview:_cloadImageView];
    
    self.graphBackgroundScrollView = [[UIScrollView alloc] initWithFrame:
                                      CGRectMake(0, 0, SCREEN_WIDTH, _cloadImageView.frame.size.height)];
    _graphBackgroundScrollView.backgroundColor = [UIColor clearColor];
    _graphBackgroundScrollView.bouncesZoom = NO;
    _graphBackgroundScrollView.showsHorizontalScrollIndicator = NO;
    int yMargin = 80;
    _graphBackgroundScrollView.bounces = NO;
    _graphBackgroundScrollView.contentSize = CGSizeMake(SCREEN_WIDTH *2, _graphBackgroundScrollView.frame.size.height - yMargin);
    [_cloadImageView addSubview:_graphBackgroundScrollView];
    
    self.lineGraph = [[ADLineGraphView alloc]
                      initWithFrame:CGRectMake(0,0, SCREEN_WIDTH *2, _graphBackgroundScrollView.frame.size.height)];
    _lineGraph.delegate = self;
    _lineGraph.backgroundColor = [UIColor clearColor];
    _lineGraph.colorLine = [UIColor light_green_Btn];
//    _lineGraph.colorXaxisLabel = [UIColor light_green_Btn];

    _lineGraph.widthLine = 1.0;
    _lineGraph.alphaLine = 1.0;
    _lineGraph.animationGraphEntranceSpeed = 5.0;
    [_graphBackgroundScrollView addSubview:_lineGraph];
}

- (void)addAHourView
{
    float posY = _calcCntView.frame.origin.y + _calcCntView.frame.size.height;
    
    for (int i = 0; i < _todayOneHourArray.count; i++) {
        ADEveryHourCountRecord *aRecord = _todayOneHourArray[i];
        
        ADOneHourDataView *aHourData =
        [[ADOneHourDataView alloc]initWithFrame:CGRectMake(0, posY + i*36, SCREEN_WIDTH, 36)];
        
        aHourData.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                    [ADHelper getHourAndMinWithDate:aRecord.recordTime],
                                    [ADHelper getHourAndMinWithDate:aRecord.endTime]];
        aHourData.numLabel.text = [NSString stringWithFormat:@"%@ 次", aRecord.cntTimes];
        
        [self.myScrollView addSubview:aHourData];
        
        [self.perOneHourViewArray addObject:aHourData];
    }
    _originTablePerHourValuesArrayCnt = (int)_todayOneHourArray.count;
    NSLog(@"pos Y:%f _originTablePerHourValuesArrayCnt:%d", posY, _originTablePerHourValuesArrayCnt);
}

//专心一小时页面返回 更新主页面
- (void)updateAHourView
{
    float posY = _calcCntView.frame.origin.y + _calcCntView.frame.size.height;
    for (int i = _originTablePerHourValuesArrayCnt; i < _todayOneHourArray.count; i++) {
        ADEveryHourCountRecord *aRecord = _todayOneHourArray[i];
        
        ADOneHourDataView *aHourData =
        [[ADOneHourDataView alloc]initWithFrame:CGRectMake(0, posY + i*36, SCREEN_WIDTH, 36)];
        
        aHourData.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                    [ADHelper getHourAndMinWithDate:aRecord.recordTime],
                                    [ADHelper getHourAndMinWithDate:aRecord.endTime]];
        aHourData.numLabel.text = [NSString stringWithFormat:@"%@ 次", aRecord.cntTimes];
        
        [self.myScrollView addSubview:aHourData];
        
        [self.perOneHourViewArray addObject:aHourData];
    }
//    NSLog(@"pos Y:%f _originTablePerHourValuesArrayCnt:%d", posY, _originTablePerHourValuesArrayCnt);
}

- (void)addZeroDataView
{
    [self addEmptyImageAndTip];
    [self addOperationTip];
}

- (void)addEmptyImageAndTip
{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 86, 254/2)];
    imgView.image = [UIImage imageNamed:@"暂无记录绿色"];
    _emptyBgView = [[UIView alloc]init];
    _emptyBgView.backgroundColor = [UIColor whiteColor];
    
    UIButton *howCntBtn = [self howToBtn];

    howCntBtn.center = CGPointMake(SCREEN_WIDTH /2, 24);
    if (iPhone6) {
        imgView.center = CGPointMake(SCREEN_WIDTH /2, 184);
        _emptyBgView.frame = CGRectMake(0, 64 + TOP_BAR_HEIGHT, SCREEN_WIDTH, 315);
    } else if (iPhone6Plus) {
        imgView.center = CGPointMake(SCREEN_WIDTH /2, 224);
        _emptyBgView.frame = CGRectMake(0, 64 + TOP_BAR_HEIGHT, SCREEN_WIDTH, 1148/3.0);
    } else if ([ADHelper isIphone4]) {
        imgView.center = CGPointMake(SCREEN_WIDTH /2, 120);
        _emptyBgView.frame = CGRectMake(0, 64 + TOP_BAR_HEIGHT, SCREEN_WIDTH, 362/2);
    } else {
        imgView.center = CGPointMake(SCREEN_WIDTH /2, 124);
        _emptyBgView.frame = CGRectMake(0, 64 + TOP_BAR_HEIGHT, SCREEN_WIDTH, (SCREEN_WIDTH+ 124)/2);
    }
    
    [_emptyBgView addSubview:howCntBtn];
    [_emptyBgView addSubview:imgView];
    
    if (_emptyBgView.superview == nil) {
        [self.view addSubview:_emptyBgView];
    }
}

- (void)addOperationTip
{
    _howImgView = [[UIImageView alloc]init];
    
    if ([ADHelper isIphone4]) {
        _howImgView.image = [UIImage imageNamed:@"如何操作_2"];
        _howImgView.frame =
        CGRectMake(12, SCREEN_HEIGHT -90 -149./2 , SCREEN_WIDTH -24, 149./2);
    } else if(iPhone6Plus) {
        _howImgView.image = [UIImage imageNamed:@"如何操作6plus"];
        _howImgView.frame =
        CGRectMake(12, SCREEN_HEIGHT -90 -280/2, SCREEN_WIDTH -24, 280/2);
    } else if(iPhone6) {
        _howImgView.image = [UIImage imageNamed:@"如何操作6"];
        _howImgView.frame =
        CGRectMake(12, SCREEN_HEIGHT -90 -280/2, SCREEN_WIDTH -24, 280/2);
    } else {
        _howImgView.image = [UIImage imageNamed:@"如何操作"];
        _howImgView.frame =
        CGRectMake(12, SCREEN_HEIGHT -90 -260/2, SCREEN_WIDTH -24, 125);
    }
    
    if (_howImgView.superview == nil) {
        [self.view addSubview:_howImgView];
    }
}

- (void)removeOperationAndEmpty
{
    [_emptyBgView removeFromSuperview];
    [_howImgView removeFromSuperview];
}

- (void)showOneView
{
    _isAnimatingOneView = YES;
    UIWindow *shareWindow = [UIApplication sharedApplication].keyWindow;
    float oneViewHeight = SCREEN_HEIGHT - 90; //bar height
    
    if (_oneView == nil) {
        _oneView = [[ADOneHourView alloc]initWithFrame:
                    CGRectMake(0, SCREEN_HEIGHT -90, SCREEN_WIDTH, oneViewHeight)];
    }
    [shareWindow addSubview:_oneView];
    
    //移动底部计数view 到window上
    [_aCntView removeFromSuperview];
    
    [shareWindow addSubview:_aCntView];

    _isOneViewShow = YES;
    //重置验证后次数
    _oneView.validCount = 0;
    
    _showOneViewDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:_showOneViewDate forKey:SHOW_ONEVIEW_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];

    [UIView animateWithDuration:0.24 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect oneFrame = _oneView.frame;
                         oneFrame.origin.y = 0;
                         _oneView.frame = oneFrame;
                         //点击后改为数字
                         [_aCntView changeCntBtnToNum];
                         //设置开始时间
                         _oneView.beginTimeLabel.text =
                         [NSString stringWithFormat:@"开始时间:%@", [ADHelper getCurrentHourAndMin]];
                     } completion:^(BOOL finished) {
                         [_oneView startTimer];
                         [ADHelper changeStatusBarColorblack];
                         _isAnimatingOneView = NO;
                     }];
}

- (void)hideOneView
{
    _isOneViewShow = NO;
    _isAnimatingOneView = YES;
    float oneViewHeight = SCREEN_HEIGHT - 90; //bar height
    
//   有实际计数时 存储专心一小时数据
    if (_oneView.validCount > 0) {
        NSLog(@"here once");

        _showOneViewDate = [[NSUserDefaults standardUserDefaults]objectForKey:SHOW_ONEVIEW_KEY];
        NSLog(@"start:%@", _showOneViewDate);
//        NSLog(@"start:%@ - %@",_aCntView.validStartTime, _aCntView.validEndTime);
        if (_oneHourValidStartTime != nil && _oneHourValidEndTime != nil) {
            
            [ADCountFetalDAO addAOneHourRecordWithStartDate:_showOneViewDate andEndDate:_oneHourValidEndTime
                                                 andCntTime:@(_oneView.validCount).stringValue];
            
            _oneHourValidStartTime = nil;
            _oneHourValidEndTime = nil;

            _todayOneHourArray = [ADCountFetalDAO readTableOneHourArrayWithDate:[NSDate date]];
            NSLog(@"todayOneHourArray:%@", _todayOneHourArray);
//            NSLog(@"_tablePerHourValuesArray:%@", _todayOneHourArray);
            //改变主页面
            [self updateAHourView];
            self.myScrollView.contentSize = CGSizeMake
            (SCREEN_WIDTH, _todayOneHourArray.count *36 +_calcCntView.frame.size.height +_calcCntView.frame.origin.y +4);
        }
    }
    
    [UIView animateWithDuration:0.24 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect oneFrame = _oneView.frame;
                         oneFrame.origin.y = oneViewHeight;
                         _oneView.frame = oneFrame;
                     } completion:^(BOOL finished) {
                         [_oneView removeFromSuperview];
                         [_aCntView removeFromSuperview];
                         
                         [self.view addSubview:_aCntView];
                         
                         if (_oneView.allCnt > 0) {
                             [self showCntTip];
                         }
                         [_oneView resetTimer];
                         _isAnimatingOneView = NO;
                     }];
}

- (void)setDotScrollView
{
    int Xindex = 0;
    for (Xindex = 0; Xindex < _perHourValuesArray.count; Xindex++) {
        if (![_perHourValuesArray[Xindex] isEqualToString:@"0"]) {
            break;
        }
    }
    
    if (Xindex >= 0 && Xindex <= 11) {
        _graphBackgroundScrollView.contentOffset = CGPointZero;
    } else if(Xindex >11 && Xindex <=13) {
        _graphBackgroundScrollView.contentOffset = CGPointMake(160 + (Xindex - 11)*48/2, 0);
    } else {
        _graphBackgroundScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }
}

- (void)addOneView
{
    _oneView.allCnt +=1;
    _oneView.totalHeadLabel.text = [NSString stringWithFormat:@"实际记录%d次", [_oneView allCnt]];
}

- (void)showCalcData
{
//    NSLog(@"today:%@", _todayFirstClickDate);
    //已经显示 不再执行
    if(_calcCntView.tip1.hidden == NO) {
        return;
    }
    if (_todayFirstClickDate == nil) {
        return;
    } else if ([ADHelper isDurationBigger1Hour:[NSDate date] date2:_todayFirstClickDate]) {
        [_calcCntView showDataWithAnimation:YES];
    }
}

- (void)addValidOneInHome
{
    if (_isOneViewShow) {
        _oneView.validCount += 1;
    }
    
    NSLog(@"display:%@ date:%@",self.appDelegate.cntDisplayDate, [NSDate date]);
    if (![[NSDate date] isEqualToDateIgnoringTime:self.appDelegate.cntDisplayDate]) {
        _allHourArray = [ADCountFetalDAO readAllHourArrayWithDate:[NSDate date]];
        NSLog(@"_allHourArray read:%@",_allHourArray);
        
        if (self.valiedClickDate != nil) {
            //重复的不再添加
            BOOL haveSame = NO;
            for (ADEveryHourCountRecord *aRecord in _allHourArray) {
                NSDate *aDate = aRecord.recordTime;
                if ([aDate isEqualToDate:self.valiedClickDate]) {
                    haveSame = YES;
                }
            }
            NSLog(@"same:%d", haveSame);
            if (haveSame == NO) {
                [ADCountFetalDAO addAEveryHourRecordWithStartDate:self.valiedClickDate];
                NSLog(@"_allHourArray added:%@",_allHourArray);
            }
            //改变日期title
            [self.aCalendarView setDayLabelWithDate:[NSDate date]];
            self.appDelegate.cntDisplayDate = [NSDate date];
            [self changeToToday];
        }
    } else {
        NSLog(@"out");
        
        //存储每次点击验证后时间
        //验证后的时间
        [ADCountFetalDAO addAEveryHourRecordWithStartDate:self.valiedClickDate];
        
        //添加数据图
        [self showDataViewWithAnimation];
        
        //主页更新
        //更新线图
        NSInteger hour = self.valiedClickDate.hour;
        NSString *hourCnt = self.perHourValuesArray[hour];
//        int hourCntNum = hourCnt.intValue;
//        hourCntNum += 1;
//        self.perHourValuesArray[hour] = [NSString stringWithFormat:@"%d", hourCntNum];
        self.perHourValuesArray[hour] = @(hourCnt.intValue + 1).stringValue;
        
        [self.lineGraph reloadGraph];
        [self setDotScrollView];
        
        //今日记录胎动总数
        _todayView.cnt = _allHourArray.count;
        //更新推算最多一小时
        [ADCountFetalDAO transHourAndTimeWithAllHourArray:_allHourArray onFinish:^(NSMutableArray *res) {
            _transformedHourArray = res;
            NSArray *mostHourAndTime = [ADCountFetalDAO findTheMaxHourInEveryHourArray:_transformedHourArray];
            ADEveryHourCountRecord *aRecord = mostHourAndTime[0];
            _mostHour = aRecord.recordTime;
            _mostHourNum = mostHourAndTime[1];
            
            NSLog(@"count most: %@", mostHourAndTime);
            
            _calcCntView.mostHourLabel.text = [ADHelper getMostHourWithDate:_mostHour];

            _calcCntView.mostHourTimeLabel.text = [NSString stringWithFormat:@"%@ 次", _mostHourNum];
            //更新平均胎动 推算胎动总数
            _avgHourNum = [ADCountFetalDAO calcAverageHourCnt:_transformedHourArray
                                                 withMostHour:_mostHour
                                              withMostHourNum:_mostHourNum];
            
            _calcCntView.perHour = _avgHourNum;
        }];
    }
}

- (void)showDataViewWithAnimation
{
    if (self.lineGraph == nil) {
        [self addScrollView];
        [self addLineDataView];
        _cloadImageView.alpha = 0;
        _lineGraph.alpha = 0;
        [self addTodayNum];
        _todayView.alpha = 0;
        [self addReadTipImage];
        _tipImgView.alpha = 0;
        
        //小于1h 不显示分析界面
        [self addCalcCntView];
        _calcCntView.alpha = 0;
        
        //移除空图
        _emptyBgView.alpha = 0;
        _howImgView.alpha = 0;
        [self removeOperationAndEmpty];
        
        [UIView animateWithDuration:0.3 delay:0.05
             usingSpringWithDamping:1 initialSpringVelocity:5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _cloadImageView.alpha = 1;
                             _lineGraph.alpha = 1;
                             _todayView.alpha = 1;
                             _tipImgView.alpha = 1;
                             _calcCntView.alpha = 1;
                             
                             if (_todayOneHourArray.count > 0) {
                                 [self addAHourView];
                             }
                             [self setScrollView];
                         } completion:^(BOOL finished) {
                         }];
    }
}

//切换到今天页面
- (void)changeToToday
{
    //没有数据 变成空页面
    if (_allHourArray.count == 0) {
        NSLog(@"wrong case");
    } else {
        //remove view
        [self removeDataView];
        [self removeOperationAndEmpty];

        //add
        NSLog(@"allHourArraycount:%d", (int)_allHourArray.count);
        
        //add view
        [self addScrollView];
        [self addLineDataView];
        [self addTodayNum];
        [self addReadTipImage];
        
        [self addCalcCntView];
        
        //算出每个小时胎动几次，添加到perHourValuesArray
        self.perHourValuesArray = [ADCountFetalDAO calcPerHourCntWithAllHourArray:_allHourArray];
        [self.lineGraph reloadGraph];
        
        [self setDotScrollView];
        
        //更新今日记录胎动总数
        _todayView.cnt = _allHourArray.count;
        
        //更新推算最多一小时
        [ADCountFetalDAO transHourAndTimeWithAllHourArray:_allHourArray onFinish:^(NSMutableArray *res) {
            _transformedHourArray = res;
            NSArray *mostHourAndTime = [ADCountFetalDAO findTheMaxHourInEveryHourArray:_transformedHourArray];
            ADEveryHourCountRecord *aRecord = mostHourAndTime[0];
            _mostHour = aRecord.recordTime;
            _mostHourNum = mostHourAndTime[1];
            
            _calcCntView.mostHourLabel.text = [ADHelper getMostHourWithDate:_mostHour];

            _calcCntView.mostHourTimeLabel.text = [NSString stringWithFormat:@"%@ 次", _mostHourNum];
            //更新平均胎动 推算胎动总数
            _avgHourNum = [ADCountFetalDAO calcAverageHourCnt:_transformedHourArray
                                                 withMostHour:_mostHour
                                              withMostHourNum:_mostHourNum];
            
            _calcCntView.perHour = _avgHourNum;
            
            //查找这一天 是否有专心一小时数据
            [self updateDataWithDate:[NSDate date]];
            
            for (ADOneHourDataView *aView in self.perOneHourViewArray) {
                [aView removeFromSuperview];
            }
            [self.perOneHourViewArray removeAllObjects];
            
            //有专心一小时数据 显示
            if (_todayOneHourArray.count > 0) {
                [self addAHourView];
            }
            
            if (_todayOneHourArray.count > 0) {
                self.myScrollView.contentSize =
                CGSizeMake(SCREEN_WIDTH, _todayOneHourArray.count *36 +
                           _calcCntView.frame.size.height +_calcCntView.frame.origin.y +4);
            } else {
                //没有专心1小时数据
                self.myScrollView.contentSize =
                CGSizeMake(SCREEN_WIDTH, 90 +_tipImgView.frame.size.height +_tipImgView.frame.origin.y +28);
            }
        }];
    }
}

- (UIButton *)howToBtn
{
    UIButton *howTo = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 294/2, 58/2)];
    [howTo setTitleColor:[UIColor colorWithRed:0.733 green:0.635 blue:0.561 alpha:1.0]
                forState:UIControlStateNormal];
    howTo.titleLabel.font = [UIFont systemFontOfSize:14];
    [howTo setTitle:howCntTip forState:UIControlStateNormal];
    
    [howTo setClipsToBounds:YES];
    [howTo.layer setCornerRadius:58/4];
    
    [howTo setBackgroundColor:[UIColor bg_lightYellow]];
    
    [howTo addTarget:self action:@selector(pushHowTo) forControlEvents:UIControlEventTouchUpInside];
    return howTo;
}

- (void)addBottomCount
{
    if (_aCntView == nil) {
        _aCntView =
        [[ADCntFetalView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT -90, SCREEN_WIDTH, 90)];
        _aCntView.delegate = self;
    
        [self.view addSubview:_aCntView];
//        [self.view bringSubviewToFront:_aCntView];
    }
}

- (void)pushHowTo
{
    [self.navigationController pushViewController:[[ADHowToCntViewController alloc]init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateDataWithDate:(NSDate *)aDate
{
    _todayOneHourArray = [ADCountFetalDAO readTableOneHourArrayWithDate:aDate];
    _allHourArray = [ADCountFetalDAO readAllHourArrayWithDate:aDate];

    _perOneHourViewArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    //初始化perHourArray
    _perHourValuesArray = [ADCountFetalDAO calcPerHourCntWithAllHourArray:_allHourArray];
//    _transformedHourArray = [ADCountFetalDAO transHourAndTimeWithAllHourArray:_allHourArray];
    NSLog(@"allHour: %@", _allHourArray);
    [ADCountFetalDAO transHourAndTimeWithAllHourArray:_allHourArray onFinish:^(NSMutableArray *res) {
        _transformedHourArray = res;
        
        NSArray *mostHourAndTime = [ADCountFetalDAO findTheMaxHourInEveryHourArray:_transformedHourArray];
        NSLog(@"!! transArray:%@", _transformedHourArray);
        NSLog(@"mostHour:%@", mostHourAndTime);
        //    _mostHour = mostHourAndTime[0];
        
        ADEveryHourCountRecord *aRecord = mostHourAndTime[0];
        _mostHour = aRecord.recordTime;
        
        NSLog(@"most:%@", _mostHour);
        
        _mostHourNum = mostHourAndTime[1];
        
        _avgHourNum = [ADCountFetalDAO calcAverageHourCnt:_transformedHourArray
                                             withMostHour:_mostHour
                                          withMostHourNum:_mostHourNum];
    }];
}

#pragma mark - SimpleLineGraph Data Source
- (int)numberOfPointsInGraph {
    return (int)[_perHourValuesArray count];
}

- (float)valueForIndex:(NSInteger)index {
    return [_perHourValuesArray[index] floatValue];
}

//optional delegate method
- (int)numberOfGradesInYAxis
{
    return 12 - 1;
}

#pragma mark - SimpleLineGraph Delegate
- (int)numberOfGapsBetweenLabels {
    return 0;
}

- (NSString *)labelOnXAxisForIndex:(NSInteger)index {
//    return [ADHelper getTwentyfourHours][index];
    return [ADHelper getStrAtHour:index];
}

#pragma mark - cntFetalView delegate
- (void)proButtonClick:(UIButton *)sender
{
    if (_isAnimatingOneView) {
        return;
    }
    
    if (sender.selected) {
        sender.selected = NO;
        //如果记录了实际数量 记录结束时间
        _oneHourValidEndTime = [NSDate date];

        [self hideOneView];
    } else {
        sender.selected = YES;
        
        [self showOneView];
    }
}

- (void)finishProButtonClick
{
    NSDate *showDate = [[NSUserDefaults standardUserDefaults]objectForKey:SHOW_ONEVIEW_KEY];
    
    _oneHourValidEndTime = [showDate dateByAddingTimeInterval:60*60];
    //清除开始时间 结束时间
    [self hideOneView];
}

- (void)addOneBtnClicked:(UIButton *)sender
{
    //记录当前时间 判断时间是否超过5min
    NSDate *now = [NSDate date];
    
    NSDate *lastValidDate = [ADCountFetalDAO getLastValidData];
    NSLog(@"date: %@", lastValidDate);
    //第一次
    
//    if ([now isEqualToDateIgnoringTime:lastValidDate]) {
        // judge time
        if ([now minutesAfterDate:lastValidDate] >=5 || lastValidDate == nil) {
            NSLog(@"is right");
            if (_oneHourValidStartTime == nil) {
                //记录有效开始时间
                _oneHourValidStartTime = now;
            }
            
            //每次点击后验证成功 时间
            self.valiedClickDate = now;
            
            NSLog(@"add once same day");
            //增加实际计数
            [self addValidOneInHome];
        } else {
            //主页面中显示提示
            [self showFiveMinView];
        }
//    } else {
//        //            NSLog(@"not in the same day  now:%@ valid:%@", now, self.appDelegate.valiedClickDate);
//        //不在同一天
//        //第一比较时
//        self.valiedClickDate = now;
//        if (_oneHourValidStartTime == nil) {
//            //记录有效开始时间
//            _oneHourValidStartTime = now;
//        }
//        
//        //增加实际计数
//        [self addValidOneInHome];
//    }
    
    //专心一小时中 实际计数加1
    if (_isOneViewShow) {
        [self addOneView];
    }
}

#pragma mark - operaiton tip
- (void)showCntTip
{
    //提示随心记用法
    if (_noticeBgView == nil) {
        _noticeBgView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT -90 -80, SCREEN_WIDTH, 80)];
        _noticeBgView.backgroundColor = UIColorFromRGB(0xFFBD00);
        UIImageView *leftView =[[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 188, 54)];
        leftView.image = [UIImage imageNamed:@"黄字"];
        [_noticeBgView addSubview:leftView];
        UIImageView *rightView =[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -92, 6, 92, 69)];
        rightView.image = [UIImage imageNamed:@"小手"];
        [_noticeBgView addSubview:rightView];
        
        _noticeBgView.alpha = 0;
        [self.view addSubview:_noticeBgView];
    }
    
    [UIView animateWithDuration:0.1 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _noticeBgView.alpha = 1;
                     } completion:^(BOOL finished) {
                         [self performSelector:@selector(hideView:) withObject:_noticeBgView afterDelay:3];
                     }];
}

- (void)showFiveMinView
{
    if (_fiveMinLabel == nil && _isOneViewShow == NO) {
        _fiveMinLabel = [[UILabel alloc]initWithFrame:
                         CGRectMake((SCREEN_WIDTH -426/2)/2, SCREEN_HEIGHT -24 -12 -90 , 426 /2, 24)];
        _fiveMinLabel.backgroundColor = [UIColor colorWithRed:0.992 green:0.769 blue:0.243 alpha:1.0];
        _fiveMinLabel.font = [UIFont systemFontOfSize:14];
        _fiveMinLabel.textColor = [UIColor colorWithRed:0.871 green:0.510 blue:0.129 alpha:1.0];
        _fiveMinLabel.text = minTip;
        _fiveMinLabel.clipsToBounds = YES;
        _fiveMinLabel.layer.cornerRadius = 6;
        
        _fiveMinLabel.textAlignment = NSTextAlignmentCenter;
        
        [[UIApplication sharedApplication].keyWindow addSubview:_fiveMinLabel];
        
        //dismiss after
        [self performSelector:@selector(hideView:) withObject:_fiveMinLabel afterDelay:1.4];
    }
}

- (void)hideView:(UIView *)aView
{
    [UIView animateWithDuration:0.62 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         aView.alpha = 0;
                     } completion:^(BOOL finished) {
                         _noticeBgView = nil;
                         _fiveMinLabel = nil;
                     }];
}

#pragma mark - sync method
- (void)syncAllDataOnFinish:(void(^)(NSError *error))finishBlock
{
    [ADCountFetalDAO syncAllDataOnGetData:^(NSError *error) {
        // 刷新数据
        self.todayFirstClickDate = [ADCountFetalDAO getTodayFirstAddOneDate];
        [self changeToToday];
    } onUploadProcess:^(NSError *error) {
        [self rotateSyncBtn];
    } onUpdateFinish:^(NSError *error) {
        [self stopRotateSyncBtn];
        if (error != nil) {
            NSLog(@"err:%@", error);
            if (error.code == 100) {
                self.syncBtn.hidden = YES;
            } else {
                [self setNeedUploadBtn];
            }
        }
    }];
}

@end