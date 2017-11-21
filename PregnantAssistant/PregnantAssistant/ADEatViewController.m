//
//  ADEatViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-26.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADEatViewController.h"
#import "ADEatTableViewCell.h"
#import "ADRecipesViewController.h"

#define LINESPACE 4

static NSString *tip =
@"月子期间的饮食既要补充生产时所消耗的大量体力，又要充分制造乳汁。但是，不宜产后立刻大补特补，根据不同时间身体的状态，合理安排饮食。";
@interface ADEatViewController ()

@end

@implementation ADEatViewController

-(void)dealloc
{
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBackItemWithImage:nil andSelectImage:nil];

    self.dataArray = @[
                       @[@"第一周 代谢排毒周",
                         @"第一周，新妈妈排恶露的黄金时期，产前的水肿以及身体多余水分也会在此时排出，因此不宜给新妈妈喝过多鸡汤、鸽子汤等，不易被吸收。"],
                       @[@"第二周 内脏收缩周",
                         @"第二周，主要增强骨质和腰肾的功能，恢复骨盆。吃炒腰子和杜仲粉有助于缓解尾椎骨等骨疼。如果是剖腹产，再持续喝一周生化汤。除了少吃盐之外，也不要吃咸菜，泡菜等盐重的菜。"],
                       @[@"第三周到一个月 滋养进补周",
                         @"第三周到一个月，该排的已排完，这时候可以吃些容易吸收，营养丰富的食物。如果母乳不够，可以适当多吃下奶食物。可以吃麻油鸡补身体。"]
                       ];
    [self addTableView];
}

- (void)addTableView
{
//    int naviHeight = [ADHelper getNavigationBarHeight];
    
    self.myTableView =
    [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
//    self.myTableView.backgroundColor = [UIColor bg_lightYellow];
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    self.myTableView.separatorColor = [UIColor defaultTintColor];
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.myTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count +1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 68;
    } else {
        ADEatTableViewCell *cell =
        (ADEatTableViewCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return cell.cellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdStr = @"aEatCell";
    
    ADEatTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdStr];
    
    if (aCell == nil) {
        aCell =
        [[ADEatTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdStr];
    }
    
    if (indexPath.row == 0) {
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH - 32, 68)];
        tipLabel.font = [UIFont systemFontOfSize:13];
//        tipLabel.textColor = [UIColor font_Brown];
        tipLabel.textColor = [UIColor font_tip_color];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tip];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
        
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, [tip length])];
        tipLabel.attributedText = attributedString;
        
        tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
        tipLabel.numberOfLines = 3;

        [aCell addSubview:tipLabel];
    } else {
        aCell.name.text = self.dataArray[indexPath.row -1][0];
        aCell.detailStr = self.dataArray[indexPath.row -1][1];
    }
    
//    aCell.backgroundColor = [UIColor bg_lightYellow];
    aCell.backgroundColor = [UIColor whiteColor];
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    aCell.customBtn.tag = indexPath.row;
    [aCell.customBtn addTarget:self
                        action:@selector(pushNextVc:)
              forControlEvents:UIControlEventTouchDown];

    
    return aCell;
}

- (void)pushNextVc:(UIButton *)sender
{
    ADRecipesViewController *aRecipeVc = [[ADRecipesViewController alloc]init];
    aRecipeVc.weekNo = (int)sender.tag;
    [self.navigationController pushViewController:aRecipeVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
