//
//  ADSetNIcknameViewController.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/7/9.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADSetNIcknameViewController.h"
#import "ADTableViewCell.h"
@interface ADSetNIcknameViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{

    UITableView *_myTableView;
    UITextField *_textField;
//    NSString * _textfiledText;
}

@end

@implementation ADSetNIcknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTitle = _isNickNameVC ? @"昵称":@"地区";
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    _myTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_myTableView addGestureRecognizer:tap];
}
#pragma mark - clickMethod
- (void)back{
    if (_isNickNameVC) {
        if ([_textField.text isEqualToString:@""]||[self isallWhitespaceCharacterWithString:_textField.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"昵称不能为空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tap{
    [_textField resignFirstResponder];
}
- (BOOL)isallWhitespaceCharacterWithString:(NSString *)str{
    NSString *temp = [str  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //看剩下的字符串的长度是否为零
    if ([temp length]!=0) {
        return NO;
    }
    return YES;
}
#pragma mark - textfieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_isNickNameVC) {
        [ADUserInfoSaveHelper saveUserName:textField.text];
    }else{
        [ADUserInfoSaveHelper saveUserArea:textField.text];
    }
}
#pragma mark - tableviewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    ADTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ADTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID isTextFiele:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.cellTextField becomeFirstResponder];
    cell.cellTextField.delegate = self;
    cell.cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField = cell.cellTextField;
    if (_isNickNameVC) {
        cell.cellTextField.text = self.nickName;
    }else{
        cell.cellTextField.text = self.area;
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_textField resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [_textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
