//
//  ADLoadingView.m
//  PregnantAssistant
//
//  Created by yitu on 15/3/10.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADLoadingView.h"
@interface ADLoadingView(){
    UIImageView *_logoView;
}
@property(nonatomic,strong)UIImageView *loadingImageView;
@property(nonatomic,strong)NSMutableArray *loadingImagesArray;
@end

#define ADLOADINGVIEW_ANIMATION_TIME 1.1f
@implementation ADLoadingView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.loadingImagesArray = [NSMutableArray arrayWithCapacity:1];
        
        for (int i = 1; i <= 11; i++) {
            [_loadingImagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"list_loading_%02d",i]]];
        }
        for (int i = 11; i >= 1; i--) {
            [_loadingImagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"list_loading_%02d",i]]];
        }
        
//        _logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 217 /3., 16)];
//        [self addSubview:_logoView];
//        _logoView.image = [UIImage imageNamed:@"加丁妈妈"];
//        _logoView.center = CGPointMake(SCREEN_WIDTH /2., SCREEN_HEIGHT - 160);
        [self crateSubviewsWithFrame:frame];
    }
    return self;
}

- (void)crateSubviewsWithFrame:(CGRect)frame
{
    self.backgroundColor = [UIColor whiteColor];
    self.loadingImageView = [[UIImageView alloc] init];//WithImage:[UIImage imageNamed:@"load_%001"]];
    _loadingImageView.frame = CGRectMake(0, 0, frame.size.width, 200);
    _loadingImageView.contentMode = UIViewContentModeCenter;
    
//    if ([ADHelper isIphone4]) {
//        _loadingImageView.center = CGPointMake(frame.size.width/2, frame.size.height/2 - 54);
//    } else {
//        _loadingImageView.center = CGPointMake(frame.size.width/2, frame.size.height/2 - 90);
//    }
    
    _loadingImageView.center = CGPointMake(frame.size.width/2.0, frame.size.height / 2.0 - 10);
    [self addSubview:_loadingImageView];
    
    _loadingImageView.animationDuration = ADLOADINGVIEW_ANIMATION_TIME;
    [_loadingImageView setAnimationImages:_loadingImagesArray];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
    label.center = CGPointMake(frame.size.width/2.0, _loadingImageView.center.y + 50);
    label.text = @"载入中";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont ADTraditionalFontWithSize:15];
    label.textColor = [UIColor emptyViewTextColor];
    [self addSubview:label];
    
    [self adLodingViewStartAnimating];
}

- (void)adLodingViewStartAnimating
{
    if ([_loadingImageView isAnimating]) {
        [_loadingImageView stopAnimating];
    }
    
    [_loadingImageView startAnimating];
    
}
- (void)adLodingViewStopAnimating
{
    [_loadingImageView stopAnimating];
    _loadingImageView = nil;
}
- (void)stopAnimation{
    [_loadingImageView stopAnimating];
    [_loadingImageView removeFromSuperview];
    [_logoView removeFromSuperview];
    [self removeFromSuperview];
}

@end
