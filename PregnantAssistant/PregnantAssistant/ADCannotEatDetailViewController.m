//
//  ADCannotEatDetailViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-29.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADCannotEatDetailViewController.h"
#import "ADCanNotEatTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ADCannotEatDetailViewController ()

@end

@implementation ADCannotEatDetailViewController

-(void)dealloc
{
    self.myTableView.dataSource = nil;
    self.myTableView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setLeftBackItemWithImage:nil
                    andSelectImage:nil];
    
    _selectedIndexes = [[NSMutableArray alloc] init];
    
    [self performSelector:@selector(setup) withObject:nil afterDelay:0.05];
}

- (void)setup
{
    [self setupData];
    [self setupTableView];
}

- (void)setupTableView
{
//    int naviHeight = [ADHelper getNavigationBarHeight];
    
    self.myTableView =
    [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    self.myTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.myTableView setContentOffset:CGPointMake(0, -64)];
//    myTableView.setContentOffset(CGPointMake(0, -64), animated: false)
    self.myTableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);

//    self.myTableView.backgroundColor = [UIColor bg_lightYellow];
    self.myTableView.backgroundColor = [UIColor whiteColor];
//    self.myTableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
//    self.myTableView.separatorColor = [UIColor defaultTintColor];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.myTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i = 0; i < _selectedIndexes.count; i++) {
        NSNumber *index =  _selectedIndexes[i];
        if ((index.intValue -20) == indexPath.row) {
            ADCanNotEatTableViewCell *cell =
            (ADCanNotEatTableViewCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
//            NSLog(@"content:%@",cell.content);
            
            CGRect textRect = [cell.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -98 -12, 240)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                         context:nil];
            int cellHeight = textRect.size.height + 36 +12;
            NSLog(@"cell Height:%d",cellHeight);
            
//            //当 cell content 内容高度算出来比以前还小(3 4 行时)
            if (cellHeight <= 100) {
                cellHeight = 101;
            }
            return cellHeight;
        }
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADCanNotEatTableViewCell *cell =
    (ADCanNotEatTableViewCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    [self biggerCell:cell.moreBtn];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdStr = @"aCanNotEatCell";
    
    ADCanNotEatTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdStr];
    
    if (aCell == nil) {
        aCell =
        [[ADCanNotEatTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:cellIdStr];
    }
    aCell.nameLabel.text = self.dataArray[indexPath.row][0];
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    aCell.backgroundColor = [UIColor whiteColor];
    
    NSString *newName= [aCell.nameLabel.text stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    
    NSMutableString *pinYinSource = [newName mutableCopy];
    
    CFStringTransform((__bridge CFMutableStringRef)pinYinSource, NULL, kCFStringTransformMandarinLatin, NO);
    
    CFStringTransform((__bridge CFMutableStringRef)pinYinSource, NULL, kCFStringTransformStripDiacritics, NO);
    
    //NSLog(@"pinYin:%@",pinYinSource);
    
    NSString *imgUrl =
    [NSString stringWithFormat:@"http://static.addinghome.com/static/paAsset/image/cannotEat/%@.png", pinYinSource];
    imgUrl = [imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"urlStr:%@ url:%@", imgUrl, [[NSURL alloc]initWithString:imgUrl]);
    [aCell.logoImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                         placeholderImage:[UIImage imageNamed:@""]];

//    aCell.logo = [UIImage imageNamed:newName];
    aCell.content = self.dataArray[indexPath.row][1];
    aCell.moreBtn.tag = 20 + indexPath.row;
    [aCell.moreBtn addTarget:self
                      action:@selector(biggerCell:)
            forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0; i < _selectedIndexes.count; i++) {
        NSNumber *index =  _selectedIndexes[i];
        if ((index.intValue -20) == indexPath.row) {
            aCell.moreBtn.hidden = YES;
            break;
        }
    }

    return aCell;
}

- (void)biggerCell:(UIButton *)sender
{
    NSLog(@"tap row:%ld",(long)sender.tag);
    
    for (NSNumber *aIndex in _selectedIndexes) {
        if (aIndex.intValue == (int)sender.tag) {
            [_selectedIndexes removeObject:aIndex];
            break;
        }
    }
    [_selectedIndexes addObject:@(sender.tag)];
    
    [self.myTableView beginUpdates];
    [self.myTableView endUpdates];
}

- (void)setupData
{
    if ([self.myTitle isEqualToString:@"水果篇"]) {
    self.dataArray = @[
@[@"木瓜",@"能消暑解渴、润肺止咳。它特有的木瓜酵素能清心润肺还可以帮助消化、治胃病，它独有的木瓜碱具有抗肿瘤功效，对淋巴性白血病细胞具有强烈抗癌活性。但孕妇下部腰膝无力，是由于精血虚、真阴不足，所以不宜食，否则用容易导致流产。"],
@[@"杏",@"性甘酸、微温、冷利、有小毒，过量食用会伤及筋骨，影响视力，还极易长疮，不利胎儿。"],
@[@"荔枝",@"孕妇不宜多吃荔枝，一方面多吃荔枝容易上火，另一方面孕妇大量食用会引起高血糖。"],
@[@"香榧子",@"孕妇最好不要吃，香榧含有一种生物碱，有促进宫缩的作用，在古代是用于打胎的，所以不能吃。"],
@[@"蟠桃",@"孕妇吃蟠桃过量会生热，可能引起急性流产、出血等，且妊娠糖尿病患者忌食。"],
@[@"山楂",@"怀孕后会有妊娠反应，而且爱吃酸甜之类的东西。但山楂果及其制品,孕妇以不吃为宜。临床证实:山楂对妇女子宫有收缩作用，如果孕妇大量食用山楂，就会刺激子宫收缩，甚至导致流产。"],
@[@"柚子",@"柚子性寒，食之过多则伤阳气，身体阳虚、畏寒肢冷者、腹胃虚弱者、孕妇不宜多吃或者最好不吃。"],
@[@"菠萝",@"菠萝中含有一种叫蛋白酶的物质，对人的皮肤、血管等有一定的副作用。过敏体质的人食之会引起菠萝中毒，称为“菠萝病”。吃后15分钟至1小时左右，出现呕吐、腹痛、腹泻，同时还出现过敏症状，如头疼，全身发痒，四肢及口舌发麻，严重者还会出现呼吸困难、休克等。所以建议孕妇少吃为妙，特别是初食者，尤要当心过敏的发生。专家建议：吃菠萝时，先把果皮削去，挖尽果丁，然后切开在盐水中浸洗，使其中的有机酸分解在盐水里，减少中毒发生的几率。"],
@[@"桂圆",@"桂圆性温太热。一切阴虚内热体质及患热性病者均不宜食用。怀孕后，阴血偏虚，阴虚则滋生内热，因此孕妇食用桂圆，往往有大便干燥、口干、肝经郁热的症候。不仅不能保胎，反而易出现漏 红、    痛等先兆流产症状。因此，孕妇不宜吃桂圆。"]
                       ];
    } else if ([self.myTitle isEqualToString:@"饮料篇"]){
        self.dataArray = @[
@[@"茶",@"孕妇如果喝茶太多、太浓，特别是饮用浓红茶，对胎儿会造成危害。茶叶中含有2～5％的咖啡因，咖啡因具有兴奋作用，服用过多会刺激胎动增加，甚至危害胎儿的生长发育。有调查证实，孕妇若每天饮5杯红茶，就可能使新生儿体重减轻。此外，茶叶中还含有多量的鞣酸，鞣酸可与孕妇食物中铁元素，结合成一种不能被机体吸收的复合物。孕妇如果过多地饮用浓茶，还有引起贫血的可能，也将给胎儿造成先天性缺铁性贫血的隐患。"],
@[@"咖啡",@"咖啡中的咖啡碱，有破坏维生素B1的作用，以致缺乏，出现烦躁、容易疲劳、记忆力减退、食欲下降及便秘等。严重的可发生神经组织损伤、心脏损伤、肌肉组织损伤及浮肿。对于孕妇来说，如果嗜好咖啡，为害更大。每天喝8杯以上咖啡的孕妇，她们生产的婴儿没有正常婴儿活泼，肌肉发育也不够健 壮。  因此，孕妇不要喝咖啡。"],
@[@"葡萄酒",@"怀孕时不能喝酒，怀孕时喝酒的母亲产下的宝宝，容易罹患胎儿性酒精症候群，脑的发育极可能收到影响。即使喝少量的酒，酒精也会经胎盘流入胎儿脑中，使脑细胞遭到破坏。"],
@[@"可乐/王老吉/加多宝",@"孕妇在怀孕期间不建议喝碳酸饮料和凉茶类饮料。可乐中含有咖啡因，很容易经胎盘进入胎儿体内，造成胎儿大脑、脏器发育异常。凉茶中大多含有夏枯草等草药，喝了容易造成体质寒凉且对子宫也不好。"],
@[@"红牛",@"红牛里含有牛磺酸和较高剂量的咖啡因，是一种兴奋剂，属于刺激性饮料，影响胎儿的脑神经发育。因此孕妇不要喝。"]
];
    } else if ([self.myTitle isEqualToString:@"蔬菜篇"]){
        self.dataArray = @[
@[@"韭菜、麦芽（糖）",@"产后退奶时很有效，但会影响荷尔蒙的分泌，且易造成恶心、呕吐。"],
@[@"菠菜",@"实际上菠菜的含铁量并不多，并非补血的理想食物，菠菜含有大量草酸，草酸可影响人体对钙和锌的吸收，而钙和锌是人体不可缺少的微量元素，孕妇过多食菠菜，无疑对胎儿发育不利。"],
@[@"马齿苋",@"马齿苋既是药物又可作菜食用，但其性寒冷而滑利。经实验证明，马齿苋汁亦对子宫有明显兴奋作用，易造成流产；"],
@[@"瓠瓜",@"孕妇尽量不要吃性凉的食物，而瓠瓜是性平、微寒的，不可大量食用。"],
@[@"扁豆",@"孕妇食用扁豆不宜过多，否则容易引发腹胀，易产气。且食用时需烧熟煮透，切不可半生半熟吃。"],
@[@"白萝卜",@"白萝卜性凉，准妈妈最好少吃，有先兆流产、子宫脱垂、体虚的准妈妈最好不吃。"],
@[@"荠菜",@"准妈妈忌食荠菜。实验表明，荠菜的提取物有类似催产素一样的令子宫收缩的作用，准妈食用后很容易导致妊娠下血或胎动不安。"],
@[@"木薯",@"木薯为有毒植物，若处理不当极易引起中毒，孕妇不要吃。"],
@[@"牛蒡",@"牛蒡有活血化瘀的作用，孕妇不要吃。"],
@[@"芦荟",@"芦荟能使女性骨盆内脏器充血，促进子宫的运动，引起准妈腹痛出血，严重可导致流产，所以不能吃。"],
@[@"豆瓣菜",@"豆瓣菜是寒凉的食物，并且豆瓣菜有通经的作用，所以准妈妈不宜食用。"],
@[@"木耳菜",@"木耳菜性属寒滑，有滑利凉血之弊，准妈最好不要吃。尤其是有习惯性流产的准妈。"],
@[@"黑木耳",@"黑木耳虽有滋养益胃的作用，但同时又具有活血化瘀之功，不利于胚胎的稳固和生长，故应忌食；"],
@[@"荸荠",@"荸荠属于寒性滑利的食物，虽然营养丰富，但尤其在孕早期不建议吃，会促进子宫收缩，引起流产。"],
@[@"仙人掌",@"仙人掌性寒又能行气活血，准妈妈不能吃，还可能引起过敏。"]
                           ];
    } else if ([self.myTitle isEqualToString:@"其他"]){
        self.dataArray = @[
@[@"杏仁",@"杏仁中含有毒物质氢氰酸，为了避免其毒性透过胎盘屏障影响胎儿，孕妇应禁食杏仁；"],
@[@"薏苡仁",@"薏苡仁是一味药食兼用的植物种仁，其性滑利。药理实验证明，薏苡仁对子宫肌肉有兴奋作用，促进子宫收缩，因而有诱发流产的可能；"],
@[@"久存土豆",@"土豆中含有生物碱，存放越入的土豆生物碱含量越大，而中剂量的土豆生物碱便可影响胎儿正常发育，导致胎儿生长缓慢；"],
@[@"猪肝",@"许多人认为猪肝很补血，然而它却有破血之效，会打散子宫内的废血；但因怀孕时期子宫内并无废血，故反易造成早期流产。"],
@[@"动物肝脏",@"许多孕妇需要吃些动物肝脏，以补充足够的维生素A。但如果过量食用，会产生维生素A中毒等不良后果。因为肝脏中维生A含量极高，可导致胎儿畸形 ；"],
@[@"螃蟹/甲鱼/海带",@"这些水产品有活性软坚作用，食用后对早期妊娠有造成出血、流产之弊。螃蟹有活血化瘀之功，尤其是蟹爪，有明显的堕胎作用；甲鱼有较强的通血络散瘀块作用；鳖甲的堕胎力比鳖肉更强；海带功能软坚，散结，化瘀，亦有堕胎之嫌。"],
@[@"黄芪",@"黄芪具有益气健脾之功，与母鸡炖熟食用，有滋补益气的作用，是气虚食用的很好补品，但快要临产的孕妇应慎用，避免妊娠晚期胎儿的正常下降生理规律被干扰，而造成难产。"],
@[@"人参",@"属大补元气之品，准妈妈滥用人参进补，可导致气盛阴虚，很容易上火；还会出现呕吐、水肿及高血压等症状，可引起见红、流产及早产等危险情况。除此之外，鹿茸、鹿胎、蜂王浆等补品，准妈妈们也不宜服用。"],
@[@"香料",@"八角茴香、小茴香、花椒、胡椒、桂皮、五香粉、辣椒等热性香料都是调味品。而热性香料具有刺激性，很容易消耗肠道水分，使胃肠腺体分泌减少，造成肠道干燥、便秘或粪石梗阻。孕妇应该尽量不吃，以免引起孕期便秘造成腹压增大，对胎儿造成不利影响。"],
@[@"芥末/薄荷",@"属于辛辣刺激物，孕妇不要吃。"],
@[@"鱼肝油",@"孕妇长期大量食用会引起食欲减退、皮肤发痒、毛发脱落、感觉过敏、眼球突出，血中凝血酶原不足及出现肌肉软弱无力、呕吐和心律失常等。因此，孕妇不要随意服用大量的鱼肝油和钙制剂。如果因治病需要，应按医嘱服用。"],
@[@"加工食品和罐头食品",@"经过加工的半成品食物虽然美味可口，但这些食物在加工过程中，需要加入一定的添加剂，如人工合成的色素、香精、甜味剂及防腐剂等，准妈妈应尽量少吃。"],
@[@"油条",@"铝的超量对人的大脑是极不利的。油条在制作时，须加入一定量的明矾，而明矾是一种含铝的无机物。炸油条时每500g面粉就要用15g明矾，也就是说，如果孕妇每天吃两根油条，就等于吃了3g明矾，这样天天积蓄起来，其摄入的铝相当惊人。这些明矾中含的铝通过胎盘，侵入胎儿的大脑，会使其形成大脑障碍，增加痴呆儿的机率。"],
@[@"咸鱼",@"咸鱼含有大量二甲基硝酸盐，进入人体内能被转化为致癌性很高的二甲基硝胺，并可通过胎盘作用于胎儿，是一种危害很大的食物。"],
@[@"味精",@"进食过多味精可影响锌的吸收，不利于胎儿神经系统的发育。"],
@[@"槟榔",@"妇吃槟榔或孕龄妇女长期嚼槟榔后再怀孕，其流产、死产及畸胎率为常人的两倍。"],
@[@"止吐药",@"有可能导致胎儿畸型。"]
];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end