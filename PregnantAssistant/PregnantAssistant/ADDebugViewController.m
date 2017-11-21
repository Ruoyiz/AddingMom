//
//  ADDebugViewController.m
//  PregnantAssistant
//
//  Created by D on 15/4/20.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADDebugViewController.h"
#import "ADUserSyncMetaHelper.h"

static NSString *cellId = @"syncCellId";

@interface ADDebugViewController ()

@end

@implementation ADDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _syncItemNameArray =
    @[@"产检日历", @"产检档案", @"数胎动", @"孕妈日记", @"待产包", @"大肚成长记", @"宫缩计时器" ,@"工具收藏", @"用户"];
    _sTimeArray = [[NSMutableArray alloc]initWithCapacity:0];
    _cTimeArray = [[NSMutableArray alloc]initWithCapacity:0];

    
    NSArray *allToolKey = [ADUserSyncMetaHelper allSyncToolKey];
    for (NSString *aKey in allToolKey) {
        NSDate *timp = [ADUserSyncMetaHelper getToolSyncDateWithSyncName:aKey];
        NSLog(@"tim: %@", timp);
        if (timp != NULL) {
            [_sTimeArray addObject:timp];
        } else {
            [_sTimeArray addObject:[NSDate dateWithTimeIntervalSince1970:1]];
        }
        
//        NSDate *ctimp = [ADUserSyncMetaHelper getToolModifyDateWithSyncName:aKey];
//        if (ctimp != NULL) {
//            [_cTimeArray addObject:ctimp];
//        } else {
//            [_cTimeArray addObject:[NSDate dateWithTimeIntervalSince1970:1]];
//        }
    }
    
    
    _tableView = [[UITableView alloc]initWithFrame:
                  CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self setCloseBtn];
}

- (void)setCloseBtn
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"关闭x号"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 15, 15)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableview method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_syncItemNameArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (aCell == nil) {
        aCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellId];
    }
    
    aCell.backgroundColor = [UIColor whiteColor];
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *toolTitle = _syncItemNameArray[indexPath.row];
    
    //ui problem
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH -20, 130)];
    [aCell addSubview:detailLabel];

    detailLabel.lineBreakMode = NSLineBreakByCharWrapping;
    detailLabel.numberOfLines = 3;
    detailLabel.backgroundColor = [UIColor whiteColor];
    
    NSDate *sDate = _sTimeArray[indexPath.row];
    NSDate *cDate = _cTimeArray[indexPath.row];
    if ([sDate isEqual:cDate]) {
        detailLabel.text = [NSString stringWithFormat:@"%@ \t\t %@\n s：%@ \n c：%@",
                            toolTitle,  @"已同步", sDate, cDate];
    } else {
        detailLabel.text = [NSString stringWithFormat:@"%@ \t\t %@\n s：%@ \n c：%@",
                            toolTitle,  @"未同步", sDate, cDate];
    }
    
    return aCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
