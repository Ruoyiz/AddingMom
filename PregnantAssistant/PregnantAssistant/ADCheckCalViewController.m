//
//  ADCheckCalendarViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-19.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADCheckCalViewController.h"
#import "ADTimeCheckViewController.h"
#import "ADHistoryCheckViewController.h"
#import "ADCheckDetial.h"

#define LINESPACE 8
static NSString * tip =
@"我们特别为准妈妈整理出一份详尽的孕产检查时间表,叮咛准妈妈按时进行各项检查,以确保母体和胎儿的健康,帮助你顺利度过难忘的280天!";

@interface ADCheckCalViewController ()

@end

@implementation ADCheckCalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTitle = @"产检日历";
    
    [self showSyncAlert];

    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([ADHelper isIphone4]) {
        self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 24);
        [self.view addSubview:self.myScrollView];
    }
    
    [ADCheckCalDAO updateDataBaseOnfinish:^{
    }];
    
    NSLog(@"token:%@ uid:%@",
          [[NSUserDefaults standardUserDefaults] addingToken], [[NSUserDefaults standardUserDefaults]addingUid]);

    [self addLabel];
    [self addButtons];
    
    if (iPhone6 || iPhone6Plus) {
        [self addBottomImg];
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addLabel
{
    if ([ADHelper isIphone4]) {
        self.tipLabel = [[UILabel alloc]initWithFrame:
                         CGRectMake(14, 8, SCREEN_WIDTH -24, 72)];
    } else {
        self.tipLabel = [[UILabel alloc]initWithFrame:
                         CGRectMake(14, 8 + [ADHelper getNavigationBarHeight], SCREEN_WIDTH -24, 72)];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tip];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [tip length])];
    self.tipLabel.attributedText = attributedString;
    
    self.tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.tipLabel.numberOfLines = 3;
    self.tipLabel.font = [UIFont tip_font];
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.textColor = [UIColor font_tip_color];
    
    if ([ADHelper isIphone4]) {
        [self.myScrollView addSubview:self.tipLabel];
    } else {
        [self.view addSubview:self.tipLabel];
    }
}

- (void)addButtons
{
    int offset = 0;
    if ([ADHelper isIphone4]) {
    } else {
        offset = 64;
    }
    
    _alarmBtn = [[ADAlarmButton alloc]initWithFrame:
                 CGRectMake(12, 44 +12 +8 +24 +offset, SCREEN_WIDTH -24, 40)];

    [_alarmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_alarmBtn addTarget:self action:@selector(showSelectDate) forControlEvents:UIControlEventTouchUpInside];
    _alarmBtn.titleLabel.font = [UIFont btn_title_font];
    
    if ([ADHelper isIphone4]) {
        [self.myScrollView addSubview:_alarmBtn];
    } else {
        [self.view addSubview:_alarmBtn];
    }
    
    self.buttonNameArray = @[
                        @"我的产检历史", @"第一次产检\n(孕12周)",
                        @"第二次产检\n(孕16~18周)",@"第三次产检\n(孕20~24周)",
                        @"第四次产检\n(孕24~28周)",@"第五次产检\n(孕28~30周)",
                        @"第六次产检\n(孕32~34周)",@"第七次产检\n(孕36周)",
                        @"第八次产检\n(孕37周)",@"第九次产检\n(孕38周)",
                        @"第十次产检\n(孕39周)",@"第十一次产检\n(孕40周)"
                        ];
    
    for (int i = 0; i < self.buttonNameArray.count; i++) {
        int row = i/2;
        int col = i%2;
        ADCustomButton *aBtn = [[ADCustomButton alloc]initWithFrame:
                                CGRectMake(12 +(SCREEN_WIDTH -6)/2 *col, 248 /2 +20 +offset + 50*row, (SCREEN_WIDTH -42)/2, 42)];
        aBtn.titleStr = self.buttonNameArray[i];
        aBtn.buttonColor = [UIColor whiteColor];
        aBtn.layer.borderColor = UIColorFromRGB(0x06a9a3).CGColor;
        aBtn.layer.borderWidth = 1.f;

        aBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        aBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [aBtn setTitleColor:[UIColor font_btn_color] forState:UIControlStateNormal];

        
        if (i == 0) {
            aBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        } else {
            aBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        
        [aBtn addTarget:self action:@selector(jumpToNextVC:) forControlEvents:UIControlEventTouchUpInside];
        aBtn.tag = 20 +i;
        if ([ADHelper isIphone4]) {
            [self.myScrollView addSubview:aBtn];
        } else {
            [self.view addSubview:aBtn];
        }
    }
}

- (void)addBottomImg
{
    CGFloat height = (SCREEN_WIDTH -32) *0.198;
    UIImageView *bottomImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -32, height)];
    bottomImgView.center = CGPointMake(SCREEN_WIDTH /2, SCREEN_HEIGHT -height -44);
    bottomImgView.image = [UIImage imageNamed:@"产检日历底部图"];
    [self.view addSubview:bottomImgView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self syncAllDataOnFinish:^(NSError *error) {
    }];

    self.selectDateArray = [ADCheckCalDAO readAllData];
    
    _alarmBtn.titleStr = @"设置产检提醒";
    _alarmBtn.userInteractionEnabled = YES;

    if (self.selectDateArray.count > 0) {
        //设置产检日期 超过设置的日期后修改为设置产检提醒
        [self setAlarmBtnTitle];
    }
    
}

- (void)setAlarmBtnTitle
{
    for (ADCheckCalTime *aCheckCal in self.selectDateArray) {
        NSDate *aDate = aCheckCal.aDate;
        if ([aDate isLaterThanDate:[NSDate date]]) {
            NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
            NSDateComponents *dateComponents =
            [calendar components:unitFlags fromDate:aDate];
            NSInteger day = [dateComponents day];
            NSInteger month = [dateComponents month];
            NSInteger year = [dateComponents year];
            
            _currentDisplayDate = aDate;
            _alarmBtn.titleStr =
            [NSString stringWithFormat:@"下一次产检时间:  %ld-%ld-%ld",(long)year,(long)month,(long)day];
            break;
        }
    }
}

- (void)showSelectDate
{
    [self.datePicker removeFromSuperview];
    self.datePicker = [[ADCustomPicker alloc] initWithFrame:
                       CGRectMake(0, SCREEN_HEIGHT+216, SCREEN_WIDTH, 216 +40)];
    
    int daysToAdd = 14;
    NSDate *newDate = [self.appDelegate.dueDate dateByAddingTimeInterval:60*60*24*daysToAdd];
    if (_currentDisplayDate != nil) {
        self.datePicker.myDatePicker.date = _currentDisplayDate;
    }
    self.datePicker.myDatePicker.maximumDate = newDate;

    [self.datePicker showPicker];
    
    [self.datePicker.doneBtn addTarget:self
                                action:@selector(finishSelect:)
                      forControlEvents:UIControlEventTouchUpInside];
}

- (void)jumpToNextVC:(UIButton *)sender
{
    //history VC
    if (sender.tag == 20) {
        ADHistoryCheckViewController *aHistoryVc = [[ADHistoryCheckViewController alloc]init];
        aHistoryVc.myTitle = sender.titleLabel.text;
        
        [self.navigationController pushViewController:aHistoryVc animated:YES];
    } else {
        ADTimeCheckViewController *aCheckVc = [[ADTimeCheckViewController alloc]init];
        NSRange titleRange = [sender.titleLabel.text rangeOfString:@"("];
        NSString *titleStr = [sender.titleLabel.text substringWithRange:NSMakeRange(0, titleRange.location)];
        aCheckVc.myTitle = titleStr;
        aCheckVc.aTime = (int)sender.tag -20;
        [self.navigationController pushViewController:aCheckVc animated:YES];
    }
}

- (void)finishSelect:(id)sender
{
    NSLog(@"select date:%@", self.datePicker.myDatePicker.date);
    
    //修改提醒
    //删除选中的日期
    [self cancelAlarmWithDate:_currentDisplayDate];
    
    NSLog(@"select date:%@", self.selectDateArray);
    //设置相同的某天 删除
    for (int i = 0; i < self.selectDateArray.count; i++) {
        ADCheckCalTime *aCheckCal = self.selectDateArray[i];
        if ([aCheckCal.aDate isEqualToDateIgnoringTime:self.datePicker.myDatePicker.date]) {
            NSLog(@"find same");
            [self cancelAlarmWithDate:aCheckCal.aDate];
            [ADCheckCalDAO delCheckCal:aCheckCal];
        }
    }
    
    [ADCheckCalDAO addCheckCalWithDate:self.datePicker.myDatePicker.date];
    
    self.selectDateArray = [ADCheckCalDAO readAllData];
    [self setAlarmBtnTitle];
    
    [self syncAllDataOnFinish:^(NSError *error) {
    }];
    
    if (![_currentDisplayDate isEqualToDateIgnoringTime:self.datePicker.myDatePicker.date]) {
        [[[UIAlertView alloc] initWithTitle:@"亲爱的"
                                    message:@"您有一个距离现在更近的产检日期，我们将显示最近的日期"
                                   delegate:self
                          cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
    }
    
    [self setAlarmWithDate:self.datePicker.myDatePicker.date];
    
    [self.datePicker hidePicker];
}

- (void)cancelAlarmWithDate:(NSDate *)aDate
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents =
    [calendar components:unitFlags fromDate:aDate];
    NSInteger day1 = [dateComponents day];
    NSInteger month1 = [dateComponents month];
    NSInteger year1 = [dateComponents year];
    
    int day_i = (int)day1;
    int month_i = (int)month1;
    int year_i = (int)year1;
    NSString *cancelId = [NSString stringWithFormat:@"%d-%d-%d", year_i, month_i, day_i];
    [self cancelAlarmWithId:cancelId];
    
    int beforeDay = day_i -1;
    NSString *cancelId2 = [NSString stringWithFormat:@"%d-%d-%d", year_i, month_i, beforeDay];
    [self cancelAlarmWithId:cancelId2];
}

- (void)setAlarmWithDate:(NSDate *)setDate
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:setDate];
    NSInteger day = [dateComponents day];
    NSInteger month = [dateComponents month];
    NSInteger year = [dateComponents year];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification != nil) {
        [comps setDay:day -1];
        [comps setMonth:month];
        [comps setYear:year];
        [comps setHour:8];
        
        NSDate *newDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
        notification.timeZone = [NSTimeZone systemTimeZone];
        notification.fireDate = newDate;
        
        NSString *notifyId = [NSString stringWithFormat:@"%d-%d-%d",(int)year,(int)month,(int)day];
        NSDictionary* info = @{@"ID":notifyId};
        notification.userInfo = info;
        
        notification.alertBody = [NSString stringWithFormat:@"亲爱的，请记得明天去产检哦~"];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    UILocalNotification *notificationToday = [[UILocalNotification alloc] init];
    if (notificationToday != nil) {
        [comps setDay:day];
        [comps setMonth:month];
        [comps setYear:year];
        [comps setHour:8];
        NSDate *newDate2 = [[NSCalendar currentCalendar] dateFromComponents:comps];
        NSLog(@"date2:%@",newDate2);
        notificationToday.fireDate = newDate2;
        
        notificationToday.timeZone = [NSTimeZone systemTimeZone];
        
        notificationToday.alertBody = [NSString stringWithFormat:@"亲爱的，请记得今天去产检哦~"];
        
        NSString *notifyId = [NSString stringWithFormat:@"%d-%d-%d",(int)year, (int)month, (int)day];
        NSDictionary* info = @{@"ID":notifyId};
        notificationToday.userInfo = info;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notificationToday];
    }
}

- (void)cancelAlarmWithId:(NSString *)aId
{
    UILocalNotification *notificationToCancel = nil;
    for(UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        if([aNotif.userInfo[@"ID"] isEqualToString:aId])
        {
            notificationToCancel=aNotif;
            break;
        }
    }
    if (notificationToCancel != nil) {
        [[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - sync method
- (void)syncAllDataOnFinish:(void(^)(NSError *error))finishBlock
{
    [ADCheckCalDAO syncAllDataOnGetData:^(NSError *error) {
        self.selectDateArray = [ADCheckCalDAO readAllData];
        
        if (self.selectDateArray.count > 0) {
            [self setAlarmBtnTitle];
        }
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
