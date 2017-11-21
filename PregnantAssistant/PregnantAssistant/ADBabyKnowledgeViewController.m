//
//  ADBabyKnowledgeViewController.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/6/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBabyKnowledgeViewController.h"
#import "ADBabyKDetailViewController.h"

@interface ADBabyKnowledgeViewController ()<UITableViewDataSource,UITableViewDelegate>{

    UITableView *_tableView;
    NSArray *_dataArray;
    
}

@end

@implementation ADBabyKnowledgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:shengaotizhong_more];
    [self layoutUI];
    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)layoutUI{
//    [self setLeftItem];
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    self.myTitle = @"宝贝成长知识";
    [self.view setBackgroundColor:UICOLOR(240, 232, 221, 1)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

- (void)loadData{
    _dataArray = @[@"儿童身高、体重、头围标准计算方法",@"身高体重曲线图使用技巧",@"父母要坚持做生长记录",@"有助于宝宝长高的五大食品",@"宝宝超重怎么办",@"影响宝宝身高的因素",@"常见疑问"];
    
}


#pragma mark - TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = _dataArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [MobClick event:[NSString stringWithFormat:@"%@%ld",shengaotizhong_wenzhang,(long)(indexPath.section + 1)]];
    ADBabyKDetailViewController *kdvc = [[ADBabyKDetailViewController alloc] init];
    kdvc.titleString = _dataArray[indexPath.section];
    kdvc.rowIndex = indexPath.section;
    [self.navigationController pushViewController:kdvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _dataArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
