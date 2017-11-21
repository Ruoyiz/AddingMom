//
//  ADCntFetalView.m
//  PregnantAssistant
//
//  Created by D on 14-10-10.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADCntFetalView.h"
#import "NSTimer+Pausing.h"
#import "NSDate+Utilities.h"

static NSString *VALIDKEY = @"LASTVALIDKEY";
static NSString *ADD1KEY = @"ADD1KEY";
static NSString *SHOW_ONEVIEW_KEY = @"showOneViewkey";

@implementation ADCntFetalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor light_green_Btn];
        [self addButtons];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeFinishButton)
                                                     name:NOTIFICATION_FINISH_ONEHOUR
                                                   object:nil];
    }
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)addButtons
{
    _proCntBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 10, 64, 70)];

    _proCntBtn.backgroundColor = [UIColor dark_green_Btn];
    [_proCntBtn setClipsToBounds:YES];
    [_proCntBtn.layer setCornerRadius:8];

    [_proCntBtn setImage:[UIImage imageNamed:@"专心一小时"] forState:UIControlStateNormal];
    [_proCntBtn setImage:[UIImage imageNamed:@"专心一小时关闭"] forState:UIControlStateSelected];
    [_proCntBtn addTarget:self action:@selector(proButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_proCntBtn];

    _addCntBtn = [[UIButton alloc]initWithFrame:CGRectMake(90, 10, SCREEN_WIDTH -104, 70)];
    [_addCntBtn addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _addCntBtn.backgroundColor = [UIColor dark_green_Btn];
    [_addCntBtn setClipsToBounds:YES];
    [_addCntBtn.layer setCornerRadius:8];
    
    if (iPhone6) {
        _proCntBtn.frame = CGRectMake(18, 10, 75, 70);
        _addCntBtn.frame = CGRectMake(75 +30, 10, SCREEN_WIDTH -48 -75, 70);
    } else if (iPhone6Plus) {
        _proCntBtn.frame = CGRectMake(55/3.0, 10, 247/3.0, 70);
        _addCntBtn.frame = CGRectMake(355/3.0, 10, 833/3.0, 70);
    }

    BOOL everClickAdd1 = [[NSUserDefaults standardUserDefaults]boolForKey:ADD1KEY];

    if (everClickAdd1 == NO) {
        [_addCntBtn setImage:[UIImage imageNamed:@"点击这里记录一次"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ADD1KEY];
    } else {
        [_addCntBtn setImage:[UIImage imageNamed:@"add1"] forState:UIControlStateNormal];
    }

    [self addSubview:_addCntBtn];
}

- (void)changeFinishButton
{
    if (_proCntBtn.selected == YES) {
        NSLog(@"come here once");
        if (_finishBtn.superview == nil) {
            [_proCntBtn removeFromSuperview];
            [_addCntBtn removeFromSuperview];
            
            //add finishBtn
            _finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
            
            [_finishBtn addTarget:self
                           action:@selector(closeOneView)
                 forControlEvents:UIControlEventTouchUpInside];
            
            [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
            _finishBtn.titleLabel.font = [UIFont systemFontOfSize:38];
            [_finishBtn setBackgroundColor:[UIColor dark_green_Btn]];

            [self addSubview:_finishBtn];
        }
    }
}

- (void)proButtonClick:(UIButton *)sender
{
    [self.delegate proButtonClick:sender];
}

- (void)closeOneView
{
    [_finishBtn removeFromSuperview];
    
    [self addSubview:_proCntBtn];
    [self addSubview:_addCntBtn];
    _proCntBtn.selected = NO;
    
    [self.delegate finishProButtonClick];
}

- (void)addButtonClick:(UIButton *)sender
{
    //点击一次后 变 +1
    [_addCntBtn setImage:[UIImage imageNamed:@"add1"] forState:UIControlStateNormal];
    
    [self.delegate addOneBtnClicked:sender];
}

- (void)changeCntBtnToNum
{
    [_addCntBtn setImage:[UIImage imageNamed:@"add1"] forState:UIControlStateNormal];
}

@end
