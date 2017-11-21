//
//  ADZoomImgView.h
//  PregnantAssistant
//
//  Created by D on 15/1/19.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADZoomImgView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, retain) UIImageView *aImgView;

- (id)initWithFrame:(CGRect)frame
             andImg:(UIImage *)aImg;

@end
