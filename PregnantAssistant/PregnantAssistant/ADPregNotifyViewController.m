//
//  ADPregNotifyViewController.m
//  PregnantAssistant
//
//  Created by D on 15/3/26.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADPregNotifyViewController.h"
#import "NSDate+Utilities.h"
#import "UIImage+Tint.h"

static NSString * tip1 = @"每日宝宝发育";
static NSString * tip2 = @"每日妈妈变化";
@interface ADPregNotifyViewController ()

@end

@implementation ADPregNotifyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(configureViews)
                                                 name:NOTIFICATION_DAY_CHANGED
                                               object:nil];
    self.navigationController.navigationItem.titleView = nil;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if (self.disMissNavBlock) {
        self.disMissNavBlock();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTitle = @"加丁妈妈·孕期提醒";
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    [self readDay];
    
    self.scorllBg = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.scorllBg];
    [self addCalView];
    [self addBabyView];
    [self addDataView];
    
    [MobClick event:duedate_notice_display];
}

- (void)readDay
{
    NSDate *newDate = [self.appDelegate.dueDate dateByAddingTimeInterval:60*60*24*1];
    NSTimeInterval time=[newDate timeIntervalSinceDate:[NSDate date]];
    int days=((int)time)/(3600*24);
    if (days < 0) {
        days = 0;
    }
    _passDay = 280 -days;
    
    _week = _passDay /7;
    _dueday = _passDay %7;
    
    NSDictionary *dictionary =
    [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BabyData" ofType:@"plist"]];
    NSArray *heightArray = dictionary[@"height"];
    NSArray *weightArray = dictionary[@"weight"];
    NSArray *descArray   = dictionary[@"desc"];
    
    self.babyData = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < heightArray.count; i++) {
        NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithCapacity:0];
        [tmpArray addObject:heightArray[i]];
        [tmpArray addObject:weightArray[i]];
        [tmpArray addObject:descArray[i]];
        [self.babyData addObject:tmpArray];
    }
}

- (void)addCalView
{
    _aCalendarView = [[ADCalendarView alloc]initWithFrame:CGRectMake(0, 3, SCREEN_WIDTH, 48) withIsCntView:NO];
    
    [self.scorllBg addSubview:_aCalendarView];
}

- (void)addBabyView
{
    _aBigTitleView =
    [[ADBigBabyTitleView alloc] initWithFrame:CGRectMake(0, _aCalendarView.frame.size.height, SCREEN_WIDTH, 200)
                                  andParentVC:self];
    [self.scorllBg addSubview:_aBigTitleView];
}

- (void)addDataView
{
    CGFloat startY = _aBigTitleView.frame.origin.y + _aBigTitleView.frame.size.height + 12;
    
    _dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, startY, SCREEN_WIDTH -20, 34)];
    _dayLabel.textColor = UIColorFromRGB(0x00DBB8);
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    [self.scorllBg addSubview:_dayLabel];
    
    startY += 34 + 20;

    _descLabel =
    [[UILabel alloc]initWithFrame:CGRectMake(0, startY,
                                             SCREEN_WIDTH, 32)];
    _descLabel.textColor = [UIColor title_darkblue];
    _descLabel.font = [UIFont systemFontOfSize:15];
    _descLabel.textAlignment = NSTextAlignmentCenter;
    _descLabel.text = @"";
    [self.scorllBg addSubview:_descLabel];
    
    UIImageView *weiBg = [[UIImageView alloc]initWithFrame:CGRectMake(22, 0, SCREEN_WIDTH -44, 29)];
    weiBg.center = _descLabel.center;
    weiBg.image = [UIImage imageNamed:@"frame"];
    [self.scorllBg addSubview:weiBg];
    
    startY += 32 + 8;
    _babyLengthLabel = [_descLabel clone];
    _babyLengthLabel.frame = CGRectMake(66, startY, 100, 32);
    [self.scorllBg addSubview:_babyLengthLabel];
    
    _babyWeightLabel = [_descLabel clone];
    _babyWeightLabel.frame = CGRectMake(SCREEN_WIDTH -126, startY, 88, 32);
    [self.scorllBg addSubview:_babyWeightLabel];
    
    UIImageView *lengthView = [[UIImageView alloc]initWithFrame: CGRectMake(48, 0, 20, 20)];
    lengthView.image = [[UIImage imageNamed:@"length"] imageWithTintColor:[UIColor title_darkblue]];
    lengthView.center = CGPointMake(lengthView.center.x, _babyLengthLabel.center.y);
    [self.scorllBg addSubview:lengthView];
    
    UIImageView *weightView = [[UIImageView alloc]initWithFrame: CGRectMake(SCREEN_WIDTH -146, 0, 20, 20)];
    weightView.image = [[UIImage imageNamed:@"weight"] imageWithTintColor:[UIColor title_darkblue]];
    weightView.center = CGPointMake(weightView.center.x, _babyLengthLabel.center.y +1);
    [self.scorllBg addSubview:weightView];

    UIImageView *detailBg = [[UIImageView alloc]initWithFrame:CGRectMake(22, 0, SCREEN_WIDTH -44, 29)];
    detailBg.center = CGPointMake(detailBg.center.x, _babyLengthLabel.center.y);
    detailBg.image = [UIImage imageNamed:@"frame"];
    [self.scorllBg addSubview:detailBg];
    
    
    //此处加载妈妈和宝贝每日变化
    startY = detailBg.frame.origin.y + detailBg.frame.size.height + 30;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, startY, SCREEN_WIDTH, 0.4)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.4;
    [self.scorllBg addSubview:lineView];
    
    startY += 18;
    
    _tip1Label = [[UILabel alloc]initWithFrame:CGRectMake(0, startY, SCREEN_WIDTH, 32)];
    _tip1Label.font = [UIFont systemFontOfSize:18];
    _tip1Label.textColor = UIColorFromRGB(0x3A3447);
    _tip1Label.textAlignment = NSTextAlignmentCenter;
    _tip1Label.text = tip1;
    [self.scorllBg addSubview:_tip1Label];
    
    
    
    _babyDataDict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:
                                                             [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]]
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    //baby desc
    _babyDescLabel = [[UILabel alloc]init];
    _babyDescLabel.font = [UIFont systemFontOfSize:14];
    _babyDescLabel.textColor = UIColorFromRGB(0x575262);
    _babyDescLabel.numberOfLines = 30;
    _babyDescLabel.text = @"";
    [self.scorllBg addSubview:_babyDescLabel];
    
    _tip2Label = [_tip1Label clone];
    _tip2Label.text = tip2;
    [self.scorllBg addSubview:_tip2Label];
    
    //mom desc
    _momDescLabel = [_babyDescLabel clone];
    [self.scorllBg addSubview:_momDescLabel];
    
    [self updateLabelWithDay:_passDay];
}

- (void)updateLabelWithDay:(NSInteger)aDay
{
    NSInteger safeDay = aDay > 280? 280 : aDay;
    if (safeDay < 0) {
        safeDay = 0;
    }
    
//    ADAppDelegate *appDelegate = APP_DELEGATE;
//    
//    NSTimeInterval time=[appDelegate.dueDate timeIntervalSinceDate:[NSDate date]];
//    int days=((int)time)/(3600*24);
    
    //int passDays = 280 -safeDay -1;
//    
//    int weeks = passDays /7;
//    int duedays = passDays %7;
    
    long leftDays =280-safeDay;
    if (leftDays < 0) {
        leftDays = 0;
    }
    NSString *weekStr = [NSString stringWithFormat:@"%ld",(long)safeDay /7];
    NSString *dayStr = [NSString stringWithFormat:@"%ld",(long)safeDay %7];
    NSString *leftDayStr = [NSString stringWithFormat:@"%ld",(long)leftDays];
    
    _dayLabel.attributedText = [self getAttributedDateWithWeek:weekStr day:dayStr surplusDay:leftDayStr];//[self getAttributedDay:[NSString stringWithFormat:@"%ld 天", 280 - (long)aDay]];
    
    NSInteger week = aDay /7;
    if (week >= 40) {
        _aBigTitleView.babyImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"40-%02d", 40]];
    } else {
        _aBigTitleView.babyImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"40-%02ld", (long)week +1]];
    }

    if (safeDay < 1) {
        safeDay = 1;
    }
    NSString *babyTip = _babyDataDict[@"babyDatas"][safeDay -1];
    
    CGRect textRect = [babyTip boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -44, 1000)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                            context:nil];
    
    _babyDescLabel.frame = CGRectMake(22, _tip1Label.frame.origin.y +_tip1Label.frame.size.height +8,
                                      SCREEN_WIDTH -44, textRect.size.height);
    _babyDescLabel.text = babyTip;
    
    _tip2Label.frame =
    CGRectMake(16, _babyDescLabel.frame.origin.y + _babyDescLabel.frame.size.height +10, SCREEN_WIDTH -32, 32);

    NSString *momTip = _babyDataDict[@"momDatas"][safeDay -1];
    CGRect textRect2 = [momTip boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -44, 1000)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                            context:nil];
    _momDescLabel.text = momTip;
    _momDescLabel.frame = CGRectMake(22, _tip2Label.frame.origin.y +_tip2Label.frame.size.height +8,
                                     SCREEN_WIDTH -44, textRect2.size.height);

    if(aDay <= 280 && aDay > 0) {
        _descLabel.text = self.babyData[aDay -1][2];
        
        _babyLengthLabel.text = [NSString stringWithFormat:@"身长 %@cm",self.babyData[aDay -1][0]];
        _babyWeightLabel.text = [NSString stringWithFormat:@"体重 %@g",self.babyData[aDay -1][1]];
        
    } else if(_passDay > 280) {
        _descLabel.text = self.babyData[self.babyData.count -1][2];

        _babyLengthLabel.text = [NSString stringWithFormat:@"身长 %@cm",self.babyData[self.babyData.count -1][0]];
        _babyWeightLabel.text = [NSString stringWithFormat:@"体重 %@g",self.babyData[self.babyData.count -1][1]];
    }
    self.scorllBg.contentSize = CGSizeMake(SCREEN_WIDTH, _momDescLabel.frame.origin.y +_momDescLabel.frame.size.height +22);
}

//- (NSMutableAttributedString *)getAttributedDay:(NSString *)aString
//{
//    NSMutableAttributedString *aAttributedString = [[NSMutableAttributedString alloc] initWithString:aString
//                                                                                          attributes:
//                                                    @{NSFontAttributeName:[UIFont systemFontOfSize:48]}];
//    
//    [aAttributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
//                               range:NSMakeRange(aString.length -2,2)];
//    
//    return aAttributedString;
//}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (NSMutableAttributedString *)getAttributedDateWithWeek:(NSString *)week day:(NSString *)day surplusDay:(NSString *)surplusDay
{
    NSString *dateString  = [NSString stringWithFormat:@"%@ 周 %@ 天  剩 %@ 天",week,day,surplusDay];
    if (dateString == nil) {
        dateString = @"0 周 0 天  剩 0 天";
    }
    
    NSMutableAttributedString *aAttributedString = [[NSMutableAttributedString alloc] initWithString:dateString];
    NSString *temp = nil;
    NSDictionary *bigFont = @{NSFontAttributeName:[UIFont systemFontOfSize:45]};
    NSDictionary *smallFont = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    
    for(int i =0; i < [dateString length]; i++)
    {
        temp = [dateString substringWithRange:NSMakeRange(i, 1)];
        if ([self isPureInt:temp]) {
            NSLog(@"第%d个字是:%@",i,temp);
            [aAttributedString setAttributes:bigFont range:NSMakeRange(i, 1)];
        }else{
            if(temp.length != 0){
                [aAttributedString setAttributes:smallFont range:NSMakeRange(i, 1)];
            }
        }
    }
    return aAttributedString;
}

- (void)configureViews
{
    NSDate *newDate = [self.appDelegate.dueDate dateByAddingTimeInterval:60*60*24*1];
    NSInteger betweenDay =
    [self.appDelegate.displayDate daysBeforeDate:newDate];
    
    //NSLog(@"dis: %@ due: %@", self.appDelegate.displayDate, newDate);
    
    if (280 -betweenDay >= 0 && 280 -betweenDay <= 280) {
        [self updateLabelWithDay:280 -betweenDay];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
