//
//  ADToolRootViewController.h
//  PregnantAssistant
//
//  Created by D on 14-9-19.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADIcon.h"

@interface ADToolRootViewController : ADBaseViewController
<UIGestureRecognizerDelegate>

@property (nonatomic, retain) NSString *vcName;

//@property (nonatomic, retain) NSMutableArray *favArray;

//@property (nonatomic, retain) NSMutableArray *recommendToolArray;

@property (nonatomic, assign) BOOL isFav;
//@property (nonatomic, assign) BOOL showCollectNoticeView;


//- (void)showNoticeView;
//- (void)saveFavArray;
- (void)setRightItemCollect;

- (void)rightItemMethod:(UIButton *)sender;

- (void)showSyncAlert;

@property (nonatomic, copy) void(^disMissNavBlock)(void);


@end
