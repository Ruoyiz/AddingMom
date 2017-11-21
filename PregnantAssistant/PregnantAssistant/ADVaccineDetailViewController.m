//
//  ADVaccineDetailViewController.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADVaccineDetailViewController.h"
#import "SHLUILabel.h"
#import "ADVaccineDAO.h"
#import "ADSetVaccindatePicker.h"

@interface ADVaccineDetailViewController ()

@end

@implementation ADVaccineDetailViewController{
    UIScrollView *_mainScrollView;
    ADVaccineTableViewCell *_cell;
    ADSetVaccindatePicker *_aPicker;
    UILabel *_vaccineDateLabel;
    UILabel *_noteDateLabel;
    
    NSInteger _noteDays;
    
    ADSetVaccineNotePicker *_notePicker;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick event:yimiaotixing_yimiaoxiangqing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    self.myTitle = @"疫苗详情";
    
    [self loadUI];
}

- (void)loadUI
{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_mainScrollView];
    
    [self reloadCell];
    [self addNoteView];
    [self addDesLabel];
    
    for (int i = 0; i<2; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 80 + 90*i, SCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor backColor];
        [_mainScrollView addSubview:view];
    }
}

- (void)reloadCell
{
    if (_cell) {
        [_cell removeFromSuperview];
        _cell = nil;
    }
    
    _vaccineModel = [ADVaccineDAO getVaccineFromName:_vaccineModel.vaccineName];
    
    _cell = [[ADVaccineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    _cell.delegate = self;
    _cell.backgroundColor = [UIColor whiteColor];
    _cell.cellType = _cellType;
    _cell.isDetailCell = YES;
    [_cell setModel:_vaccineModel];
    
    [_mainScrollView addSubview:_cell];
}

- (void)addNoteView
{
    UIView *noteView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 80)];
    noteView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:noteView];
    
    UILabel *vaccineTitleLabel = [self createLabelWithFrame:CGRectMake(15, 10, (SCREEN_WIDTH - 30)/2.0, 30) font:[UIFont ADTitleFontWithSize:16] text:@"接种日期" textColor:[UIColor title_darkblue]];
    [noteView addSubview:vaccineTitleLabel];
    
    UILabel *noteTitleLabel = [self createLabelWithFrame:CGRectMake(15, 40, (SCREEN_WIDTH - 30)/2.0, 30) font:[UIFont ADTitleFontWithSize:16] text:@"提醒时间" textColor:[UIColor title_darkblue]] ;
    [noteView addSubview:noteTitleLabel];
    
    
    _vaccineDateLabel = [self createLabelWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 10, (SCREEN_WIDTH - 30) / 2.0 - 20, 30) font:[UIFont systemFontOfSize:14] text:@"未设置" textColor:[UIColor darkGrayColor]];
    _vaccineDateLabel.textAlignment = NSTextAlignmentRight;
    [noteView addSubview:_vaccineDateLabel];
    
    _noteDateLabel = [self createLabelWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 40, (SCREEN_WIDTH - 30) / 2.0 - 20, 30) font:[UIFont systemFontOfSize:14] text:@"未设置" textColor:[UIColor darkGrayColor]];
    _noteDateLabel.textAlignment = NSTextAlignmentRight;
    [noteView addSubview:_noteDateLabel];
    
    CGFloat startX = _noteDateLabel.frame.origin.x + _noteDateLabel.frame.size.width + 5;
    UIButton *editVaccineDate = [[UIButton alloc] initWithFrame:CGRectMake(startX, 19, 12, 12)];
    [editVaccineDate setImage:[UIImage imageNamed:@"EDIT"] forState:UIControlStateNormal];
    [noteView addSubview:editVaccineDate];
    
    UIButton *editNoteDate = [[UIButton alloc] initWithFrame:CGRectMake(startX, 49, 12, 12)];
    [editNoteDate setImage:[UIImage imageNamed:@"EDIT"] forState:UIControlStateNormal];
    [noteView addSubview:editNoteDate];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateVaccindateDate)];
    _vaccineDateLabel.userInteractionEnabled = YES;
    [_vaccineDateLabel addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateNoteDate)];
    _noteDateLabel.userInteractionEnabled = YES;
    [_noteDateLabel addGestureRecognizer:tap2];
    
    if (![_vaccineModel.vaccindateDateStamp isEqualToString:@"0"]) {
        NSInteger time = [_vaccineModel.vaccindateDateStamp integerValue];
        NSDate *vaccindate = [NSDate dateWithTimeIntervalSince1970:time];
        [self setVaccindateDate:vaccindate];
    }
    
    if (![_vaccineModel.noteDateStamp isEqualToString:@"0"]) {
        NSInteger time = [_vaccineModel.noteDateStamp integerValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        [self setNote:date];
    }
}

- (void)addDesLabel
{
    NSArray *array1 = [_vaccineModel.vaccineDes componentsSeparatedByString:@"【"];
    CGFloat startY = 190;
    
    for (NSString *str in array1) {
        NSArray *array3 = [str componentsSeparatedByString:@"】"];
        if (array3.count == 2) {
            CGRect frame = CGRectMake(15, startY, SCREEN_WIDTH - 30, 30);
            NSString *title = [[array3 firstObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *content = [[array3 lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (title.length != 0) {
                UILabel *titleLabel = [self createLabelWithFrame:frame font:[UIFont ADTitleFontWithSize:16] text:title textColor:[UIColor title_darkblue]];
                [_mainScrollView addSubview:titleLabel];
                startY += 40;
            }
            
            if (content.length != 0) {
                startY += [self createSHLabelWithStartY:startY text:content] + 10;
            }            
        }
    }
    
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, startY);
}

- (CGFloat)createSHLabelWithStartY:(CGFloat)startY text:(NSString *)text
{
    SHLUILabel *contentLab = [[SHLUILabel alloc] init];
    contentLab.backgroundColor = [UIColor whiteColor];
    contentLab.characterSpacing = 1;
    contentLab.linesSpacing = 5;
    contentLab.paragraphSpacing = 0;
    contentLab.font = [UIFont systemFontOfSize:14];
    contentLab.text = text;
    contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    contentLab.numberOfLines = 0;
    contentLab.textColor = [UIColor darkGrayColor];
    CGFloat labelHeight = [contentLab getAttributedStringHeightWidthValue:SCREEN_WIDTH - 30];
    contentLab.frame = CGRectMake(15, startY, SCREEN_WIDTH - 30, labelHeight);
    [_mainScrollView addSubview:contentLab];
    
    return labelHeight;
}

- (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text textColor:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.font = font;
    
    return label;
}

- (void)didClickedTagButtonInCell:(ADVaccineTableViewCell *)cell
{
    if ([_cellType isEqualToString:@"2"]) {
        ADVaccine *model = _vaccineModel;
        NSString *name = [[model.vaccineName componentsSeparatedByString:@" "] firstObject];
        
        NSString *collect = model.isCollected;
        int i = 0;
        
        NSMutableArray *array = [ADVaccineDAO readAllExpenseVaccine];
        
        for (ADVaccine *targetModel in array) {
            NSString *targetName = [[targetModel.vaccineName componentsSeparatedByString:@" "] firstObject];
            if ([targetName isEqualToString:name]) {
                if ([collect isEqualToString:@"0"]) {
                    [ADVaccineDAO modifyVaccine:targetModel collect:@"1" success:^(ADVaccine *newModel) {
                        
                    }];
                }else{
                    [ADVaccineDAO modifyVaccine:targetModel collect:@"0" success:^(ADVaccine *newModel) {
                    }];
                }
            }
            
            i++;
        }
    }
    
    [self reloadCell];
}

- (void)updateVaccindateDate
{
    [self dismissNotePicker];
    
    //NSLog(@"编辑接种日期");
    //ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication]  delegate];
    if (_aPicker == nil) {
        _aPicker = [[ADSetVaccindatePicker alloc] initWithFrame:
                    CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216 +50)];
       
        [self.view addSubview:_aPicker];
    }
    
    
    NSDate *date;//[myApp.babyBirthday dateByAddingDays:days];
    if ([_vaccineModel.vaccindateDateStamp isEqualToString:@"0"]) {
        NSInteger integer = [_vaccineModel.vaccindateDateStr integerValue];
        NSInteger days = integer % 100 + integer / 100 *30 + 1;
        ADAppDelegate *myApp = APP_DELEGATE;
        date = [myApp.babyBirthday dateByAddingDays:days];
    }else{
        
        date = [NSDate dateWithTimeIntervalSince1970:_vaccineModel.vaccindateDateStamp.integerValue];
    }
    _aPicker.myDatePicker.date = date;
    
    [self dateSelected:nil];
    [UIView animateWithDuration:0.62 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _aPicker.frame =
                         CGRectMake(0, SCREEN_HEIGHT -216 -50, SCREEN_WIDTH, 216 +50);
                     } completion:^(BOOL finished) {
                     }];
    
    [_aPicker.myDatePicker addTarget:self
                              action:@selector(dateSelected:)
                    forControlEvents:UIControlEventValueChanged];
    
    [_aPicker.doneBtn addTarget:self
                         action:@selector(finishSelect:)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self reloadCell];
}

- (void)updateNoteDate
{
    if (_aPicker) {
        [self finishSelect:nil];
    }
    [self dissMissApicker];
    //NSLog(@"编辑提醒日期");
    NSArray *array = [_vaccineDateLabel.text componentsSeparatedByString:@"."];
    if (array.count != 3) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先设置接种时间" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 100;
        [alert show];
        return;
    }
    
    if (_notePicker == nil) {
        _notePicker = [[ADSetVaccineNotePicker alloc] initWithFrame:
                    CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216 +50)];
        
        [self.view addSubview:_notePicker];
    }
    
    [UIView animateWithDuration:0.62 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _notePicker.frame =
                         CGRectMake(0, SCREEN_HEIGHT -216 -50, SCREEN_WIDTH, 216 +50);
                     } completion:^(BOOL finished) {
                     }];
    
    [_notePicker.doneBtn addTarget:self
                         action:@selector(finishSelectNote:)
               forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - delegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self updateVaccindateDate];
}

- (void)finishSelectNote:(UIButton *)button
{
    UIPickerView *pickerView = _notePicker.myPicker;
    NSInteger selectOne = [pickerView selectedRowInComponent:0];
    NSInteger selectTwo = [pickerView selectedRowInComponent:1];
    NSInteger selectThr = [pickerView selectedRowInComponent:2];
    _noteDays = selectOne;
    if (selectOne == 2) {
        selectOne = 3;
        _noteDays = 3;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *vaccindate = [dateFormatter dateFromString:_vaccineDateLabel.text];
    
    NSDate *noteDate = [vaccindate dateByAddingDays:-selectOne];
    NSString *noteDateStr = [dateFormatter stringFromDate:noteDate];
    NSString *noteStr = [NSString stringWithFormat:@"%@ %02ld:%02ld",noteDateStr,(long)selectTwo,(long)selectThr];
    _noteDateLabel.text = noteStr;
    
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    
    NSDate *date = [dateFormatter dateFromString:noteStr];

    
    NSInteger stamp = [date timeIntervalSince1970];
    [ADVaccineDAO modifyVaccine:_vaccineModel noteDate:[NSString stringWithFormat:@"%ld",(long)stamp]];
    [self dismissNotePicker];
    
    //[self setLocalNotificationWithDate:date];
    
    NSString *str = @"别忘了去打疫苗";
    NSArray *array = [_vaccineDateLabel.text componentsSeparatedByString:@"."];
    if (array.count == 3) {
        str = [NSString stringWithFormat:@"别忘了%@月%@日去打疫苗",[array objectAtIndex:1],[array lastObject]];
    }
    
    [ADVaccineDAO addANotificationWithName:_vaccineModel.vaccineName noteDate:date noteTitle:str];
}

- (void)dateSelected:(id)sender
{
    [self setVaccindateDate:_aPicker.myDatePicker.date];
}

- (void)finishSelect:(UIButton *)sender
{
    NSString *name = [[_vaccineModel.vaccineName componentsSeparatedByString:@" "] firstObject];
    
    NSArray *vaccineDataArray = [ADVaccineDAO readAllExpenseVaccine];
    
    int i = 0;
    BOOL resetVaccine = NO;
    for (ADVaccine *targetModel in vaccineDataArray) {
        NSString *targetName = [[targetModel.vaccineName componentsSeparatedByString:@" "] firstObject];
        if ([targetName isEqualToString:name]) {
            if (!resetVaccine && [name isEqualToString:@"五联疫苗"]) {
                resetVaccine = YES;
                [ADVaccineDAO resetAllConflictVaccine];
            }
            
            [ADVaccineDAO modifyVaccine:targetModel collect:@"1" success:^(ADVaccine *newModel) {}];
        }
        
        i++;
    }
    
    NSDate *finialDate = [ADHelper modifyToZeroHourMinWithDate:_aPicker.myDatePicker.date];
    NSString *str = [NSString stringWithFormat:@"%ld",(long)[finialDate timeIntervalSince1970]];
    [ADVaccineDAO modifyVaccine:_vaccineModel vaccindeStamp:str];
    
    if (![_vaccineModel.noteDateStamp isEqualToString:@"0"]) {
        NSInteger time = [_vaccineModel.noteDateStamp integerValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        
        NSString *str = @"别忘了去打疫苗";
        NSArray *array = [_vaccineDateLabel.text componentsSeparatedByString:@"."];
        if (array.count == 3) {
            str = [NSString stringWithFormat:@"别忘了%@月%@日去打疫苗",[array objectAtIndex:1],[array lastObject]];
        }
        
        [ADVaccineDAO addANotificationWithName:_vaccineModel.vaccineName noteDate:date noteTitle:str];
    }
    
    [self dissMissApicker];
    //_vaccineModel = [ADVaccineDAO getVaccineFromName:_vaccineModel.vaccineName];
    [self reloadCell];
}

- (void)setVaccindateDate:(NSDate *)date
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSInteger day = [dateComponents day];
    NSInteger month = [dateComponents month];
    NSInteger year = [dateComponents year];
    _vaccineDateLabel.text = [NSString stringWithFormat:@"%ld.%02ld.%02ld",(long)year, (long)month, (long)day];
}

- (void)setNote:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    
    NSString *str = [dateFormatter stringFromDate:date];
    _noteDateLabel.text = str;
    //[self setLocalNotificationWithDate:date];
}

- (void)dismissAllPicker
{
    [self dissMissApicker];
    [self dismissNotePicker];
}

- (void)dissMissApicker
{
    [UIView animateWithDuration:0.3 animations:^{
        _aPicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _aPicker.frame.size.height);
    }];
}

- (void)dismissNotePicker
{
    [UIView animateWithDuration:0.3 animations:^{
        _notePicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _aPicker.frame.size.height);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
