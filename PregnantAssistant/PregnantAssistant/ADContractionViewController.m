//
//  ADContractionViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-30.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADContractionViewController.h"
#import "ADHistoryContractViewController.h"
#import "ADContractionTableViewCell.h"
#import "NSTimer+Pausing.h"

#define LINESPACE 4
static NSString *tip =
@"当孕妈咪感到肚子发紧发硬或疼痛时，点击开始计时记录宫缩时间。持续时间即本次宫缩持续的时间，间隔时间即本次宫缩距离上次宫缩的时间";

@interface ADContractionViewController ()

@end

@implementation ADContractionViewController

-(void)dealloc
{
    self.myTableView.dataSource = nil;
    self.myTableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTitle = @"宫缩计时器";
    
    [self showSyncAlert];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self readRecords];
    
    [self addTimeCard];
    
    [self addBottomBtn];
    
    if (self.todayRecords.count > 0) {
        [self addTableView];
    } else {
        [self addTip];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ADContractionDAO updateDataBaseOnfinish:^{
    }];
    
    [self syncAllDataOnFinish:^(NSError *error) {
    }];
   
    [self readRecords];

    [self.myTableView reloadData];
    
    if (self.todayRecords.count > 0) {
        [self.tipLabel removeFromSuperview];
    } else {
        if (self.tipLabel.superview == nil) {
            [self addTip];
        }
    }
    
    //阻止锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //允许锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (void)becomeActive
{
    NSLog(@"%@", _startTime);
    //设置持续时间
//    NSDate *startDate = _todayRecords[0][0];
//    NSDate *endDate = _todayRecords[0][1];
    
//    NSString *lastStr = [ADHelper getIntervalWithDate:[NSDate date] andDate2:_startTime];
//    _lastLabel.text =  lastStr;
//    _durationTime = [[NSDate date] timeIntervalSinceDate:_startTime];
    NSLog(@"startDate %d", _durationTime);
}

- (void)readRecords
{
    self.allRecords = [ADContractionDAO readAllData];
    self.todayRecords = [ADContractionDAO getTodayRecords];
}

- (void)addTip
{
//    int naviHeight = [ADHelper getNavigationBarHeight];

    self.tipLabel =
    [[UILabel alloc]initWithFrame:CGRectMake(12, SCREEN_HEIGHT -90 -8 -72, SCREEN_WIDTH -24, 72)];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tip];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [tip length])];
    self.tipLabel.attributedText = attributedString;
    
    self.tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.tipLabel.numberOfLines = 3;
    self.tipLabel.font = [UIFont tip_font];
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.textColor = [UIColor font_Brown];

    [self.view addSubview:_tipLabel];
}

- (void)addTimeCard
{
    UIView *timeCard = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 158)];
    timeCard.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:timeCard];
    // 持续时间
    UILabel *durationTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH, 24)];
    durationTipLabel.text = @"持续时间";
    durationTipLabel.font = [UIFont systemFontOfSize:14];
    durationTipLabel.textAlignment = NSTextAlignmentCenter;
    durationTipLabel.textColor = [UIColor font_Brown];
    [timeCard addSubview:durationTipLabel];
    
    _lastLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 90)];
    _lastLabel.text = @"00:00:00";
    _lastLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:68];
    _lastLabel.textColor = [UIColor font_IconGray];
    _lastLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:_lastLabel];
    CGPoint newCenter = _lastLabel.center;
//    newCenter.x = 160;
    _lastLabel.center = newCenter;
    [timeCard addSubview:_lastLabel];
    
    // 间隔时间
    UILabel *conIntervalLabel = [durationTipLabel clone];
    conIntervalLabel.frame = CGRectMake(0, 100, SCREEN_WIDTH, 24);
    conIntervalLabel.text = @"间隔时间";
    [timeCard addSubview:conIntervalLabel];
    
    _intervalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 112 +64, SCREEN_WIDTH, 50)];
    _intervalLabel.text = @"00:00:00";
    _intervalLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
    _intervalLabel.textAlignment = NSTextAlignmentCenter;
    _intervalLabel.textColor = [UIColor font_IconGray];
    [self.view addSubview:_intervalLabel];
}

- (void)addTableView
{
//    int naviHeight = [ADHelper getNavigationBarHeight];
    self.myTableView = [[UITableView alloc]initWithFrame:
                        CGRectMake(0, 158 +64, SCREEN_WIDTH, SCREEN_HEIGHT -158 - 90 -64)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:self.myTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _todayRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdStr = @"aContractCell";
    
    ADContractionTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdStr];
    
    if (aCell == nil) {
        aCell = [[ADContractionTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                 reuseIdentifier:cellIdStr];
    }
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ADContraction *aRecord = _todayRecords[indexPath.row];
    NSDate *startDate = aRecord.startDate;
    NSDate *endDate = aRecord.endDate;

//    NSDate *startDate = _todayRecords[indexPath.row][0];
//    NSDate *endDate = _todayRecords[indexPath.row][1];
    NSString *startStr = [ADHelper getHourMinSecWithDate:startDate];
    NSString *lastStr = [ADHelper getIntervalWithDate:endDate andDate2:startDate];
    
    aCell.startTimeLabel.text = startStr;
    aCell.startTimeLabel.textColor = [UIColor font_tip_color];
    aCell.lastTimeLabel.text = [NSString stringWithFormat:@"持续时间: %@", lastStr];
    aCell.lastTimeLabel.textColor = [UIColor font_btn_color];

    //最后的纪录 间隔时间为 0
    if (indexPath.row == _todayRecords.count -1) {
        aCell.intervalLabel.text = [NSString stringWithFormat:@"间隔时间: 00:00:00"];
    } else {
        //新纪录的在前面 所以 +1
        ADContraction *beforeRecord = _todayRecords[indexPath.row +1];
        NSDate *beforeStartDate = beforeRecord.startDate;
        
        NSString *intervalStr = [ADHelper getIntervalWithDate:startDate andDate2:beforeStartDate];
        aCell.intervalLabel.text = [NSString stringWithFormat:@"间隔时间: %@", intervalStr];
    }
    aCell.intervalLabel.textColor = [UIColor font_btn_color];
    
    aCell.backgroundColor = [UIColor whiteColor];
    
    return aCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-  (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        //del data
//        [_todayRecords removeObjectAtIndex:indexPath.row];
        [ADContractionDAO delARecord:_todayRecords[indexPath.row]];
        _todayRecords = [ADContractionDAO getTodayRecords];
        NSLog(@"_todayRe: %@", _todayRecords);
        //del cell
//        [tableView deleteRowsAtIndexPaths:@[indexPath]
//                         withRowAnimation:UITableViewRowAnimationNone];
        [tableView reloadData];
        
        if (_todayRecords.count == 0 && _tipLabel.superview == nil) {
            [self addTip];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (void)addBottomBtn
{
    _aRecordView =
    [[ADRecordContractView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT -90, SCREEN_WIDTH, 90)];
    [self.view addSubview:_aRecordView];
    
    [_aRecordView.historyBtn addTarget:self
                                action:@selector(historyButtonClick:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    [_aRecordView.recordBtn addTarget:self
                               action:@selector(recordBtnClick:)
                     forControlEvents:UIControlEventTouchUpInside];
    _aRecordView.recordBtn.selected = NO;
}

- (void)historyButtonClick:(UIButton *)sender
{
    ADHistoryContractViewController *aHistory = [[ADHistoryContractViewController alloc]init];
    //    aHistory.allRecords = _allRecords;
//    NSLog(@"set allRec:%@ _allRecords:%@", aHistory.allRecords, _allRecords);
    [self.navigationController pushViewController:aHistory animated:YES];
}

- (void)recordBtnClick:(UIButton *)sender
{
    if (sender.selected == YES) {
        if (self.myTableView == nil) {
            [self addTableView];
        }
        [self.tipLabel removeFromSuperview];
        
        sender.selected = NO;
        //记录结束时间
        _endTime = [NSDate date];
        //暂停计时器
        [_lastTimer pause];
        //start end last
        [ADContractionDAO addARecord:[[ADContraction alloc]initStartTime:_startTime
                                                              andEndTime:_endTime]];
        //sync
        [self syncAllDataOnFinish:^(NSError *error) {
        }];
        self.todayRecords = [ADContractionDAO getTodayRecords];
        
        _intervalLabel.text = @"00:00:00";
        _intervalTime = 0;
        
        //重新加载tableview
        [self.myTableView reloadData];
    } else {
        sender.selected = YES;
        //记录开始时间
        _startTime = [NSDate date];
        
        _lastLabel.text = @"00:00:00";
        _durationTime = 0;
        //启动计时器
        _lastTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(updateDurTime)
                                                    userInfo:nil
                                                     repeats:YES];
        
        //设置间隔时间label
        //上一次 和 这一次
        if (_todayRecords.count == 0) {
            return;
        }
        
        NSLog(@"today:%@", _todayRecords);
        
        // 标题间隔时间
        ADContraction *lastContraction = _todayRecords[0];
        NSDate *lastStartDate = lastContraction.startDate;
        
        NSTimeInterval time = [_startTime timeIntervalSinceDate:lastStartDate];
        int hour = ((int)time)/(3600);
        int min = ((int)time)/(60) %60;
        int sec = ((int)time)%(60);

        _intervalLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hour, min, sec];
    }
}

- (void)updateDurTime
{
    _durationTime += 1;
    
    int hour = _durationTime /3600;
    int min = _durationTime /60 %60;
    int sec = _durationTime %60;
    
//    NSLog(@"min:%d", min);
    _lastLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hour, min, sec];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - sync method
- (void)syncAllDataOnFinish:(void(^)(NSError *error))finishBlock
{
    [ADContractionDAO syncAllDataOnGetData:^(NSError *error) {
    } onUploadProcess:^(NSError *error) {
        [self rotateSyncBtn];
    } onUpdateFinish:^(NSError *error) {
        if (error != nil) {
            NSLog(@"sync err:%@", error);
            if (error.code == 100) {
                self.syncBtn.hidden = YES;
            } else {
                [self setNeedUploadBtn];
            }
        } else {
            [self stopRotateSyncBtn];
            [self readRecords];
            NSLog(@"tableView:%@", self.myTableView);
            if (self.todayRecords.count > 0) {
                [self addTableView];
            }

            [self.myTableView reloadData];
        }
    }];
}


@end