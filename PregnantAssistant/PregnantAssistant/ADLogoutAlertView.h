//
//  ADLogoutView.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/14.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ADLogoutTypeSynchronized = 0,
    ADLogoutTypeSyncing,
} ADLogoutType;

@interface ADLogoutAlertView : UIAlertView <UIAlertViewDelegate>

@property (nonatomic,assign) ADLogoutType logoutType;

- (id)initWithLogoutType:(ADLogoutType)logoutType;

- (void)showWithConfirm:(void (^) (void))confirmBlock;

//- (void)showSyncWithConfirm:(void (^) (void))confirmBlock;

@end
