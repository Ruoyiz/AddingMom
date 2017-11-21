//
//  ADStatementViewController.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/8.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADStatementViewController.h"
#import "ADGetTextSize.h"
#import "ADLable.h"
#import "UIFont+ADFont.h"
#import "ADAdWebVC.h"
@interface ADStatementViewController (){
    CGFloat _indexY;
}
@end

@implementation ADStatementViewController{
    UIScrollView *_backScrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myTitle = @"关于加丁妈妈";
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    [self createSubviews];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
#define TOP_DISTANCE (38 + 64)
#define CENTER_VIEW_HEIGHT 44
- (void)createSubviews
{
    _indexY = TOP_DISTANCE;
    CGFloat imageWidth = 90 * SCREEN_WIDTH/320.0;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _indexY, imageWidth, imageWidth)];
    iconImageView.center = CGPointMake(SCREEN_WIDTH/2.0, _indexY + imageWidth/2.0);
    iconImageView.image = [UIImage imageNamed:@"loginLogo"];
//    iconImageView.contentMode = UIViewContentModeCenter;
    iconImageView.layer.cornerRadius = imageWidth/6.0;
    iconImageView.layer.masksToBounds = YES;
    [self.view addSubview:iconImageView];
    _indexY += imageWidth;
    _indexY += 38;
    
    ADLable *desLabel = [[ADLable alloc] initWithFrame:CGRectMake(0, _indexY, SCREEN_WIDTH, 60) titleText:@"加丁妈妈\n妈妈每天的精神食粮" textColor:UIColorFromRGB(0x333333) textFont:[UIFont ADTraditionalFontWithSize:14] lineSpace:14];
    desLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:desLabel];
    _indexY += 60;
    _indexY += 58;
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, _indexY, SCREEN_WIDTH, CENTER_VIEW_HEIGHT)];
    [self.view addSubview:centerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(tap)];
    
    [centerView addGestureRecognizer:tap];
    
    UIView *lineVIew1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineVIew1.backgroundColor = [UIColor separator_line_color];
    [centerView addSubview:lineVIew1];
    UIView *lineVIew2 = [[UIView alloc] initWithFrame:CGRectMake(0, CENTER_VIEW_HEIGHT - 0.5, SCREEN_WIDTH, 0.5)];
    lineVIew2.backgroundColor = [UIColor separator_line_color];
    [centerView addSubview:lineVIew2];

    ADLable *leftLabel = [[ADLable alloc] initWithFrame:CGRectMake(14, CENTER_VIEW_HEIGHT/2.0 - 7, 100, 38) titleText:@"加丁妈妈声明" textColor:UIColorFromRGB(0x333333) textFont:[UIFont ADTraditionalFontWithSize:14] lineSpace:0];
    [centerView addSubview:leftLabel];
    
    UIImageView *rowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 14 - 4, CENTER_VIEW_HEIGHT/2 - 5.5, 4, 11)];
    rowImageView.image = [UIImage imageNamed:@"gogrey"];
    [centerView addSubview:rowImageView];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version =[infoDictionary objectForKey:@"CFBundleShortVersionString"];
    ADLable *versionLabel = [[ADLable alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT  - 50, SCREEN_WIDTH, 38) titleText:[NSString stringWithFormat:@"Version %@",version] textColor:UIColorFromRGB(0x333333) textFont:[UIFont ADTraditionalFontWithSize:9] lineSpace:0];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    
}
- (void)tap{
    ADAdWebVC *avc = [[ADAdWebVC alloc] init];
    avc.webTitle = @"加丁妈妈声明";
    avc.adUrl= @"http://www.addinghome.com/pa/statement";
    [self.navigationController pushViewController:avc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
