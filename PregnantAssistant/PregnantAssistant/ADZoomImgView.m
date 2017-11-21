//
//  ADZoomImgView.m
//  PregnantAssistant
//
//  Created by D on 15/1/19.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADZoomImgView.h"

@implementation ADZoomImgView

- (id)initWithFrame:(CGRect)frame
             andImg:(UIImage *)aImg
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 3.0;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = 1.0;
        
        CGFloat height =( aImg.size.height/aImg.size.width)*SCREEN_WIDTH;
        _aImgView = [[UIImageView alloc]initWithFrame:
                     CGRectMake(0, (SCREEN_HEIGHT - height)/2.0, SCREEN_WIDTH, height)];
        
        _aImgView.image = aImg;
        _aImgView.contentMode = UIViewContentModeScaleAspectFill;
        _aImgView.userInteractionEnabled = YES;
        [self addSubview:_aImgView];

        self.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        
        UITapGestureRecognizer *aTapGes =
        [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg:)];
        [_aImgView addGestureRecognizer:aTapGes];
    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _aImgView;
}

- (void)tapImg:(UITapGestureRecognizer *)aGes
{
    [[NSNotificationCenter defaultCenter] postNotificationName:tapImgNotification object:nil];
}

@end
