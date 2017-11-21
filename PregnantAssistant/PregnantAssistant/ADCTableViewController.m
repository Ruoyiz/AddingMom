//
//  ADCTableViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-26.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADCTableViewController.h"
#import "ADConfineTableViewCell.h"

@interface ADCTableViewController ()

@end

@implementation ADCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    if ([self.myTitle isEqualToString:@"产妇卫生"]) {
        self.dataArray = @[
                           @[@"洗澡洗头",
                             @"在阴道顺产情况下，产后体力恢复了，一般就可以洗澡了；如果顺产时进行了侧切，一般产后3至5天就可以洗澡，但禁止坐浴；如果是剖腹产，一般产后7~10天、伤口愈合了，也可以洗澡洗头了。但是洗澡洗头时需要注意保暖。家人应提前预热好卫生间，只洗淋浴不洗盆浴，洗后及时擦干、穿衣、吹干头发、避免感冒。"],
                           @[@"清洗会阴",
                             @"月子里恶露排出，产妇的会阴部分泌物较多，每天应用温开水清洗外阴部。勤换卫生巾并保持会阴部清洁和干燥。恶露会在大约产后4个星期至6个星期干净。"],
                           @[@"清洁口腔",
                             @"月子里产妇少吃多餐，吃的次数较多，如果不注意口腔卫生，容易使口腔内的细菌繁殖，发生口腔疾病。应该每天刷牙一次，可选用软毛牙刷轻柔地刷动。每次吃过东西后，应当用温开水漱口。 "],
                           @[@"修剪指甲",
                             @"产妇剪指甲、趾甲也可以照常进行，以免尖锐的指甲划伤自己或者宝宝娇嫩的皮肤。"],
                           @[@"清洗乳头",
                             @"哺乳前用温开水清洗乳头，切忌使用肥皂、酒精、洗涤剂等，以免除去保护乳头和乳晕皮肤的天然薄膜，造成乳头皲裂，影响哺乳。 "],
                           ];
    } else { //母乳喂养
        self.dataArray = @[
                           @[@"保持自信",
                             @"妈妈对自己能够胜任母乳喂养工作的自信心将是母乳喂养成功的基本保证。不论女性乳房的形状、大小如何，都能制造出足够的奶水，从而带给宝宝丰富的营养。"],
                           @[@"多多吮吸",
                             @"妈妈的奶水越少，越要增加宝宝吮吸的次数；由于宝宝吮吸的力量较大，正好可借助宝宝的嘴巴来按摩乳晕。喂得越多，奶水分泌得就越多。"],
                           @[@"吸空乳房",
                             @"妈妈要多与宝宝的肌肤接触，孩子对乳头的吸吮是母乳分泌的量佳刺激。每次哺乳后要让宝宝充分吸空乳房，这有利于乳汁的再产生。"],
                           @[@"注意“食”效",
                             @"新手妈咪应当保持每日喝牛奶的良好习惯（不要分娩后马上喝，否则容易胃涨，感觉肠胃好了才开始），多吃新鲜蔬菜水果，合理摄取营养丰富的食物。但吃得“好”不是所谓的大补，传统的猪蹄、鸡汤、鲫鱼汤中的高脂肪会增加堵塞乳腺管的风险，不利母乳分泌，还会让妈咪发胖，也会使奶水中的脂肪含量增多不利于宝宝消化。所以传统的下奶汤适量喝，既能让自己奶量充足、又能修复元气且营养均衡不发胖，这才是新手妈咪希望达到的月子“食”效。"],
                           @[@"双侧哺乳",
                             @"如果一次只喂一边，乳房受的刺激减少，自然泌乳也少。每次喂奶两边的乳房都要让宝宝吮吸到。有些宝宝食量比较小，吃一只乳房的奶就够了，这时不妨先用吸奶器把前部分比较稀薄的奶水吸掉，让宝宝吃到比较浓稠、更富营养的奶水。"],
                           @[@"良好心情",
                             @"母乳是否充足与新妈妈的心理因素及情绪情感关系极为密切。所以，妈妈在任何情况下都要不急不躁，以平和、愉快的心态面对生活中的一切。"],
                           @[@"补充水分",
                             @"哺乳妈妈常会在喂奶时感到口渴，这是正常的现象。妈妈在喂奶时要注意补充水分，或是多喝豆浆、杏仁粉茶（此方为国际母乳会推荐）、果汁、原味蔬菜汤等。水分补充适度即可，这样乳汁的供给才会既充足又富营养。"],
                           @[@"充分休息",
                             @"夜里因为要起身喂奶好几次，晚上睡不好觉。睡眠不足当然会使奶水量减少。哺乳妈妈要注意抓紧时间休息，白天可以让丈夫或者家人帮忙照看一下宝宝，自己抓紧时间睡个午觉。还要学会如何在晚间喂奶的同时不影响自己的睡眠。每天争取能有10小时的睡眠，睡时要采取侧卧位，利于子宫复原。"],
                           @[@"按摩热敷",
                             @"按摩乳房能刺激乳房分泌乳汁，妈妈用干净的毛巾蘸些温开水，由乳头中心往乳晕方向成环形擦拭，两侧轮流热敷，每侧各15分钟"],
                           @[@"避免受伤",
                             @"如果妈妈的乳头受伤、破皮、皲裂或流血并导致发炎时，就会影响乳汁分泌。为避免乳头受伤，建议妈妈们采用正确的喂奶姿势，控制好单侧的吮吸时间，否则很容易反复受伤。"]
                           ];
    }
    [self addTableView];
}

- (void)addTableView
{
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
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADConfineTableViewCell *cell =
    (ADConfineTableViewCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
   
    return cell.detailHeight + 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdStr = @"aConCell";
    
    ADConfineTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdStr];
    
    if (aCell == nil) {
        aCell =
        [[ADConfineTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdStr];
    }
   
    NSLog(@"name: %@", self.dataArray[indexPath.row][0]);
    aCell.name.text = self.dataArray[indexPath.row][0];
    aCell.detailStr = self.dataArray[indexPath.row][1];

//    aCell.backgroundColor = [UIColor bg_lightYellow];
    aCell.backgroundColor = [UIColor whiteColor];
    
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return aCell;
}

- (void)dealloc
{
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
