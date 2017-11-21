//
//  ADAddVaccineViewController.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADAddVaccineViewController.h"
#import "ADVaccineDetailViewController.h"
#import "ADVaccineDAO.h"

@interface ADAddVaccineViewController ()

@end

@implementation ADAddVaccineViewController{
    NSMutableArray *_vaccineDataArray;
    UITableView *_myTableView;
    UIView *_toolBar;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_myTableView) {
        [self getVaccineData];
    }
    
    [MobClick event:yimiaotixing_zifeiyimiao];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    self.myTitle = @"增加自费疫苗";
    _vaccineDataArray = [NSMutableArray array];
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = [UIColor backColor];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    
    [self getVaccineData];
}

- (void)getVaccineData
{
    [_vaccineDataArray removeAllObjects];
    _vaccineDataArray = [ADVaccineDAO readAllExpenseVaccine];
    if (_vaccineDataArray.count == 0) {
        
        NSLog(@"获取plist自费疫苗");
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ExpenseVaccineList" ofType:@"plist"];
        NSArray *vaccineArray = [NSArray arrayWithContentsOfFile:path];
        
        NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
        for (NSDictionary *dic in vaccineArray) {
            ADVaccine *model = [ADVaccine getModelFromDic:dic uid:uid];
            model.isCollected = @"0";
            [_vaccineDataArray addObject:model];
        }
        
        [ADVaccineDAO addAllVaccineFromVaccineArray:_vaccineDataArray];
    }
    
    [_myTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _vaccineDataArray.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"ADVaccineTableViewCell";
    ADVaccineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ADVaccineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.delegate = self;
    }
    ADVaccine *model = [_vaccineDataArray objectAtIndex:indexPath.section];
    cell.cellType = @"2";
    cell.model = model;
    cell.tag = indexPath.section;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//    view.backgroundColor = [UIColor redColor];
//    return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ADVaccine *model = [_vaccineDataArray objectAtIndex:indexPath.section];
    ADVaccineDetailViewController *vc = [[ADVaccineDetailViewController alloc] init];
    vc.cellType = @"2";
    vc.vaccineModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - cell delegate
- (void)didClickedTagButtonInCell:(ADVaccineTableViewCell *)cell
{
    ADVaccine *model = [_vaccineDataArray objectAtIndex:cell.tag];
    NSString *name = [[model.vaccineName componentsSeparatedByString:@" "] firstObject];
    
    NSString *collect = model.isCollected;
    if ([collect isEqualToString:@"1"]) {
        NSString *str = [NSString stringWithFormat:@"yimiaotixing_del_%@",name];
        NSLog(@"删除 %@",str);
        [MobClick event:str];
    }else{
        NSString *str = [NSString stringWithFormat:@"yimiaotixing_add_%@",name];
        NSLog(@"添加 %@",str);
        [MobClick event:str];
    }
    
    int i = 0;
    BOOL resetVaccine = NO;
    for (ADVaccine *targetModel in _vaccineDataArray) {
        NSString *targetName = [[targetModel.vaccineName componentsSeparatedByString:@" "] firstObject];
        if ([targetName isEqualToString:name]) {
            if ([collect isEqualToString:@"0"]) {
                if (!resetVaccine && [name isEqualToString:@"五联疫苗"]) {
                    resetVaccine = YES;
                    [ADVaccineDAO resetAllConflictVaccine];
                }
                [ADVaccineDAO modifyVaccine:targetModel collect:@"1" success:^(ADVaccine *newModel) {
                }];
            }else{
                [ADVaccineDAO modifyVaccine:targetModel collect:@"0" success:^(ADVaccine *newModel) {
                }];
            }
        }
        
        i++;
    }
    
    [self getVaccineData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
