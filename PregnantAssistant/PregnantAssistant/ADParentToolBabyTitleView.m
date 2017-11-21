//
//  ADParentToolBabyTitleView.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/5/8.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADParentToolBabyTitleView.h"
#import "NSDate+Utilities.h"
#import "ADBabyBirthdayCalendar.h"

#define viewLeftDistance 22
#define viewTopDistance 34
#define oldLableTextFont 18
#define betweenImageLabel 6
#define betweenLabelImage 16
#define vasionLabelTextFont 14

#define labelWidth 88

@interface ADParentToolBabyTitleView (){
    
    UIImageView *_bgImageView;//背景图片（未定）
    
    UILabel *_heightLable;
    UILabel *_weightLable;
    UILabel *_vasionLable;
    
    UIImageView *_heightLeftImage;
    UIImageView *_weightLeftImage;
    UIImageView *_vasionLeftImage;
    UIImageView *_rowImageView;
    
    NSMutableArray *_babyData;
    
    float labelHeight;
    float originalY;
    NSString *babySex;
    
    UILabel *_yearLabel;
    UILabel *_monthLabel;
    UILabel *_dayLabel;
}

@end

@implementation ADParentToolBabyTitleView

- (id)initWithFrame:(CGRect)frame andParentVC:(UIViewController *)aVc {
    
    if (self = [super initWithFrame:frame]) {
        
        [self layoutSubviewsWithframe:frame];
        
    }
    
    return self;
}


- (void)setRefeshData:(NSMutableDictionary *)dictionary{
    
    //CGRect selfFrame = self.frame;
    
    
    ADAppDelegate *myApp = APP_DELEGATE;
    babySex = @"boy";
    if (myApp.babySex == ADBabySexBoy) {
        babySex = @"boy";
    }else if(myApp.babySex == ADBabySexGirl){
        babySex = @"girl";
    }
    NSArray *heightArray = dictionary[@"height"][babySex];
    NSArray *weightArray = dictionary[@"weight"][babySex];
    NSArray *bigHeightArray = dictionary[@"bigHeight"][babySex];
    NSArray *bigWeightArray = dictionary[@"bigWeight"][babySex];
    
    NSArray *vasionArray   = dictionary[@"vasion"][@"vasionDate"];
    
    ADAppDelegate *myAPP = APP_DELEGATE;
    NSInteger years,month,day;
    ADBabyBirthdayCalendar *babyBirCal = [[ADBabyBirthdayCalendar alloc] initWithBirthdayDate:myAPP.babyBirthday endDaysDate:[NSDate date]];
    years = babyBirCal.years;
    month = babyBirCal.month;
    day = babyBirCal.days;
    _oldLable.text = [self getTextWithYears:years month:month day:day];
    
    NSInteger weekIndex = [self getWeekIndex];
    
    if (weekIndex < 52) {
        _heightLable.text = [NSString stringWithFormat:@"%@cm",heightArray[weekIndex]];
        _weightLable.text = [NSString stringWithFormat:@"%@kg",weightArray[weekIndex]];
        _vasionLable.text = [NSString stringWithFormat:@"%@（%@）",vasionArray[weekIndex],[self getDateStringWithWeekIndex:weekIndex]];
        
    }else if( years < 3){
        NSInteger mouthIndex = 0;
        if (years == 1) {
            mouthIndex = month/3;
        }else if (years == 2){
            
            mouthIndex = 4 + month/3;
        }
        _heightLable.text = [NSString stringWithFormat:@"%@cm",bigHeightArray[mouthIndex]];
        _weightLable.text = [NSString stringWithFormat:@"%@kg",bigWeightArray[mouthIndex]];
        _weightLable.frame = _vasionLable.frame;
        _weightLeftImage.frame = _vasionLeftImage.frame;
        _vasionLable.hidden = YES;
        _vasionLeftImage.hidden = YES;
        _rowImageView.hidden = YES;
    }else {
        
        [self addTitleDateLabelWithDay:day ansMonth:month andYears:years];
        _oldLable.hidden = YES;
        _vasionLeftImage.hidden = YES;
        _vasionLable.hidden = YES;
        _heightLable.hidden = YES;
        _heightLeftImage.hidden = YES;
        _weightLable.hidden = YES;
        _weightLeftImage.hidden = YES;
        _rowImageView.hidden = YES;
    }
}

- (void)setAlpheFromVC:(float)alpheFromVC{
    _oldLable.alpha = alpheFromVC;
    _yearLabel.alpha = alpheFromVC;
    _monthLabel.alpha = alpheFromVC;
    _dayLabel.alpha = alpheFromVC;
    _heightLable.alpha = alpheFromVC;
    _weightLable.alpha = alpheFromVC;
    _vasionLable.alpha = alpheFromVC;
    _heightLeftImage.alpha = alpheFromVC;
    _weightLeftImage.alpha = alpheFromVC;
    _vasionLeftImage.alpha = alpheFromVC;
    _rowImageView.alpha = alpheFromVC;
}


#pragma mark 初始化视图
- (void)layoutSubviewsWithframe:(CGRect)frame  {
    
    float viewHeight = frame.size.height;
    float width = frame.size.width;
    labelHeight = (viewHeight -viewTopDistance)/6;
    originalY = viewTopDistance;
    
    _bgImageView =[[UIImageView alloc] init];
    _bgImageView.frame = frame;
    _bgImageView.image = [UIImage imageNamed:@"宝妈工具背景"];
    [self addSubview:_bgImageView];
    
    _oldLable = [[UILabel alloc] initWithFrame:CGRectMake(viewLeftDistance, viewTopDistance, width - viewLeftDistance , labelHeight*2)];
    _oldLable.font = [UIFont fontWithName:@"RTWSYueGoTrial-Light" size:oldLableTextFont];
    _oldLable.textColor = [UIColor whiteColor];
    [self addSubview:_oldLable];
    originalY += labelHeight*5/2;
    
    _heightLeftImage = [[UIImageView alloc]initWithFrame:CGRectMake(viewLeftDistance, originalY, labelHeight, labelHeight)];
    _heightLeftImage.image = [UIImage imageNamed:@"length"];
    [self addSubview:_heightLeftImage];
    
    _heightLable = [[UILabel alloc] initWithFrame:CGRectMake(viewLeftDistance +labelHeight +betweenImageLabel, originalY, labelWidth , labelHeight)];
    _heightLable.font = [UIFont fontWithName:@"RTWSYueGoTrial-Light" size:vasionLabelTextFont];
    _heightLable.textColor = [UIColor whiteColor];
    [self addSubview:_heightLable];
    
    _weightLeftImage = [[UIImageView alloc]initWithFrame:CGRectMake(viewLeftDistance +labelHeight +betweenImageLabel +labelWidth +betweenLabelImage - 8, originalY, labelHeight, labelHeight)];
    _weightLeftImage.image = [UIImage imageNamed:@"weight"];
    [self addSubview:_weightLeftImage];
    
    _weightLable = [[UILabel alloc] initWithFrame:CGRectMake(_weightLeftImage.frame.origin.x + labelHeight +betweenImageLabel, originalY, labelWidth , labelHeight)];
    _weightLable.font = [UIFont fontWithName:@"RTWSYueGoTrial-Light" size:vasionLabelTextFont];
    _weightLable.textColor = [UIColor whiteColor];
    [self addSubview:_weightLable];
    originalY += labelHeight*3/2;
    
    _vasionLeftImage = [[UIImageView alloc]initWithFrame:CGRectMake(viewLeftDistance, originalY, labelHeight, labelHeight)];
    _vasionLeftImage.image = [UIImage imageNamed:@"视力提升期"];
    [self addSubview:_vasionLeftImage];
    
    _vasionLable = [[UILabel alloc] initWithFrame:CGRectMake(viewLeftDistance +labelHeight +betweenImageLabel, originalY, 300 , labelHeight)];
    _vasionLable.font = [UIFont fontWithName:@"RTWSYueGoTrial-Light" size:vasionLabelTextFont];
    _vasionLable.textColor = [UIColor whiteColor];
    [self addSubview:_vasionLable];
    
    _rowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -52, 0, 50, 50)];
    _rowImageView.image = [UIImage imageNamed:@"go"];
    _rowImageView.center = CGPointMake(_rowImageView.center.x, frame.size.height /2 +2);
    [self addSubview:_rowImageView];
    
}

- (void)addTitleDateLabelWithDay:(NSInteger)day ansMonth:(NSInteger)month andYears:(NSInteger)years{
    
    NSInteger distance = -60;
    NSInteger width = 100;
    NSMutableAttributedString *Str;
    if (years) {
        _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewLeftDistance, 50, width, 40)];
        Str = [self getMutableAttributedStringWithString:[NSString stringWithFormat:@"%ld岁",(long)years]];
        _yearLabel.attributedText = Str;
        _yearLabel.textColor = [UIColor whiteColor];
        [self addSubview:_yearLabel];
        if (month) {
            _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewLeftDistance +width +distance, 50, width, 40)];
            Str = [self getMutableAttributedStringWithString1:[NSString stringWithFormat:@"%ld个月",(long)month]];
            _monthLabel.attributedText = Str;
            _monthLabel.textColor = [UIColor whiteColor];
            _monthLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_monthLabel];
            if (day) {
                _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewLeftDistance +width*2 +distance, 50, width, 40)];
                Str = [self getMutableAttributedStringWithString:[NSString stringWithFormat:@"%ld天",(long)day]];
                _dayLabel.attributedText = Str;
                _dayLabel.textColor = [UIColor whiteColor];
                [self addSubview:_dayLabel];
            }
        }else{
            if (day) {
                _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewLeftDistance +width +distance, 50, width, 40)];
                Str = [self getMutableAttributedStringWithString:[NSString stringWithFormat:@"%ld天",(long)day]];
                _dayLabel.attributedText = Str;
                _dayLabel.textColor = [UIColor whiteColor];
                _dayLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:_dayLabel];
            }
        }
    }
    
}

- (NSMutableAttributedString *)getMutableAttributedStringWithString:(NSString *)string{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger strLenth = string.length;
    [str addAttribute:NSFontAttributeName value:[UIFont parentToolTitleViewDetailHeiFontWithSize:36] range:NSMakeRange(0, strLenth - 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont parentToolTitleViewDetailHeiFontWithSize:18] range:NSMakeRange(strLenth - 1, 1)];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x00dbb8) range:NSMakeRange(0, strLenth)];
    return str;
}

- (NSMutableAttributedString *)getMutableAttributedStringWithString1:(NSString *)string{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger strLenth = string.length;
    [str addAttribute:NSFontAttributeName value:[UIFont parentToolTitleViewDetailHeiFontWithSize:36] range:NSMakeRange(0, strLenth - 2)];
    [str addAttribute:NSFontAttributeName value:[UIFont parentToolTitleViewDetailHeiFontWithSize:18] range:NSMakeRange(strLenth - 2, 2)];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x00dbb8) range:NSMakeRange(0, strLenth)];
    return str;
}

- (NSString *)getDateStringWithWeekIndex:(NSInteger)weekIndex{
    ADAppDelegate *myAPP = APP_DELEGATE;
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit |NSCalendarUnitYear;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date1= [NSDate dateWithWeeksFromDate:myAPP.babyBirthday weeks:weekIndex];
    NSDate *date2 = [NSDate dateWithWeeksFromDate:[myAPP.babyBirthday dateByAddingDays:-1] weeks:weekIndex+1];
    NSDateComponents *componects1 = [gregorian components:unitFlags fromDate:date1];
    NSDateComponents *componects2 = [gregorian components:unitFlags fromDate:date2];
    
    NSString *datestring = [NSString stringWithFormat:@"%ld.%ld-%ld.%ld",(long)[componects1 month],(long)[componects1 day],(long)[componects2 month],(long)[componects2 day]];
    return datestring;
}

- (NSString *)getTextWithYears:(NSInteger)years month:(NSInteger)month day:(NSInteger)day{
    
    NSString *textString;
    NSString *yearsString;
    NSString *monthString;
    NSString *dayString;
    if (years) {
        yearsString =  [NSString stringWithFormat:@"%ld岁",(long)years];
    }else{
        yearsString = @"";
    }
    if (month) {
        monthString = [NSString stringWithFormat:@"%ld个月",(long)month];
    }else{
        monthString = @"";
    }
    if (day) {
        dayString = [NSString stringWithFormat:@"%ld天",(long)day];
    }else{
        dayString = @"";
    }
    textString =  [NSString stringWithFormat:@"宝宝%@%@%@",yearsString,monthString,dayString];
    return textString;
}

- (NSInteger)getDaysWithDate:(NSDate *)date{
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:date];
    return ((int)time)/(3600*24);
}

- (NSInteger)getWeekIndex{
    ADAppDelegate *myAPP = APP_DELEGATE;
    NSInteger days = [self getDaysWithDate:myAPP.babyBirthday];
    return days > 0?days/7:0;
}




@end
