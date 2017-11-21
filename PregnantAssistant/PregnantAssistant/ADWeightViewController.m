//
//  ADWeightViewController.m
//  PregnantAssistant
//
//  Created by D on 15/4/1.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADWeightViewController.h"
#import "ADUserInfoSaveHelper.h"
#import "ADTableViewCell.h"
@interface ADWeightViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_myTableView;
    ADTableViewCell *cell;
}

@end

@implementation ADWeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _myTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    if (_isWeight) {
        self.myTitle = @"孕前体重";
        _weightArray = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i = 40; i <= 100; i++) {
            [_weightArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
        _dotweightArray = @[@".0", @".1", @".2", @".3", @".4",
                            @".5", @".6", @".7", @".8", @".9"];
        [self addPicker];
        _setWeightPicker.myPicker.delegate = self;
        _setWeightPicker.myPicker.dataSource = self;
    }else{
        self.myTitle = @"身高";
        _heightArray = [NSMutableArray array];
        for (int i = 140; i <= 200; i ++) {
            [_heightArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
        [self addHeightPicker];
        _setHeightPicker.myDatePicker.delegate = self;
        _setHeightPicker.myDatePicker.dataSource = self;
    }

    if (self.heightStr.length == 0 || [self.heightStr isEqualToString:@"0"]) {
        self.heightStr = @"160";
    }
    
    if (self.weightStr.length == 0 || [self.weightStr isEqualToString:@"0"]) {
        self.weightStr = @"40.0";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ADTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID isTextFiele:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self addDisplayLabel];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (void)addDisplayLabel
{
    NSInteger row;
    NSInteger dotRow;
    if (_isWeight) {
        cell.myTitleLable.text = [NSString stringWithFormat:@"%@ kg",_weightStr];
        
        NSString *rowStr = self.weightStr;
        NSString *dotRowStr;
        if ([rowStr myContainsString:@"."]) {
            dotRowStr = [[rowStr componentsSeparatedByString:@"."] lastObject];
            dotRowStr = [dotRowStr substringWithRange:NSMakeRange(0, 1)];
        }
        if ([rowStr myContainsString:@"kg"]) {
            rowStr = [rowStr substringWithRange:NSMakeRange(0, rowStr.length -3)];
        }
        NSLog(@"rowStr:%@", rowStr);
        _bigWeight = [rowStr integerValue];
        row = _bigWeight -40;
        dotRow = dotRowStr.integerValue;
        _dotWeight = dotRow;
        NSLog(@"row:%ld", (long)row);
        if (row < 0) {
            row = 0;
        } else if (row >= _weightArray.count) {
            row = _weightArray.count -1;
        }
        
        [_setWeightPicker.myPicker selectRow:row inComponent:0 animated:NO];
        [_setWeightPicker.myPicker selectRow:dotRow inComponent:1 animated:NO];

    }else{
        if (_heightStr == nil || [_heightStr isEqualToString:@"0 cm"]) {
            cell.myTitleLable.text = @"160 cm";
            _heightStr = @"160";
        }else{
            cell.myTitleLable.text = [NSString stringWithFormat:@"%@ cm",_heightStr];
        }
        NSString *rowStr = [_heightStr copy];
        if ([rowStr myContainsString:@"cm"]) {
            rowStr = [rowStr substringWithRange:NSMakeRange(0, rowStr.length -3)];
        }
        NSLog(@"rowStr:%@", rowStr);
        _bigHeight = [rowStr integerValue];
        row = _bigHeight -140;
        NSLog(@"row:%ld", (long)row);
        if (row < 0) {
            row = 0;
        } else if (row >= _heightArray.count) {
            row = _heightArray.count -1;
        }
        if ([_heightStr isEqualToString:@"0"] || [_heightStr isEqualToString:@""]) {
            [_setHeightPicker.myDatePicker selectRow:20 inComponent:0 animated:NO];
        }else{
            [_setHeightPicker.myDatePicker selectRow:row inComponent:0 animated:NO];
        }
    }
}

- (void)addPicker
{
    _setWeightPicker = [[ADSetWeightPicker alloc] initWithFrame:
                        CGRectMake(0, SCREEN_HEIGHT - 260, SCREEN_WIDTH, 260)];
    
    [self.view addSubview:_setWeightPicker];
    [_setWeightPicker.doneBtn addTarget:self
                                 action:@selector(finishSelect:)
                       forControlEvents:UIControlEventTouchUpInside];
}
- (void)addHeightPicker{
    _setHeightPicker = [[ADSetHeightPicker alloc] initWithFrame:
                        CGRectMake(0, SCREEN_HEIGHT - 260, SCREEN_WIDTH, 260)];
    [self.view addSubview:_setHeightPicker];
    [_setHeightPicker.doneBtn addTarget:self
                                 action:@selector(finishSelect:)
                       forControlEvents:UIControlEventTouchUpInside];

}

- (void)finishSelect:(UIButton *)sender
{
    //save
    if (_isWeight) {
        NSLog(@"a weight:%@", _weightStr);
        [ADUserInfoSaveHelper saveUserWeight:_weightStr];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [ADUserInfoSaveHelper saveUserHeight:_heightStr];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (_isWeight) {
        return 3;
    }
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_isWeight) {
        if (component == 0) {
            return _weightArray.count;
        } else if (component == 1) {
            return _dotweightArray.count;
        } else {
            return 1;
        }
    }
    if (component == 0) {
        return _heightArray.count;
    }
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_isWeight) {
        if (component == 0) {
            return _weightArray[row];
        } else if (component == 1) {
            return _dotweightArray[row];
        } else {
            return @"kg";
        }
    }
    if (component == 0) {
        return _heightArray[row];
    }
    return @"cm";

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_isWeight) {
        if (component == 0) {
            _bigWeight = row +40;
        } else if (component == 1) {
            _dotWeight = row;
        }
        cell.myTitleLable.text = [NSString stringWithFormat:@"%ld.%ldkg", (long)_bigWeight, (long)_dotWeight];
        _weightStr = [NSString stringWithFormat:@"%ld.%ld", (long)_bigWeight, (long)_dotWeight];
    }else{
        if (component ==0) {
            _bigHeight = row + 140;
        }
        cell.myTitleLable.text = [NSString stringWithFormat:@"%ldcm", (long)_bigHeight];
        _heightStr = [NSString stringWithFormat:@"%ld", (long)_bigHeight];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
