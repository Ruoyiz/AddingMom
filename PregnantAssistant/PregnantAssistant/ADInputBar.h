//
//  ADInputBar.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/26.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADInputBarDelegate <NSObject>

@optional

- (void)ADTextViewDidChange:(UITextView *)textView;

- (BOOL)ADTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (void)ADTextView:(UITextView *)textView  didClickedSendButton:(UIButton *)button;

- (void)ADTextViewDidChangeSelection:(UITextView *)textView;

@end

@interface ADInputBar : UIView <UITextViewDelegate>

@property (nonatomic,strong) UITextView *inputTextView;

@property (nonatomic,strong) UIButton *sendButton;

@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,assign) id <ADInputBarDelegate> inputDelegate;

- (void)setTextCenter;

@end
