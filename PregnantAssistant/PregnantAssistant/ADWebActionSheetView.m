//
//  ADWebActionSheetView.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/25.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADWebActionSheetView.h"

#define titleColor 0x737373

@implementation ADWebActionSheetView{
    UIButton *_backButton;
    NSArray *_shareTitleArray;
    NSArray *_shareImageArray;
    NSArray *_titleArray;
    NSArray *_titleImageArray;
}

- (id)init
{
    self = [super init];
    if (self) {
        _shareTitleArray = [NSArray arrayWithObjects:@"新浪微博", @"微信好友", @"朋友圈", nil];
        _shareImageArray = [NSArray arrayWithObjects:@"微博分享", @"微信", @"朋友圈分享", nil];
        _titleArray = [NSArray arrayWithObjects:@"拷贝链接", @"浏览器中打开", @"刷新", nil];
        _titleImageArray = [NSArray arrayWithObjects:@"拷贝链接", @"浏览器中打开", @"刷新", nil];
        [self addButtonsAndLabels];
    }
    return self;
}

- (instancetype)initWithShareTitleArray:(NSArray *)shareTitleArray shareImageArray:(NSArray *)shareImageArray titleArray:(NSArray *)titleArray titleImageArray:(NSArray *)titleImageArray{
    self = [super init];
    if (self) {
        _shareImageArray = shareImageArray;
        _shareTitleArray = shareTitleArray;
        _titleArray = titleArray;
        _titleImageArray = titleImageArray;
        [self addButtonsAndLabels];
    }
    return self;
}
- (void)addButtonsAndLabels
{
    
    CGFloat iconWidth = 50;
    if (SCREEN_WIDTH > 320) {
        iconWidth = 60;
    }
    
    CGFloat startY = 0;
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_HEIGHT, 40 + (iconWidth + 60)*2.0 + 65);
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, startY, SCREEN_WIDTH - 30, 40 + (iconWidth + 60)*2.0)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, startY, SCREEN_WIDTH - 30, 40)];
    shareLabel.font = [UIFont systemFontOfSize:15];
    shareLabel.textColor = UIColorFromRGB(titleColor);
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.text = @"分享到";
    
    shareLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:shareLabel];
    
    UIView *sharpLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH - 30, 0.6)];
    sharpLineView.backgroundColor = [UIColor separator_gray_line_color];
    [backView addSubview:sharpLineView];
    for (int i = 0; i<_shareImageArray.count; i++) {
        
        if([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        } else {
            if (i != 0) {
                break;
            }
        }
        
        NSString *shareTitle = [_shareTitleArray objectAtIndex:i];
        NSString *shareImage = [_shareImageArray objectAtIndex:i];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 30)*i/3.0, 55 + iconWidth + 5, (SCREEN_WIDTH - 30)/3.0, 20)];
        label.text = shareTitle;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor font_Brown];
        label.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:label];
        
        UIImageView *shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconWidth, iconWidth)];
        shareImageView.center = CGPointMake(label.center.x, label.center.y - 13 - iconWidth/2.0);
        shareImageView.contentMode = UIViewContentModeCenter;
        shareImageView.layer.cornerRadius = 6;
        shareImageView.layer.masksToBounds = YES;
        shareImageView.image = [UIImage imageNamed:shareImage];
        [backView addSubview:shareImageView];
        
        
        UIView *coverView = [[UIControl alloc] initWithFrame:shareImageView.frame];
        coverView.layer.cornerRadius = coverView.frame.size.width / 2.0;
        coverView.layer.masksToBounds = YES;
        coverView.alpha = 0.5;
        coverView.tag = i + 1;
        coverView.backgroundColor = [UIColor clearColor];
        
        [(UIControl *)coverView addTarget:self action:@selector(itemTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [(UIControl *)coverView addTarget:self action:@selector(itemTouchedUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [(UIControl *)coverView addTarget:self action:@selector(itemTouchedDown:) forControlEvents:UIControlEventTouchDown];
        [(UIControl *)coverView addTarget:self action:@selector(itemTouchedCancel:) forControlEvents:UIControlEventTouchCancel];
        
        [backView addSubview:coverView];
    }
    
    UIView *sharpLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, 55 + iconWidth + 10 + 35, SCREEN_WIDTH - 30, 0.6)];
    sharpLine2.backgroundColor = [UIColor separator_gray_line_color];
    [backView addSubview:sharpLine2];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(15, self.frame.size.height - 55, SCREEN_WIDTH - 30, 45)];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitleColor:UIColorFromRGB(titleColor) forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 8;
    [cancelButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.masksToBounds = YES;
    [self addSubview:cancelButton];
    
    for (int i = 0; i< _titleArray.count; i++) {
        NSString *title = [_titleArray objectAtIndex:i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 30)*i/3.0, backView.frame.size.height - 40, (SCREEN_WIDTH - 30)/3.0, 20)];
        label.text = title;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor font_Brown];
        label.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:label];
        
        NSString *imageName = [_titleImageArray objectAtIndex:i];
        UIImageView *shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconWidth, iconWidth)];
        shareImageView.center = CGPointMake(label.center.x, label.center.y - 13 - iconWidth/2.0);
        shareImageView.layer.cornerRadius = 6;
        shareImageView.contentMode = UIViewContentModeCenter;
        shareImageView.layer.masksToBounds = YES;
        shareImageView.image = [UIImage imageNamed:imageName];
        [backView addSubview:shareImageView];
        
        
        UIView *coverView = [[UIControl alloc] initWithFrame:shareImageView.frame];
        coverView.layer.cornerRadius = coverView.frame.size.width / 2.0;
        coverView.layer.masksToBounds = YES;
        coverView.alpha = 0.5;
        coverView.tag = 10 + i;
        coverView.backgroundColor = [UIColor clearColor];
        
        [(UIControl *)coverView addTarget:self action:@selector(itemTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [(UIControl *)coverView addTarget:self action:@selector(itemTouchedUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [(UIControl *)coverView addTarget:self action:@selector(itemTouchedDown:) forControlEvents:UIControlEventTouchDown];
        [(UIControl *)coverView addTarget:self action:@selector(itemTouchedCancel:) forControlEvents:UIControlEventTouchCancel];
        
        [backView addSubview:coverView];
        
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 1;
}

-(void)itemTouchedUpOutside:(UIView *)item
{
    item.backgroundColor = [UIColor clearColor];
}
-(void)itemTouchedDown:(UIView *)item
{
    item.backgroundColor = [UIColor darkGrayColor];
}
- (void)itemTouchedUpInside:(UIView *)item
{
    NSLog(@"%ld",(long)item.tag);
    item.backgroundColor = [UIColor clearColor];
    
    if ([self.delegate respondsToSelector:@selector(clickItemAtIndex:)]) {
        [self.delegate clickItemAtIndex:item.tag];
    }
    [self dismissActionSheet];
}
- (void)itemTouchedCancel:(UIView *)item
{
    item.backgroundColor = [UIColor clearColor];
}

- (void)show
{
    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_backButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventTouchUpInside];
    _backButton.backgroundColor = [UIColor darkGrayColor];
    _backButton.alpha = 0;
    [myApp.window addSubview:_backButton];
    [myApp.window addSubview:self];
    
    [UIView animateWithDuration:0.3 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _backButton.alpha = 0.4;
                         self.frame = CGRectMake(0, SCREEN_HEIGHT - self.frame.size.height, SCREEN_WIDTH, self.frame.size.height);
                     } completion:^(BOOL finished) {
                     }];
    
}

- (void)shareContent:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(clickItemAtIndex:)]) {
        [self.delegate clickItemAtIndex:sender.tag];
    }
    [self dismissActionSheet];
}

- (void)dismissActionSheet
{
    [UIView animateWithDuration:0.3 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _backButton.alpha = 0;
                         self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.frame.size.height);
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [_backButton removeFromSuperview];
                     }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
