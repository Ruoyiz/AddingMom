//
//  ADParentsNotifViewController.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/5/11.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADParentsNotifViewController.h"
#import "ADCalendarView.h"
#import "UIFont+ADFont.h"
#import "UIImage+Tint.h"
#import "ADBabyBirthdayCalendar.h"

#define ORIGINAL_X 61
#define YEARS_LABEL_HEIGHT 40
#define BETWEEN_LABEL 20
#define BETWEEN_BOTTOM_LABEL 24
#define BETWEEN_BOTTOM_VASIONLABEL 6
#define VASIONLABEL_LEFT 18
#define BOTTOM_TITLELABE_HEIGHT 20
#define BOTOOM_BETWEEN_HEIGHT 17

@interface ADParentsNotifViewController (){

    ADCalendarView *_aCalendarView;
    UIScrollView *_bgScrollView;
    NSDictionary *_dataDict;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSArray *_botoomTextdataArray;
    
    UILabel *_yearLabel;
    UILabel *_mouthLable;
    UILabel *_dayLable;
    UILabel *_lengthLabel;
    UILabel *_weightLabel;
    
    UILabel *_vasionLabel;
    UILabel *_vasionContentLabel;
    UIImageView *_detailBg;
    
    NSInteger _indexY;
    NSInteger _calendarY;
    NSInteger _bottomY;
    NSString *babySex;
    
}

@end

@implementation ADParentsNotifViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetViews)
                                                 name:NOTIFICATION_DAY_CHANGED
                                               object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTitle = @"加丁妈妈·发育提醒";
    //self.automaticallyAdjustsScrollViewInsets = NO;
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    [self loadData];
    [self layoutUI];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_DAY_CHANGED object:nil];
}
#pragma mark - UI操作


- (void)resetViews{
    
    [self updateCalentLabelWithDate:self.appDelegate.displayDate];
    
    [self updateVasionLabelwithDate:[self.appDelegate.displayDate dateByAddingDays:1] andIndexY:_calendarY];
    [self updateWeightAndHeightLabelWithDate:[self.appDelegate.displayDate dateByAddingDays:1]];
    [self upDateBottomLabelTextWithDate:[self.appDelegate.displayDate dateByAddingDays:1]];
}

- (void)updateWeightAndHeightLabelWithDate:(NSDate *)date{

    NSInteger index = [self getWeekIndexWithDate:date];
    _lengthLabel.text = [NSString stringWithFormat:@"%@cm",_dataDict[@"height"][babySex][index]];
    _weightLabel.text = [NSString stringWithFormat:@"%@kg",_dataDict[@"weight"][babySex][index]];
    
}

- (void)upDateBottomLabelTextWithDate:(NSDate *)date{
    for (int i =0; i < 3; i ++) {
        UILabel *label = (UILabel *)[_bgScrollView viewWithTag:1000 +i];
        [label removeFromSuperview];
        UILabel *label2 = (UILabel *)[_bgScrollView viewWithTag:10000 + i];
        [label2 removeFromSuperview];
        UIImageView *image = (UIImageView *)[_bgScrollView viewWithTag:100000 + i];
        [image removeFromSuperview];
    }
    [self addBottomViewWithDate:date andIndex:_bottomY];
}

- (void)layoutUI{

    [self addBgScrollView];
    [self addCalView];//日期
    [self addOldLabel];//年龄
    [self addBottomViewWithDate:[NSDate dateWithDaysFromNow:1] andIndex:_indexY];//底部视图
    
}

- (void)addBgScrollView{
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
}

- (void)addCalView
{
    _aCalendarView = [[ADCalendarView alloc]initWithFrame:CGRectMake(0, 3, SCREEN_WIDTH, 48)
                                            withIsCntView:NO];
    _aCalendarView.dayLabel.font = [UIFont parentToolTitleViewDetailFontWithSize:17.0];
    _aCalendarView.isParentingCalendar = YES;
    [_bgScrollView addSubview:_aCalendarView];
    _indexY += 51;
    
}

- (void)addOldLabel{

    _indexY += BETWEEN_LABEL;//12 是日期label与年龄的间距
    float width = 100;
    ADAppDelegate *myApp = APP_DELEGATE;
    babySex = @"boy";
    if (myApp.babySex == ADBabySexBoy) {
        babySex = @"boy";
    }else if(myApp.babySex == ADBabySexGirl){
            babySex = @"girl";
    }
    _mouthLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - width + BETWEEN_LABEL/2, _indexY, width, YEARS_LABEL_HEIGHT)];
    _mouthLable.textAlignment = NSTextAlignmentCenter;
    [_bgScrollView addSubview:_mouthLable];

    _dayLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - BETWEEN_LABEL/2 , _indexY, width, YEARS_LABEL_HEIGHT)];
    _dayLable.textAlignment = NSTextAlignmentCenter;
    [_bgScrollView addSubview:_dayLable];
    [self updateCalentLabelWithDate:[NSDate date]];
    
    _vasionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _indexY, SCREEN_WIDTH, 30)];
    _vasionLabel.textColor = UIColorFromRGB(0x4d4586);
    _vasionLabel.textAlignment = NSTextAlignmentCenter;
    _vasionLabel.font = [UIFont parentToolTitleViewDetailFontWithSize:18];
    [_bgScrollView addSubview:_vasionLabel];
    _indexY += 30;
    _indexY += BETWEEN_BOTTOM_VASIONLABEL;
    _calendarY = _indexY;
    [self updateVasionLabelwithDate:[NSDate dateWithDaysFromNow:1] andIndexY:_indexY];
    
}

- (void)updateVasionLabelwithDate:(NSDate *)date andIndexY:(NSInteger)indexY{

    UILabel *label = (UILabel *)[_bgScrollView viewWithTag:102];
    [label removeFromSuperview];

    UIImageView *imageview = (UIImageView *)[_bgScrollView viewWithTag:1002];
    [imageview removeFromSuperview];

    
    NSInteger weekIndex =[self getWeekIndexWithDate:date];
    
    NSString *vasionContectText =  _dataDict[@"vasion"][@"vasionDes"][weekIndex];
    _vasionLabel.text = _dataDict[@"vasion"][@"vasionDate"][weekIndex];
    _vasionContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(VASIONLABEL_LEFT, indexY, SCREEN_WIDTH - 2*VASIONLABEL_LEFT, 30)];
    _vasionContentLabel.numberOfLines = 0;
    _vasionContentLabel.tag = 102;
    _vasionContentLabel.text = vasionContectText;
    _vasionContentLabel.textColor = UIColorFromRGB(0x352f44);
    _vasionContentLabel.font = [UIFont parentToolTitleViewDetailHeiFontWithSize:14];
    NSMutableAttributedString *Str = [self getParagraphstyleWithMutableAttributedAndString:vasionContectText];
    _vasionContentLabel.attributedText = Str;
    CGSize vasionContectLabelsize = [vasionContectText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*VASIONLABEL_LEFT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    _vasionContentLabel.frame = CGRectMake(VASIONLABEL_LEFT, indexY, vasionContectLabelsize.width, vasionContectLabelsize.height);
    [_vasionContentLabel sizeToFit];
    [_bgScrollView addSubview:_vasionContentLabel];
    indexY += vasionContectLabelsize.height;
    indexY += BETWEEN_BOTTOM_LABEL;
    
    _detailBg = [[UIImageView alloc]initWithFrame:CGRectMake(VASIONLABEL_LEFT, indexY, SCREEN_WIDTH -VASIONLABEL_LEFT*2, 28)];
    _detailBg.image = [UIImage imageNamed:@"framePurpe"];
    _detailBg.tag = 1002;
    [_bgScrollView addSubview:_detailBg];
    
    UIImageView *lengthView = [[UIImageView alloc]initWithFrame: CGRectMake(36, 4, 20, 20)];
    lengthView.image = [[UIImage imageNamed:@"length"] imageWithTintColor: UIColorFromRGB(0x352f44)];
    [_detailBg addSubview:lengthView];
    
    _lengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 4,  80, 20)];
    _lengthLabel.textAlignment = NSTextAlignmentLeft;
    _lengthLabel.font = [UIFont parentToolTitleViewDetailFontWithSize:14.0];
    _lengthLabel.textColor = UIColorFromRGB(0x352f44);
    _lengthLabel.text = [NSString stringWithFormat:@"%@cm",_dataDict[@"height"][babySex][weekIndex]];
    
    [_detailBg addSubview:_lengthLabel];
    NSInteger detailBgWidth = _detailBg.frame.size.width;
    UIImageView *weightView = [[UIImageView alloc]initWithFrame: CGRectMake(detailBgWidth - 36 - 80 -9, 4, 20, 20)];
    weightView.image = [[UIImage imageNamed:@"weight"] imageWithTintColor: UIColorFromRGB(0x352f44)];
    [_detailBg addSubview:weightView];
    
    _weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(detailBgWidth - 36 -80, 4,  80, 20)];
    _weightLabel.textAlignment = NSTextAlignmentRight;
    _weightLabel.font = [UIFont parentToolTitleViewDetailFontWithSize:14.0];
    _weightLabel.textColor = UIColorFromRGB(0x352f44);
    _weightLabel.text = [NSString stringWithFormat:@"%@kg",_dataDict[@"weight"][babySex][weekIndex]];
    [_detailBg addSubview:_weightLabel];
    
    indexY += 28;
    indexY += BETWEEN_BOTTOM_LABEL;
    _indexY = indexY;
    _bottomY = indexY;

    
}

- (void)updateCalentLabelWithDate:(NSDate *)date{

    ADAppDelegate *myapp = APP_DELEGATE;
    ADBabyBirthdayCalendar *calendar = [[ADBabyBirthdayCalendar alloc] initWithBirthdayDate:myapp.babyBirthday endDaysDate:date];
    NSInteger month = calendar.month;
    NSInteger day = calendar.days;
    
    
    NSMutableAttributedString *Str = [self getMutableAttributedStringWithString:[NSString stringWithFormat:@"%ld个月",(long)month]];
    _mouthLable.attributedText = Str;
    
    Str = [self getMutableAttributedStringWithString1:[NSString stringWithFormat:@"%ld天",(long)day]];
    _dayLable.attributedText = Str;
    
    float width = 100;

    if (!month) {
        _mouthLable.hidden = YES;
        _dayLable.hidden = NO;
        _dayLable.frame = CGRectMake(SCREEN_WIDTH/2 - 100, 71, 200, YEARS_LABEL_HEIGHT);
        _dayLable.textAlignment = NSTextAlignmentCenter;
    }
    if (!day) {
        _dayLable.hidden = YES;
        _mouthLable.hidden = NO;
        _mouthLable.frame = CGRectMake(SCREEN_WIDTH/2 - 100, 71, 200, YEARS_LABEL_HEIGHT);
        _mouthLable.textAlignment = NSTextAlignmentCenter;
    }
    if (month && day) {
        _dayLable.hidden = NO;
        _mouthLable.hidden = NO;
        _mouthLable.frame = CGRectMake(SCREEN_WIDTH/2 - width + BETWEEN_LABEL/2, 71, width, YEARS_LABEL_HEIGHT);
        _mouthLable.textAlignment = NSTextAlignmentCenter;
        _dayLable.frame = CGRectMake(SCREEN_WIDTH/2 - BETWEEN_LABEL/2 , 71, width, YEARS_LABEL_HEIGHT);
        _dayLable.textAlignment = NSTextAlignmentCenter;
    }
    
    _indexY += YEARS_LABEL_HEIGHT;
    _indexY += BETWEEN_BOTTOM_LABEL;
}

- (NSDate *)getPriousDateFromDate:(NSDate *)date withDay:(int)weekIndex
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:weekIndex];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

- (void)addBottomViewWithDate:(NSDate *)date andIndex:(NSInteger)indexY{

    NSArray *titleArray = @[@"本周宝宝发育",@"本周营养贴士",@"本周护理要点"];
    NSArray *titleDataArray = @[@"development", @"nutrition", @"nursing"];
    for (int i =0; i < 3; i++) {
        UIImageView *image = [self getLineImageWithFrame:CGRectMake(0, indexY, SCREEN_WIDTH, 1)];
        image.tag = 100000 + i;
        [_bgScrollView addSubview:image];
        indexY += BOTOOM_BETWEEN_HEIGHT + 1;
        UILabel *titleLabel = [self getTitleLabel:CGRectMake((SCREEN_WIDTH-200)/2, indexY, 200, BOTTOM_TITLELABE_HEIGHT) withTextString:titleArray[i]];
        titleLabel.tag = 1000+i;
        [_bgScrollView addSubview:titleLabel];
        indexY += BOTTOM_TITLELABE_HEIGHT;
        indexY += 6;
        NSString *titledataString = titleDataArray[i];
        _botoomTextdataArray = _dataDict[titledataString];
        UILabel * _bottomTextLabel = [self getHeightLabel:CGRectMake(VASIONLABEL_LEFT, indexY, SCREEN_WIDTH - 2*VASIONLABEL_LEFT, 30) WithTextString:_botoomTextdataArray[[self getWeekIndexWithDate:date]]];
        _bottomTextLabel.tag = 10000 + i;
        [_bgScrollView addSubview:_bottomTextLabel];
        indexY += _bottomTextLabel.frame.size.height;
        indexY += BOTOOM_BETWEEN_HEIGHT;
    }
    _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, indexY +20);
}



#pragma mark - 数据加载
- (void)loadData{
    
    _dataArray = [NSMutableArray array];
    NSString *pathString = [[NSBundle mainBundle]pathForResource:@"ParentToolData" ofType:@"plist"];
    _dataDict = [NSDictionary dictionaryWithContentsOfFile:pathString];
    
}

- (NSInteger)getDaysWithDate:(NSDate *)date{
    ADAppDelegate *myapp = APP_DELEGATE;
    NSTimeInterval time = [[date dateByAddingDays:-1] timeIntervalSinceDate:myapp.babyBirthday];
    return ((int)time)/(3600*24);
}

- (NSInteger)getWeekIndexWithDate:(NSDate *)date{
    
    NSInteger days = [self getDaysWithDate:date];
    return days > 0?days/7:0;
}

- (NSMutableAttributedString *)getParagraphstyleWithMutableAttributedAndString:(NSString *)string{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    return str;
    
}

- (UILabel *)getHeightLabel:(CGRect)frame WithTextString:(NSString *)textString{
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.text = textString;
    label.textColor = UIColorFromRGB(0x352f44);
    label.font = [UIFont parentToolTitleViewDetailHeiFontWithSize:14];
    NSMutableAttributedString *Str = [self getParagraphstyleWithMutableAttributedAndString:textString];
    label.attributedText = Str;
    CGSize vasionContectLabelsize = [textString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2*VASIONLABEL_LEFT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    label.frame = CGRectMake(frame.origin.x, frame.origin.y, vasionContectLabelsize.width, vasionContectLabelsize.height);
    [label sizeToFit];
    return label;
}

- (UILabel *)getTitleLabel:(CGRect)frame withTextString:(NSString *)textString{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = textString;
    label.font = [UIFont parentToolTitleViewDetailFontWithSize:18.0];
    label.textColor = UIColorFromRGB(0x4d4586);
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UIImageView *)getLineImageWithFrame:(CGRect)frame{

    UIImageView *image = [[UIImageView alloc] init];
    image.frame = frame;
    image.backgroundColor = UIColorFromRGB(0xf1ebe3);
    return image;
}

- (NSMutableAttributedString *)getMutableAttributedStringWithString:(NSString *)string{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger strLenth = string.length;
    [str addAttribute:NSFontAttributeName value:[UIFont parentToolTitleViewDetailHeiFontWithSize:45] range:NSMakeRange(0, strLenth - 2)];
    [str addAttribute:NSFontAttributeName value:[UIFont parentToolTitleViewDetailHeiFontWithSize:15] range:NSMakeRange(strLenth - 2, 2)];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x00dbb8) range:NSMakeRange(0, strLenth)];
    return str;
}

- (NSMutableAttributedString *)getMutableAttributedStringWithString1:(NSString *)string{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger strLenth = string.length;
    [str addAttribute:NSFontAttributeName value:[UIFont parentToolTitleViewDetailHeiFontWithSize:45] range:NSMakeRange(0, strLenth - 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont parentToolTitleViewDetailHeiFontWithSize:15] range:NSMakeRange(strLenth - 1, 1)];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x00dbb8) range:NSMakeRange(0, strLenth)];
    return str;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
