//
//  ADRootVCManager.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/7/31.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADRootVCManager : NSObject <UIWebViewDelegate>

@property (nonatomic, strong) ADAppDelegate *myAppDelegate;
+ (ADRootVCManager *)sharedManager;

- (void)webSkipAction;
- (void)showSplash;
- (void)setRootVc;

@end
