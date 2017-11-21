//
//  ADTimeCheckViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-19.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADTimeCheckViewController.h"

#define LINESPACE 6

@interface ADTimeCheckViewController ()

@end

@implementation ADTimeCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.checkContentArray = @[
        @[@"血压、体重、妇检、心电图、血常规、血型(ABO RH)、凝血、尿常规、肝功、两对半、血糖、血钙、血脂、丙肝抗体、梅毒反应素、HI抗体、优生四项(巨细胞病毒、单纯疱疹病毒、风疹病毒、弓形虫)、微量元素，B超；",
          @"1）本次检查比较多，主要用于评估孕妇的初始的身体健康状况；\n2）NT B超：即通过B超进行胎儿颈部透明度筛查，评估宝宝患唐氏综合征的风险。 "],
        @[@"血压、体重、宫高、腹围、多普勒胎心，尿常规、唐氏筛查",
          @"1）唐氏筛查：即抽静脉血检验评估宝宝患唐氏综合征的风险；\n2）多普勒胎心：正常的胎儿心率随子宫内环境的不同，时刻发生着变化，胎心率的变化是中枢神经系统正常调节机能的表现，也是宝宝在子宫内状态良好的表现。正常胎心120-160次/分； " ],
         @[@"血压、体重、宫高、腹围、多普勒胎心、尿常规、大排畸B超",
           @"1）排畸B超：主要检查胎儿各器官发育状态，看有无畸形；" ],
         @[@"血压、体重、宫高、腹围、多普勒胎心、尿常规、妊娠糖尿病筛查",
           @"1） 妊娠糖尿病筛查：也就是通常说的糖筛，糖筛高危一般医生会建议继续做糖耐检查，以确诊有无妊娠合并糖尿病。" ],
         @[@"血压、体重、宫高、腹围、多普勒胎心、尿常规；", @"" ],
         @[@"血压、体重、宫高、腹围、多普勒胎心、尿常规、血常规、血生化、凝血、心电图、B超、骨盆测量",
           @"1）此次B超主要检查胎儿脐血流、S/D值计算，胎儿发育评估；\n2）骨盆测量：检查孕妇产道及骨盆的大小和形态，了解胎儿和骨盆之间的比例，评估是否可以顺利将胎儿娩出。" ],
         @[@"血压、体重、宫高、腹围、多普勒胎心、尿常规、胎心监护",
           @"1）从36周开始，需要每周进行一次产检；\n2）胎心监护的使命是尽早发现胎儿异常，在胎儿尚未遭受不可逆性损伤时，采取有效的急救措施。因此胎心监护非常重要。并且孕妇在家需自数胎动监测胎儿健康。" ],
         @[@"血压、体重、宫高、腹围、多普勒胎心、尿常规、胎心监护", @"" ],
         @[@"血压、体重、宫高、腹围、多普勒胎心、尿常规、胎心监护、B超",
           @"本次B超主要检查羊水、S/D比值、胎儿体重，脐带和胎盘情况，评估胎儿发育及健康状态；" ],
         @[@"血压、体重、宫高、腹围、多普勒胎心、尿常规、胎心监护", @"" ],
         @[@"血压、体重、宫高、腹围、多普勒胎心、尿常规、胎心监护",
           @"以上是常规的产检次数，如果检查结果有异常，医生会根据需要另加检查项目和预约检查时间。产检是照护胎儿健康的重要阶段，同时也是准父母和胎儿第一段亲密接触的美好时光。"]
        ];
}

-(void)setATime:(int)aTime
{
    NSArray *timeArray = @[
                           @"第12周",
                           @"第16~18周",@"第20~24周",
                           @"第24~28周",@"第28~30周",
                           @"第32~34周",@"第36周",
                           @"第37周",@"第38周",
                           @"第39周",@"第40周"
                           ];
    _aTime = aTime;
    UILabel * timeTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 9, 200, 24)];
//    timeTitle.textColor = [UIColor defaultTintColor];
    timeTitle.textColor = [UIColor font_btn_color];
    timeTitle.font = [UIFont systemFontOfSize:16];
    
    timeTitle.text = [NSString stringWithFormat:@"时间: %@",timeArray[aTime -1]];

    [self.view addSubview:timeTitle];
    
    UILabel *timeContent = nil;
    if (aTime == 1) {
        //time content
        timeContent = [[UILabel alloc]initWithFrame:CGRectMake(12, 24 +10 +44, SCREEN_WIDTH -24, 48)];
        timeContent.textColor = [UIColor font_tip_color];
        timeContent.font = [UIFont systemFontOfSize:14];
        NSString *timeStr =
        @"此时去医院，建立“孕妇健康手册”档案，以后每次孕检结果都将记录在内，供日后参考。";
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:timeStr];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
        
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, [timeStr length])];
        timeContent.attributedText = attributedString;
        
        timeContent.lineBreakMode = NSLineBreakByCharWrapping;
        timeContent.numberOfLines = 3;
        
        [self.view addSubview:timeContent];
    }
    
    UILabel *checkTitle =
    [[UILabel alloc]initWithFrame:CGRectMake(12, timeContent.frame.size.height + 34 +44, 200, 24)];
    checkTitle.textColor = [UIColor font_btn_color];
    checkTitle.font = [UIFont systemFontOfSize:16];
    checkTitle.text = @"检查内容";
    [self.view addSubview:checkTitle];
    
    //conternt
    NSString *checkStr = self.checkContentArray[aTime- 1][0];
    
    CGSize sizeHeight = [checkStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14+3]}
                                               context:nil].size;

    int checkHeight = sizeHeight.height+4;

    UILabel *checkContent =
    [[UILabel alloc]initWithFrame:
     CGRectMake(12, checkTitle.frame.origin.y + checkTitle.frame.size.height +2, SCREEN_WIDTH -24, checkHeight)];
//    checkContent.textColor = [UIColor font_Brown];
    checkContent.textColor = [UIColor font_tip_color];
    checkContent.font = [UIFont systemFontOfSize:14];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:checkStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [checkStr length])];
    checkContent.attributedText = attributedString;
    
    checkContent.lineBreakMode = NSLineBreakByCharWrapping;
    checkContent.numberOfLines = 6;
    [checkContent sizeToFit];
    
    [self.view addSubview:checkContent];
    
    //point
    NSString *pointStr = self.checkContentArray[aTime -1][1];
    if (pointStr.length > 0) {

        UILabel *pointTitle = [[UILabel alloc]initWithFrame:
         CGRectMake(12, checkContent.frame.origin.y + checkContent.frame.size.height +4, 200, 24)];
//        pointTitle.textColor = [UIColor defaultTintColor];
        pointTitle.textColor = [UIColor font_btn_color];
        pointTitle.font = [UIFont systemFontOfSize:16];
        pointTitle.text = @"重点解读";
        
        [self.view addSubview:pointTitle];

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:pointStr];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
        
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, [pointStr length])];
        
        CGSize sizeHeight = [checkStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14+12]}
                                                   context:nil].size;
        
        int pointHeight = sizeHeight.height;

        UILabel *pointContent =
        [[UILabel alloc]initWithFrame:
         CGRectMake(12, pointTitle.frame.origin.y +pointTitle.frame.size.height +4, SCREEN_WIDTH -24, pointHeight)];
//        pointContent.textColor = [UIColor font_Brown];
        pointContent.textColor = [UIColor font_tip_color];
        pointContent.font = [UIFont systemFontOfSize:14];
        pointContent.attributedText = attributedString;
        pointContent.lineBreakMode = NSLineBreakByCharWrapping;
        pointContent.numberOfLines = 6;
        
        [self.view addSubview:pointContent];
        
        [pointContent sizeToFit];
    }
}

-(void)setADetial:(ADCheckDetial *)aDetial
{
    UILabel *aTime = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, 200, 24)];
    aTime.textColor = [UIColor defaultTintColor];
    aTime.font = [UIFont systemFontOfSize:14];
    aTime.text = aDetial.time;
    
    [self.view addSubview:aTime];
    
    UILabel *aCheck = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, 200, 24)];
    aCheck.textColor = [UIColor defaultTintColor];
    aCheck.font = [UIFont systemFontOfSize:14];
    aCheck.text = aDetial.check;
    
    [self.view addSubview:aCheck];

    UILabel *aPoint = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, 200, 24)];
    aPoint.textColor = [UIColor defaultTintColor];
    aPoint.font = [UIFont systemFontOfSize:14];
    aPoint.text = aDetial.check;
    
    [self.view addSubview:aPoint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end