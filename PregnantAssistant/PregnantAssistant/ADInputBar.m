//
//  ADInputBar.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/26.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADInputBar.h"
#import "ADUserInfoSaveHelper.h"

@implementation ADInputBar{
    CGRect _originFrame;
    CGFloat _originHeight;
    UIView *_textBackView;
    
    NSInteger _newTextLength;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 60);
    self = [super initWithFrame:frame];
    if (self) {
        _originFrame = frame;
        _originHeight = frame.size.height;
        [self loadTextView];
    }
    
    return self;
}

- (id)init
{
    CGRect frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 60);
    self = [super initWithFrame:frame];
    if (self) {
        _originFrame = frame;
        [self loadTextView];
    }
    return self;
}

- (void)loadTextView
{
    CGFloat iconWidth = 50 - 16;
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, iconWidth, iconWidth)];
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    if ([uid isEqualToString:@"0"]) {
        icon.image = [UIImage imageNamed:@"无头像"];
    }else{
        icon.image = [ADUserInfoSaveHelper readIconData];
    }
    icon.layer.cornerRadius = iconWidth / 2.0;
    icon.layer.masksToBounds = YES;
    [self addSubview:icon];
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [[UIColor separator_gray_line_color] CGColor];
    self.layer.borderWidth = 1;
    
    _textBackView = [[UIView alloc] initWithFrame:CGRectMake(30 + iconWidth, 5, SCREEN_WIDTH - 2 * (30 + iconWidth), 50)];
    _textBackView.backgroundColor = [UIColor whiteColor];
//    _textBackView.layer.cornerRadius = 8;
//    _textBackView.layer.masksToBounds = YES;
//    _textBackView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    _textBackView.layer.borderWidth = 1;
    [self addSubview:_textBackView];
    
    _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, _textBackView.frame.size.width - 10, 40)];
    _inputTextView.delegate = self;
    _inputTextView.font = [UIFont systemFontOfSize:16];
    [_textBackView addSubview:_inputTextView];
    _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - iconWidth, 0, iconWidth + 15, 50)];
    [_sendButton setTitleColor:[UIColor btn_green_bgColor] forState:UIControlStateNormal];
    _sendButton.titleLabel.font = [UIFont ADTraditionalFontWithSize:15];
    [_sendButton addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton setTitle:@"发表" forState:UIControlStateNormal];
    [self addSubview:_sendButton];
}

- (void)setTextCenter
{
    CGSize constraintSize = CGSizeMake(_inputTextView.frame.size.width, MAXFLOAT);
    CGSize size = [_inputTextView sizeThatFits:constraintSize];
    CGFloat contentHeight = size.height;
    
    CGFloat oldHeight = self.frame.size.height;
    CGFloat newHeight = contentHeight + 20;
    
    [UIView animateWithDuration:0.3 animations:^{
        if (oldHeight != newHeight) {
            self.frame = CGRectMake(0, self.frame.origin.y - (newHeight - oldHeight), SCREEN_WIDTH, newHeight);
        }
        _textBackView.frame = CGRectMake(_textBackView.frame.origin.x, _textBackView.frame.origin.y, _textBackView.frame.size.width, contentHeight + 10);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _inputTextView.frame = CGRectMake(5, 5, _inputTextView.frame.size.width, contentHeight);
        }];
    }];
    
}

#pragma mark - textView 代理
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"did");
    [self setTextCenter];
        
    if ([self.inputDelegate respondsToSelector:@selector(ADTextViewDidChange:)]) {
        [self.inputDelegate ADTextViewDidChange:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    _newTextLength = text.length;
    if ([self.inputDelegate respondsToSelector:@selector(ADTextView:shouldChangeTextInRange:replacementText:)]) {
        return [self.inputDelegate ADTextView:textView shouldChangeTextInRange:range replacementText:text];
    }
    
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if ([self.inputDelegate respondsToSelector:@selector(ADTextView:didClickedSendButton:)]) {
        [self.inputDelegate ADTextViewDidChangeSelection:textView];
    }
}

#pragma mark - 按钮点击事件
- (void)sendComment:(UIButton *)button
{
    if ([self.inputDelegate respondsToSelector:@selector(ADTextView:didClickedSendButton:)]) {
        [self.inputDelegate ADTextView:_inputTextView didClickedSendButton:button];
    }
}

@end
