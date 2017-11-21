//
//  ADRateStoreViewController.m
//  PregnantAssistant
//
//  Created by D on 15/2/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADRateStoreViewController.h"
#import "UIImage+Tint.h"

@interface ADRateStoreViewController ()

@end

@implementation ADRateStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _aScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _aScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH *(3066 /828.) + 50);
    [self.view addSubview:_aScrollView];
    
    _aScrollView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *aRateImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *(3066 /828.))];
    aRateImgView.image = [UIImage imageNamed:@"为我点赞"];
    [_aScrollView addSubview:aRateImgView];
    
    aRateImgView.center = CGPointMake(SCREEN_WIDTH /2.0, aRateImgView.center.y);
    
    [self setLeftBackItemWithImage:nil andSelectImage:nil];

    self.myTitle = @"为我点赞";
    
    [self addbar];
    self.syncBtn.hidden = YES;
}

- (void)addbar
{
    UIView *bar = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT -50, SCREEN_WIDTH, 50)];
    bar.backgroundColor = UIColorFromRGB(0x9176ff);
    [self.view addSubview:bar];
    
    UIImageView *good = [[UIImageView alloc]initWithFrame:CGRectMake(20, (50 -32)/2, 23, 32)];
    good.image = [UIImage imageNamed:@"点赞"];
    [bar addSubview:good];
    
    UILabel *like = [[UILabel alloc]initWithFrame:CGRectMake(56, 0, SCREEN_WIDTH , 50)];
    like.font = [UIFont fontWithName:@"RTWSYueGoTrial-Light" size:18.0f];
    like.text = @"为我点赞";
    like.textAlignment = NSTextAlignmentLeft;
    like.textColor = [UIColor whiteColor];
    like.backgroundColor = [UIColor clearColor];
    [bar addSubview:like];
    
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -26, (50 -18)/2, 6, 18)];
    arrow.image = [[UIImage imageNamed:@"gogrey"] imageWithTintColor:[UIColor whiteColor]];
    [bar addSubview:arrow];

    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goRate)];
    [bar addGestureRecognizer:aTap];
    bar.userInteractionEnabled = YES;
}

- (void)goRate
{
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString:@"https://itunes.apple.com/us/app/yun-ma-zhu-shou-zui-tie-xin/id931197358?l=zh&ls=1&mt=8"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
