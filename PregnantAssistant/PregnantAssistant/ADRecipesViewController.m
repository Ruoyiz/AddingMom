//
//  ADRecipesViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-27.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADRecipesViewController.h"
#import "ADDreamCardView.h"

@interface ADRecipesViewController ()

@end

@implementation ADRecipesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBackItemWithImage:nil
                    andSelectImage:nil];
    
    self.myTitle = @"月子饮食";
    NSLog(@"tag:%d", self.weekNo);
    
    self.view.backgroundColor = [UIColor bg_lightYellow];
    
    self.myScrollView =
    [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [self.view addSubview:self.myScrollView];
    
    [self readData];
    
    [self addDetailView];
}

- (void)readData
{
    if (self.weekNo == 1) {
        self.dataArray = @[
                           @[@"餐点功能",@"清除废血（恶露）、废水、废气及陈旧废物\n产妇刚生产完体力胃口皆不佳,食物以轻淡,好消化为主.以猪肝、乌仔鱼、小黄鱼为主。"],
                           @[@"餐谱",@"1.  生化汤：顺产者使用七份，剖腹产者使用十四份，每日300 cc （分三次喝）\n2.  麻油炒猪肝：每日2份，用烤老姜、米酒精华水（坐月子水）、麻油炒成\n3.  甜糯米粥：每日两碗\n4.  红豆汤：每日两碗\n5.  鱼汤：乌鱼、鲈鱼或黄花鱼，以低溫烘焙胡麻油、米酒精华水、烤老姜煮成，每日一条\n6.  坐月子饮料：杜仲养身茶，或荔枝壳茶，或桂圓枸杞茶，止渴养身当开水饮用，每日两杯，共约600  cc\n7.  生麦芽汁：退奶者用，每日一碗，连续三日（喂母乳者禁用）。请事先告知，并在未涨奶前饮用\n8.  薏仁饭：每日两碗（若吃不下请不必勉强）\n9. 特效催乳汤：章鱼猪手汤（产后四天无奶者用）\n10．木瓜茶：奶水稀少者用（生产三天后用）\n11．养肝汤：养肝护肝，帮助肝脏提高解毒能力"],
                           @[@"功效说明", @"1、生化汤：活血补虚，怯恶露，收缩子宫\n2、麻油猪肝：清除淤血，将子宫内的血块打散以利排出\n3、乌鱼或黄花鱼：肉质细嫩，炖汤易吸收，乌鱼有促进伤口愈合之效\n4、红豆汤：强心利尿，清除体内废水并通过尿道排出；红豆多吃易胀气，故每日须控制在 二碗以内\n5、糯米粥：利用糯米的粘性，适度刺激肠，助其恢复蠕动力并能防止内脏下垂；因糯米不 易消化，故每日须控制在二碗以内\n6、坐月子饮料：解渴、养生\n7、药膳粥：剖腹产及小产者，前三天补气用\n8、养肝汤：养肝护肝，帮助肝脏提高解毒能力，尤其排除剖腹产麻药的毒性"]
                           ];
    } else if (self.weekNo == 2) {
        self.dataArray = @[
@[@"餐点功能",@"收缩子宫、骨盆腔\n\
着重腰骨复原、骨盆腔复旧，促进新陈代谢，預防腰酸背痛"],
@[@"餐谱",
@"1.  生化汤：剖腹生产者須喝至第十四天，每日300 cc（分三次喝），顺产者不再喝\n\
2.  麻油炒猪腰：每日两碗，共两个，用烤老姜、胡麻油炒成\n\
3.  甜糯米粥或桂圆粥：每日一碗\n\
4.  红豆汤：每日两碗\n\
5.  油饭：每日一碗\n\
6.  鱼汤:乌鱼、鲫鱼或黄花鱼，以低温烘焙胡麻油、米酒精华水、烤老姜煮成，每日一条\n\
7.  坐月子饮料：杜仲养身茶，或荔枝壳茶，或桂圆枸杞茶，止渴养身当开水饮用，每日两杯，共约600 cc\n\
8.  蔬菜：选择品性温和的蔬菜，以红色的蔬菜为主，例如：红萝卜、观音菜或红苋菜、菠菜，以胡麻油制作，每日二份  \n\
9.  薏仁饭：每日两碗（若吃不下请不必勉强，也可选择面食）   \n\
10.  木瓜茶：奶水稀少者用"
],
@[@"功效说明",
@"1、麻油猪腰：帮助产妇收缩子宫、骨盆腔\n\
2、薏仁饭（粥）：低淀粉，利尿\n\
3、油饭：润滑肠道，促进体内废物排出，提高肠胃蠕动能力\n\
4、红色蔬菜：防止便秘、补血\n\
5、药膳：补血、补气、补筋骨"
]
                           ];
    } else if (self.weekNo == 3) {
        self.dataArray = @[
@[@"餐点功能",@"补充营养、恢复体力（小产及剖腹产者至四十天）\n\
调养体力，补血、理气，预防老化，恢复女性肌肤的光滑与弹性"],
@[@"餐谱",
@"1.  麻油鸡：以米酒精华水（坐月子水）、麻油、烤老姜制作，每日两碗\n\
2.  甜糯米粥：每日一碗\n\
3.  红豆汤：每日一碗\n\
4.  油饭：每日一碗\n\
5.  鱼类：一般鱼类均可（剖腹产可吃鲈鱼、乌鱼），每日一碗\n\
6.  坐月子饮料：杜仲养身茶，或荔枝壳茶，或桂圆枸杞茶，止渴养身当开水饮用，每日两杯，共约600 cc\n\
7.  蔬菜：品性温和的蔬菜，以红色的蔬菜为主,如红萝卜、观音菜或红苋菜、菠菜，每日二份\n\
8.  水果：哈蜜瓜、木瓜、葡萄、樱桃、水蜜桃等新鲜水果，每日一样\n\
9.  薏仁饭：每日两碗（若吃不下请不必勉强\n\
10.  花生猪脚汤或章鱼猪手汤（无奶水或奶水不足者食用），每日一碗连续三日      11. 药膳：炖汤每日一碗（不愿食猪手者食用，如山药鸡汤）\n\
12．木瓜茶：奶水稀少者用"
],
@[@"功效说明",
@"1、麻油鸡：选用农家公鸡，补充蛋白\n\
2、花生猪脚：促进乳汁分泌，供奶水稀少者食用\n\
3、鱼类：补充养分、促进伤口恢复\n\
4、蔬菜：提供各种人体必须维生素和氨基酸，提高母乳质量\n\
5、水果：选取温性果类，适合不同体质产妇需求，帮助消化，防止便秘"
]
                           ];
    }
}

- (void)addDetailView
{
    _positionY = 12;
    for (int i = 0; i < self.dataArray.count; i++) {
        ADDreamCardView *aCard = [[ADDreamCardView alloc]init];
        aCard.name = self.dataArray[i][0];
        aCard.content = self.dataArray[i][1];
        
        aCard.frame = CGRectMake(8, _positionY, SCREEN_WIDTH -16, aCard.addCardHeight +32);
        _positionY += aCard.addCardHeight;
        _positionY += 10 +32;
        [self.myScrollView addSubview:aCard];
    }
    self.myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _positionY + 64 +4);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
