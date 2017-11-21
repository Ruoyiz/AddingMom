//
//  ADExpectantListViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-18.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADExpectantListViewController.h"
#import "ADCustomHeaderView.h"
#import "ADBackgroundView.h"
#import "ADHaveLabourThingCell.h"
#import "ADInLabourDAO.h"

#define LINESPACE 8

@interface ADExpectantListViewController ()

@property (nonatomic, strong) RLMNotificationToken *notification;

@end

static NSString * tip = @"去查看推荐的待产包清单里,点击\"加入清单\",需要准备的物品就在这里显示啦 :)";
static NSString * readyTip = @"准备好了就打钩吧！";
static NSString * cellId = @"aHaveCell";

@implementation ADExpectantListViewController

- (void)dealloc
{
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTitle = @"我的待产清单";
    
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headerTitles = @[
                        @"住院清单", @"产妇卫生用品",
                        @"产妇护理", @"宝宝日用",
                        @"宝宝洗护", @"宝宝喂养",
                        @"宝宝服饰", @"宝宝护肤",
                        @"宝宝床上用品", @"宝宝出行"
                        ];
    
    self.displayHeaderTitles = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self readSaveLabourThingArray];
    
    __weak typeof(self) weakSelf = self;
    self.notification = [RLMRealm.defaultRealm addNotificationBlock:^(NSString *note, RLMRealm *realm) {
        //del cellview
        if (_allKindThingArray.count == 0) {
            [weakSelf addAEmptyView];
            weakSelf.navigationItem.rightBarButtonItem = nil;
            [weakSelf.myTableView removeFromSuperview];
        } else {
            [weakSelf.myTableView reloadData];
        }
    }];

}

- (void)addTipLabel
{
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 2 +64, SCREEN_WIDTH, 24)];
    tipLabel.text = readyTip;
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = [UIColor font_tip_color];
    
    [self.view addSubview:tipLabel];
}

- (void)readSaveLabourThingArray
{
    _allKindThingArray = [[NSMutableArray alloc]initWithCapacity:0];

    for(int i = 0;i < self.headerTitles.count; i++) {
        //读取每类待产包 已有物品
        RLMResults *aKindThing = [ADInLabourDAO readWantThingWithKindTitle:_headerTitles[i]];
        if (aKindThing.count > 0) {
            [self.displayHeaderTitles addObject:self.headerTitles[i]];
            [_allKindThingArray addObject:aKindThing];
        }
    }
 
    //读取每类待产包 已买物品
//    _haveBuyArray = [ADInLabourDAO readHaveBuyThing];
    
//    if (_haveBuyArray == nil) {
//        _haveBuyArray = [[NSMutableArray alloc]initWithCapacity:0];
//    }
//    NSLog(@"buy:%@ all:%@",_haveBuyArray, _allKindThingArray);
    
    if (_allKindThingArray.count > 0) {
        [self addTipLabel];
        [self addTableView];
        [self setRightItemWithStrEdit];
    } else {
        [self addAEmptyView];
    }
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
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        //del data
        RLMResults *aKindThings = self.allKindThingArray[indexPath.section];
        [ADInLabourDAO delAWantLabourThing:aKindThings[indexPath.row]];
        
        if (aKindThings.count == 0) {
            [self.displayHeaderTitles removeObjectAtIndex:indexPath.section];
            [self.allKindThingArray removeObjectAtIndex:indexPath.section];
            [self.myTableView reloadData];
        }
        
    }
}

- (void)addTableView
{
    CGRect newRect = [[UIScreen mainScreen] bounds];
    newRect.size.height -= [ADHelper getNavigationBarHeight] +24;
    newRect.origin.y += 24 +64;
    
    self.myTableView = [[UITableView alloc]initWithFrame:newRect style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    self.myTableView.separatorColor = [UIColor clearColor];
    self.myTableView.backgroundColor = [UIColor whiteColor];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"ADHaveLabourThingCell"
                                                 bundle:[NSBundle mainBundle]]
           forCellReuseIdentifier:cellId];
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.myTableView];
}

- (void)addAEmptyView
{
    CGRect newRect = [[UIScreen mainScreen] bounds];
//    newRect.size.height -= [ADHelper getNavigationBarHeight];
    newRect = CGRectMake(0, NAVIBAT_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIBAT_HEIGHT);
    ADBackgroundView *aBgView = [[ADBackgroundView alloc]initWithFrame:newRect];
    aBgView.aTip = tip;
    aBgView.alpha = 0;
    
    [self.view addSubview:aBgView];
    [UIView beginAnimations:@"showEView" context:nil];
    [UIView setAnimationDuration:0.24];
    
    aBgView.alpha = 1;
    
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _displayHeaderTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"section:%ld %@", (long)section, _allThingArray[section]);
    return [_allKindThingArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADHaveLabourThingCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    aCell.backgroundColor = [UIColor whiteColor];
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    aCell.aSelectBtn.tag = indexPath.row;
    [aCell.aSelectBtn addTarget:self
                         action:@selector(haveBuy:)
               forControlEvents:UIControlEventTouchUpInside];
    
    RLMResults *aKindThing = _allKindThingArray[indexPath.section];
    ADNewLabourThing *aThing = aKindThing[indexPath.row];
    aCell.thingLabel.text = aThing.name;
    aCell.numLabel.text = aThing.recommendCnt;
    
    if (aThing.haveBuy) {
        [aCell.aSelectBtn setSelected:YES];
    }

    return aCell;
}

- (void)tableView:(UITableView *)tableView
didEndDisplayingCell:(ADHaveLabourThingCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell.aSelectBtn setSelected:NO];
}

- (void)haveBuy:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    
    RLMResults *aKindThing = self.allKindThingArray[indexPath.section];
    ADNewLabourThing *aThing = aKindThing[indexPath.row];
    [ADInLabourDAO markALabourThingName:aThing.name withBuyStatus:sender.selected];
}

- (UIView*)tableView:(UITableView*)tableView
viewForHeaderInSection:(NSInteger)section
{
    ADCustomHeaderView* aHeaderView =
    [[ADCustomHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    
    aHeaderView.contentView.backgroundColor = [UIColor whiteColor];
    aHeaderView.titleLabel.text = self.displayHeaderTitles[section];
    
    return aHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView  heightForHeaderInSection:(NSInteger)section
{
    return 36;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
