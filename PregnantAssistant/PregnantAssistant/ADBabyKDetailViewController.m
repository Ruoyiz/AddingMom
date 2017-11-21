//
//  ADBabyKDetailViewController.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/6/9.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBabyKDetailViewController.h"

#define TOP_LEFT_DISTANCE 20

@interface ADBabyKDetailViewController (){

    UITextView *_textView;
    NSArray *_dataArray;
}

@end

@implementation ADBabyKDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    self.myTitle = _titleString;
    [self layoutUI];
    [self loadData];
}

- (void)layoutUI{
    _textView = [[UITextView alloc] init];
    _textView.frame = CGRectMake(TOP_LEFT_DISTANCE, 64, SCREEN_WIDTH - 2 * TOP_LEFT_DISTANCE, SCREEN_HEIGHT - 64);
    _textView.editable = NO;
    _textView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_textView];
    
}

- (void)loadData{
    _dataArray = [NSArray array];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"WHData" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    _dataArray = dict[@"knowledge"];
    _textView.attributedText = [self getParagraphstyleWithMutableAttributedAndString:_dataArray[_rowIndex]];
}

- (NSMutableAttributedString *)getParagraphstyleWithMutableAttributedAndString:(NSString *)string{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    [str addAttribute:NSFontAttributeName value:[UIFont parentToolTitleViewDetailHeiFontWithSize:16] range:NSMakeRange(0, [string length])];
    return str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
