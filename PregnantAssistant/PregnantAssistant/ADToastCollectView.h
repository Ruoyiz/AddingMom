//
//  ADToastCollectView.h
//  PregnantAssistant
//
//  Created by D on 15/3/24.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADToastCollectView : UIView

@property (strong, nonatomic) UIImageView *titleImg;
@property (strong, nonatomic) UILabel *titleLabel;

@property (copy, nonatomic) NSString *myTitle;
@property (strong, nonatomic) UIView *superView;

- (id)initWithFrame:(CGRect)frame
           andTitle:(NSString *)aTitle
       andParenView:(UIView *)superView;

- (void)showCollectToast;
- (void)showUnCollectToast;

@end
