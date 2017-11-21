//
//  ADForgetViewController.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/7/8.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADForgetViewController.h"
#import "ADLoginNetWork.h"
#import "ADResetPasswordVC.h"

@interface ADForgetViewController ()

@end

@implementation ADForgetViewController{
    
    NSTimer *_timer;
    
    CGFloat _totolCount;
    
    UIButton *_resendButton;
    
    NSString *_codeId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTitle = @"重置密码";
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    _totolCount = 60;
    [self loadUI];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)sendRequest
{
    [ADToastHelp showSVProgressToastWithTitle:@"正在发送"];
    [ADLoginNetWork sendPhoneCodeWithPhone:self.phone password:nil type:@"findPassword" success:^(id responseObject) {
        [ADToastHelp dismissSVProgress];
        
        UITextField *codeTextField = (UITextField *)[self.view viewWithTag:200];
        
        if (!codeTextField) {
            
            NSLog(@"加载验证textField");
            [self loadVerifyView];
        }
        
        _codeId = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"codeId"]];
    } failure:^(NSString *errorMsg) {
        
        [ADToastHelp showSVProgressToastWithError:errorMsg];

        [_timer setFireDate:[NSDate distantFuture]];
        [_resendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_resendButton setTitleColor:[UIColor tagGreenColor] forState:UIControlStateNormal];
        _resendButton.layer.borderColor = [[UIColor tagGreenColor] CGColor];
        
        _totolCount = 60;
        _resendButton.enabled = YES;
        
    }];
}

- (void)loadUI
{
    CGFloat textHeight = 50;
    CGFloat textFieldFont = 13;
    CGFloat resendHeight = 30;
    CGFloat resendWdth = 105;
    
    if (SCREEN_HEIGHT >= 667) {
        textHeight = 55;
        textFieldFont = 13;
        resendHeight = 34;
        resendWdth = 115;
    }
    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(22, NAVIBAT_HEIGHT, SCREEN_WIDTH - 44 - resendWdth - 15, textHeight)];
    textField.placeholder = @"请输入手机号";
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.font = [UIFont ADTraditionalFontWithSize:textFieldFont];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.tag = 100;
    [textField becomeFirstResponder];
    [self.view addSubview:textField];
    
    UIView *sharpView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIBAT_HEIGHT + textHeight - 0.6, SCREEN_WIDTH, 0.6)];
    sharpView.backgroundColor = [UIColor separator_gray_line_color];
    [self.view addSubview:sharpView];
    
    _resendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, resendWdth, resendHeight)];
    _resendButton.center = CGPointMake(SCREEN_WIDTH - 22 - _resendButton.frame.size.width / 2.0, NAVIBAT_HEIGHT + textHeight / 2.0);
    _resendButton.backgroundColor = [UIColor whiteColor];
    [_resendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_resendButton setTitleColor:[UIColor tagGreenColor] forState:UIControlStateNormal];
    _resendButton.titleLabel.font = [UIFont ADTraditionalFontWithSize:textFieldFont + 1];
    [_resendButton addTarget:self action:@selector(resendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    
    _resendButton.layer.cornerRadius = _resendButton.frame.size.height / 2.0;
    _resendButton.layer.masksToBounds = YES;
    _resendButton.layer.borderColor = [[UIColor tagGreenColor] CGColor];
    _resendButton.layer.borderWidth = 1;
    
    _resendButton.enabled = YES;
    
    [self.view addSubview:_resendButton];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCount:) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)loadVerifyView
{
    CGFloat textHeight = 50;
    CGFloat textFieldFont = 13;
    
    if (SCREEN_HEIGHT >= 667) {
        textHeight = 55;
        textFieldFont = 14;
    }
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(22, textHeight + NAVIBAT_HEIGHT, SCREEN_WIDTH - 44, textHeight)];
    textField.placeholder = @"请输入验证码";
    textField.tag = 200;
    textField.font = [UIFont ADTraditionalFontWithSize:textFieldFont];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField becomeFirstResponder];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:textField];
    
    UIView *sharpView = [[UIView alloc] initWithFrame:CGRectMake(0, textHeight * 2 - 0.6 + NAVIBAT_HEIGHT, SCREEN_WIDTH, 0.6)];
    sharpView.backgroundColor = [UIColor separator_gray_line_color];
    [self.view addSubview:sharpView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(70, NAVIBAT_HEIGHT + 30 + 2 * textHeight, SCREEN_WIDTH - 140, textHeight - 10)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont ADTraditionalFontWithSize:16];
    [button setTitleColor:[UIColor tagGreenColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(verifyDone:) forControlEvents:UIControlEventTouchUpInside];
    
    button.layer.cornerRadius = button.frame.size.height / 2.0;
    button.layer.masksToBounds = YES;
    
    button.layer.borderColor = [[UIColor tagGreenColor] CGColor];
    button.layer.borderWidth = 1;
    [self.view addSubview:button];
}

- (void)timeCount:(NSTimer *)timer
{
    if (_totolCount > 0) {
        _totolCount--;
        [_resendButton setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)_totolCount] forState:UIControlStateNormal];
        _resendButton.enabled = NO;
    }else{
        [_resendButton setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
        [_resendButton setTitleColor:[UIColor tagGreenColor] forState:UIControlStateNormal];
        _resendButton.backgroundColor = [UIColor whiteColor];
        _resendButton.layer.borderColor = [[UIColor tagGreenColor] CGColor];
        _resendButton.enabled = YES;
        [_timer setFireDate:[NSDate distantFuture]];
        _totolCount = 60;
    }
}

- (void)verifyDone:(UIButton *)button
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:200];
    if (textField.text.length != 0 && _codeId != nil) {
        button.enabled = NO;
        [textField resignFirstResponder];
        NSString *code = textField.text;
        [ADToastHelp showSVProgressToastWithTitle:@"正在验证"];
        [ADLoginNetWork VerifyPhoneCodeWithCode:code phone:self.phone codeId:_codeId success:^(id responseObject) {
            button.enabled = YES;
            [SVProgressHUD dismiss];
            
            ADResetPasswordVC *rvc = [[ADResetPasswordVC alloc] init];
            rvc.phone = self.phone;
            rvc.code = code;
            rvc.codeId = _codeId;
            [self.navigationController pushViewController:rvc animated:YES];
            
        } failure:^(NSString *errorMsg) {
            
            button.enabled = YES;
            [ADToastHelp showSVProgressToastWithError:errorMsg];
        }];
        
    }else if(_codeId == nil){
        [ADToastHelp showSVProgressToastWithError:@"验证码错误"];
    }else{
        [ADToastHelp showSVProgressToastWithError:@"请输入验证码"];
    }
}

-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

- (void)resendVerifyCode
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:100];

    if (textField.text.length == 0) {
        
        [ADToastHelp showSVProgressToastWithError:@"请输入手机号"];
        return;
    }
    
    if(![self isValidateMobile:textField.text]){
        [ADToastHelp showSVProgressToastWithError:@"请输入正确的手机号"];
        return;
    }
    
    self.phone = textField.text;
    [self sendRequest];
    
    _resendButton.enabled = NO;
    _resendButton.backgroundColor = [UIColor whiteColor];
    _resendButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [_resendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_resendButton setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)_totolCount] forState:UIControlStateNormal];
    
    [_timer setFireDate:[NSDate distantPast]];
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
