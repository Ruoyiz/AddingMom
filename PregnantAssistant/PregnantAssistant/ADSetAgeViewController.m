//
//  ADSetAgeViewController.m
//  PregnantAssistant
//
//  Created by D on 15/4/1.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADSetAgeViewController.h"
#import "NSDate+Utilities.h"
#import "ADUserInfoSaveHelper.h"
#import "ADTableViewCell.h"
@interface ADSetAgeViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    UITableView *_myTableView;
    ADTableViewCell *cell;
    NSString *_cellstring ;
}
@end

@implementation ADSetAgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH) style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    [self addPicker];
    self.myTitle = @"年龄";

    
    NSDate *date  = nil;
    NSLog(@"age : %@",self.birthDayTimpSp);
    if([self.birthDayTimpSp isEqualToString:@"0"] || [self.birthDayTimpSp isEqualToString:@""]){
        date = [[NSDate date] dateByAddingYears:-25];
    } else {
        date = [NSDate dateWithTimeIntervalSince1970:self.birthDayTimpSp.integerValue];
    }
    NSLog(@"fromDate : %@,nowDate: %@",date,[NSDate date]);
    
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSInteger day = [dateComponents day];
    NSInteger month = [dateComponents month];
    NSInteger year = [dateComponents year];
    
    _cellstring = [NSString stringWithFormat:@"%ld.%02ld.%02ld",(long)year, (long)month, (long)day];
    _setAgePicker.myDatePicker.date = date;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ADTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID isTextFiele:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.myTitleLable.text = _cellstring;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)addPicker
{
    _setAgePicker = [[ADSetAgePicker alloc] initWithFrame:
                     CGRectMake(0, SCREEN_HEIGHT - 260, SCREEN_WIDTH, 260)];
    [_setAgePicker.myDatePicker addTarget:self
                                   action:@selector(dateSelected:)
                         forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_setAgePicker];
    
    [_setAgePicker.doneBtn addTarget:self
                              action:@selector(finishSelect:)
                    forControlEvents:UIControlEventTouchUpInside];
}

- (void)dateSelected:(id)sender
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDate *date = _setAgePicker.myDatePicker.date;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSInteger day = [dateComponents day];
    NSInteger month = [dateComponents month];
    NSInteger year = [dateComponents year];
    cell.myTitleLable.text = [NSString stringWithFormat:@"%ld.%02ld.%02ld",(long)year, (long)month, (long)day];
//    _ageLabel.text = [NSString stringWithFormat:@"%ld岁", (long)[ADHelper getAgeWithBirthDate:date]];
}
//- (void)tap:(UITapGestureRecognizer *)tap{
//    [UIView animateWithDuration:0.3 animations:^{
//        _setAgePicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 266);
//    }];
//}
//- (void)show{
//    [UIView animateWithDuration:0.3 animations:^{
//        _setAgePicker.frame = CGRectMake(0, SCREEN_HEIGHT -216 -50 -64, SCREEN_WIDTH, 266);
//    }];
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    // 输出点击的view的类名
//    NSLog(@"%@", NSStringFromClass([touch.view class]));
//    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return  YES;
//}

- (void)finishSelect:(UIButton *)sender
{
    NSString *birthDay = [NSString stringWithFormat:@"%f", [_setAgePicker.myDatePicker.date timeIntervalSince1970]];
    [ADUserInfoSaveHelper saveBirthDay:birthDay];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
