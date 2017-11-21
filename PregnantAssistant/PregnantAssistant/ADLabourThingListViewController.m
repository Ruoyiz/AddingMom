//
//  ADLabourThingListViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-18.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADLabourThingListViewController.h"
#import "ADLabourThing.h"
#import "ADLabourThingTableViewCell.h"

static NSString *cellIdStr = @"aThing";

@interface ADLabourThingListViewController ()

@property (nonatomic, strong) RLMNotificationToken *notification;

@end

@implementation ADLabourThingListViewController

-(void)dealloc
{
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBackItemWithImage:nil andSelectImage:nil];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setRightItemWithTxt:@"全部添加" andColor:[UIColor btn_green_bgColor]];
    
    [self addTableView];
    
    [self.myTableView registerNib:
     [UINib nibWithNibName:@"ADLabourThingTableViewCell" bundle:[NSBundle mainBundle]]
           forCellReuseIdentifier:cellIdStr];
    
    _wantLabourThing = [ADInLabourDAO readWantThingWithKindTitle:self.myTitle];
    
    __weak typeof(self) weakSelf = self;
    self.notification = [RLMRealm.defaultRealm addNotificationBlock:^(NSString *note, RLMRealm *realm) {
        [weakSelf.myTableView reloadData];
    }];
}

- (void)rightItemMethod:(UIButton *)sender
{
    [self addAllThing];
}

- (void)addTableView
{
    CGRect newRect = [[UIScreen mainScreen] bounds];
//    newRect.size.height -= [ADHelper getNavigationBarHeight];

    self.myTableView = [[UITableView alloc]initWithFrame:newRect style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    self.myTableView.separatorColor = [UIColor light_green_Btn];
    self.myTableView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.myTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.labourThing.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 124;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADLabourThingTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdStr];
    aCell.backgroundColor = [UIColor whiteColor];
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return aCell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(ADLabourThingTableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //set Data
    cell.name = self.labourThing[indexPath.row][0];
    cell.reason = self.labourThing[indexPath.row][1];
    cell.num = [NSString stringWithFormat:@"推荐数量:%@", self.labourThing[indexPath.row][2]];
    cell.score = [self.labourThing[indexPath.row][3] floatValue];
    cell.addListBtn.tag = indexPath.row;
    [cell.addListBtn addTarget:self
                        action:@selector(addALabourThing:)
              forControlEvents:UIControlEventTouchDown];
//    NSLog(@"cell.tag:%d", (int)cell.addListBtn.tag);
//  
//    NSLog(@"labour thing:%@", self.labourThing);
    
    if ([ADInLabourDAO isContainAThing:self.labourThing[indexPath.row][0] inKind:self.myTitle]) {
        [cell.addListBtn setSelected:YES];
    } else {
        [cell.addListBtn setSelected:NO];
    }
}

- (void)addALabourThing:(UIButton *)sender
{
    //读取每类待产包 已有物品
    NSLog(@"aThing:%@",self.labourThing[sender.tag]);
    NSArray *aThing = self.labourThing[sender.tag];
    //已有不添加
    if ([ADInLabourDAO isContainAThing:aThing[0] inKind:self.myTitle]) {
        [ADInLabourDAO delAWantLabourThingWithName:aThing[0]];
    } else {
        [ADInLabourDAO addAWantLabourThing:[[ADNewLabourThing alloc] initWithName:self.labourThing[sender.tag][0]
                                                                           reason:self.labourThing[sender.tag][1]
                                                                  recommendCntStr:self.labourThing[sender.tag][2]
                                                                   recommentScore:self.labourThing[sender.tag][3]
                                                                        kindTitle:self.myTitle
                                                                          haveBuy:NO]];
    }
}

- (void)addAllThing
{
    [ADInLabourDAO addAKindWantThing:self.labourThing andKindTitle:self.myTitle];
    
    //改变添加按钮
    for (UIView *view in self.myTableView.subviews) {
        for (ADLabourThingTableViewCell *aCell in view.subviews) {
            [aCell.addListBtn setSelected:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
