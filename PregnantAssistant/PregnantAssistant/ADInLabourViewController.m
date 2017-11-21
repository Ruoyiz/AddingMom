//
//  ADInLabourViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-17.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADInLabourViewController.h"
#import "ADExpectantListViewController.h"
#import "ADLabourThingListViewController.h"

#define LINESPACE 4

@interface ADInLabourViewController ()

@end

static NSString * tip = @"以下根据经验总结汇总的待产清单哦,汇集了多位妈妈的心血~,供准妈妈参考~";
@implementation ADInLabourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTitle = @"待产包";
    
    [self showSyncAlert];

    self.view.backgroundColor = [UIColor whiteColor];

    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    if ([ADHelper isIphone4]) {
        self.myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 56);
    }
    [self.view addSubview:self.myScrollView];
    
    [self addTipLabel];
    
    [self addButtons];
    
    [self addBottomImg];
    
    [ADInLabourDAO updateDataBaseOnfinish:^{}];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ADInLabourDAO readAllData]; // don't del
    [self syncAllDataOnFinish:^(NSError *error) {
    }];
}

- (void)addButtons
{
    _expectantListBtn = [[ADCustomButton alloc]initWithFrame:CGRectMake(12, 16, SCREEN_WIDTH -24, 40)];
    _expectantListBtn.titleStr = @"我的待产清单";
    _expectantListBtn.buttonColor = [UIColor whiteColor];
    _expectantListBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    
    _expectantListBtn.layer.borderColor = UIColorFromRGB(0x06a9a3).CGColor;
    _expectantListBtn.layer.borderWidth = 1.f;
    
    [_expectantListBtn setTitleColor:[UIColor font_btn_color] forState:UIControlStateNormal];
    
    [_expectantListBtn addTarget:self action:@selector(pushExpectantListVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.myScrollView addSubview:_expectantListBtn];
    
    self.buttonName = @[
                        @"住院清单", @"产妇卫生用品",
                        @"产妇护理", @"宝宝日用",
                        @"宝宝洗护", @"宝宝喂养",
                        @"宝宝服饰", @"宝宝护肤",
                        @"宝宝床上用品", @"宝宝出行"
                        ];
    
    for (int i = 0; i < self.buttonName.count; i++) {
        int row = i/2;
        int col = i%2;
        ADCustomButton *aBtn = [[ADCustomButton alloc]initWithFrame:
                                CGRectMake(12 +(SCREEN_WIDTH- 6) /2 *col, 240 /2 + 48*row, (SCREEN_WIDTH -42)/2, 40)];
        aBtn.titleStr = self.buttonName[i];
        aBtn.buttonColor = [UIColor whiteColor];
        aBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [aBtn addTarget:self action:@selector(jumpToNextVC:) forControlEvents:UIControlEventTouchUpInside];
        aBtn.tag = 20 +i;
        
        aBtn.layer.borderColor = UIColorFromRGB(0x06a9a3).CGColor;
        aBtn.layer.borderWidth = 1.f;
        
        [aBtn setTitleColor:[UIColor font_btn_color] forState:UIControlStateNormal];

        [self.myScrollView addSubview:aBtn];
    }
}

- (void)addBottomImg
{
    UIImageView *bottomImgView = nil;
    
    if ([ADHelper isIphone4]) {
        bottomImgView =
        [[UIImageView alloc]initWithFrame:CGRectMake(10, 236/2 +48*5 +16, 300, 247/3)];
    } else {
        bottomImgView =
        [[UIImageView alloc]initWithFrame:CGRectMake(10, 236/2 +48*5 +54, SCREEN_WIDTH -20, (SCREEN_WIDTH -20) *0.274)];
        bottomImgView.center =
        CGPointMake(SCREEN_WIDTH /2.0, SCREEN_HEIGHT - bottomImgView.frame.size.height -44);
    }
    bottomImgView.image = [UIImage imageNamed:@"待产包底部图"];
    [self.myScrollView addSubview:bottomImgView];
}

- (void)addTipLabel
{
    self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 44 +16 +4, SCREEN_WIDTH -24, 50)];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tip];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [tip length])];
    self.tipLabel.attributedText = attributedString;
    
    self.tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.tipLabel.numberOfLines = 2;
    self.tipLabel.font = [UIFont tip_font];
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.textColor = [UIColor font_tip_color];
    
    [self.myScrollView addSubview:self.tipLabel];
}

- (void)pushExpectantListVC:(id)sender
{
    ADExpectantListViewController *aListVC = [[ADExpectantListViewController alloc]init];
    [self.navigationController pushViewController:aListVC animated:YES];
}

- (void)jumpToNextVC:(UIButton *)sender
{
    ADLabourThingListViewController *aThingListVC = [[ADLabourThingListViewController alloc]init];
    aThingListVC.myTitle = sender.titleLabel.text;
    aThingListVC.labourThing = [ADHelper getArrayFromTxt:sender.titleLabel.text];
    
    [self.navigationController pushViewController:aThingListVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - sync method
- (void)syncAllDataOnFinish:(void(^)(NSError *error))finishBlock
{
    [ADInLabourDAO syncAllDataOnGetData:^(NSError *error) {
        
    } onUploadProcess:^(NSError *error) {
        [self rotateSyncBtn];
    } onUpdateFinish:^(NSError *error) {
        if (error != nil) {
            NSLog(@"err:%@", error);
            if (error.code == 100) {
                self.syncBtn.hidden = YES;
            } else {
                [self setNeedUploadBtn];
            }
        } else {
            [self stopRotateSyncBtn];
        }
    }];
}

@end
