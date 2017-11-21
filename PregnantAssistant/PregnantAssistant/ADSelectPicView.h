//
//  ADSelectPicView.h
//  PregnantAssistant
//
//  Created by D on 14/11/8.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

static int selectNum = 0;
@interface ADSelectPicView : UIView

- (id)initWithFrame:(CGRect)frame
             andImg:(UIImage *)aImg;

@property (nonatomic, assign) BOOL isSelect;

//@property (nonatomic, retain) UIImage *picImg;
@property (nonatomic, retain) UIImageView *selectMarkView;

@end
