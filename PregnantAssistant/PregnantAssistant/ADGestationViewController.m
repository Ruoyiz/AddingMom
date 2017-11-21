//
//  ADGestationViewController.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/17.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADGestationViewController.h"
#import "ADGestationTitleView.h"
#import "ADBigBabyTitleView.h"

@interface ADGestationViewController () <weekIndexChanged>{

    NSArray *_babyDataArray;
    NSArray *_momDataArray;
    ADBigBabyTitleView *_bigBabyTitleView;
    UIScrollView *_bgScrollView;
    
    UIView *_lineView1;
    UILabel *_tip2Label;
    UILabel *_babyDescLabel;
    UILabel *_momDescLabel;
    
    NSInteger indexY;
    
}

@end

#define WEEKVIEW_HEIGHT 48
#define BIGBABYTITLEVIEW_HEIGHT 200
#define TIPLABEL_HEIGHT 32
#define LEFT_DISTANCE 20

#define LABELFONT_NUMBER 15

@implementation ADGestationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self layoutUI];
}
#pragma mark - 初始化视图
- (void)layoutUI{
    self.myTitle = @"胎儿发育图";
    self.syncBtn.hidden = YES;
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
    
    ADGestationTitleView *titleView = [[ADGestationTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WEEKVIEW_HEIGHT) withWeekIndex:[self getWeeksIndex]];
    titleView.delegate = self;
    [_bgScrollView addSubview:titleView];
    indexY += WEEKVIEW_HEIGHT;
    _bigBabyTitleView = [[ADBigBabyTitleView alloc] initWithFrame:CGRectMake(0, WEEKVIEW_HEIGHT, SCREEN_WIDTH, BIGBABYTITLEVIEW_HEIGHT) andParentVC:self];
    [_bgScrollView addSubview:_bigBabyTitleView];
    indexY += BIGBABYTITLEVIEW_HEIGHT + 18;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, indexY, SCREEN_WIDTH, 0.4)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.4;
    [_bgScrollView addSubview:lineView];
    
    _lineView1 = [[UIView alloc] init];
    _lineView1.backgroundColor = [UIColor lightGrayColor];
    _lineView1.alpha = 0.4;
    [_bgScrollView addSubview:_lineView1];

    
    indexY += 18;
    UILabel * _tip1Label = [[UILabel alloc]initWithFrame:CGRectMake(0, indexY, SCREEN_WIDTH, TIPLABEL_HEIGHT)];
    _tip1Label.font = [UIFont parentToolTitleViewDetailFontWithSize:18];
    _tip1Label.textColor = UIColorFromRGB(0x4d4587);
    _tip1Label.textAlignment = NSTextAlignmentCenter;
    _tip1Label.text = @"每周宝宝发育";
    [_bgScrollView addSubview:_tip1Label];
    indexY += TIPLABEL_HEIGHT;
    indexY += 10;
    _babyDescLabel = [[UILabel alloc]init];
    _babyDescLabel.numberOfLines = 0;
    [_bgScrollView addSubview:_babyDescLabel];
    
    
    _tip2Label = [[UILabel alloc]init];
    _tip2Label.font = [UIFont parentToolTitleViewDetailFontWithSize:18];
    _tip2Label.textColor = UIColorFromRGB(0x4d4587);
    _tip2Label.textAlignment = NSTextAlignmentCenter;
    _tip2Label.text = @"每周妈妈变化";
    [_bgScrollView addSubview:_tip2Label];
    
    _momDescLabel = [[UILabel alloc]init];
    _momDescLabel.numberOfLines = 0;
    [_bgScrollView addSubview:_momDescLabel];
    [self layoutViewWithweekIndex:[self getWeeksIndex]];
}
#pragma mark - 根据周来调整视图坐标
- (void)layoutViewWithweekIndex:(NSInteger)weekIndex{
    
    NSInteger myindexY = indexY;
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4];
    
    NSLog(@"ix: %ld cnt:%lu", (long)weekIndex, (unsigned long)_babyDataArray.count);
    CGSize babyDesTextSize = [_babyDataArray[weekIndex] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * LEFT_DISTANCE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont parentToolTitleViewDetailHeiFontWithSize:LABELFONT_NUMBER],NSParagraphStyleAttributeName:paragraphStyle1} context:nil].size;
    _babyDescLabel.text = _babyDataArray[weekIndex];
    _babyDescLabel.attributedText = [self getParagraphstyleWithMutableAttributedAndString:_babyDataArray[weekIndex]];
    _babyDescLabel.frame = CGRectMake(LEFT_DISTANCE, myindexY, babyDesTextSize.width, babyDesTextSize.height);
    myindexY += babyDesTextSize.height;
    myindexY += 10;
    _lineView1.frame = CGRectMake(0, myindexY, SCREEN_WIDTH, 0.4);
    myindexY += 10;
    _tip2Label.frame = CGRectMake(0, myindexY, SCREEN_WIDTH, TIPLABEL_HEIGHT);
    myindexY += TIPLABEL_HEIGHT;
    myindexY += 10;
    
    _momDescLabel.text = _momDataArray[weekIndex];
    CGSize momDesTextSize = [_momDataArray[weekIndex] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * LEFT_DISTANCE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont parentToolTitleViewDetailHeiFontWithSize:LABELFONT_NUMBER],NSParagraphStyleAttributeName:paragraphStyle1} context:nil].size;
    _momDescLabel.frame = CGRectMake(LEFT_DISTANCE, myindexY, momDesTextSize.width, momDesTextSize.height);
    _momDescLabel.attributedText = [self getParagraphstyleWithMutableAttributedAndString:_momDataArray[weekIndex]];
    myindexY += momDesTextSize.height;
    myindexY += 84;
    
    _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, myindexY);
}
#pragma mark - 获取数据
- (void)loadData{
    _babyDataArray = [NSArray array];
    _momDataArray = [NSArray array];
    NSString *pathSting = [[NSBundle mainBundle]pathForResource:@"GestationData" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:pathSting];
    _babyDataArray = dict[@"babyData"];
    _momDataArray = dict[@"momData"];
}

#pragma mark - weekChangeDelegate

- (void)weekindexChangedToWeek:(NSInteger)weekindex{
    if (weekindex >= 40) {
        _bigBabyTitleView.babyImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"40-%02d", 40]];
    } else {
        _bigBabyTitleView.babyImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"40-%02ld", (long)weekindex +1]];
    }
    [self layoutViewWithweekIndex:weekindex];
}


- (NSInteger)getWeeksIndex{
    ADAppDelegate *appDelegate = APP_DELEGATE;
    NSTimeInterval time=[appDelegate.dueDate timeIntervalSinceDate:[NSDate date]];
    int days=((int)time)/(3600*24);
    if (days<0) {
        days = 0;
    }
    int passDay = 280 -days -1;
    int week = passDay /7;
    NSLog(@"week == %d",week);
    return week;
}

- (NSMutableAttributedString *)getParagraphstyleWithMutableAttributedAndString:(NSString *)string{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    [str addAttributes:@{NSFontAttributeName:[UIFont parentToolTitleViewDetailHeiFontWithSize:LABELFONT_NUMBER],NSForegroundColorAttributeName:UIColorFromRGB(0x4d4587)} range:NSMakeRange(0, [string length])];
    return str;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
