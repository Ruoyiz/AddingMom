//
//  ADVerifyViewController.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/7/6.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADVerifyViewController.h"
#import "ADLoginNetWork.h"
#import "ADNavigationController.h"

@interface ADVerifyViewController ()

@end

@implementation ADVerifyViewController{
    NSTimer *_timer;
    
    CGFloat _totolCount;
    
    UIButton *_resendButton;
    
    NSString *_codeId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTitle = @"手机号验证";
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    _totolCount = 60;
    [self loadUI];
    
    [self sendRequest];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)sendRequest
{
    [ADLoginNetWork sendPhoneCodeWithPhone:self.phone password:self.password type:@"register" success:^(id responseObject) {
        
        _codeId = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"codeId"]];
    } failure:^(NSString *errorMsg) {
        
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
    textField.placeholder = @"请输入收到的验证码";
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = [UIFont ADTraditionalFontWithSize:textFieldFont];
    textField.tag = 100;
    [textField becomeFirstResponder];
    [self.view addSubview:textField];
    
    UIView *sharpView = [[UIView alloc] initWithFrame:CGRectMake(0, textHeight - 0.6 + NAVIBAT_HEIGHT, SCREEN_WIDTH, 0.6)];
    sharpView.backgroundColor = [UIColor separator_gray_line_color];
    [self.view addSubview:sharpView];
    
    _resendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, resendWdth, resendHeight)];
    _resendButton.center = CGPointMake(SCREEN_WIDTH - 22 - _resendButton.frame.size.width / 2.0, NAVIBAT_HEIGHT + textHeight / 2.0);
    _resendButton.backgroundColor = [UIColor whiteColor];
    [_resendButton setTitle:@"重新发送(60)" forState:UIControlStateNormal];
    [_resendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _resendButton.titleLabel.font = [UIFont ADTraditionalFontWithSize:textFieldFont + 1];
    [_resendButton addTarget:self action:@selector(resendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    
    _resendButton.layer.cornerRadius = _resendButton.frame.size.height / 2.0;
    _resendButton.layer.masksToBounds = YES;
    _resendButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _resendButton.layer.borderWidth = 1;
    
    _resendButton.enabled = NO;
        
    [self.view addSubview:_resendButton];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(70, 30 + textHeight + NAVIBAT_HEIGHT, SCREEN_WIDTH - 140, textHeight - 10)];
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
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCount:) userInfo:nil repeats:YES];//[NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeCount:) userInfo:nil repeats:YES];
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

- (void)changeBackBtnEnable:(BOOL)aStatus
{
    self.navigationItem.leftBarButtonItem.enabled = aStatus;
    ADNavigationController *nc = (ADNavigationController *)self.navigationController;
    if ([nc isKindOfClass:[ADNavigationController class]]) {
        nc.canDragBack = aStatus;
    }
}

- (void)verifyDone:(UIButton *)button
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:100];
    if (textField.text.length != 0 && _codeId != nil) {
        button.enabled = NO;
        [textField resignFirstResponder];
        [self changeBackBtnEnable:NO];
        [ADToastHelp showSVProgressToastWithTitle:@"正在注册"];
        [ADLoginNetWork registerWithPhone:self.phone password:self.password codeId:_codeId code:textField.text success:^(id responseObject) {
            NSString *uid = [responseObject objectForKey:@"uid"];
            if (![uid isEqual:[NSNull null]]) {
                
                //注册完成直接登录
                [[NSUserDefaults standardUserDefaults] setAddingUid:[NSString stringWithFormat:@"%@",uid]];
                [ADLoginNetWork loginWithPhone:self.phone password:self.password success:^(id responseObject) {
                    [ADToastHelp showSVProgressWithSuccess:@"注册成功"];
                    [self changeBackBtnEnable:YES];
                    [self performSelector:@selector(addingLoginSuccessful) withObject:nil afterDelay:0.2];
                } failure:^(NSString *errorMsg) {
                    [self loginFailureWithMsg:errorMsg];
                    [self changeBackBtnEnable:YES];
                }];
            }
            button.enabled = YES;
        } failure:^(NSString *errorMsg) {
            
            NSLog(@"验证错误 %@",errorMsg);
            button.enabled = YES;
            
            [self loginFailureWithMsg:errorMsg];
        }];
    }else if(_codeId == nil){
        [ADToastHelp showSVProgressToastWithError:@"验证码错误"];
    }else{
        [ADToastHelp showSVProgressToastWithError:@"请输入验证码"];
    }
}

- (void)resendVerifyCode
{
    [self sendRequest];
    
    _resendButton.enabled = NO;
    _resendButton.backgroundColor = [UIColor whiteColor];
    _resendButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [_resendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_resendButton setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)_totolCount] forState:UIControlStateNormal];
    
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)addingLoginSuccessful
{
    [self.loginControl addingLoginSuccessfull];
}

- (void)loginFailureWithMsg:(NSString *)msg
{
    if([msg isEqualToString:@"invalid code"]){
        [ADToastHelp showSVProgressToastWithError:@"验证码错误"];
    }else if ([msg isEqualToString:@"register existed phone"]){
        [ADToastHelp showSVProgressToastWithError:@"手机号已经注册，请登录"];
    }
    else{
        [ADToastHelp showSVProgressToastWithError:ConnectError];

    }
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
