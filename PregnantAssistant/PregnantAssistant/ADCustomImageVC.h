//
//  ADCustomImageVC.h
//  PregnantAssistant
//
//  Created by D on 15/1/17.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADZoomImgView.h"
#import "UCZProgressView.h"

@interface ADCustomImageVC : UIViewController<UIScrollViewDelegate>

@property (nonatomic, copy) NSArray *imgUrl;

@property (nonatomic, strong) UIScrollView *pageScroll;
@property (nonatomic, strong) UIPageControl *pagePotControl;

@property (nonatomic, assign) NSInteger currentInx;
@property (nonatomic, strong) ADZoomImgView *currentImgView;
@property (nonatomic, strong) UCZProgressView *aProgressView;

- (instancetype)initWithImgUrls:(NSArray *)aUrlArray
                andCurrentIndex:(NSInteger)aInx
                  andCurrentImg:(UIImage *)currentImg;

@end
