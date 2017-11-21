//
//  ADCanNotEatViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-27.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADCanNotEatViewController.h"
#import "ADCannotEatDetailViewController.h"
#import "ADRecommadFoodViewController.h"
#import "ADCustomEatButton.h"
#import "ADCustomButton.h"
#import "ADCanNotEatBtn.h"

#define LINESPACE 6
#define BUTTON_HEIGHT 64
#define BUTTON_WEIGHT 136
static NSString *tip = @"该工具介绍的是您孕期需要注意的食物，并非备孕，月子及哺乳期的食物。";
@interface ADCanNotEatViewController ()

@end

@implementation ADCanNotEatViewController{
    UIScrollView *_backScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myTitle = @"不能吃";
    self.view.backgroundColor = [UIColor whiteColor];
    _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_backScrollView];
    
    self.titleArray = @[
                        @"水果篇", @"饮料篇",
                        @"蔬菜篇", @"其他",
                        @"妊娠期糖尿病饮食",
                        @"妊娠期高血压饮食",
                        @"贫血了吃什么好"
                        ];
    [self addButtons];
    
    [self addTip];
    
    self.syncBtn.hidden = YES;
}

- (void)addButtons
{
    for (int i = 0; i < 4; i++) {
        int row = i /2;
        int col = i %2;
        
        ADCanNotEatBtn *aBtn =
        [[ADCanNotEatBtn alloc]initWithFrame:CGRectMake(0, 0, 100, 100)
                                    andTitle:self.titleArray[i]
                                  andImgName:self.titleArray[i]];
        
        CGFloat perWidth = SCREEN_WIDTH / 4;
        aBtn.center = CGPointMake ((perWidth +6) + (perWidth -6) *2*col, 70 +116*row);
        
        [_backScrollView addSubview:aBtn];
        _posY = aBtn.frame.origin.y + aBtn.frame.size.height;
        [aBtn addTarget:self action:@selector(jumpToDetialVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    int startPos = _posY +20;
    for (int i = 4; i < self.titleArray.count; i++) {
        ADCustomButton *aBtn = [[ADCustomButton alloc]init];
        aBtn.frame =
        CGRectMake(16, startPos +(i -4)*56, SCREEN_WIDTH -32, 44);
        
        aBtn.titleStr = self.titleArray[i];
        aBtn.buttonColor = [UIColor whiteColor];
        aBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [aBtn addTarget:self action:@selector(jumpToNextVC:) forControlEvents:UIControlEventTouchUpInside];
        aBtn.tag = 20 +i;
        
        [_backScrollView addSubview:aBtn];
        _posY = aBtn.frame.origin.y + aBtn.frame.size.height;
        
        [aBtn setTitleColor:[UIColor font_btn_color] forState:UIControlStateNormal];
        aBtn.layer.borderColor = UIColorFromRGB(0xe65463).CGColor;
        aBtn.layer.borderWidth = 1.f;
    }
}

- (void)addTip
{
    UILabel *tipLabel =
    [[UILabel alloc]initWithFrame:CGRectMake(18, _posY +8, SCREEN_WIDTH -32, 44)];
    tipLabel.font = [UIFont tip_font];
    tipLabel.textColor = [UIColor font_tip_color];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tip];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [tip length])];
    tipLabel.attributedText = attributedString;
    
    tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
    tipLabel.numberOfLines = 2;

    
    [_backScrollView addSubview:tipLabel];
    _backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _posY + 60);
}

- (void)jumpToDetialVC:(ADCanNotEatBtn *)sender
{
    //NSLog(@"detail");
    ADCannotEatDetailViewController *aDetialVc = [[ADCannotEatDetailViewController alloc]init];
    aDetialVc.myTitle = sender.titleStr;
    [self.navigationController pushViewController:aDetialVc animated:YES];
}

- (void)jumpToNextVC:(ADCustomButton *)sender
{
    //NSLog(@"next");
    ADRecommadFoodViewController *aDetialVc =
    [[ADRecommadFoodViewController alloc]init];
    aDetialVc.myTitle = sender.titleLabel.text;
    [self.navigationController pushViewController:aDetialVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
