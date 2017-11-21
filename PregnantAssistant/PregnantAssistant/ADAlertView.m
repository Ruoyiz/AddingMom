//
//  ADAlertView.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/27.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADAlertView.h"

typedef void (^myblock)(void);

@implementation ADAlertView{
    UIView *_alertView;
    myblock _myBlock;
}

- (id)initWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle
{
    self = [super initWithTitle:title message:nil delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle, nil];
    [self show];
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"点击纯纯粹粹");
    if (buttonIndex == 1) {
        _myBlock();
    }
}

- (void)showWithConfirm:(void (^) (void))confirmBlock
{
    _myBlock = confirmBlock;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
