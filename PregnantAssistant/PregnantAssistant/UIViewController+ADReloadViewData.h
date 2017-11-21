//
//  UIViewController+ADReloadViewData.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/4/9.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ADReloadViewData)

//这个category方法是为了消除警告
- (void)reloadViewData;

- (void)showRefreshView;

@end
