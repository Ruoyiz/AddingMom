//
//  ADNewHWViewController.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/6/2.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADNewHWViewController.h"
#import "ADWHeightPickerView.h"
#import "ADWHDatePickView.h"
#import "ADWHDataManager.h"
#import "ADWeightHeightModel.h"
#define PICKERVIEW_HEIGHT 266

@interface ADNewHWViewController ()<heightPickerViewDidselected>{
    
    UIView *_bgView;
    ADWHeightPickerView *_heightPicker;
    ADWHDatePickView *_datePickerView;
    NSMutableArray *_heightArray;
    NSMutableArray *_weightArray;
    BOOL _isHeight;
    
    NSDate * _choseDate;
    NSString *_dateText;
    NSString *_heightText;
    NSString *_weightText;
    
    BOOL _ishasDate;
    BOOL _ishasWeight;
    BOOL _ishasHeight;
    NSDate *_myDate;
    
}
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *heightButton;
@property (weak, nonatomic) IBOutlet UIButton *weightButton;

@end

@implementation ADNewHWViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setLeftItem];
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    self.myTitle = @"新的生长记录";
    [self layoutData];
    [self layoutUI];
    [self layoutDatePickView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:UICOLOR(240, 232, 221, 1)];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_ishasDate&&_ishasHeight&&_ishasWeight) {
        if (_isComefromParentHW) {
            [ADWHDataManager deleteModelWithCreatDate:_myDate];
        }
        NSDictionary *dic = @{@"time":[NSString stringWithFormat:@"%ld",(long)[_choseDate timeIntervalSince1970]],@"height":_heightText,@"weight":_weightText};
        [ADWHDataManager saveWhDataWithDic:dic];
    }
}

#pragma mark - layoutUI
- (void)layoutUI{
    _dateText = @"点击添加日期";
    _heightText = @"点击添加身高记录";
    _weightText = @"点击添加体重记录";
    _choseDate = [NSDate date];
    [_dateButton setTitleColor:UIColorFromRGB(0x4d4587) forState:UIControlStateNormal];
    [_heightButton setTitleColor:UIColorFromRGB(0x4d4587) forState:UIControlStateNormal];
    [_weightButton setTitleColor:UIColorFromRGB(0x4d4587) forState:UIControlStateNormal];
    ADWeightHeightModel *model;
    NSLog(@"iscomfrom %d",_isComefromParentHW);
    if (_isComefromParentHW) {
        model = _fromParentModel;
        _ishasHeight = _ishasWeight = _ishasDate = YES;
    }else {
        model = [ADWHDataManager readFirstModel];
    }
    if (model.weight) {
        _weightText = model.weight;
        _heightText = model.height;
        _choseDate = [NSDate dateWithTimeIntervalSince1970:[model.time doubleValue]];
        _myDate = _choseDate;
        [self setDateButtonTextWithDate:_choseDate];
        _ishasDate = _ishasHeight = _ishasWeight = YES;
    }
    [_dateButton setTitle:_dateText forState:UIControlStateNormal];
    [_heightButton setTitle:_heightText forState:UIControlStateNormal];
    [_weightButton setTitle:_weightText forState:UIControlStateNormal];
    if (!model.weight) {
        _heightText = @"50.0";
        _weightText = @"5.0";
    }
}
- (void)layoutDatePickView{
    ADAppDelegate *myApp = APP_DELEGATE;
    NSLog(@"choseDate == %@",_choseDate);
    _datePickerView = [[ADWHDatePickView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT) titleString:@"选择日期" titleImageName:@"iconOk" minimumDate:myApp.babyBirthday maximumDate:[NSDate date] nowDate:_choseDate];
    [_datePickerView.datePicker addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
    [_datePickerView.doneBtn addTarget:self action:@selector(datePickerDone:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - lyoutData

- (void)layoutData{
    _heightArray = [[NSMutableArray alloc] init];
    _weightArray = [[NSMutableArray alloc] init];
    for (int i = 30; i < 110; i++) {
        [_heightArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for (int i = 0; i < 25; i ++) {
        [_weightArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
}

#pragma mark - ClickedEvent
- (IBAction)heightPickerShow:(UIButton *)sender {
    if (sender.tag == 100) {
        _heightPicker = [[ADWHeightPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT) title:@"选择身高" isHeight:YES];
        _heightPicker.contentArray = _heightArray;
        [_heightPicker.myDatePicker selectRow:[_heightText integerValue] - 30 inComponent:0 animated:NO];
        [_heightPicker.myDatePicker selectRow:[self getDecNumberWithTextString:_heightText] inComponent:1 animated:NO];
        _isHeight = YES;
        _heightPicker.defHeight = _heightText;
        _heightPicker.defWeight = [NSString stringWithFormat:@"%ld",(long)[self getDecNumberWithTextString:_heightText]];
        
    }else if(sender.tag == 101){
        _heightPicker = [[ADWHeightPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT)  title:@"选择体重" isHeight:NO];
        _heightPicker.contentArray = _weightArray;
        [_heightPicker.myDatePicker selectRow:[_weightText integerValue] inComponent:0 animated:NO];
        [_heightPicker.myDatePicker selectRow:[self getDecNumberWithTextString:_weightText] inComponent:1 animated:NO];
        _isHeight = NO;
        _heightPicker.defHeight = _weightText;
        _heightPicker.defWeight = [NSString stringWithFormat:@"%ld",(long)[self getDecNumberWithTextString:_weightText]];
        
    }
    _heightPicker.tag = sender.tag;
    _heightPicker.delegate = self;
    [_heightPicker.doneBtn addTarget:self action:@selector(heightPickerDone:) forControlEvents:UIControlEventTouchUpInside];
    [self pickViewShow:_heightPicker];
}


- (IBAction)DatePickShow:(UIButton *)sender {
    [self datePickViewShow:_datePickerView];
}
#define mark - show
- (void)pickViewShow:(ADWHeightPickerView *)pickView{
    if (_bgView.superview != nil) {
        return;
    }
    [self  showBgview];
    [self.appDelegate.window addSubview:pickView];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        pickView.frame = CGRectMake(0, SCREEN_HEIGHT - PICKERVIEW_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}
- (void)datePickViewShow:(ADWHDatePickView *)datePick{
    if (_bgView.superview != nil) {
        return;
    }
    [self  showBgview];
    [self.appDelegate.window addSubview:datePick];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        datePick.frame = CGRectMake(0, SCREEN_HEIGHT - PICKERVIEW_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT);
    } completion:^(BOOL finished) {
    }];
    
}

#pragma mark - Done

- (void)heightPickerDone:(UIButton *)button{
    [self dismissExBgView];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        _heightPicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT);
    } completion:^(BOOL finished) {
        [_heightPicker removeFromSuperview];
    }];
    if (_isHeight) {
        _ishasHeight = YES;
        [_heightButton setTitle:_heightText forState:UIControlStateNormal];
    }else{
        _ishasWeight = YES;
        [_weightButton setTitle:_weightText forState:UIControlStateNormal];
    }
    
}
- (void)datePickerDone:(UIButton *)button{
    _ishasDate = YES;
    [self setDateButtonTextWithDate:_choseDate];
    [self dismissExBgView];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        _datePickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT);
    } completion:^(BOOL finished) {
        [_datePickerView removeFromSuperview];
    }];
    [_dateButton setTitle:_dateText forState:UIControlStateNormal];
}

#pragma mark - heightPickerViewDelegate
- (void)pickViewDidselecedWithWidthHeightText:(NSString *)text{
    if (_isHeight) {
        _heightText = text;
    }else {
        _weightText = text;
    }
}

- (void)dateSelected:(ADWHDatePickView *)pickView{
    _choseDate = _datePickerView.datePicker.date;
}

- (void)setDateButtonTextWithDate:(NSDate *)date{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSInteger day = [dateComponents day];
    NSInteger month = [dateComponents month];
    NSInteger year = [dateComponents year];
    _dateText = [NSString stringWithFormat:@"%ld.%ld.%ld",(long)year,(long)month,(long)day];
    
    
}

#pragma mark - bgViewShowOrHide
- (void)showBgview
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self.appDelegate.window addSubview:_bgView];
    
    [UIView animateWithDuration:0.3 delay:0
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
                     } completion:^(BOOL finished) {
                     }];
    
    UITapGestureRecognizer *disMissTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissExBgView)];
    [_bgView addGestureRecognizer:disMissTap];
}

- (void)dismissExBgView
{
    _bgView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^ {
        _bgView.alpha = 0;
        _datePickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT);
        _heightPicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT);
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_datePickerView removeFromSuperview];
        [_heightPicker removeFromSuperview];
    }];
}


- (NSInteger)getDecNumberWithTextString:(NSString *)textString{
    
    NSString *str = [textString substringFromIndex:textString.length - 1];
    return [str integerValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
