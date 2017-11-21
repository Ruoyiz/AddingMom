//
//  ADActionSheetView.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/4/9.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADActionSheetView.h"

#define BUTTON_INDEX 10000

#define titleColor 0x737373
#define cellHeight  45

@implementation ADActionSheetView{
    UIButton *_backButton;
    NSString *_actionSheetTitle;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithTitleArray:(NSArray *)titleArray cancelTitle:(NSString *)cancelTitle actionSheetTitle:(NSString *)actionSheetTitle
{
    CGFloat actionSheetHeight = cellHeight*(titleArray.count + 2) + 10;
    self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, actionSheetHeight)];
    if (self) {
        _actionSheetTitle = actionSheetTitle;
        _titleArray = [NSMutableArray arrayWithArray:titleArray];
        [_titleArray addObject:cancelTitle];
        [self setUp];
    }
    
    return self;
}

- (void)setUp
{
    for (int i = 0; i < 2; i++) {
        NSInteger titleCount = _titleArray.count;
        CGFloat startPos = 0;
        if (i == 1) {
            startPos = cellHeight * _titleArray.count + 5;
            titleCount = 1;
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, startPos, SCREEN_WIDTH - 30, cellHeight * titleCount)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 6;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
    }
    self.backgroundColor = [UIColor clearColor];
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH- 30, cellHeight)];
    moreLabel.text = _actionSheetTitle;
    moreLabel.textColor = UIColorFromRGB(titleColor);
    moreLabel.textAlignment = NSTextAlignmentCenter;
    moreLabel.font = [UIFont ADTraditionalFontWithSize:15.0];//[UIFont fontWithName:@"RTWSYueGoTrial-Light" size:15.0f];
    moreLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:moreLabel];
    
    CGRect frame = CGRectMake(15, cellHeight, SCREEN_WIDTH - 30, cellHeight);
    
    int i=0;
    for (NSString *title in _titleArray) {
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        [button setTitle:title forState:UIControlStateNormal];
        button.tag = BUTTON_INDEX + i;
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont ADTraditionalFontWithSize:15.0];;
        [button addTarget:self action:@selector(actionSheetClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (i == _titleArray.count - 2) {
            frame.origin.y += cellHeight + 5;
        }else{
            frame.origin.y += cellHeight;
        }
        
        if (i == _titleArray.count - 1) {
            [button setTitleColor:UIColorFromRGB(titleColor) forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor btn_green_bgColor] forState:UIControlStateNormal];
            UIView *underLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 0.6)];
            underLineView.backgroundColor = [UIColor separator_gray_line_color];
            [button addSubview:underLineView];
        }
        i++;
    }
}

- (void)actionSheetClicked:(UIButton *)button
{
    ADAppDelegate *myApp = APP_DELEGATE;
    myApp.isSharing = YES;
    
    [self dismissActionSheet];
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedCustomButtonAtIndex:)]) {
        [self.delegate performSelector:@selector(actionSheet:clickedCustomButtonAtIndex:) withObject:self withObject:[NSNumber numberWithInteger:button.tag - BUTTON_INDEX]];
    }
}

- (void)show
{
    ADAppDelegate *myApp = APP_DELEGATE;
    UIWindow *myWindow = myApp.window;
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backButton.alpha = 0;
    _backButton.backgroundColor = [UIColor blackColor];
    [_backButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [myWindow addSubview:_backButton];
    
    [myWindow addSubview:self];
    
    [UIView animateWithDuration:0.2 delay:0.05 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT - self.frame.size.height, SCREEN_WIDTH, self.frame.size.height);
        _backButton.alpha = 0.3;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissActionSheet
{
    [_backButton removeFromSuperview];
    [UIView animateWithDuration:0.2 delay:0.05 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
