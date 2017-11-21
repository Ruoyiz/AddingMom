//
//  ADAlertView.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/27.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADAlertView : UIAlertView <UIAlertViewDelegate>

//@property (nonatomic,strong) NSString *title;
//
//@property (nonatomic,strong) NSString *confirmTitle;
//
//@property (nonatomic,strong) NSString *cancelTitle;

- (id)initWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle;

- (void)showWithConfirm:(void (^) (void))confirmBlock;

@end
