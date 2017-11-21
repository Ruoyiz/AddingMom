//
//  ADShareView.m
//  PregnantAssistant
//
//  Created by D on 14/12/6.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADShareView.h"

#define titleColor 0x737373

@implementation ADShareView

- (id)initWithFrame:(CGRect)frame
        andParentVC:(UIViewController *)aVC
          showTitle:(BOOL)showTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        _parentVc = aVC;
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
    CGFloat actionHeight = 40 + (iconWidth + 60) + 45 + 20;
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_HEIGHT, actionHeight);
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, startY, SCREEN_WIDTH - 30, actionHeight - 65)];
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
    
    UIView *sharpLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH - 30, 1)];
    sharpLineView.backgroundColor = [UIColor separator_gray_line_color];
    [backView addSubview:sharpLineView];
    
    startY = 55 + iconWidth + 10;
    UILabel *weiboLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, startY, (SCREEN_WIDTH - 30)/3.0, 20)];
    weiboLabel.font = [UIFont systemFontOfSize:12];
    weiboLabel.textColor = [UIColor font_Brown];
    weiboLabel.textAlignment = NSTextAlignmentCenter;
    weiboLabel.text = @"新浪微博";
    
    weiboLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:weiboLabel];
    
    UILabel *weixinLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 30)/3.0, startY, (SCREEN_WIDTH - 30)/3.0, 20)];
    weixinLabel.font = [UIFont systemFontOfSize:12];
    weixinLabel.textColor = [UIColor font_Brown];
    weixinLabel.textAlignment = NSTextAlignmentCenter;
    weixinLabel.text = @"微信好友";
    
    weixinLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:weixinLabel];
    
    UILabel *pengyouLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 30)*2/3.0, startY, (SCREEN_WIDTH - 30)/3.0, 20)];
    pengyouLabel.font = [UIFont systemFontOfSize:12];
    pengyouLabel.textColor = [UIColor font_Brown];
    pengyouLabel.textAlignment = NSTextAlignmentCenter;
    pengyouLabel.text = @"朋友圈";
    
    pengyouLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:pengyouLabel];
    
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.tag = 1;
    weiboBtn.frame = CGRectMake(0, 0, iconWidth, iconWidth);
    [weiboBtn setImage:[UIImage imageNamed:@"微博分享"] forState:UIControlStateNormal];
    [weiboBtn addTarget:_parentVc action:@selector(shareContent:) forControlEvents:UIControlEventTouchUpInside];
    weiboBtn.center = CGPointMake(weiboLabel.center.x, weiboLabel.center.y - iconWidth/2.0 - 20);
    [backView addSubview:weiboBtn];
    
    UIButton *weixinBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.tag = 2;
    weixinBtn.frame = CGRectMake(0, 0, iconWidth, iconWidth);
    [weixinBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    weixinBtn.center = CGPointMake(weixinLabel.center.x, weiboLabel.center.y - iconWidth/2.0 - 20);
    [weixinBtn addTarget:_parentVc action:@selector(shareContent:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:weixinBtn];
    
    UIButton *pengyouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pengyouBtn.tag = 3;
    pengyouBtn.frame = CGRectMake(0, 0, iconWidth, iconWidth);
    [pengyouBtn setImage:[UIImage imageNamed:@"朋友圈分享"] forState:UIControlStateNormal];
    [pengyouBtn addTarget:_parentVc action:@selector(shareContent:) forControlEvents:UIControlEventTouchUpInside];
    pengyouBtn.center = CGPointMake(pengyouLabel.center.x, weiboLabel.center.y - iconWidth/2.0 - 20);
    [backView addSubview:pengyouBtn];
//
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(15, self.frame.size.height - 55, SCREEN_WIDTH - 30, 45)];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitleColor:UIColorFromRGB(titleColor) forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 8;
    [cancelButton addTarget:_parentVc action:@selector(dismissActionSheet) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.masksToBounds = YES;
    [self addSubview:cancelButton];
    
    if([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
    } else {
        weixinLabel.hidden = YES;
        pengyouLabel.hidden = YES;
        weixinBtn.hidden = YES;
        pengyouBtn.hidden = YES;
    }

    [UIView animateWithDuration:0.2 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = CGRectMake(0, SCREEN_HEIGHT - actionHeight, SCREEN_WIDTH, actionHeight);
                     } completion:^(BOOL finished) {
                     }];
    
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 1;
}

- (void)shareContent:(UIButton *)sender
{
    
}

- (void)dismissActionSheet
{
    
}
@end
