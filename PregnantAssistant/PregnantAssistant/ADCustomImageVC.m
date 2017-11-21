//
//  ADCustomImageVC.m
//  PregnantAssistant
//
//  Created by D on 15/1/17.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADCustomImageVC.h"
#import <SDWebImageDownloader.h>

typedef void (^FinishImgRequstBlock)(UIImage *);

@implementation ADCustomImageVC

-(void)dealloc
{
}

- (instancetype)initWithImgUrls:(NSArray *)aUrlArray
                andCurrentIndex:(NSInteger)aInx
                  andCurrentImg:(UIImage *)currentImg
{
    if (self = [super init]) {
        _imgUrl = aUrlArray;
        _currentInx = aInx;
//        _currentImgView = [[ADZoomImgView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *aInx, 0,
//                                                                         SCREEN_WIDTH, SCREEN_HEIGHT)
//                                                       andImg:currentImg];
    }
    return self;
}

- (void)addPageScrollView
{
    _pageScroll = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _pageScroll.backgroundColor = [UIColor blackColor];
    _pageScroll.contentSize = CGSizeMake(_imgUrl.count *self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_pageScroll];
    _pageScroll.bounces = YES;
    _pageScroll.alwaysBounceHorizontal = YES;
    _pageScroll.showsHorizontalScrollIndicator = NO;
    _pageScroll.showsVerticalScrollIndicator = NO;
    _pageScroll.pagingEnabled = YES;
    self.pageScroll.delegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self addPageScrollView];
    
//    [_pageScroll addSubview:_currentImgView];
    //先load 选中的图片 再接着加载 循环之后
    NSString *currentUrlStr = _imgUrl[_currentInx];
    
    [self addIndicatorAtView:self.view];
    [self loadImgWithURLStr:currentUrlStr onFinish:^(UIImage * resultImg) {
        NSInteger aInx = [_imgUrl indexOfObject:currentUrlStr];
        _currentImgView =
        [[ADZoomImgView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *aInx, 0,
                                                       SCREEN_WIDTH, SCREEN_HEIGHT)
                                     andImg:resultImg];
        
        [_pageScroll addSubview:_currentImgView];
    
        [self removeIndicatorAtview];
        for (NSString *aUrl in _imgUrl) {
            if (aUrl != currentUrlStr) {
                [self loadImgWithURLStr:aUrl onFinish:^(UIImage *resImg) {
                        NSInteger aInx = [_imgUrl indexOfObject:aUrl];
                        ADZoomImgView *aZoomImg =
                        [[ADZoomImgView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *aInx, 0,
                                                                       SCREEN_WIDTH, SCREEN_HEIGHT)
                                                     andImg:resImg];
                        [_pageScroll addSubview:aZoomImg];
                }];
            }
        }
    }];

    UITapGestureRecognizer *aTapGes =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg:)];
    
    [self.view addGestureRecognizer:aTapGes];

    if (_imgUrl.count > 1) {
        self.pagePotControl = [[UIPageControl alloc] init];
        if (RETINA_INCH4) {
            self.pagePotControl.frame =
            CGRectMake((SCREEN_WIDTH - 220)/2, SCREEN_HEIGHT - 44, 220, 30);
        } else if (IS_IPHONE_6_PLUS || IS_IPHONE_6) {
            self.pagePotControl.frame =
            CGRectMake((SCREEN_WIDTH- 220)/2, SCREEN_HEIGHT - 52, 220, 30);
        }  else {
            self.pagePotControl.frame =
            CGRectMake((SCREEN_WIDTH - 220)/2, SCREEN_HEIGHT - 32, 220, 30);
        }
        
        _pagePotControl.numberOfPages = _imgUrl.count;
        _pagePotControl.pageIndicatorTintColor = UIColorFromRGB(0xFFC7CF);
        _pagePotControl.currentPageIndicatorTintColor = UIColorFromRGB(0xFF7685);
        [_pagePotControl addTarget:self
                            action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_pagePotControl];
        
        [_pageScroll setContentOffset:CGPointMake(SCREEN_WIDTH * _currentInx, 0)
                             animated:NO];
        _pagePotControl.currentPage = _currentInx;
    }
}

- (void)addIndicatorAtView:(UIView *)aView
{
    _aProgressView = [[UCZProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _aProgressView.translatesAutoresizingMaskIntoConstraints = NO;
    _aProgressView.center = CGPointMake(SCREEN_WIDTH /2.0, SCREEN_HEIGHT /2.0 -8);
    _aProgressView.indeterminate = YES;
    _aProgressView.backgroundView.backgroundColor = [UIColor clearColor];
    _aProgressView.tintColor = [UIColor defaultTintColor];
    [aView addSubview:_aProgressView];
}

- (void)removeIndicatorAtview{
    if (_aProgressView) {
        [_aProgressView removeFromSuperview];
        _aProgressView = nil;
    }
}

- (void)loadImgWithURLStr:(NSString *)aUrlStr
                 onFinish:(FinishImgRequstBlock)aFinishBlock
{
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:aUrlStr]
                                                        options:0
                                                       progress:
     ^(NSInteger receivedSize, NSInteger expectedSize) {
     }
                                                      completed:
     ^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
         if (image && finished) {
             if (aFinishBlock) {
                 aFinishBlock(image);
             }
         }
     }];
}

- (void)tapImg:(UITapGestureRecognizer *)aGes
{
    [[NSNotificationCenter defaultCenter] postNotificationName:tapImgNotification object:nil];
}

- (void)changePage:(UIPageControl *)pageContol
{
    [self.pageScroll setContentOffset:CGPointMake(SCREEN_WIDTH * pageContol.currentPage, 0)
                             animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //图片滚动  pageCtroll滚动
    CGFloat harfWidth = scrollView.frame.size.width/2;
    int page = (scrollView.contentOffset.x - harfWidth)/SCREEN_WIDTH + 1;
    _pagePotControl.currentPage = page;
}

@end
