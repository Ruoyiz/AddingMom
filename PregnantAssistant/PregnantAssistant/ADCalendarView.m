//
//  ADCalendarView.m
//  PregnantAssistant
//
//  Created by D on 14-9-15.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADCalendarView.h"
#import "UIImage+Tint.h"
#import "NSDate+Utilities.h"

@implementation ADCalendarView

- (id)initWithFrame:(CGRect)frame
      withIsCntView:(BOOL)isCnt
{
    _isCntView = isCnt;
    self = [self initWithFrame:frame];

    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _appDelegate = APP_DELEGATE;
        self.backgroundColor = [UIColor whiteColor];
        
        if (_isCntView) {
            _appDelegate.cntDisplayDate = [NSDate date];
        } else {
            _appDelegate.displayDate = [NSDate date];
        }
        [self addArrow];
        [self addDayLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeTodayTitle)
                                                     name:NOTIFICATION_ADD_VALID_ONE_CHANGE
                                                   object:nil];
    }
    return self;
}

- (void)addArrow
{
    UIImage *leftArrowImage = [[UIImage imageNamed:@"leftArrow"] imageWithTintColor:UIColorFromRGB(0x00DBB8)];
    UIButton *leftArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftArrowBtn setImage:leftArrowImage forState:UIControlStateNormal];
    [[leftArrowBtn imageView] setContentMode: UIViewContentModeCenter];
    [leftArrowBtn setFrame:CGRectMake(0, 0, 48, 48)];
    [leftArrowBtn addTarget:self action:@selector(subDay:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:leftArrowBtn];
    
    UIImage *rightArrowImage = [[UIImage imageNamed:@"rightArrow"] imageWithTintColor:UIColorFromRGB(0x00DBB8)];
    UIButton *rightArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightArrowBtn setImage:rightArrowImage forState:UIControlStateNormal];
    [[rightArrowBtn imageView] setContentMode: UIViewContentModeCenter];
    [rightArrowBtn setFrame:CGRectMake(SCREEN_WIDTH -48, 0, 48, 48)];
    [rightArrowBtn addTarget:self action:@selector(addDay:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:rightArrowBtn];
}

- (void)addDayLabel
{
    _dayLabel = [[UILabel alloc]initWithFrame:
                 CGRectMake(56, (self.frame.size.height) /2 -17, self.frame.size.width -112, 32)];
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    _dayLabel.font = [UIFont systemFontOfSize:17];
    _dayLabel.textColor = UIColorFromRGB(0x4d4587);
    if (_isCntView) {
        _dayLabel.text = [ADHelper getCurrentDay];
    } else {
        _dayLabel.text = [self getDate2Str:[NSDate date]];
    }

    _dayLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *linkTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetDate:)];

    [_dayLabel addGestureRecognizer:linkTap];

    [self addSubview:_dayLabel];
}

- (void)resetDate:(UILabel *)sender
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    if (_isCntView) {
        if ([_appDelegate.cntDisplayDate isEqualToDateIgnoringTime:[NSDate date]]) {
            return;
        }
        _appDelegate.cntDisplayDate = [NSDate date];
        _dayLabel.text = [self getDateStr:_appDelegate.cntDisplayDate];
        
        [center postNotificationName:NOTIFICATION_CHANGE_CNT_TODAY object:nil];
    } else {
        _appDelegate.displayDate = [NSDate date];
        _dayLabel.text = [self getDate2Str:_appDelegate.displayDate];
        
        [center postNotificationName:NOTIFICATION_DAY_CHANGED object:nil];
    }
}

- (void)changeTodayTitle
{
    _dayLabel.text = [self getDateStr:[NSDate date]];
}

- (void)setDayLabelWithDate:(NSDate *)date
{
    _dayLabel.text = [self getDateStr:date];
}

- (void)subDay:(UIButton *)sender
{
    [self changeDayLabelWithDiff:-1];
}

- (void)addDay:(UIButton *)sender
{
    if (_isCntView) {
        if ([[NSDate date] isEqualToDateIgnoringTime:_appDelegate.cntDisplayDate]) {
            return;
        }
    } else {
    }

    [self changeDayLabelWithDiff:1];
}

- (void)changeDayLabelWithDiff:(int)aDiff
{
    if (_isCntView) {
        _appDelegate.cntDisplayDate = [_appDelegate.cntDisplayDate dateByAddingTimeInterval:60*60*24*aDiff];
        _dayLabel.text = [self getDateStr:_appDelegate.cntDisplayDate];

        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CNT_DAY_CHANGED object:nil];
    } else {
        
        //fix 设置日期太远
        _appDelegate.displayDate = [_appDelegate.displayDate dateByAddingTimeInterval:60*60*24*aDiff];
        if (aDiff == 1)
        {
            if (!_isParentingCalendar) {
                NSDate *newDate = [_appDelegate.dueDate dateByAddingTimeInterval:60*60*24*1];
                if ([_appDelegate.displayDate isEqualToDateIgnoringTime:newDate])
                {
                    _appDelegate.displayDate = [_appDelegate.displayDate dateByAddingTimeInterval:60*60*24*-aDiff];
                    return;
                }

            }else{
                NSDate *newDate = [NSDate dateWithWeeksFromDate:_appDelegate.babyBirthday weeks:52];
                NSLog(@"displayDate %@, babyBirthday %@",[self getDateStr:_appDelegate.displayDate],[self getDateStr:_appDelegate.babyBirthday]);
                if ([_appDelegate.displayDate isEqualToDateIgnoringTime:newDate])
                {
                   _appDelegate.displayDate = [_appDelegate.displayDate dateByAddingTimeInterval:60*60*24*-aDiff];
                    return;
                }
            }
            NSLog(@"press >");
            [MobClick event:duedate_notice_forward];
        } else {
            if (_isParentingCalendar) {
                if ([ADHelper isBiggerSecWithDate1:_appDelegate.babyBirthday date2:[_appDelegate.displayDate dateByAddingDays:0]]) {
                    
                    _appDelegate.displayDate = [_appDelegate.displayDate dateByAddingTimeInterval:60*60*24*-aDiff];

                    return;
                }
            }
            NSLog(@"press <");
            [MobClick event:duedate_notice_backward];
        }
        
        
        _dayLabel.text = [self getDate2Str:_appDelegate.displayDate];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DAY_CHANGED object:nil];
        
        
    }
}

- (NSString *)getDateStr:(NSDate *)aDate
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:aDate];
    NSInteger day = [dateComponents day];
    NSInteger month = [dateComponents month];
    NSInteger year = [dateComponents year];
    return [NSString stringWithFormat:@"%ld年%ld月%ld日", (long)year, (long)month, (long)day];
}

- (NSString *)getDate2Str:(NSDate *)aDate
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:aDate];
    NSInteger day = [dateComponents day];
    NSInteger month = [dateComponents month];
    NSInteger year = [dateComponents year];
    
//    //ios system time ?
//    NSDate *newDate = [_appDelegate.dueDate dateByAddingTimeInterval:60*60*24*1];
//    NSTimeInterval time = [newDate timeIntervalSinceDate:aDate];
////    NSLog(@"due:%@ dis:%@", _appDelegate.dueDate, aDate);
//    int days = ((int)time) / (3600*24);
//    
//    NSLog(@"days:%d", days);
//    int passDay = 280 -days;
//    
//    if (days == 0) {
//        passDay = 280;
//    }
//    
//    int week = passDay /7;
//    int dueday = passDay %7;
    
    return [NSString stringWithFormat:@"%ld.%ld.%ld", (long)year, (long)month, (long)day];
}

@end
