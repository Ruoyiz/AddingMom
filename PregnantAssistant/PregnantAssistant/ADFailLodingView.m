//
//  ADFailLodingView.m
//  PregnantAssistant
//
//  Created by D on 15/4/9.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADFailLodingView.h"

typedef void (^Myblock)(void);

@implementation ADFailLodingView
{
    Myblock _tapBlock;
}

-(instancetype)initWithFrame:(CGRect)frame tapBlock:(void (^) (void))tapActionBlock
{
    if (self = [super initWithFrame:frame]) {
        _tapBlock = tapActionBlock;
        [self loadUIWithFrame:frame];
    }
    return self;
}

- (void)loadUIWithFrame:(CGRect)frame
{
    UIButton *button = [[UIButton alloc] initWithFrame:self.frame];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(emptyAreaTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageView.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0 - 10);
    imageView.layer.cornerRadius = 25;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:@"update-arrow"];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
    label.center = CGPointMake(frame.size.width/2.0, imageView.center.y + 50);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont ADTraditionalFontWithSize:15];
    label.textColor = [UIColor emptyViewTextColor];
    label.text = @"点击重试";
    [self addSubview:label];
    
    UIView *coverView = [[UIControl alloc] initWithFrame:imageView.frame];
    coverView.layer.cornerRadius = coverView.frame.size.width / 2.0;
    coverView.layer.masksToBounds = YES;
    coverView.alpha = 0.5;

    coverView.backgroundColor = [UIColor clearColor];
    
    [(UIControl *)coverView addTarget:self action:@selector(itemTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [(UIControl *)coverView addTarget:self action:@selector(itemTouchedUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [(UIControl *)coverView addTarget:self action:@selector(itemTouchedDown:) forControlEvents:UIControlEventTouchDown];
    [(UIControl *)coverView addTarget:self action:@selector(itemTouchedCancel:) forControlEvents:UIControlEventTouchCancel];
    [self addSubview:coverView];
}

- (void)emptyAreaTap
{
    if ([self.delegate respondsToSelector:@selector(emptyAreaTaped)]) {
        [self.delegate emptyAreaTaped];
    }
}

- (void)showInView:(UIView *)view
{
    
    [view addSubview:self];
}

- (void)reloadAction
{
    [UIView animateWithDuration:0.4 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         
                         //移除_failLoadingView
                         [self removeFromSuperview];
                         _tapBlock();
                     }];
    
}

-(void)itemTouchedUpOutside:(UIView *)item
{
    item.backgroundColor = [UIColor clearColor];
}
-(void)itemTouchedDown:(UIView *)item
{
    item.backgroundColor = [UIColor whiteColor];
}
- (void)itemTouchedUpInside:(UIView *)item
{
    NSLog(@"%ld",(long)item.tag);
    item.backgroundColor = [UIColor clearColor];
    
    [self reloadAction];
    
}
- (void)itemTouchedCancel:(UIView *)item
{
    item.backgroundColor = [UIColor clearColor];
}



@end
