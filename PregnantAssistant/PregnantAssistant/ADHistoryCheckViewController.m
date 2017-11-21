//
//  ADHistoryCheckViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-19.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADHistoryCheckViewController.h"
#import "ADHistoryCell.h"

#define ADDBTNHEIGHT 52
#define CELLHEIGHT 52

@interface ADHistoryCheckViewController ()

@end

@implementation ADHistoryCheckViewController

-(void)dealloc
{
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.warnDateArray = [ADCheckCalDAO readAllData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.warnDateArray.count > 0) {
        [self setRightItemWithStrEdit];
        [self addTableView];
    } else {
        [self addEmptyView];
        [self addEmptyTipView];
    }
    [self addBottomAdd];
}

- (void)addTableView
{
//    int naviHeight = [ADHelper getNavigationBarHeight];
   
//    float tableViewHeight = SCREEN_HEIGHT -naviHeight -ADDBTNHEIGHT;
    float tableViewHeight = SCREEN_HEIGHT -ADDBTNHEIGHT - NAVIBAT_HEIGHT;
    self.myTableView =
    [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIBAT_HEIGHT, SCREEN_WIDTH, tableViewHeight)];

    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.delegate = self;
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.myTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    [self.view addSubview:self.myTableView];
}

- (void)addEmptyView
{
//    CGRect newRect = [[UIScreen mainScreen] bounds];
//    if ([ADHelper isIphone4]) {
//        newRect.origin.y += 24;
//    }
//    newRect.size.height -= [ADHelper getNavigationBarHeight] +ADDBTNHEIGHT;
    
    _aBgView = [[ADBackgroundView alloc]initWithFrame:CGRectMake(0, NAVIBAT_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIBAT_HEIGHT)];
    _aBgView.alpha = 0;
    
    [self.view addSubview:_aBgView];
    [UIView beginAnimations:@"showEView" context:nil];
    [UIView setAnimationDuration:0.24];
    
    _aBgView.alpha = 1;
    
    [UIView commitAnimations];
}

- (void)addEmptyTipView
{
    _emptyTipView = [[UIImageView alloc]initWithFrame:
                              CGRectMake((SCREEN_WIDTH - 376/2) /2, SCREEN_HEIGHT -ADDBTNHEIGHT -4 -92/2, 376/2, 92/2)];
    _emptyTipView.image = [UIImage imageNamed:@"点击这里设置产检提醒"];
    [self.view addSubview:_emptyTipView];
}

- (void)addBottomAdd
{
//    int naviHeight = [ADHelper getNavigationBarHeight];
    self.addNote = [[ADAddBottomBtn alloc]initWithFrame:
                    CGRectMake(0, SCREEN_HEIGHT -ADDBTNHEIGHT, SCREEN_WIDTH, ADDBTNHEIGHT)];
    self.addNote.backgroundColor = [UIColor light_green_Btn];
    
    [self.addNote addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.addNote];
}

- (void)rightItemMethod:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        [self changeCellWithEdit:YES];
    } else {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        [self changeCellWithEdit:NO];
    }
}

- (void)changeCellWithEdit:(BOOL)editing
{
    [self.myTableView setEditing:editing animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-  (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        //cancelAlarm
        ADCheckCalTime *aCheckCal = self.warnDateArray[indexPath.row];
        NSDate *delDate = aCheckCal.aDate;
        NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDateComponents *dateComponents =
        [calendar components:unitFlags fromDate:delDate];
        NSInteger day = [dateComponents day];
        NSInteger month = [dateComponents month];
        NSInteger year = [dateComponents year];
        
        int day_i = (int)day;
        int month_i = (int)month;
        int year_i = (int)year;
        NSString *cancelId = [NSString stringWithFormat:@"%d-%d-%d", year_i, month_i, day_i];
        [self cancelAlarmWithId:cancelId];
        
        int beforeDay = day_i -1;
        NSString *cancelId2 = [NSString stringWithFormat:@"%d-%d-%d", year_i, month_i, beforeDay];
        [self cancelAlarmWithId:cancelId2];
        

        [ADCheckCalDAO delCheckCal:aCheckCal];
        self.warnDateArray = [ADCheckCalDAO readAllData];
        
        //del cellview
        if (self.warnDateArray.count == 0) {
            
            [self.myTableView setEditing:NO animated:NO];
            [self addEmptyView];
            [self addEmptyTipView];
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)showDatePicker
{
    [self.datePicker removeFromSuperview];
    self.datePicker =
    [[ADCustomPicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT+216, SCREEN_WIDTH, 216 +40)
                              withMinDate:NO];
    //重新覆盖最大日期 为 42周后
    ADAppDelegate *appDelegate = APP_DELEGATE;
    int daysToAdd = 14;
    NSDate *newDate = [appDelegate.dueDate dateByAddingTimeInterval:60*60*24*daysToAdd];
    self.datePicker.myDatePicker.maximumDate = newDate;
    
    int daysToSub = -280;
    NSDate *beforeDate = [appDelegate.dueDate dateByAddingTimeInterval:60*60*24*daysToSub];
    self.datePicker.myDatePicker.minimumDate = beforeDate;
    [self.datePicker showPicker];
    
    [self.datePicker.doneBtn addTarget:self
                                action:@selector(finishSelect:)
                      forControlEvents:UIControlEventTouchUpInside];
}

- (void)finishSelect:(UIButton *)sender
{
    [self.datePicker hidePicker];
    
    //去重
    for (ADCheckCalTime *aCal in self.warnDateArray) {
        if ([aCal.aDate isEqualToDateIgnoringTime:self.datePicker.myDatePicker.date]) {
            return;
        }
    }
    
    [ADCheckCalDAO addCheckCalWithDate:self.datePicker.myDatePicker.date];
    self.warnDateArray = [ADCheckCalDAO readAllData];
    
    if (self.warnDateArray.count > 0) {
        [_aBgView removeFromSuperview];
        [_emptyTipView removeFromSuperview];
        [self setRightItemWithStrEdit];
    }
    
    if(self.myTableView == nil) {
        [self addTableView];
    }
    
    [self.myTableView reloadData];
    
//    [ADCheckCalDAO saveCheckDateWithArray:_warnDateArray];
    
    [self setAlarm];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"warnDate:%@",self.warnDateArray);
    return self.warnDateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdStr = @"aWarnCell";
    
    ADHistoryCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdStr];
    
    if (aCell == nil) {
        aCell = [[ADHistoryCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdStr];
    }
    aCell.backgroundColor = [UIColor whiteColor];
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return aCell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //set Data
    ADCheckCalTime *aCal = _warnDateArray[indexPath.row];
    NSDate *aDate =  aCal.aDate;
    
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents =
    [calendar components:unitFlags fromDate:aDate];
    NSInteger day = [dateComponents day];
    NSInteger month = [dateComponents month];
    NSInteger year = [dateComponents year];
    
    NSString *noteStr =
    [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day];

    ADAppDelegate *appDelegate = APP_DELEGATE;
    NSInteger reminDay = [aDate distanceInDaysToDate:appDelegate.dueDate];
    NSInteger passDay = 280 -reminDay;
    
    NSInteger dueDay = passDay %7;
    NSInteger dueWeek = passDay /7;
    
    NSString *dueStr =
    [NSString stringWithFormat:@"孕%ld周%ld天",(long)dueWeek, (long)dueDay];
    cell.textLabel.text = noteStr;
    cell.textLabel.textColor = [UIColor font_btn_color];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.detailTextLabel.text = dueStr;
    cell.detailTextLabel.textColor = [UIColor font_btn_color];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:17];
    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
}

- (void)setAlarm
{
    NSDate *setDate = self.datePicker.myDatePicker.date;
    
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:setDate];
    NSInteger day = [dateComponents day];
    NSInteger month = [dateComponents month];
    NSInteger year = [dateComponents year];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification!=nil)
    {
        [comps setDay:day -1];
        [comps setMonth:month];
        [comps setYear:year];
        [comps setHour:8];
        
        NSDate *newDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
        notification.timeZone = [NSTimeZone systemTimeZone];
        
        NSLog(@"due8 %@",newDate);
        
        notification.fireDate = newDate;
        
        int day_i = (int)day -1;
        int month_i = (int)month;
        int year_i = (int)year;
        
        NSString *notifyId = [NSString stringWithFormat:@"%d-%d-%d",year_i,month_i,day_i];
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
        
        notificationToday.timeZone=[NSTimeZone systemTimeZone];
        //        notification.soundName = @"ping.caf";
        
        notificationToday.alertBody = [NSString stringWithFormat:@"亲爱的，请记得今天去产检哦~"];
        
        int day_i = (int)day -1;
        int month_i = (int)month;
        int year_i = (int)year;

        NSString *notifyId = [NSString stringWithFormat:@"%d-%d-%d",year_i,month_i,day_i];
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

@end
