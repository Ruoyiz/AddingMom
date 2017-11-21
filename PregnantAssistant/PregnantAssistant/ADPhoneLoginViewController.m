//
//  ADPhoneLoginViewController.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/7/6.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADPhoneLoginViewController.h"
#import "ADRegisterViewController.h"
#import "ADLoginNetWork.h"
#import "ADToastHelp.h"
#import "ADUserInfoListVC.h"
#import "ADForgetViewController.h"
#import "ADNavigationController.h"

@interface ADPhoneLoginViewController ()

@end

@implementation ADPhoneLoginViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTitle = @"登录";
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    UIButton *rightItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightItemButton setTitle:@"注册" forState:UIControlStateNormal];
    [rightItemButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    rightItemButton.titleLabel.font = [UIFont ADTraditionalFontWithSize:15];
    [rightItemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(rightItemMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    
    [self loadUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UITextField *textField = (UITextField *)[self.view viewWithTag:100];
    [textField becomeFirstResponder];
}

- (void)loadUI
{
    
    NSArray *textArray = [NSArray arrayWithObjects:@"请输入手机号" ,@"请输入密码", nil];
    NSArray *imageArray = [NSArray arrayWithObjects:@"手机", @"锁", nil];
    
    CGFloat textHeight = 50;
    CGFloat textFieldFont = 13;
    
    if (SCREEN_HEIGHT >= 667) {
        textHeight = 55;
        textFieldFont = 14;
    }
    
    for (int i = 0 ; i < textArray.count; i++){
        
        UIImageView *textFieldImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22,NAVIBAT_HEIGHT + textHeight * i, 20, textHeight)];
        textFieldImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        textFieldImageView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:textFieldImageView];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(22 + 30, NAVIBAT_HEIGHT + textHeight * i, SCREEN_WIDTH - 44 - 30, textHeight)];
        textField.placeholder = [textArray objectAtIndex:i];
        textField.font = [UIFont ADTraditionalFontWithSize:textFieldFont];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.tag = 100 + i;
        if (i == 0) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }else{
            textField.keyboardType = UIKeyboardTypeAlphabet;
            textField.secureTextEntry = YES;
        }
        [self.view addSubview:textField];
        
        UIView *sharpView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIBAT_HEIGHT + textHeight * (i + 1) - 0.6, SCREEN_WIDTH, 0.6)];
        sharpView.backgroundColor = [UIColor separator_gray_line_color];
        [self.view addSubview:sharpView];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(70, NAVIBAT_HEIGHT + 30 + 3 * textHeight - 20, SCREEN_WIDTH - 140, textHeight - 10)];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont ADTraditionalFontWithSize:16];
    [button setTitleColor:[UIColor tagGreenColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    button.layer.cornerRadius = button.frame.size.height / 2.0;
    button.layer.masksToBounds = YES;
    
    button.layer.borderColor = [[UIColor tagGreenColor] CGColor];
    button.layer.borderWidth = 1;
    [self.view addSubview:button];
    
    UIButton *resetSecButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120 - 15, NAVIBAT_HEIGHT + textHeight + textHeight, 120, textHeight)];
    [resetSecButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    resetSecButton.titleLabel.font = [UIFont ADTraditionalFontWithSize:13];
    [resetSecButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    resetSecButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [resetSecButton addTarget:self action:@selector(forgetSecret) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetSecButton];
}

- (void)login
{
    UITextField *phoneTextField = (UITextField *)[self.view viewWithTag:100];
    UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:101];
    
    if(phoneTextField.text.length == 0 || passwordTextField.text.length == 0){
        [ADToastHelp showSVProgressToastWithError:@"账号或密码不可为空"];
        return;
    }
    if(![self isValidateMobile:phoneTextField.text] || passwordTextField.text.length < 6 || passwordTextField.text.length > 15){
        [ADToastHelp showSVProgressToastWithError:@"账号或密码不正确"];
        return;
    }
    
    [phoneTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [self changeBackBtnEnable:NO];
    [ADToastHelp showSVProgressToastWithTitle:@"正在登录"];
    [ADLoginNetWork loginWithPhone:phoneTextField.text password:passwordTextField.text success:^(id responseObject) {
        [ADToastHelp showSVProgressWithSuccess:@"登录成功"];
        [self changeBackBtnEnable:YES];
        [self performSelector:@selector(loginSuccess) withObject:nil afterDelay:0.2];
    } failure:^(NSString *errorMsg) {
        NSLog(@"%@",errorMsg);
        [ADToastHelp showSVProgressToastWithError:errorMsg];
        [self changeBackBtnEnable:YES];
    }];
}

- (void)changeBackBtnEnable:(BOOL)aStatus
{
    self.navigationItem.leftBarButtonItem.enabled = aStatus;
    ADNavigationController *nc = (ADNavigationController *)self.navigationController;
    if ([nc isKindOfClass:[ADNavigationController class]]) {
        nc.canDragBack = aStatus;
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

- (void)loginSuccess
{
    [self.loginControl addingLoginSuccessfull];
}

- (void)rightItemMethod:(UIButton *)button
{
    ADRegisterViewController *rvc = [[ADRegisterViewController alloc] init];
    rvc.loginControl = self.loginControl;
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)forgetSecret
{
    NSLog(@"忘记密码");
    ADForgetViewController *fvc = [[ADForgetViewController alloc] init];
    fvc.loginControl = self.loginControl;
    [self.navigationController pushViewController:fvc animated:YES];
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
