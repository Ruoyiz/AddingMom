//
//  ADParentHWViewController.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/5/27.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADParentHWViewController.h"
#import "ADHeightWeightTableViewCell.h"
#import "ADWeightHeightModel.h"
#import "ADHWBottomBarView.h"
#import "ADNewHWViewController.h"
#import "ADWHDataManager.h"
#import "ADBabyKnowledgeViewController.h"
#import "ADBabyHeightCurveViewController.h"
#import "AFNetworking.h"
#import "ADEmptyView.h"
#define TABLEVIEW_TOPY 0

@interface ADParentHWViewController ()<UITableViewDataSource,UITableViewDelegate,BottomViewClickDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_WHCells;
    
    ADHWBottomBarView *_bottomView;
    
    NSDictionary *_dict;
    ADEmptyView * _emptyView;
    UIImageView *_emptyImg;
}

@end
@implementation ADParentHWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTitle = @"身高体重";
    [self addTabelView];
    [self addBottomBarView];

    //同步的提示
    [self showSyncAlert];
    
    _dataArray = [[NSMutableArray alloc] init];
    _WHCells = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self syncMethod:nil];
}


#pragma mark - layoutUI
#pragma mark TableView
- (void)addTabelView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - TABLEVIEW_TOPY - 49 - 64) style:UITableViewStyleGrouped];
    [_tableView setBackgroundColor:UICOLOR(240, 232, 221, 1)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)addBottomBarView{
    
    NSArray *imageArray = @[@"身高体重图表",@"身高体重添加",@"身高体重知识"];
    _bottomView = [[ADHWBottomBarView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49) ImageArray:imageArray imageHeight:36];
    _bottomView.backgroundColor = UICOLOR(169, 146, 254, 1);
    _bottomView.delegate = self;
    [self.view addSubview:_bottomView];
    
}

- (void)addEmptyView
{
    if (!_emptyView) {
        _emptyView = [[ADEmptyView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) title:@"暂无纪录" image:[UIImage imageNamed:@"list_loading_06"]];
        [self.view addSubview:_emptyView];
    }
}

#pragma mark - 读取数据

- (void)loadData{
    
    if (_dataArray) {
        [_dataArray removeAllObjects];
    }
    RLMResults *result = [ADWHDataManager readAllModel];
    for (ADWeightHeightModel *model in result) {
        [_dataArray addObject:model];
        ADHeightWeightTableViewCell *cell =[[ADHeightWeightTableViewCell alloc]init];
        [_WHCells addObject:cell];
    }
    NSLog(@"array == %@",_dataArray);
    if (_dataArray.count) {
        [_emptyView removeFromSuperview];
        _emptyView = nil;
    }else{
        [self addEmptyView];
    }
    [_tableView reloadData];
}

#pragma mark - BottomClickDelegate
- (void)bottomViewClickedWithIndex:(NSInteger)index{
    if (index == 1) {
    }
    ADNewHWViewController *newVc = [[ADNewHWViewController alloc] init];
    newVc.isComefromParentHW = NO;
    ADBabyKnowledgeViewController *babyVc = [[ADBabyKnowledgeViewController alloc] init];
    ADBabyHeightCurveViewController *babyHCVc = [[ADBabyHeightCurveViewController alloc] init];
    switch (index) {
        case 0:
            [self.navigationController pushViewController:babyHCVc animated:YES];
            break;
        case 1:
            [MobClick event:shengaotizhong_tianjia2];
            [self.navigationController pushViewController:newVc animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:babyVc animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark - TabelViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    ADHeightWeightTableViewCell *cell = _WHCells[indexPath.section];
    //    cell.heightRefreshModel = _dataArray[indexPath.section];
//    ADHeightWeightTableViewCell *cell = _WHCells[indexPath.section];
//    cell.heightRefreshModel = _dataArray[indexPath.section];
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"ADHeightWeightTableViewCell";
    ADHeightWeightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ADHeightWeightTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.refreshModel = _dataArray[indexPath.section];
    cell.imageButton.tag = indexPath.section;
    [cell.imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addHeightLabel.text = nil;
    cell.addWidthLabel.text = nil;
    if (indexPath.section == 0) {
        
        ADWeightHeightModel *model1 = [ADWHDataManager readFirstModel];
        ADWeightHeightModel *model2 = [ADWHDataManager readSecendModel];
        float height1 = [model1.height floatValue];
        float height2 = [model2.height floatValue];
        float weight1 = [model1.weight floatValue];
        float weight2 = [model2.weight floatValue];
        if (model2) {
            if (height1 > height2) {
                cell.addHeightLabel.text = [NSString stringWithFormat:@"+%.1fcm",height1 - height2];
                cell.addHeightLabel.textColor = [UIColor tagRedColor];
            }else{
                cell.addHeightLabel.text = [NSString stringWithFormat:@"%.1fcm",height1 - height2];
                cell.addHeightLabel.textColor = [UIColor light_green_Btn];
            }
            if (weight1 > weight2) {
                cell.addWidthLabel.text = [NSString stringWithFormat:@"+%.1fkg",weight1 - weight2];
                cell.addWidthLabel.textColor = [UIColor tagRedColor];
            }else{
                cell.addWidthLabel.text = [NSString stringWithFormat:@"%.1fkg",weight1 - weight2];
                cell.addWidthLabel.textColor = [UIColor light_green_Btn];
            }
        }
    }
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ADWeightHeightModel *model = _dataArray[indexPath.section];
        [ADWHDataManager deleteModelWithCreatDate:[NSDate dateWithTimeIntervalSince1970:[model.time doubleValue]]];
        [ADWHDataManager sortModelData];
        [self loadData];
    }
}



- (void)imageButtonClick:(UIButton *)button{
    ADNewHWViewController *newVc = [[ADNewHWViewController alloc] init];
    newVc.isComefromParentHW = YES;
    newVc.fromParentModel = _dataArray[button.tag];
    [self.navigationController pushViewController:newVc animated:YES];
}

- (NSString *)getAddHeightLabelText{
    ADWeightHeightModel *model1 = [ADWHDataManager readFirstModel];
    ADWeightHeightModel *model2 = [ADWHDataManager readSecendModel];
    float height1 = [model1.height floatValue];
    float height2 = [model2.height floatValue];
    if (height1 > height2) {
        return [NSString stringWithFormat:@"+%.1fcm",height1 - height2];
    }
    return [NSString stringWithFormat:@"%.1f",height1 - height2];
}

- (NSString *)getaddWidthLabelText{
    ADWeightHeightModel *model1 = [ADWHDataManager readFirstModel];
    ADWeightHeightModel *model2 = [ADWHDataManager readSecendModel];
    float height1 = [model1.weight floatValue];
    float height2 = [model2.weight floatValue];
    if (height1 > height2) {
        return [NSString stringWithFormat:@"+%.1fcm",height1 - height2];
    }
    return [NSString stringWithFormat:@"%.1f",height1 - height2];
    
}

- (void)syncMethod:(UIButton *)sender{
    
    [self rotateSyncBtn];
    [ADWHDataManager syncAllDataOnGetData:^(BOOL isComplte) {
        [self stopRotateSyncBtn];
        [self loadData];
    }getDataFailure:^(NSError *error) {
        [self setNeedUploadBtn];
    } onUploadProcess:^(BOOL iscomplete) {
        [self stopRotateSyncBtn];
    }uploadFailure:^(NSError *error) {
        [self setNeedUploadBtn];
    } noNeed:^(bool netWork){
        netWork ? [self stopRotateSyncBtn]:[self setNeedUploadBtn];
    }];
    
    [self loadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
