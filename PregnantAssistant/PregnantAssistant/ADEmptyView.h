//
//  ADEmptyView.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/30.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADEmptyView : UIView

@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) NSAttributedString *attributeString;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image;
//- (id)initWithFrame:(CGRect)frame title:(NSString *)title highlightText:(NSString *)highlightTxt imgName:(NSString *)aImgName;
- (id)initWithFrame:(CGRect)frame attributeString:(NSAttributedString *)attributeString imageName:(UIImage *)imageName textClicked:(void (^) (void))textClickedBlock;

@end
