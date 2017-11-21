//
//  ADNewBornViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-26.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADNewBornViewController.h"
#import "ADNewBornDetialViewController.h"

@interface ADNewBornViewController ()

@end

@implementation ADNewBornViewController

-(void)dealloc
{
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBackItemWithImage:nil
                    andSelectImage:nil];

    self.titleArray = @[
                        @"新生儿日常护理",
                        @"新生儿喂养",
                        @"新生儿睡眠",
                        @"新生儿疾病"
                        ];
    
    [self addTableView];
}

- (void)addTableView
{
    int naviHeight = [ADHelper getNavigationBarHeight];
    
    self.myTableView =
    [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - naviHeight)];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
//    self.myTableView.backgroundColor = [UIColor bg_lightYellow];
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.separatorColor = [UIColor defaultTintColor];
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.myTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdStr = @"aConCell";
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdStr];
    
    if (aCell == nil) {
        aCell =
        [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdStr];
    }
    
    aCell.backgroundColor = [UIColor whiteColor];
    
    aCell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    aCell.textLabel.text = self.titleArray[indexPath.row];
    
    aCell.textLabel.font = [UIFont systemFontOfSize:15];
    
    aCell.textLabel.textColor = [UIColor defaultTintColor];
    
    UIView *bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, 55.5, SCREEN_WIDTH, 0.5)];
    bottomline.backgroundColor = [UIColor defaultTintColor];
    [aCell addSubview:bottomline];
    
    return aCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    ADNewBornDetialViewController *newVc= [[ADNewBornDetialViewController alloc]init];
    newVc.myTitle = self.titleArray[indexPath.row];
    
    [self.navigationController pushViewController:newVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
