//
//  ADDreamViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-26.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADDreamViewController.h"
#import "ADCustomButton.h"
#import "ADDreamDetialViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString *tip = @"生男生女由精子的性别决定, 不过胎梦万一准了呢？";
@interface ADDreamViewController ()

@end

@implementation ADDreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTitle = @"胎梦解梦";
    
//    self.view.backgroundColor = [UIColor bg_lightYellow];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.buttonNames = @[
                         @"暗示生男孩的胎梦",
                         @"暗示生女孩的胎梦"
                         ];
    
    [self addContent];
    
    self.syncBtn.hidden = YES;
}

- (void)addContent
{
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16 +64, SCREEN_WIDTH -32, SCREEN_WIDTH/2)];
    
    NSString *imgStr =
    [NSString stringWithFormat:@"http://static.addinghome.com/static/paAsset/image/other/胎梦图.png"];
    imgStr = [imgStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *imgUrl = [NSURL URLWithString:imgStr];
    [logoView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@""] options:SDWebImageProgressiveDownload];

    [self.view addSubview:logoView];
    
    ADCustomButton *boy = [[ADCustomButton alloc]initWithFrame:
     CGRectMake(16, logoView.frame.origin.y + logoView.frame.size.height +12, SCREEN_WIDTH -32, 64)];
    [boy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    boy.titleLabel.font = [UIFont systemFontOfSize:16];
//    [boy setBackgroundColor:[UIColor defaultTintColor]];
    [boy setBackgroundColor:UIColorFromRGB(0x83D0FF)];
    
    [boy setTitleStr:self.buttonNames[0]];
    [boy addTarget:self action:@selector(pushVc:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:boy];
    
    ADCustomButton *girl =
    [[ADCustomButton alloc]initWithFrame:
     CGRectMake(16, boy.frame.origin.y +boy.frame.size.height +12, SCREEN_WIDTH -32, 64)];
    [girl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    girl.titleLabel.font = [UIFont systemFontOfSize:16];
    [girl addTarget:self action:@selector(pushVc:) forControlEvents:UIControlEventTouchUpInside];
    
    [girl setTitleStr:self.buttonNames[1]];
    
    [girl setBackgroundColor:UIColorFromRGB(0x83D0FF)];
    
    [self.view addSubview:girl];
    
    UILabel *tipLabel =
    [[UILabel alloc]initWithFrame:CGRectMake(0, girl.frame.origin.y + girl.frame.size.height +8, SCREEN_WIDTH, 24)];
    tipLabel.text = tip;
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = [UIColor font_tip_color];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:tipLabel];
}

- (void)pushVc:(UIButton *)sender
{
    ADDreamDetialViewController *aDetialVc = [[ADDreamDetialViewController alloc]init];
    aDetialVc.myTitle = sender.titleLabel.text;
    [self.navigationController pushViewController:aDetialVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
