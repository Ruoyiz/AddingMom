//
//  ADResetPasswordVC.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/7/8.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADResetPasswordVC.h"
#import "ADLoginNetWork.h"
#import "ADPhoneLoginViewController.h"

@interface ADResetPasswordVC ()

@end

@implementation ADResetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTitle = @"重置密码";
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    [self loadUI];
}

- (void)loadUI
{
    CGFloat textHeight = 50;
    CGFloat textFieldFont = 13;
    
    if (SCREEN_HEIGHT >= 667) {
        textHeight = 55;
        textFieldFont = 14;
    }
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(22, NAVIBAT_HEIGHT, SCREEN_WIDTH - 44, textHeight)];
    textField.placeholder = @"请输入新密码";
    textField.tag = 100;
    textField.font = [UIFont ADTraditionalFontWithSize:textFieldFont];
    textField.keyboardType = UIKeyboardTypeAlphabet;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = YES;
    [self.view addSubview:textField];
    
    UIView *sharpView = [[UIView alloc] initWithFrame:CGRectMake(0, textHeight - 0.6 + NAVIBAT_HEIGHT, SCREEN_WIDTH, 0.6)];
    sharpView.backgroundColor = [UIColor separator_gray_line_color];
    [self.view addSubview:sharpView];
   
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(70, 30 + textHeight + NAVIBAT_HEIGHT, SCREEN_WIDTH - 140 , textHeight - 10)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor tagGreenColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont ADTraditionalFontWithSize:16];
    [button addTarget:self action:@selector(verifyDone:) forControlEvents:UIControlEventTouchUpInside];
    
    button.layer.cornerRadius = button.frame.size.height / 2.0;
    button.layer.masksToBounds = YES;
    
    button.layer.borderColor = [[UIColor tagGreenColor] CGColor];
    button.layer.borderWidth = 1;
    [self.view addSubview:button];
}

- (void)verifyDone:(UIButton *)button
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:100];
    NSString *password = textField.text;
    
    if(password.length < 6 || password.length > 15){
        [ADToastHelp showSVProgressToastWithError:@"密码不符合要求，请修改"];
        return;
    }
    
    [ADToastHelp showSVProgressToastWithTitle:@"正在重置密码"];
    [ADLoginNetWork resetPasswordWithPhone:self.phone password:password codeId:self.codeId code:self.code success:^(id responseObject) {
        
        [ADToastHelp showSVProgressWithSuccess:@"重置密码成功"];
        NSArray *VCArray = self.navigationController.viewControllers;
        for (UIViewController *vc in VCArray) {
            if ([vc isKindOfClass:[ADPhoneLoginViewController class]]) {
                
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    } failure:^(NSString *errorMsg) {
        [ADToastHelp showSVProgressToastWithError:errorMsg];
    }];
//    if (password.length != 0) {
//        
//    }else{
//        [ADToastHelp showSVProgressToastWithError:@"请输入密码"];
//
//    }
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
