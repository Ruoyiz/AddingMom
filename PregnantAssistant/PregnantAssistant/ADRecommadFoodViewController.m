//
//  ADRecommadFoodViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-29.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADRecommadFoodViewController.h"
#import "SHLUILabel.h"

@interface ADRecommadFoodViewController ()

@end

@implementation ADRecommadFoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setLeftBackItemWithImage:nil
                    andSelectImage:nil];
    
//    self.view.backgroundColor = [UIColor bg_lightYellow];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self readData];

    [self addScrollView];
    [self addDetialLabel];
}

- (void)addScrollView
{
//    int naviHeight = [ADHelper getNavigationBarHeight];
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_myScrollView];
}

- (void)addDetialLabel
{
    NSString *detailStr = nil;
    if ([self.myTitle isEqualToString:@"妊娠期糖尿病饮食"]) {
        detailStr = self.dataArray[0];
    } else if ([self.myTitle isEqualToString:@"妊娠期高血压饮食"]) {
        detailStr = self.dataArray[1];
    } else if ([self.myTitle isEqualToString:@"贫血了吃什么好"]) {
        detailStr = self.dataArray[2];
    }
    
    SHLUILabel *contentLab = [[SHLUILabel alloc] init];
    contentLab.paragraphSpacing = 8;
    contentLab.font = [UIFont ADTraditionalFontWithSize:14];
    contentLab.text = detailStr;
    contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    contentLab.numberOfLines = 0;
    contentLab.textColor = [UIColor font_tip_color];
    CGFloat labelHeight = [contentLab getAttributedStringHeightWidthValue:SCREEN_WIDTH - 32];
    contentLab.frame = CGRectMake(16, 12, SCREEN_WIDTH - 32, labelHeight);
    [self.myScrollView addSubview:contentLab];
    
    self.myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, labelHeight + 30);
}

- (void)readData
{
    self.dataArray = @[
@"    饮食治疗是妊娠期糖尿病最主要、最基本的治疗方法，85%的患者只需要进行单纯的饮食治疗就能使血糖得到良好的控制。专家称，与一般的糖尿病患者不同的是，妊娠期间的饮食控制标准相对较松，因为其还需满足孕妇及胎儿能量的需求。妊娠糖尿病饮食要注意什么呢？\n\
1、多选粗粮\n\
    以面包为例，白面包的GI（血糖生成指数）为70，但掺入75―80%的大麦粒的面包为34，所以提倡用粗制粉带碎谷粒制成的面包代替精白面包。\n\
2、简单就好\n\
    蔬菜能不切就不切，谷粒能整粒就不要磨。\n\
3、多吃膳食纤维\n\
    在可摄取的份量范围内，多摄取高纤维食物，如：以糙米或五谷米饭取代白米饭，增加蔬菜的摄取量，吃新鲜水果而勿喝果汁等，如此可延缓血糖的升高，帮助血糖的控制，也比较有饱足感，但千万不可无限量地吃水果。\n\
4、增加主食中的蛋白质\n\
    在主食中增加蛋白质能够很好地降低GI，例如一般的小麦面条GI为81.6，强化蛋白质的意大利细面条GI为37。饺子就是较好的低GI食品，因为里面含有大量的蛋白质和纤维。\n\
5、炒菜时要用急火煮，少加水\n\
    食物的软硬、生熟、稀稠、颗粒大小对GI都有影响。加工时间越长，温度越高，水分越多，糊化就越好，GI也越高，所以炒菜时最好用急火煮，少加水。\n\
6、多吃点醋\n\
    食物经发酵后产生酸性物质，可使整个膳食的食物GI降低，所以在副食中加醋或柠檬汁，也是调节GI的有效方法。\n\n\
妊娠期糖尿病患者可以吃一些水果，不过要注意选择种类、数量等。\n\
1、选择低糖水果：如苹果、草莓、油桃等。\n\
2、每次吃水果不宜太多，最好不要超过100克。\n\
3、在两餐中间吃，切忌餐后食用。一般可选择上午9∶00―9∶30，下午15∶00―16∶00，晚上睡前21∶00左右为宜，最好选在加餐时间吃，可直接作为加餐食用，既预防低血糖，又可保持血糖不发生大的波动。而餐后吃水果，对血糖高的孕妇很不利，更不宜每餐都吃水果。\n\
4.吃水果后，要适当减少主食。平时，每吃100―125克水果，应减少主食25克，对调节血糖有好处。",

@"    妊娠高血压是指妊娠中血压的收缩压高于一百四十或舒张压高于九十，或妊娠后期之血压比早期收缩压升高三十或舒张压升高十五即是。\n\
    妊娠期妇女所特有而又常见的疾病，以高血压、水肿、蛋白尿、抽搐、昏迷、心肾功能衰竭，甚至发生母子死亡为临床特点。所以千万不要小看妊娠高血压，认为孩子出生后，高血压就会自然痊愈了。\n\
    妊娠高血压由于孕妇处在怀孕期间，用药会特别的谨慎，最好的方法当然是食疗了。这里我们推荐一些特别针对妊娠高血压患者的降压食谱。\n\n\
1、宜多吃芹菜。芹菜纤维较粗，香味浓郁，富含胡萝卜素、维生素C、烟酸及粗纤维等，有镇静降压、清热凉血等功效。妊娠高血压的准妈妈常吃芹菜，能够有效缓解症状。\n\
2、宜多吃鱼。鱼富含优质蛋白质与优质脂肪，其所含的不饱和脂肪酸比任何食物中的都多。不饱和脂肪酸是抗氧化的物质，可以降低血中的胆固醇，抑制血小板凝集，从而有效地防止全身小动脉硬化及血栓的形成。所以鱼是孕妇防治妊娠期高血压的理想食品。\n\
3、宜多吃鸭肉。鸭肉性平而不热，脂肪高而不腻。它富含蛋白质、脂肪、铁、钾、糖等多种营养素，有清热凉血、祛病健身的功效。不同品种的鸭肉，食疗作用也不同。纯白鸭肉可清热凉血，妊娠期高血压病患者宜常食。研究表明，鸭肉中的脂肪不同于黄油或猪油，其化学成分近似橄榄油，有降低胆固醇的作用，对防治妊娠期高血压病有益。\n\
4、宜多吃黄鳝。鳝鱼是一种高蛋白、低脂肪的食品，能够补中益气，治虚疗损。准妈妈常吃黄鳝可以防治妊娠期高血压病。需要注意的是，黄鳝一旦死亡，就和蟹一样，体内细菌大量繁殖并产生毒素，所以要食用鲜活的黄鳝。",

@"    如果孕妈妈贫血了，应该多吃动物血和肝脏、新鲜蔬菜以及黑色食物等食物，这些食物都含有丰富的铁物质。\n\n\
1、动物的血和肝脏。动物肝脏中既含有丰富的铁，维生素A，也有较丰富的叶酸，同时还含有其他的微量元素，如锌、硒等，能有效促进身体对铁质的吸收。如鸡肝、猪肝等，一周吃两次，鸭血汤、蛋黄、番茄等食物含铁量都较高，可经常吃。\n\
2、新鲜的蔬菜。蔬菜含有的铁物质相对比较低，而且也不利于人体的吸收，但是新鲜的绿色蔬菜含有丰富的叶酸。叶酸虽然不是和铁物质一样是造血的主力军，但它参与红血球的生成，算是辅助造血，所以叶酸如果缺乏，也会造成细胞贫血。\n\
3、黑色食物。民间有一种说法，黑色的食物含有丰富的铁物质，具有明显改善营养性贫血的功效，可以起到补血的作用，所以孕妇贫血不妨多吃一些黑色的食物，比如黑豆、黑木耳、黑芝麻等。\n\
4、孕妈妈后期应该多吃含有丰富高蛋白类的食物。怀孕的后期宝宝发育的非常快，这时孕妈妈就要注意了，只要宝宝每周体重不超过1公斤，就要多吃富含高蛋白类的食物，比如牛奶、鱼类、蛋类、瘦肉、豆类等。这些食物对孕妇贫血的治疗有着良好效果。但要注意荤素结合，蔬菜、水果也要跟得上，以免过食油腻东西伤胃。\n\
5、由于孕妇中度以上贫血，对铁需求量极大，普通的食物补充未必能满足所需。因此，孕妇缺铁性贫血还应该适当服用安全、合适的补铁产品补铁。"
];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
