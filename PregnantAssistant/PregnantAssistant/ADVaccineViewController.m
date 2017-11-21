//
//  ADVaccineViewController.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/4.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADVaccineViewController.h"
#import "ADVaccineDetailViewController.h"
#import "ADKnowledeViewController.h"
#import "ADAddVaccineViewController.h"
#import "ADVaccineDAO.h"

@interface ADVaccineViewController ()

@end

@implementation ADVaccineViewController{
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
    
    [MobClick event:yueryimiaotixing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ADVaccineDAO syncVaccineDataSuccess:^{
        
    } failure:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTitle = @"疫苗提醒";
    _vaccineDataArray = [NSMutableArray array];
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = [UIColor backColor];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    
    [self getVaccineData];
    
    //同步的提示
    [self showSyncAlert];

    [self addToolBar];

    [self rotateSyncBtn];
    [ADVaccineDAO syncVaccineDataSuccess:^{
        [self reloadDataAfterSync];
        [self stopRotateSyncBtn];
    } failure:^{
        [self stopRotateSyncBtn];
        [self setNeedUploadBtn];
    }];
}

- (void)getVaccineData
{
    [_vaccineDataArray removeAllObjects];
    
    _vaccineDataArray = [ADVaccineDAO readAllVaccineCollected:@"1"];
    if (_vaccineDataArray.count == 0) {
        //NSLog(@"获取plist的疫苗数据。并保存在本地");
        NSString *path = [[NSBundle mainBundle] pathForResource:@"VaccineList" ofType:@"plist"];
        NSArray *vaccineArray = [NSArray arrayWithContentsOfFile:path];
        NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
        for (NSDictionary *dic in vaccineArray) {
            ADVaccine *model = [ADVaccine getModelFromDic:dic uid:uid];
            model.isCollected = @"1";
            [_vaccineDataArray addObject:model];
        }
        
        [ADVaccineDAO addAllVaccineFromVaccineArray:_vaccineDataArray];
        
        //NSLog(@"获取plist自费疫苗");
        NSString *expansePath = [[NSBundle mainBundle] pathForResource:@"ExpenseVaccineList" ofType:@"plist"];
        NSArray *expanseVaccineArray = [NSArray arrayWithContentsOfFile:expansePath];
        
        NSMutableArray *expanseArray = [NSMutableArray array];
        for (NSDictionary *dic in expanseVaccineArray) {
            ADVaccine *model = [ADVaccine getModelFromDic:dic uid:uid];
            model.isCollected = @"0";
            [expanseArray addObject:model];
        }
        
        [ADVaccineDAO addAllVaccineFromVaccineArray:expanseArray];
    }
    
    [_myTableView reloadData];
}

- (void)reloadDataAfterSync
{
    [_vaccineDataArray removeAllObjects];
    _vaccineDataArray = [ADVaccineDAO readAllVaccineCollected:@"1"];
    [_myTableView reloadData];
}

- (void)addToolBar
{
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    _toolBar.backgroundColor = [UIColor vaccinePurpleColor];
    [self.view addSubview:_toolBar];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"身高体重添加"] forState:UIControlStateNormal];
    button.center= CGPointMake(SCREEN_WIDTH/2.0, 25);
    [button addTarget:self action:@selector(addVaccine) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:button];
}

- (void)addVaccine
{
    ADAddVaccineViewController *vc = [[ADAddVaccineViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_vaccineDataArray.count == 0) {
        return 0;
    }
    
    return _vaccineDataArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *noteCellName = @"NoteCellName";
        UITableViewCell *noteCell = [tableView dequeueReusableCellWithIdentifier:noteCellName];
        if (noteCell == nil) {
            noteCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noteCellName];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
            button.backgroundColor = [UIColor whiteColor];
            [button setImage:[UIImage imageNamed:@"WHY"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor title_darkblue] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont ADTitleFontWithSize:16];
            button.userInteractionEnabled = NO;
            [button setTitle:@" 宝宝疫苗知识提醒" forState:UIControlStateNormal];
            [noteCell addSubview:button];
        }
        
        return noteCell;
    }
    
    static NSString *cellName = @"ADVaccineTableViewCell";
    ADVaccineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ADVaccineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.delegate = self;
    }
    ADVaccine *model = [_vaccineDataArray objectAtIndex:indexPath.section - 1];
    cell.tag = indexPath.section;
    cell.cellType = @"0";
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 45;
    }
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
    
    if (indexPath.section != 0) {
        ADVaccine *model = [_vaccineDataArray objectAtIndex:indexPath.section-1];
        ADVaccineDetailViewController *vc = [[ADVaccineDetailViewController alloc] init];
        vc.cellType = @"0";
        vc.vaccineModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ADKnowledeViewController *vc = [[ADKnowledeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didClickedTagButtonInCell:(ADVaccineTableViewCell *)cell
{
    [self getVaccineData];
}

- (void)syncMethod:(UIButton *)sender
{
    NSLog(@"同步数据");
    [self rotateSyncBtn];
    [ADVaccineDAO syncVaccineDataSuccess:^{
        [self reloadDataAfterSync];
        [self stopRotateSyncBtn];
    } failure:^{
        [self stopRotateSyncBtn];
        [self setNeedUploadBtn];
    }];
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
