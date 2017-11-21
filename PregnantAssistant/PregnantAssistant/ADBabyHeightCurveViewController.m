//
//  ADBabyHeightCurveViewController.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/6/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBabyHeightCurveViewController.h"
#import "ADWHDataManager.h"
#import "ADWeightHeightModel.h"
#import "ADHeightCurveView.h"
#import "ADNewHWViewController.h"
#import "UIImage+Tint.h"


@interface ADBabyHeightCurveViewController (){
    
    UIButton *_weightButton;
    UIButton *_heightButton;
    
    BOOL _weightButtonClicked;
    
    ADHeightCurveView *_curveHeightView;
    ADHeightCurveView *_curveWeightView;
    
    UIScrollView *_scrollView ;
}

@end


#define BUTTON_WIDTH  90
#define BUTTON_HEIGHT 35

@implementation ADBabyHeightCurveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTitle = @"身高体重曲线";
//    [self setLeftItem];
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    [self setRightItemWithAddHeightWeight];
    [MobClick event:shengaotizhong_dianjishuju];
    
    [self LayoutUI];
    [self.view setBackgroundColor:UIColorFromRGB(0xF6F6F6)];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _weightButtonClicked = NO;
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self LayoutCurveView];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_curveWeightView) {
        [_curveWeightView removeFromSuperview];
    }
    if (_curveHeightView) {
        [_curveHeightView removeFromSuperview];
    }
}


#pragma mark - lyoutUI

- (void)LayoutUI{
    CGFloat indexX = SCREEN_WIDTH /2 - BUTTON_WIDTH -10 ,indexY = 10.0 + 64;
    _heightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _heightButton.userInteractionEnabled = YES;
    [_heightButton setTitle:@"身高" forState:UIControlStateNormal];
    
    [_heightButton setBackgroundImage:[[UIImage imageNamed:@"身高体重"] imageWithTintColor:UIColorFromRGB(0x00DCB8)] forState:UIControlStateNormal];
    [_heightButton setTitleColor:UIColorFromRGB(0x00DCB8) forState:UIControlStateNormal];
    
    _heightButton.tag = 100;
    _heightButton.titleLabel.font = [UIFont parentToolTitleViewDetailFontWithSize:22];
    [_heightButton addTarget:self action:@selector(myButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _heightButton.frame = CGRectMake(indexX, indexY, BUTTON_WIDTH, BUTTON_HEIGHT);
    [self.view addSubview:_heightButton];
    
    indexX = SCREEN_WIDTH/2 + 10;
    _weightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_weightButton setBackgroundImage:[[UIImage imageNamed:@"身高体重"] imageWithTintColor:UIColorFromRGBAndAlpha(0xCCCCCC, 0.5)] forState:UIControlStateNormal];
    _weightButton.userInteractionEnabled = YES;
    _weightButton.tag = 200;
    [_weightButton setTitle:@"体重" forState:UIControlStateNormal];
    [_weightButton setTitleColor:UIColorFromRGBAndAlpha(0xCCCCCC, 0.5) forState:UIControlStateNormal];
    _weightButton.titleLabel.font = [UIFont parentToolTitleViewDetailFontWithSize:22];
    [_weightButton addTarget:self action:@selector(myButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _weightButton.frame = CGRectMake(indexX, indexY, BUTTON_WIDTH, BUTTON_HEIGHT);
    [self.view addSubview:_weightButton];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 55 + 64, SCREEN_WIDTH, SCREEN_HEIGHT -55 - 64)];
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT - 55 - 64)];
    _scrollView.bounces = NO;//禁止回弹效果
    [self.view addSubview:_scrollView];
}

- (void)LayoutCurveView{
    _curveHeightView = [[ADHeightCurveView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 3, SCREEN_HEIGHT - 55 -64)
                                                          title:@"身高曲线图 (单位:cm)"
                                                         YArray: @[@110,@100,@90,@80,@70,@60,@50,@40,@30]
                                                         XArray: @[@1,@2,@3,@4,@5,@6,@8,@10,@12,@15,@18,@21,@24,@30,@36]
                                                patterImageName:@"身高两边" isHeight:YES
                                                 userCurveColor:UIColorFromRGB(0x00AC82)];
    _curveHeightView.backgroundColor = UIColorFromRGB(0xB9AAFF);
    [_scrollView addSubview:_curveHeightView];
    [MobClick event:shengaotizhong_shengaoquxian];
}

- (void)myButtonClicked:(UIButton *)button{
    if (button.tag == 200) {
        _curveHeightView.hidden = YES;
        if (!_weightButtonClicked) {
            _curveWeightView = [[ADHeightCurveView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 3, SCREEN_HEIGHT -55 - 64)
                                                                  title:@"体重曲线图(单位:kg)"
                                                                 YArray:@[@25,@20,@15,@10,@5,@0]
                                                                 XArray: @[@1,@2,@3,@4,@5,@6,@8,@10,@12,@15,@18,@21,@24,@30,@36]
                                                        patterImageName:@"体重两边" isHeight:NO
                                                         userCurveColor:UIColorFromRGB(0xB9AAFF)];
            _curveWeightView.backgroundColor = UIColorFromRGB(0x00CBAC);
            [_scrollView addSubview:_curveWeightView];
            _weightButtonClicked = YES;
            [MobClick event:shengaotizhong_tizhongquxian];
        }
        _curveWeightView.hidden = NO;
        
        [_weightButton setBackgroundImage:[[UIImage imageNamed:@"身高体重"] imageWithTintColor:UIColorFromRGB(0x00DCB8)] forState:UIControlStateNormal];
        [_weightButton setTitleColor:UIColorFromRGB(0x00DCB8) forState:UIControlStateNormal];
        
        [_heightButton setTitleColor:UIColorFromRGBAndAlpha(0xCCCCCC, 0.5) forState:UIControlStateNormal];
        [_heightButton setBackgroundImage:[[UIImage imageNamed:@"身高体重"] imageWithTintColor:UIColorFromRGBAndAlpha(0xCCCCCC, 0.5)] forState:UIControlStateNormal];
    }else{
        _curveWeightView.hidden = YES;
        _curveHeightView.hidden = NO;
        
        [_heightButton setBackgroundImage:[[UIImage imageNamed:@"身高体重"] imageWithTintColor:UIColorFromRGB(0x00DCB8)] forState:UIControlStateNormal];
        [_heightButton setTitleColor:UIColorFromRGB(0x00DCB8) forState:UIControlStateNormal];
        [_weightButton setTitleColor:UIColorFromRGBAndAlpha(0xCCCCCC, 0.5) forState:UIControlStateNormal];
        [_weightButton setBackgroundImage:[[UIImage imageNamed:@"身高体重"] imageWithTintColor:UIColorFromRGBAndAlpha(0xCCCCCC, 0.5)] forState:UIControlStateNormal];
        
    }
}

- (void)rightItemMethod:(UIButton *)button{
    [MobClick event:shengaotizhong_tianjia1];
    ADNewHWViewController *vc = [[ADNewHWViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
