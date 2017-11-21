//
//  ADKnowledeViewController.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADKnowledeViewController.h"
#import "SHLUILabel.h"

@interface ADKnowledeViewController ()

@end

@implementation ADKnowledeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:yimiaotixing_zhishitixing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    self.myTitle = @"疫苗知识";
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"宝宝疫苗知识提醒";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor darkGrayColor];
    [scrollView addSubview:titleLabel];
    
    NSString*filePath=[[NSBundle mainBundle] pathForResource:@"vaccineKnowledge"ofType:@"txt"];
    NSString *text = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    SHLUILabel *contentLab = [[SHLUILabel alloc] init];
    contentLab.backgroundColor = [UIColor whiteColor];
    contentLab.characterSpacing = 1;
    contentLab.linesSpacing = 5;
    contentLab.paragraphSpacing = 0;
    contentLab.font = [UIFont systemFontOfSize:15];
    contentLab.text = text;
    contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    contentLab.numberOfLines = 0;
    contentLab.textColor = [UIColor darkGrayColor];
    CGFloat labelHeight = [contentLab getAttributedStringHeightWidthValue:SCREEN_WIDTH - 30];
    contentLab.frame = CGRectMake(15, 40, SCREEN_WIDTH - 30, labelHeight);
    
    [scrollView addSubview:contentLab];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, labelHeight + 65);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
