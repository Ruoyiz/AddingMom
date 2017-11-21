//
//  ADRegisterViewController.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/7/6.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADRegisterViewController.h"
#import "ADVerifyViewController.h"
#import "ADLoginNetWork.h"

@interface ADRegisterViewController ()

@end

@implementation ADRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTitle = @"注册";
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    [self loadUI];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)loadUI
{
    NSArray *textArray = [NSArray arrayWithObjects:@"请输入手机号" ,@"请输入密码（6-15个字符）", nil];
    NSArray *imageArray = [NSArray arrayWithObjects:@"手机", @"锁", nil];
    
    CGFloat textHeight = 50;
    CGFloat textFieldFont = 13;
    
    if (SCREEN_HEIGHT >= 667) {
        textHeight = 55;
        textFieldFont = 14;
    }
    
    for (int i = 0 ; i < textArray.count; i++){
        UIImageView *textFieldImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, NAVIBAT_HEIGHT + textHeight * i, 20, textHeight)];
        textFieldImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        textFieldImageView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:textFieldImageView];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(22 + 30, NAVIBAT_HEIGHT + textHeight * i, SCREEN_WIDTH - 44 - 30, textHeight)];
        textField.placeholder = [textArray objectAtIndex:i];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.font = [UIFont ADTraditionalFontWithSize:textFieldFont];
        textField.tag = 100 + i;
        if (i == 0) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            [textField becomeFirstResponder];
        }else{
            textField.keyboardType = UIKeyboardTypeAlphabet;
            textField.secureTextEntry = YES;
        }
        [self.view addSubview:textField];
        
        UIView *sharpView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIBAT_HEIGHT + textHeight * (i + 1) - 0.6, SCREEN_WIDTH, 0.6)];
        sharpView.backgroundColor = [UIColor separator_gray_line_color];
        [self.view addSubview:sharpView];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(70, NAVIBAT_HEIGHT + 30 + 2 * textHeight, SCREEN_WIDTH - 140, textHeight - 10)];
    [button setTitle:@"注册" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont ADTraditionalFontWithSize:16];
    [button setTitleColor:[UIColor tagGreenColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    
    button.layer.cornerRadius = button.frame.size.height / 2.0;
    button.layer.masksToBounds = YES;
    
    button.layer.borderColor = [[UIColor tagGreenColor] CGColor];
    button.layer.borderWidth = 1;
    [self.view addSubview:button];
}

-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

- (void)registerUser
{
    UITextField *phoneTextField = (UITextField *)[self.view viewWithTag:100];
    UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:101];
    
    if(phoneTextField.text.length == 0 || passwordTextField.text.length == 0){
        [ADToastHelp showSVProgressToastWithError:@"账号或密码不可为空"];
        return;
    }
    if(![self isValidateMobile:phoneTextField.text]){
        [ADToastHelp showSVProgressToastWithError:@"手机号不符合要求，请修改"];
        return;
    }
    
    if(passwordTextField.text.length < 6 || passwordTextField.text.length > 15){
        [ADToastHelp showSVProgressToastWithError:@"密码不符合要求，请修改"];
        return;
    }
    
    [phoneTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    [ADToastHelp showSVProgressToastWithTitle:@"正在验证"];
    [ADLoginNetWork registerVirifyWithPhone:phoneTextField.text password:passwordTextField.text success:^(id responseObject) {
        ADVerifyViewController *verifyVC = [[ADVerifyViewController alloc] init];
        verifyVC.phone = phoneTextField.text;
        verifyVC.password = passwordTextField.text;
        verifyVC.loginControl = self.loginControl;
        [self.navigationController pushViewController:verifyVC animated:YES];
    } failure:^(NSString *errorMsg) {
        if ([errorMsg isEqualToString:ConnectError]) {
            [ADToastHelp showSVProgressToastWithError:errorMsg];
        }else if ([errorMsg isEqualToString:@"register existed phone"]) {
            [ADToastHelp showSVProgressToastWithError:@"该手机号已经注册，请直接登录"];
        }else if([errorMsg isEqualToString:@"register invalid password"]){
            [ADToastHelp showSVProgressToastWithError:@"密码不符合要求，请修改"];
        }else{
            [ADToastHelp showSVProgressToastWithError:@"手机号不符合要求，请修改"];
        }
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
