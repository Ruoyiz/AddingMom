//
//  ADShareView.h
//  PregnantAssistant
//
//  Created by D on 14/12/6.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADShareView : UIView

@property (nonatomic, retain) UIViewController *parentVc;

- (id)initWithFrame:(CGRect)frame
        andParentVC:(UIViewController *)aVC
          showTitle:(BOOL)showTitle;

@end
