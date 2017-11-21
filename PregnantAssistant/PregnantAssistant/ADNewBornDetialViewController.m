//
//  ADNewBornDetialViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-26.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADNewBornDetialViewController.h"

#define LINESPACE 6
@interface ADNewBornDetialViewController ()

@end

@implementation ADNewBornDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
//    self.view.backgroundColor = [UIColor bg_lightYellow];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.myTitle isEqualToString:@"新生儿日常护理"]) {
        self.dataArray = @[
                           @[@"title", @"新生儿由于肠道发育还没完全，而且臀部皮肤细嫩，因此经常会有便秘、腹泻、尿布疹、红臀等等的问题，因此如何正确处理新生儿的大小便显得尤其重要。"],
                           @[
                           @"新生儿大便",@"新生儿大便里面，隐藏了很多宝宝身体里的小秘密。爸妈可以通过观察宝宝便便的性状、排便次数等，去了解宝宝消化状态和适时调整孩子饮食。爸妈对孩子每天的大便次数要心中有数，留意便便的颜色有没有异常，有没有特殊气味等。"],
                           @[@"婴儿尿布疹",@"尿布疹是发生在裹尿布部位的一种皮肤炎性病变，也称为婴儿红臀，表现为臀部与尿布接触区域的皮肤发红、发肿，甚至出现溃烂、溃疡及感染，稍有轻微的外力或摩擦便会引起损伤。继续发展则出现渗出液，表皮脱落，浅表的溃疡，不及时治疗则发展为较深的溃疡，甚至褥疮。"],
                           @[@"臀部护理",@"宝宝肌肤娇嫩，特别是臀部经常被尿布包裹着，容易引起尿布疹。保护及护理宝宝的臀部肌肤，成了新手爸妈的一项必修课。护理宝宝臀部，最重要是勤换尿布，让宝宝臀部保持干爽。"],
                           @[@"脐带护理",@"宝宝脐带切断后，脐带残端会逐渐干枯变细而成为黑色。通常在出生后3—7天内，脐带残端会逐步脱落。脐带结扎剪断部位容易感染，同时脐带可直达宝宝的体内血管，因此在断脐后，对脐带残端的护理非常重要。"]
                           ];
    } else if ([self.myTitle isEqualToString:@"新生儿喂养"]) {
        self.dataArray = @[
                           @[@"title", @"吃的好，宝宝才能快高长大。新生儿喂养是新爸爸新妈妈必需掌握的一门学问，其中包括了母乳喂养、人工喂养、混合喂养、营养等的知识和技巧，还有一些如打嗝、吐奶、呛奶等等特殊情况的紧急处理。"],
                           @[@"母乳喂养",@"母乳，是妈妈送给宝宝最珍贵的礼物。如何让宝宝吃上最优质的母乳？这需要妈妈在母乳喂养时掌握正确的姿势和步骤，还要留意哺乳期内的一些饮食秘诀与禁忌等。为了宝宝健康，母乳喂养的妈妈可得多注意自己的身体哦。"],
                           @[@"人工喂养",@"人工喂养是当母亲因各种原因不能喂哺婴儿时，可选用牛、羊乳等兽乳，或其他代乳品喂养婴儿。人工喂养需要适量而定，否则不利于婴儿发育。"],
                           @[@"混合喂养",@"混合喂养是在确定母乳不足的情况下，以其它乳类或代乳品来补充喂养婴儿，使婴儿吃饱，维持他的正常生长发育。混合喂养虽然不如母乳喂养好，但在一定程度上能保证妈妈的乳房按时受到婴儿吸吮的刺激，从而维持乳汁的正常分泌，婴儿每天能吃到2—3次母乳，对婴儿的健康仍然有很多好处。"],
                           @[@"新生儿打嗝",@"新手爸妈会发现，刚出生不久的宝宝很容易打嗝。这有可能是由于护理不当而造成。例如喂奶姿势不正确，或者是喂完奶后没有给宝宝拍嗝等其他原因。当宝宝吃完奶后，爸妈不妨给宝宝拍拍背，这样就不会打嗝了。"],
                           @[@"新生儿吐奶",@"新生儿吐奶是一种常见的现象，如果妈妈发现宝宝吐奶的时间一般在喂奶后的1个小时之内，而且宝宝也不会觉得很辛苦，那就是普通的吐奶现象，主要是由于爸妈喂养不当所造成的。所以爸妈要科学喂养和加强护理。"]
                           ];
    } else if ([self.myTitle isEqualToString:@"新生儿睡眠"]) {
        self.dataArray = @[
                           @[@"title",@"新生宝宝除了吃跟拉外，其余时间几乎都在睡眠中度过，因此睡眠对于新生儿来说是十分重要的，掌握其睡眠特点才能保证其睡眠质量。"],
                           @[@"新生儿睡觉不踏实",@"新生儿睡觉不踏实是很常见的现象。宝宝或许只是因为吃太饱了或者尿布湿了、衣服紧了等原因而造成睡不踏实，爸妈只要好好找出孩子睡不踏实的原因，然后对症解决，很快就可以让宝宝睡得安稳了。"],
                           @[@"新生儿哭闹不睡觉",@"宝宝不肯睡觉，总是哭闹个不停。初当爸妈，总是特别担心孩子。导致新生儿哭闹不睡觉的原因有很多，有时候可能是因为宝宝中枢发育不完善，爸妈对宝宝反应不敏感，宝宝缺钙等情况，都可以让宝宝哭闹不肯睡觉"]
                           ];
    } else if ([self.myTitle isEqualToString:@"新生儿疾病"]) {
        self.dataArray = @[
                           @[@"title", @"宝宝哇哇落地，爸爸妈妈就开始忙碌了：愁他吃，烦他穿，忧他病，究竟宝宝生病爸妈要如何护理呢？"],
                           @[@"新生儿发烧",@"新生宝宝因为体温调节中枢功能不完善，对温度不敏感，所以很容易导致身体发热。一般来说，37.4℃以上就算低烧了。爸妈要注意多通风、注意散热，让宝宝多休息。体温超过38℃，最好几时带宝宝到医院治疗。"],
                           @[@"新生儿肺炎",@"由于新生宝宝身体免疫力较差、呼吸中枢调节功能不完善等原因，新生儿感染肺炎，该病在临床上很常见，四季均易发病，以冬春为多。患病的宝宝如果没有得到及时的治疗，会对生长发育产生影响，所以爸妈一定要引起注意。"],
                           @[@"新生儿溶血症",@"新生儿溶血症是由于妈妈和宝宝的血型不合，而引起的免疫性疾病。症状轻的宝宝，对全身状况影响较小，严重的话，会出现嗜睡，厌食，甚至死亡。所以做好产前检查，也是能够预防宝宝患上新生儿溶血症的重要方法。"]
                           ];
    }
    
    [self addScrollView];
    [self addDataLabel];
}

- (void)addScrollView
{
    self.myScrollView =
    [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [self.view addSubview:self.myScrollView];
}

- (void)addDataLabel
{
    NSString *titleStr = self.dataArray[0][1];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 14, SCREEN_WIDTH -28, 84)];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [titleStr length])];
    titleLabel.attributedText = attributedString;
    
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.numberOfLines = 4;
    titleLabel.font = [UIFont systemFontOfSize:13];
//    titleLabel.textColor = [UIColor font_Brown];
    titleLabel.textColor = [UIColor font_tip_color];
    [titleLabel sizeToFit];
    
    [self.myScrollView addSubview:titleLabel];

    int posY = titleLabel.frame.origin.y + titleLabel.frame.size.height +6;
    for (int i = 0;i < self.dataArray.count;i++) {
        if (i > 0) {
            //add p title
            _pTitle =
            [[UILabel alloc]initWithFrame:CGRectMake(16, posY, SCREEN_WIDTH -32, 16)];
            _pTitle.text = self.dataArray[i][0];
            _pTitle.font = [UIFont systemFontOfSize:14];
            _pTitle.textColor = [UIColor defaultTintColor];
            [self.myScrollView addSubview:_pTitle];
            
            //add p content
            posY += _pTitle.frame.size.height +6;
            NSString *pContent = self.dataArray[i][1];
            _pContent =
            [[UILabel alloc]initWithFrame:CGRectMake(16, posY, SCREEN_WIDTH -32, 100)];
            _pContent.font = [UIFont systemFontOfSize:13];
//            _pContent.textColor = [UIColor font_Brown];
            _pContent.textColor = [UIColor font_tip_color];
            

            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:pContent];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            
            [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
            
            [attributedString addAttribute:NSParagraphStyleAttributeName
                                     value:paragraphStyle
                                     range:NSMakeRange(0, [pContent length])];
            
            
            _pContent.attributedText = attributedString;
            
            _pContent.lineBreakMode = NSLineBreakByCharWrapping;
            _pContent.numberOfLines = 7;
            [_pContent sizeToFit];
            [self.myScrollView addSubview:_pContent];
            
            posY += _pContent.frame.size.height +6;
        }
    }
    
    NSLog(@"posY:%d",posY);
    self.myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, posY + 64 +8);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
