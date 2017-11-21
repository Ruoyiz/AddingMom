//
//  ADParentToolBabyTitleView.h
//  PregnantAssistant
//
//  Created by 加丁 on 15/5/8.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADParentToolBabyTitleView : UIView

@property (nonatomic, strong)NSDictionary *refeshData;
@property (nonatomic, strong)UILabel *oldLable;
@property (nonatomic, assign)float alpheFromVC;

- (id)initWithFrame:(CGRect)frame andParentVC:(UIViewController *)aVc;

@end
