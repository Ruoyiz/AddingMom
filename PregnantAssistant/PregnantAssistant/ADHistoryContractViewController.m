//
//  ADHIstoryContractViewController.m
//  PregnantAssistant
//
//  Created by D on 14/10/20.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADHistoryContractViewController.h"
#import "ADContractionTableViewCell.h"
//#import "ADHeaderContractTableViewCell.h"
#import "ADContractHeaderView.h"
#import "ADEmptyView.h"

@interface ADHistoryContractViewController (){
    ADEmptyView *_emptyView;
}
@end

@implementation ADHistoryContractViewController

-(void)dealloc
{
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTitle = @"宫缩历史记录";
    
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    [self readArray];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.allRecords.count > 0) {
        [self addTable];
        [self setRightItemWithStrEdit];
    } else {
        [self addEmpty];
    }
}

- (void)addEmpty
{
    UIImage *img = [UIImage imageNamed:@"暂无记录绿色"];
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -105)/2 -12, 64, 105, 161)];
    _imgView.image = img;
    CGPoint newCenter = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
//    newCenter.y -= [ADHelper getNavigationBarHeight] +24;
    _imgView.center = newCenter;
    [self.view addSubview:_imgView];
}

- (void)readArray
{
    _allRecords = [ADContractionDAO readAllDataDesc];
    _finalAllRecords = [[NSMutableArray alloc]initWithCapacity:0];
    _titleArray = [[NSMutableArray alloc]initWithCapacity:0];
    NSLog(@"all rec:%@", _allRecords);
    
    NSDate *lastReadDay = nil;
    for (int i = 0; i < _allRecords.count; i++) {
        ADContraction *aRecord = _allRecords[i];
        //非一天
        if (lastReadDay == nil || ![lastReadDay isEqualToDateIgnoringTime:aRecord.startDate]) {
            lastReadDay = aRecord.startDate;
            
            RLMResults *aDayContraction = [ADContractionDAO getRecordsAtDay:aRecord.startDate];
            //次
            NSString *times = [NSString stringWithFormat:@"共计%d次", (int)aDayContraction.count];
            NSString *aTitle = [ADHelper getTitleStrFromDate:aRecord.startDate];
            NSString *finalTitle = [NSString stringWithFormat:@"%@ %@",aTitle, times];
            [self.titleArray addObject:finalTitle];
            NSLog(@"titleArray:%@", self.titleArray);
            
            [_finalAllRecords addObject:aDayContraction];
            NSLog(@"finalArray:%@", self.finalAllRecords);
        }
    }
}

- (void)addTable
{
//    float tableViewHeight = SCREEN_HEIGHT - [ADHelper getNavigationBarHeight];
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                   style:UITableViewStylePlain];
    
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.delegate = self;
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.myTableView];
}

- (void)rightItemMethod:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        [self changeCellWithEdit:YES];
    } else {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        [self changeCellWithEdit:NO];
    }
}

- (void)changeCellWithEdit:(BOOL)editing
{
    [self.myTableView setEditing:editing animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdStr = @"aRecordCell";
    
    ADContractionTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdStr];
    
    if (aCell == nil) {
        aCell =
        [[ADContractionTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdStr];
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(16, aCell.frame.size.height +12 -0.5, SCREEN_WIDTH -32, 0.5)];
        bottomLine.backgroundColor = [UIColor font_LightBrown];
        [aCell addSubview:bottomLine];
    }
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    aCell.backgroundColor = [UIColor whiteColor];
    
//    NSArray *aDayRecord = _allRecords[indexPath.section]; //倒序
    RLMResults *aDayRecords = _finalAllRecords[indexPath.section];
    ADContraction *aContraction = aDayRecords[indexPath.row];
//    NSLog(@"aDayRecord:%@", aDayRecords);
    NSDate *startDate = aContraction.startDate;
    NSDate *endDate = aContraction.endDate;

    aCell.startTimeLabel.text = [ADHelper getHourMinSecWithDate:startDate];
    aCell.startTimeLabel.textColor = [UIColor font_tip_color];

    NSString *lastStr = [ADHelper getIntervalWithDate:endDate andDate2:startDate];
    aCell.lastTimeLabel.text = [NSString stringWithFormat:@"持续时间: %@", lastStr];
    aCell.lastTimeLabel.textColor = [UIColor font_btn_color];

    if (indexPath.row == aDayRecords.count -1) {
        aCell.intervalLabel.text = [NSString stringWithFormat:@"间隔时间: 00:00:00"];
    } else {
        ADContraction *aContraction = aDayRecords[indexPath.row +1];

        NSDate *beforeStartDate = aContraction.startDate;
        
        NSString *intervalStr = [ADHelper getIntervalWithDate:startDate andDate2:beforeStartDate];
        aCell.intervalLabel.text = [NSString stringWithFormat:@"间隔时间: %@", intervalStr];
    }
    aCell.intervalLabel.textColor = [UIColor font_btn_color];
    
    return aCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (UIView*)tableView:(UITableView*)tableView
viewForHeaderInSection:(NSInteger)section
{
    ADContractHeaderView *aHeaderView =
    [[ADContractHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    
    aHeaderView.contentView.backgroundColor = [UIColor whiteColor];
    aHeaderView.titleLabel.text = self.titleArray[section];
    
    return aHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"allRecords:%@", _finalAllRecords);
    if (section < _finalAllRecords.count) {
        RLMResults *aDayRecord = _finalAllRecords[section];
        return aDayRecord.count;
    } else {
        return 0;
    }
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
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        //del data
        [ADContractionDAO delARecord:_finalAllRecords[indexPath.section][indexPath.row]];
        
        RLMResults *aDayRecord = _finalAllRecords[indexPath.section];
        NSLog(@"indexPath:%@", indexPath);

        //某天的所有记录没了
        if (aDayRecord.count == 0) {
            [self.titleArray removeObjectAtIndex:indexPath.section];
            [self readArray];
            [self.myTableView reloadData];
        } else {
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationLeft];
            [self readArray];
            [self.myTableView reloadData];

//            [tableView reloadData];
        }
        
        //所有记录都没了
        if (_allRecords.count == 0) {
            [self addEmpty];
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        NSLog(@"allRec:%@ cnt:%lu", _allRecords, (unsigned long)_allRecords.count);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
