//
//  ADConfinementViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-26.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADConfinementViewController.h"
#import "ADCustomButton.h"
#import "ADCTableViewController.h"
#import "ADNewBornViewController.h"
#import "ADEatViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define LINESPACE 2
static NSString *tip =
@"\"月子\"是一个通俗概念, 它的医学术语叫\"产褥期\"。美国产科学圣经《威廉姆斯产科学》和国内教科书权威《妇产科学》均规定: 产褥期(puerperium)是指从胎盘娩出至产妇全身各器官(除乳腺外)恢复至妊娠前状态(包括形态和功能), 这一阶段一般规定为6周(42天)。中国传统的\"坐月子\"的目的即在这段时间内通过良好的营养和充分的休息使产妇的身体完全恢复。";
@interface ADConfinementViewController ()

@end

@implementation ADConfinementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTitle = @"坐月子";
    
//    self.view.backgroundColor = [UIColor bg_lightYellow];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.buttonNames = @[
                         @"产妇卫生",
                         @"月子饮食",
                         @"母乳喂养",
                         @"新生儿护理"
                         ];
    [self addImage];
    
    [self addTip];
    
    [self addButtons];
    
    self.syncBtn.hidden = YES;
}

- (void)addImage
{
    _logoView = [[UIImageView alloc]init];
    if ([ADHelper isIphone4]) {
        NSString *imgStr =
        [NSString stringWithFormat:@"http://static.addinghome.com/static/paAsset/image/other/坐月子4s.png"];
        imgStr = [imgStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *imgUrl = [NSURL URLWithString:imgStr];
        [_logoView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@""] options:SDWebImageProgressiveDownload];
        
        _logoView.frame = CGRectMake(16, 16 +64, 568/2, 215/2);
    } else {
//        NSString *imgStr =
//        [NSString stringWithFormat:@"http://static.addinghome.com/static/paAsset/image/other/坐月子.png"];
//        imgStr = [imgStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        
//        NSURL *imgUrl = [NSURL URLWithString:imgStr];
//        [_logoView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@""] options:SDWebImageProgressiveDownload];
        _logoView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16 + 64, SCREEN_WIDTH -32, SCREEN_WIDTH/2)];
        _logoView.image = [UIImage imageNamed:@"zuoyuezi"];
//        _logoView.frame = CGRectMake(16, 16, SCREEN_WIDTH -32, SCREEN_WIDTH/2);
    }
    [self.view addSubview:_logoView];
}

- (void)addTip
{
    _tipLabel = [[UILabel alloc]initWithFrame:
                 CGRectMake(14, _logoView.frame.origin.y + _logoView.frame.size.height, SCREEN_WIDTH -24, 158)];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tip];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [tip length])];
    _tipLabel.attributedText = attributedString;
    
    _tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _tipLabel.numberOfLines = 8;
    _tipLabel.font = [UIFont systemFontOfSize:14];
    
//    _tipLabel.backgroundColor = [UIColor bg_lightYellow];
    _tipLabel.backgroundColor = [UIColor whiteColor];
    _tipLabel.textColor = [UIColor font_tip_color];
    [_tipLabel sizeToFit];
    
    [self.view addSubview:_tipLabel];
}

- (void)addButtons
{
    for (int i = 0; i < self.buttonNames.count; i++) {
        int col = i %2;
        int row = i /2;
        ADCustomButton *aBtn = [[ADCustomButton alloc]init];
        
        if ([ADHelper isIphone4]) {
            aBtn.frame =
            CGRectMake(12 +314/2 *col, _tipLabel.frame.origin.y + _tipLabel.frame.size.height +12 + 60*row, 278/2, 45);
        } else {
            aBtn.frame =
            CGRectMake(12 +(SCREEN_WIDTH -6)/2 *col, _tipLabel.frame.origin.y + _tipLabel.frame.size.height +12 + 72*row,
                       (SCREEN_WIDTH -42)/2, 56);
        }
        
        aBtn.titleStr = self.buttonNames[i];
        [aBtn setTitleColor:[UIColor font_btn_color] forState:UIControlStateNormal];
        aBtn.buttonColor = [UIColor whiteColor];
        aBtn.layer.borderColor = UIColorFromRGB(0xe65463).CGColor;
        aBtn.layer.borderWidth = 1.f;
        aBtn.titleLabel.font = [UIFont systemFontOfSize:17];

        [aBtn addTarget:self action:@selector(jumpToNextVC:) forControlEvents:UIControlEventTouchUpInside];
        aBtn.tag = 20 +i;
        [self.view addSubview:aBtn];
    }
}

- (void)jumpToNextVC:(UIButton *)sender
{
    if (sender.tag == 20 || sender.tag == 22){
        ADCTableViewController *aVC = [[ADCTableViewController alloc]init];
        aVC.myTitle = sender.titleLabel.text;
        [self.navigationController pushViewController:aVC animated:YES];
    } else if (sender.tag == 23) {
        ADNewBornViewController *newBorn = [[ADNewBornViewController alloc]init];
        newBorn.myTitle = sender.titleLabel.text;
        [self.navigationController pushViewController:newBorn animated:YES];
    } else if (sender.tag == 21) {
        ADEatViewController *eatVc = [[ADEatViewController alloc]init];
        eatVc.myTitle = sender.titleLabel.text;
        [self.navigationController pushViewController:eatVc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
